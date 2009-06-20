Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KHExrO126659 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 12:15:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46A78952B0F
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:23:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2rXv8FCNWvTz7ZsJ for
	<xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:23:31 -0700 (PDT)
Date: Sat, 20 Jun 2009 13:15:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] Fix common.config to allow SCRATCH_DEV and
	SCRATCH_MNT to be optional
Message-ID: <20090620171525.GA11354@infradead.org>
References: <1245434013-9433-1-git-send-email-tytso@mit.edu>
	<1245434013-9433-2-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1245434013-9433-2-git-send-email-tytso@mit.edu>
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

On Fri, Jun 19, 2009 at 01:53:32PM -0400, Theodore Ts'o wrote:
> Commit 3ae9f2f8 purports to allow SCRATCH_DEV and SCRATCH_MNT to be
> optional, but tests in common.config will cause check to exit with an
> error if these environment variables are not defined.  Fix this problem.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks, I've put this in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
