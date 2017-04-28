Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36463 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161851AbdD1GLX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2017 02:11:23 -0400
MIME-Version: 1.0
In-Reply-To: <20170427193118.GH23371@birch.djwong.org>
References: <1493279911-2936-1-git-send-email-amir73il@gmail.com> <20170427193118.GH23371@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 28 Apr 2017 09:11:22 +0300
Message-ID: <CAOQ4uxiOj9N7iMmxjBm-=n_B7pbuH3SuKNFOce7T3txz+r23aA@mail.gmail.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 27, 2017 at 10:31 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Apr 27, 2017 at 10:58:31AM +0300, Amir Goldstein wrote:
>> Unless mounted with nouuid, copy the uuid of the filesystem to
>> struct super block s_uuid field, as several other filesystems do.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/xfs/xfs_mount.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> Darrick,
>>
>> The VFS sb->s_uuid field is needed for a new overlay feature
>> 'constant inode numbers' [1].
>>
>> We store the filesystem uuid along with encoded file handles, so that
>> we can verify later that we are encoding file handles from the same
>> filesystem from which the handles were encoded.
>>
[...]

>>
>> I made a choice not to set sb->s_uuid in case xfs was mounted with nouuid,
>> to maintain a self inflicted rule that sb->s_uuid is unique in a system
>> for an xfs super_block.  This is an arbitrary decision so others may not
>> agree with it.
>>
>> My reasoning in the context of verifying file handles is this -
>> If a file handle was exported from one copy of an xfs filesystem, I rather
>> it was not decoded from another copy of the filesystem (i.e. LVM snapshot),
>> at least not while both copies are mounted on the same system.
>
> I disagree.  ext4, f2fs, gfs2, ocfs2, and ubifs all set s_uuid
> unconditionally, even if that means there are multiple struct
> superblocks floating around with the same s_uuid.  Now, I surmise that
> for overlayfs copy-up you want to be able to store (sb_uuid, fh) as an
> xattr to keep track of the original inode, and for that you really /do/
> want sb_uuid to be unique.
>

No. I don't care about sb_uuid being unique.
As I wrote I am indifferent to the choice of exporting with -o nouuid.
Your reasoning works for me (do what everyone else does),
so I'll change the patch and re-post.

> But therein lies a problem -- if another ext4 fs shows up with the same
> uuid and the overlayfs accidentally gets paired with the second ext4,
> your stored xattr is toast because you can't tell that this is the wrong
> filesystem... unless you already detect this situation?
>

No. I don't bother.

> I suppose since this xattr thing is an optimization(?) you /could/
> actually keep track of whether or not there are mounted fses with the
> same s_uuid and therefore know whether or not it's safe to use it.
>

It is not only an optimization. It's partly a sanity check to prevent
admin from making mistakes, partly a way to automatically detect
that overlay layers were copied over so file handles should not be
trusted.

It is certainly not going to prevent an admin that wants to shoot
himself in the leg carry out his plans.

> I don't have an objection to XFS filling out s_uuid unconditionally like
> the other filesystems do.  If we want to change the meaning of that
> field, let's change all of the fses at once.
>

I am happy with the way things are...

[...]
>
> What happens if you create two ext4 filesystems with the same uuid,
> mount an overlay with one ext4, make some changes, then unmount the
> overlay and mount it with the other ext4?
>

As I wrote, if admin wants to shoot himself in the leg, he is free to do so
just as he is with NFS export.
In the example you gave, admin could re-export the same NFS share from
the other ext4 fs (and nfsd doesn't even check UUID AFAIK), so NFS client
coming with old file handles could be served with completely different files
from the new fs.

I do want to protect admin from things that could go wrong with normal
behavior:
- copying layers on the same fs and mounting overlay - verify file handles (*)
- copying layers to a different fs and mounting overlay - verify uuid
- copying an entire fs (or LVM snapshot) and mount an 'overlay clone' -
  it's ok to use the handles in the clone even if they point to files that
  diverged from the original fs. It's just as if the overlay mount content
  itself was cloned and diverged from its original copy.

(*) on the samefs case, file handles could still be decoded and point to
     a different lower layer, but that is a calculated risk we are willing to
     live with, because the file handles are just used to find a unique inode
     number and pin the inode while this inode number is exposed

Amir.
