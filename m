Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42452 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753862AbdD0Uah (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Apr 2017 16:30:37 -0400
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
References: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
 <20170427193118.GH23371@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <984c6ee4-9ece-7424-420f-1fc26faca378@sandeen.net>
Date: Thu, 27 Apr 2017 15:30:35 -0500
MIME-Version: 1.0
In-Reply-To: <20170427193118.GH23371@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 4/27/17 2:31 PM, Darrick J. Wong wrote:
> On Thu, Apr 27, 2017 at 10:58:31AM +0300, Amir Goldstein wrote:

...

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
> But therein lies a problem -- if another ext4 fs shows up with the same
> uuid and the overlayfs accidentally gets paired with the second ext4,
> your stored xattr is toast because you can't tell that this is the wrong
> filesystem... unless you already detect this situation?
> 
> I suppose since this xattr thing is an optimization(?) you /could/
> actually keep track of whether or not there are mounted fses with the
> same s_uuid and therefore know whether or not it's safe to use it.
> 
> I don't have an objection to XFS filling out s_uuid unconditionally like
> the other filesystems do.  If we want to change the meaning of that
> field, let's change all of the fses at once.

So this all reminded me that I had a rework of xfs's unique UUID detection
routine to iterate all the xfs supers in the system looking for a duplicate.
(vs our current homegrown table mess).

It'd be trivial to make that a vfs function and set a flag on the vfs super
if the UUID is not unique.  Would that be worthwhile?  I can send a patch 
if so.

-Eric
