Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:45935 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbdJWGsZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 02:48:25 -0400
Received: by mail-yw0-f194.google.com with SMTP id j4so11185738ywb.2
        for <linux-xfs@vger.kernel.org>; Sun, 22 Oct 2017 23:48:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171023053236.GV3666@dastard>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxhzZT=5O6PM4Gp=uSwYPFdrO5X9D8UF54f3jEmM2LxK1Q@mail.gmail.com>
 <20171020224157.GS3666@dastard> <CAOQ4uxjQk_82RxzSKWT+UeepkKXtrXbVmNW2wz6Mngq=UX+XZg@mail.gmail.com>
 <20171022232741.GU3666@dastard> <CAOQ4uxhu0ModoKNUQPg03Bc=iTrqwX3xuPH=GuvedAHT-XvzXg@mail.gmail.com>
 <20171023053236.GV3666@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Oct 2017 09:48:24 +0300
Message-ID: <CAOQ4uxgH8oza283kL=cUvE7a0SA5wPsD1gyVApBqd2hWHE8y3w@mail.gmail.com>
Subject: Re: [PATCH 00/17] Parent Pointers V3
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 23, 2017 at 8:32 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Oct 23, 2017 at 07:30:01AM +0300, Amir Goldstein wrote:
>> On Mon, Oct 23, 2017 at 2:27 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sat, Oct 21, 2017 at 10:34:30AM +0300, Amir Goldstein wrote:
>> >> On Sat, Oct 21, 2017 at 1:41 AM, Dave Chinner <david@fromorbit.com> wrote:
>> >> > On Thu, Oct 19, 2017 at 07:11:50AM +0300, Amir Goldstein wrote:
>> >> >> On Thu, Oct 19, 2017 at 1:55 AM, Allison Henderson
>> >> >> <allison.henderson@oracle.com> wrote:
>> >> >> > Hi all,
>> >> >> >
>> >> >> > This is the third version of parent pointer attributes for xfs.
>> >> >> > I've integrated the suggestions made since v2, mostly moving the
>> >> >> > attr buffers in the xfs_attr_log_item to pointers that point to
>> >> >> > xfs_attr_item. I've also implementing the recovery routines for
>> >> >> > the xfs_attr_log_format.  If I missed anything please point it
>> >> >> > out.  As always, comments and feedback are appreciated.  Thank
>> >> >> > you!
>> >> >> >
>> >> >>
>> >> >> A minor comment about the cover letter.
>> >> >> All designated reviewers must know exactly what "parent pointers" are for,
>> >> >> but it could be useful to add some context in the cover letter about the purpose
>> >> >> of this work for the sake of other readers on the list. Useful to refer to the
>> >> >> upcoming scrub support patches.
>> >> >>
>> >> >> BTW, not sure if this was mentioned in the previous lifetime of those
>> >> >> patches, but parent pointers can be used to implement exportfs operation
>> >> >> xfs_fs_fh_to_parent() for "non-connectable" file handles (FILEID_INO32_GEN)
>> >> >> and to implement xfs_fs_get_name(), which would make reconnect_path()
>> >> >> *much* more efficient.
>> >> >
>> >> > However, XFS only uses FILEID_INO32_GEN for directories
>> >> > because they have known parents. For them, we implement ->get_parent()
>> >> > and that means reconnect_path just does ->lookup("..") to find the
>> >> > parents and doesn't need anything special.
>> >> >
>> >> > We use FILEID_INO32_GEN_PARENT for all other types of files to
>> >> > encode the ino # + generation of the parent inode into the handle.
>> >> > That means for any non-dir file handle, our implemention of
>> >> > ->fh_to_parent  will get us the parent info as efficiently as
>> >> > possible.
>> >>
>> >> We only encode FILEID_INO32_GEN_PARENT when we are asked for
>> >> a "connectable" file handle, which is NOT the case with name_to_handle_at(2)
>> >> and is the case with nfsd on when NFS share is exported with subtree_check
>> >> options, which AFAIK, is the less common case.
>> >>
>> >> The question is, when we encode a non-connectable file handle
>> >> (FILEID_INO32_GEN), will nfsd benefit from getting a connected file handle
>> >> after decode? (result may always be connected if dentry is already in cache).
>> >>
>> >> > IOWs, parent pointers won't actually speed up filehandle ->
>> >> > dentry reconnection on XFS at all because we already encode parent
>> >> > pointers into the filehandles that need them....
>> >>
>> >> Look at default implementation of ->get_name() in expfs.c and you will
>> >> see why I wrote that xfs_fs_get_name() would make reconnect_path()
>> >> *much* more efficient, even for directories.
>> >
>> > If you think it will be a win, then I'm not going to stop you from
>> > implementing and benchmarking it to demonstrate how much faster it
>> > is. Should be pretty simple to benchmark - stat a whole bunch of
>> > files on an NFS client, drop server caches, stat the files again. If
>> > it's a win, the server CPU and IO load should be lower, and the
>> > client side stat rate should be faster....
>> >
>>
>> Sure. In due time.
>>
>> Mean while I would like to ask if there is a concrete reason for storing
>> diroffset to parent pointer of directory inodes, besides the obvious reason
>> of not special casing directory inodes.
>
> Uniquely identifying each parent pointer in the case of multiple
> hard links to a single inode from a single directory.
>
> There's a heap of historic information on the history of the
> attribute format in this discussion:
>
> http://oss.sgi.com/archives/xfs/2014-01/msg00224.html
>
> To answer your question more specifically, the last part of this
> post summarises the link disambiguation problem and proposes the
> use of {ino,gen,diroffset} tuples to uniquely identify parent
> directory entries:
>
> http://oss.sgi.com/archives/xfs/2014-01/msg00263.html
>
>> If there is no such reason I would like to propose to store parent
>> pointers of directory inodes with an xattr name that is diroffset agnostic,
>> namely:
>>
>> struct xfs_dir_parent_name_rec {
>>       __be64  p_ino;
>>       __be32  p_gen;
>> } __attribute__((packed));
>>
>> It makes sense for metadata consistency anyway, but the reason I am
>> proposing this is so xfs_fs_get_name() could be implemented at O(1).
>
> Yup, but now consider unlinking an inode that has thousands of hard
> links to it, and many of them exist in the same directory. How do we
> find the right xattr to remove without a brute-force search of all
> the parent pointers that point back to the same directory? i.e. We
> have to retreive each one and compare the stored xattr value (i.e.
> the filename) to the dirent we are unlinking. IOWs, we now need to
> iterate and fetch attributes rather than just constructing a unique
> handle and saying "remove!".
>
> Also, we need unique identifiers for parent pointers so they are
> useful for online scrub/repair:
>
> http://oss.sgi.com/archives/xfs/2014-02/msg00090.html
>
> Realistically, we have been designing this under the premise that
> reverse name lookups are going to be rare compared to directory
> modification operations. If we have to do iterative searches to
> determine what xattr to remove, or even if a specific parent xattr
> *exists*, then we've got a runtime overhead problem that every user
> will see, not just those that use reverse lookups in the corner
> cases that they are necessary.
>
> If the filehandle doesn't contain all the info needed to do the
> inode->name reverse lookup efficiently, then encode that info into
> the filehandle for parent pointer enabled filesystems before handing
> it out (e.g. add "diroff" to the ino/gen we encode) so that it's
> available when necessary on the decode side....
>

That is not possible, because file handle encoding of directories
must be unique identified of the object, meaning encoding cannot change
after rename.

But you missed my question completely. I understand why diroffset
is needed for non-dir. But directories are not allowed to have 2 differnt
parents nor 2 entries in the parent dir, so I was asking if we can
special case parent pointer stored in *directory inodes*.

Am I missing something?

Amir.
