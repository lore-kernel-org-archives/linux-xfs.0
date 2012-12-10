Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBA1SNkt154916 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 19:28:23 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jonem2X6oB7HV02T for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 17:30:50 -0800 (PST)
Date: Mon, 10 Dec 2012 12:30:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] XFS: Mark no-more-exist xfsbufd related sysctl
	parameters as obsolete.
Message-ID: <20121210013048.GK15784@dastard>
References: <50C521D7.5060202@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50C521D7.5060202@jp.fujitsu.com>
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
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs ML <xfs@oss.sgi.com>

On Mon, Dec 10, 2012 at 08:42:15AM +0900, Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> 
> xfsbufd is removed since commit 43ff2122e6492bcc88b065c433453dce88223b30.
> But there stille be two sysctl parameters about it
> (fs.xfs.{xfsbufd_centisecs,age_buffer_centisecs}.)
> 
> This patch marks these parameters as obsolete. In adition, prints
> a warning message if someone tries to use these parameters.

While we currently don't use them, I'm not sure they are obsolete.
We need to integrate the AIL flushing with time-based log idling
(i.e.  flushing to an empty state), and part of that work is making
the AIL log items have a age-based flush component.
i.e. how often it will wake to try to flush/idle the log when there
is no pressure, and how long items should wait before being flushed
even when there is activity.

Those two parameters are exactly what the xfsbufd parameters have
historically controlled, so rather than introduce new sysctls for
the same purpose, I was planning on just re-using them. Hence I
suspect that marking them obsolete is probably the wrong thing to do
right now - adding the time-based component to the AIL flushing
would be a better solution.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
