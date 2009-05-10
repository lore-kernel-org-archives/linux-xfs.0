Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4AJbHmm200572 for <xfs@oss.sgi.com>; Sun, 10 May 2009 14:37:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 611AC1448A9D
	for <xfs@oss.sgi.com>; Sun, 10 May 2009 12:41:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cqIDxLPQbpEX8vDi for
	<xfs@oss.sgi.com>; Sun, 10 May 2009 12:41:48 -0700 (PDT)
Date: Sun, 10 May 2009 15:37:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfsqa test to check log size scaling
Message-ID: <20090510193722.GB14021@infradead.org>
References: <20080522061257.GR173056135@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080522061257.GR173056135@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, May 22, 2008 at 04:12:57PM +1000, David Chinner wrote:
> XFS-QA test to check that log size scaling works correctly
> for old and new maximum log sizes.

This patch has a couple of problems.


For 32bit architecturs with 4k pages the maximum filesize is limited
to just under 16 Terrabytes, so the 100 Terrabyte file can't be
created.  Even if limit the size to just under 16TB we can run of
space quite quickly by just creating the filesystem and the large
log on smaller test setups.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
