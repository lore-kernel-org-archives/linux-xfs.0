Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:49512 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751377AbdJUHeb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Oct 2017 03:34:31 -0400
Received: by mail-yw0-f193.google.com with SMTP id z195so1743829ywz.6
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 00:34:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171020224157.GS3666@dastard>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxhzZT=5O6PM4Gp=uSwYPFdrO5X9D8UF54f3jEmM2LxK1Q@mail.gmail.com> <20171020224157.GS3666@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 21 Oct 2017 10:34:30 +0300
Message-ID: <CAOQ4uxjQk_82RxzSKWT+UeepkKXtrXbVmNW2wz6Mngq=UX+XZg@mail.gmail.com>
Subject: Re: [PATCH 00/17] Parent Pointers V3
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Oct 21, 2017 at 1:41 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Oct 19, 2017 at 07:11:50AM +0300, Amir Goldstein wrote:
>> On Thu, Oct 19, 2017 at 1:55 AM, Allison Henderson
>> <allison.henderson@oracle.com> wrote:
>> > Hi all,
>> >
>> > This is the third version of parent pointer attributes for xfs.
>> > I've integrated the suggestions made since v2, mostly moving the
>> > attr buffers in the xfs_attr_log_item to pointers that point to
>> > xfs_attr_item. I've also implementing the recovery routines for
>> > the xfs_attr_log_format.  If I missed anything please point it
>> > out.  As always, comments and feedback are appreciated.  Thank
>> > you!
>> >
>>
>> A minor comment about the cover letter.
>> All designated reviewers must know exactly what "parent pointers" are for,
>> but it could be useful to add some context in the cover letter about the purpose
>> of this work for the sake of other readers on the list. Useful to refer to the
>> upcoming scrub support patches.
>>
>> BTW, not sure if this was mentioned in the previous lifetime of those
>> patches, but parent pointers can be used to implement exportfs operation
>> xfs_fs_fh_to_parent() for "non-connectable" file handles (FILEID_INO32_GEN)
>> and to implement xfs_fs_get_name(), which would make reconnect_path()
>> *much* more efficient.
>
> However, XFS only uses FILEID_INO32_GEN for directories
> because they have known parents. For them, we implement ->get_parent()
> and that means reconnect_path just does ->lookup("..") to find the
> parents and doesn't need anything special.
>
> We use FILEID_INO32_GEN_PARENT for all other types of files to
> encode the ino # + generation of the parent inode into the handle.
> That means for any non-dir file handle, our implemention of
> ->fh_to_parent  will get us the parent info as efficiently as
> possible.

We only encode FILEID_INO32_GEN_PARENT when we are asked for
a "connectable" file handle, which is NOT the case with name_to_handle_at(2)
and is the case with nfsd on when NFS share is exported with subtree_check
options, which AFAIK, is the less common case.

The question is, when we encode a non-connectable file handle
(FILEID_INO32_GEN), will nfsd benefit from getting a connected file handle
after decode? (result may always be connected if dentry is already in cache).


>
> IOWs, parent pointers won't actually speed up filehandle ->
> dentry reconnection on XFS at all because we already encode parent
> pointers into the filehandles that need them....

Look at default implementation of ->get_name() in expfs.c and you will
see why I wrote that xfs_fs_get_name() would make reconnect_path()
*much* more efficient, even for directories.

Cheers,
Amir.
