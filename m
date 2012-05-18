Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4I9VOel117230 for <xfs@oss.sgi.com>; Fri, 18 May 2012 04:31:25 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HDXCFwxSQWiNHzq9 for <xfs@oss.sgi.com>;
	Fri, 18 May 2012 02:31:23 -0700 (PDT)
Date: Fri, 18 May 2012 19:31:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120518093120.GU25351@dastard>
References: <20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507225944.GA5091@dastard> <20120509073507.GQ5091@dastard>
	<4FAADCA8.6030702@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FAADCA8.6030702@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Juerg Haefliger <juergh@gmail.com>, xfs@oss.sgi.com

On Wed, May 09, 2012 at 04:07:52PM -0500, Mark Tinguely wrote:
> On 05/09/12 02:35, Dave Chinner wrote:
> 
> >
> >Transaction	 Wait queues	 Grant head	 Write Head	 Log head	 Log tail
> >-----------------------------------------------------------------------------------------
> >INACTIVE         empty empty     118 438024      118 438024      118 802         118 697
> >INACTIVE         empty empty     119 20240       119 20240       118 802         118 697
> >REMOVE           empty empty     118 438456      118 438456      118 802         118 697
> >REMOVE           empty empty     118 438772      118 438772      118 802         118 697
> >CREATE           empty empty     119 35872       119 35872       118 802         118 697
> >FSYNC_TS         active empty    119 205428      119 205428      118 802         118 697
> >FSYNC_TS         active empty    119 202944      119 202944      118 802         118 697
> >FSYNC_TS         active empty    119 200664      119 200664      118 802         118 697
> >REMOVE           empty empty     118 380316      118 380316      118 724         118 652
> >INACTIVE         empty empty     118 552532      118 552532      118 724         118 652
> >FSYNC_TS         empty empty     118 382140      118 382140      118 724         118 652
> >INACTIVE         empty empty     118 565968      118 565968      118 724         118 652
> >REMOVE           empty empty     119 25404       119 25404       118 802         118 697
> >INACTIVE         active empty    119 25580       119 25580       118 802         118 697
> 
> 
> 
> Just so you don't go down a blind alley, the timestamp on the log
> went backwards there. If you resort on the time stamps this does not
> go backwards.

Yup, you are right, timestamps jump around, so that may not be the cause.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
