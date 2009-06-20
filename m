Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KH1wbl125933 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 12:02:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 664CD30E681
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:02:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Mzhf9aVZQqkdzl5S for
	<xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:02:23 -0700 (PDT)
Date: Sat, 20 Jun 2009 13:02:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] Skip _check_test_fs unless a test is actually run
Message-ID: <20090620170222.GA5508@infradead.org>
References: <1245434013-9433-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1245434013-9433-1-git-send-email-tytso@mit.edu>
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

On Fri, Jun 19, 2009 at 01:53:31PM -0400, Theodore Ts'o wrote:
> Running _check_test_fs can take a non-trivial amount of time, and if a
> test has been skipped because it doesn't work on Linux, or it doesn't
> work of for ext4, it's pointless to re-run _check_test_fs.  So move
> the call to _check_test_fs so it is only run if a test is actually run.

Thanks, I've put this in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
