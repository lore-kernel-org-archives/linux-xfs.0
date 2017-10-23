Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:46239 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbdJWEaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 00:30:03 -0400
Received: by mail-yw0-f193.google.com with SMTP id t71so10989063ywc.3
        for <linux-xfs@vger.kernel.org>; Sun, 22 Oct 2017 21:30:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171022232741.GU3666@dastard>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxhzZT=5O6PM4Gp=uSwYPFdrO5X9D8UF54f3jEmM2LxK1Q@mail.gmail.com>
 <20171020224157.GS3666@dastard> <CAOQ4uxjQk_82RxzSKWT+UeepkKXtrXbVmNW2wz6Mngq=UX+XZg@mail.gmail.com>
 <20171022232741.GU3666@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Oct 2017 07:30:01 +0300
Message-ID: <CAOQ4uxhu0ModoKNUQPg03Bc=iTrqwX3xuPH=GuvedAHT-XvzXg@mail.gmail.com>
Subject: Re: [PATCH 00/17] Parent Pointers V3
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 23, 2017 at 2:27 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Oct 21, 2017 at 10:34:30AM +0300, Amir Goldstein wrote:
>> On Sat, Oct 21, 2017 at 1:41 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Thu, Oct 19, 2017 at 07:11:50AM +0300, Amir Goldstein wrote:
>> >> On Thu, Oct 19, 2017 at 1:55 AM, Allison Henderson
>> >> <allison.henderson@oracle.com> wrote:
>> >> > Hi all,
>> >> >
>> >> > This is the third version of parent pointer attributes for xfs.
>> >> > I've integrated the suggestions made since v2, mostly moving the
>> >> > attr buffers in the xfs_attr_log_item to pointers that point to
>> >> > xfs_attr_item. I've also implementing the recovery routines for
>> >> > the xfs_attr_log_format.  If I missed anything please point it
>> >> > out.  As always, comments and feedback are appreciated.  Thank
>> >> > you!
>> >> >
>> >>
>> >> A minor comment about the cover letter.
>> >> All designated reviewers must know exactly what "parent pointers" are for,
>> >> but it could be useful to add some context in the cover letter about the purpose
>> >> of this work for the sake of other readers on the list. Useful to refer to the
>> >> upcoming scrub support patches.
>> >>
>> >> BTW, not sure if this was mentioned in the previous lifetime of those
>> >> patches, but parent pointers can be used to implement exportfs operation
>> >> xfs_fs_fh_to_parent() for "non-connectable" file handles (FILEID_INO32_GEN)
>> >> and to implement xfs_fs_get_name(), which would make reconnect_path()
>> >> *much* more efficient.
>> >
>> > However, XFS only uses FILEID_INO32_GEN for directories
>> > because they have known parents. For them, we implement ->get_parent()
>> > and that means reconnect_path just does ->lookup("..") to find the
>> > parents and doesn't need anything special.
>> >
>> > We use FILEID_INO32_GEN_PARENT for all other types of files to
>> > encode the ino # + generation of the parent inode into the handle.
>> > That means for any non-dir file handle, our implemention of
>> > ->fh_to_parent  will get us the parent info as efficiently as
>> > possible.
>>
>> We only encode FILEID_INO32_GEN_PARENT when we are asked for
>> a "connectable" file handle, which is NOT the case with name_to_handle_at(2)
>> and is the case with nfsd on when NFS share is exported with subtree_check
>> options, which AFAIK, is the less common case.
>>
>> The question is, when we encode a non-connectable file handle
>> (FILEID_INO32_GEN), will nfsd benefit from getting a connected file handle
>> after decode? (result may always be connected if dentry is already in cache).
>>
>> > IOWs, parent pointers won't actually speed up filehandle ->
>> > dentry reconnection on XFS at all because we already encode parent
>> > pointers into the filehandles that need them....
>>
>> Look at default implementation of ->get_name() in expfs.c and you will
>> see why I wrote that xfs_fs_get_name() would make reconnect_path()
>> *much* more efficient, even for directories.
>
> If you think it will be a win, then I'm not going to stop you from
> implementing and benchmarking it to demonstrate how much faster it
> is. Should be pretty simple to benchmark - stat a whole bunch of
> files on an NFS client, drop server caches, stat the files again. If
> it's a win, the server CPU and IO load should be lower, and the
> client side stat rate should be faster....
>

Sure. In due time.

Mean while I would like to ask if there is a concrete reason for storing
diroffset to parent pointer of directory inodes, besides the obvious reason
of not special casing directory inodes.

If there is no such reason I would like to propose to store parent
pointers of directory inodes with an xattr name that is diroffset agnostic,
namely:

struct xfs_dir_parent_name_rec {
      __be64  p_ino;
      __be32  p_gen;
} __attribute__((packed));

It makes sense for metadata consistency anyway, but the reason I am
proposing this is so xfs_fs_get_name() could be implemented at O(1).

For those who are not familiar, the get_name() operation takes a
parent dentry and disconnected child dentry and returns a name
for the child, so that the disconnected dentry could be reconnected to the
dcache tree.

This operation is called (indirectly) from nfsd when decoding directory
file handles, because directory file handles must be fully connected to
dcache tree before nfsd can work with them.

Currently, the get_name() operation is implemented by few file systems,
but for the majority of file systems, the default implementation in
fs/exportfs/expfs.c is used, which iterates the parent directory entries
looking for a match to child inode number.

In the worst case, the default get_name() implementation is
O(<dir size>*<tree depth>) in metadata IO reads, which could be a lot
for very wide directory trees.

Implementing xfs_fs_get_name() as iteration over the inode's xattr looking
for a parent pointer that matches child ino/gen is a likely-win.
Implementing xfs_fs_get_name() as a single xattr_get of
xfs_dir_parent_name_rec is an doubtful win and I won't mind running
the benchmark to demonstrate it.

Cheers,
Amir.
