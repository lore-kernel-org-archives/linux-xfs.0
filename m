Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p36DxftD037836 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 08:59:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E3D51E05BC3
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 07:02:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QeUxMZ4Ka110damb for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2011 07:02:57 -0700 (PDT)
Date: Wed, 6 Apr 2011 10:02:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] xfs: convert log tail checking to a warning
Message-ID: <20110406140257.GB24618@infradead.org>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302070758-17312-10-git-send-email-david@fromorbit.com>
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

On Wed, Apr 06, 2011 at 04:19:18PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On the Power platform, the log tail debug checks fire excessively
> causing the system to panic early in testing. The debug checks are
> known to be racy, though on x86_64 there is no evidence that they
> trigger at all.
> 
> We want to keep the checks active on debug systems to alert us to
> problems with log space accounting, but we need to reduce the impact
> of a racy check on testing on the Power platform.
> 
> As a result, convert the ASSERT conditions to warnings, and
> allow them to fire only once per filesystem mount. This will prevent
> false positives from interfering with testing, whilst still
> providing us with the indication that they may be a problem with log
> space accounting should that occur.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Keeping a potentially racy debug check around still seems somewhat
fishy to me.  But you've done all the recent log work, so if it's
going to help you spot problems I'm fine with keeping it in this way,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
