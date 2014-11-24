Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 130B07F66
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 10:38:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01523304032
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 08:38:31 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id CnTe4z3fXFCaXhir (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 08:38:30 -0800 (PST)
Date: Mon, 24 Nov 2014 17:38:30 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
	write_time()
Message-ID: <20141124163830.GA26471@twin.jikos.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-2-git-send-email-tytso@mit.edu>
	<1416600528.24312.10@mail.thefacebook.com>
	<20141121214245.GG7112@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141121214245.GG7112@thunk.org>
Reply-To: dsterba@suse.cz
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <clm@fb.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Nov 21, 2014 at 04:42:45PM -0500, Theodore Ts'o wrote:
> Out of curiosity, why does btrfs_update_time() need to call
> btrfs_root_readonly()?  Why can't it just depend on the
> __mnt_want_write() call in touch_atime()?

mnt_want_write looks only at the mountpoint flags, the readonly
subvolume status is external to that.

> Surely if there are times when it's not OK to write into a btrfs file
> system and mnt_is_readonly() returns false, the VFS is going to get
> very confused abyway.
> 
> If the btrfs_update_time() is not necessary, then we could drop
> btrfs_update_time() and update_time() from the inode operations
> entirely, and depend on the VFS-level code in update_time().

It is necessary and the whole .update_time callback was added
intentionally, see commits

c3b2da314834499f34cba94f7053e55f6d6f92d8
fs: introduce inode operation ->update_time

e41f941a23115e84a8550b3d901a13a14b2edc2f
Btrfs: move over to use ->update_time

2bc5565286121d2a77ccd728eb3484dff2035b58
Btrfs: don't update atime on RO subvolumes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
