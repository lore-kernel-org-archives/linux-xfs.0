Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7IGAtWP150398 for <xfs@oss.sgi.com>; Tue, 18 Aug 2009 11:11:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9E993DC591
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2009 09:11:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qrjReWHFUDDrUPEV for
	<xfs@oss.sgi.com>; Tue, 18 Aug 2009 09:11:20 -0700 (PDT)
Date: Tue, 18 Aug 2009 12:11:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add ext2/3/4-specific _check_extN_filesystem function
Message-ID: <20090818161116.GA2162@infradead.org>
References: <1250607467-15085-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1250607467-15085-1-git-send-email-tytso@mit.edu>
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

On Tue, Aug 18, 2009 at 10:57:47AM -0400, Theodore Ts'o wrote:
> The _check_generic_filesystem function doesn't force a full filesystem
> check, so filesystem inconsistencies after a test wouldn't be noticed.
> To fix this, I added an extN specific check filesystem function.

Looks like the only difference between the generic and the extN
check routine is the addition of -f to the fsck command line.  What
about just introducing a _fsck_args similar to _mount_opts where
filesystems can set their additional required mount options?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
