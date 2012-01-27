Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RArotL163183 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 04:53:51 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GWEe6zS5XjpvJ2YC (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Jan 2012 02:53:49 -0800 (PST)
Date: Fri, 27 Jan 2012 05:53:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfstests: Sort recursive getfattr output in 062
Message-ID: <20120127105344.GB23335@infradead.org>
References: <4EC10664.1080501@tuxadero.com>
	<CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com>
	<20111115142246.GA7516@thunk.org>
	<246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
	<4ECA4282.5020908@whamcloud.com>
	<401CC4FF-8955-4D5F-B620-5C39AF566123@mit.edu>
	<4ECB2ADE.3010007@redhat.com> <4ECD28D1.1080800@redhat.com>
	<4F20766E.9040902@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F20766E.9040902@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Yu Jian <yujian@whamcloud.com>, Theodore Tso <tytso@MIT.EDU>, xfs-oss <xfs@oss.sgi.com>, Andreas Dilger <adilger@whamcloud.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Wed, Jan 25, 2012 at 03:38:54PM -0600, Eric Sandeen wrote:
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
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> - ---
> 
> V2: move sorting function into common.attr

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
