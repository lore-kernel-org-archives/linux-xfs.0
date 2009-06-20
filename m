Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KH6jPZ126169 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 12:06:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 085699529E4
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:15:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id M8RftgyCfC2fqXCf for
	<xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:15:09 -0700 (PDT)
Date: Sat, 20 Jun 2009 13:07:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix _require_scratch test for extN, resierfs, gfs2,
	and btrfs
Message-ID: <20090620170703.GB5508@infradead.org>
References: <7D909252-70A0-44C2-A5D7-D56A4B6CD244@sgi.com>
	<1245443301-27495-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1245443301-27495-1-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: xfs@oss.sgi.com

On Fri, Jun 19, 2009 at 04:28:21PM -0400, Theodore Ts'o wrote:
> The extN, reiserfs, gfs2, and btrfs filesysytem types should use the
> same check for a block device as XFS and UDF, and not the test for
> NFS, which was checking for host:/foo/bar/baz when checking for a
> scratch device.
> 
> Also, the NFS logic was also incorrect, in that it would allow a
> zero-length SCRATCH_DEV to continue.

Thanks, I've applied this with a small modification to make the local
disk case the default in the case statement so that we don't have to
touch this function when adding support for additional local
filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
