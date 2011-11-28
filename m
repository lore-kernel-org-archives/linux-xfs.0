Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASBWvac233945 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 05:32:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AD8C19D6F8E
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 03:03:06 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	n5ORWQGCilSH4Dln for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 03:03:06 -0800 (PST)
Date: Mon, 28 Nov 2011 06:03:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: Sort recursive getfattr output in 062
Message-ID: <20111128110302.GD13766@infradead.org>
References: <4EC10664.1080501@tuxadero.com>
	<CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com>
	<20111115142246.GA7516@thunk.org>
	<246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
	<4ECA4282.5020908@whamcloud.com>
	<401CC4FF-8955-4D5F-B620-5C39AF566123@mit.edu>
	<4ECB2ADE.3010007@redhat.com> <4ECD28D1.1080800@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ECD28D1.1080800@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andreas Dilger <adilger@whamcloud.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@MIT.EDU>, Yu Jian <yujian@whamcloud.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 23, 2011 at 11:09:37AM -0600, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Test 062 was made "generic" a while back, but it fails on any filesystem
> which returns getfattr -R results (aka readdir results) in something
> other than inode-order.
> 
> With a little awk-fu we can sort the records from getfattr -R so that
> the output is the same for xfs as well as ext4, etc.
> 
> Also filter out lost+found which extN creates at mkfs time, but
> some other filesystems do not.

Looks fine to me, except that I'd put the sorting helper into
common.attr.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
