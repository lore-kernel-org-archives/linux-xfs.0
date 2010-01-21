Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LBKFAf068548 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 05:20:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 593761C6A525
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:21:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FPZEOED5c1Hl2Kgx for
	<xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:21:17 -0800 (PST)
Date: Thu, 21 Jan 2010 06:21:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfstests: rebuild aclocal.m4
Message-ID: <20100121112115.GA27634@infradead.org>
References: <1264053773-6054-1-git-send-email-david@fromorbit.com>
	<1264053773-6054-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1264053773-6054-2-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Thu, Jan 21, 2010 at 05:02:52PM +1100, Dave Chinner wrote:
> The local m4 configuration has not been built in a long time.
> Trying to rebuild it results in failures with dmapi library
> detection and libxfs.h detection macros. Fix the errors and rebuild
> it.
> 
> Note: the new format for the aclocal.m4 file uses m4_include
> directives which means it is much smaller th an before and won't
> need updating unless we include new m4 macro files.

Looks good, but shouldn't we create aclocal.m4 automocatically as part
of make configure which generates the rest of the auto* stuff and stop
having it checked into the git repository?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
