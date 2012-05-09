Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q49L7tZQ128384 for <xfs@oss.sgi.com>; Wed, 9 May 2012 16:07:56 -0500
Message-ID: <4FAADCA8.6030702@sgi.com>
Date: Wed, 09 May 2012 16:07:52 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Still seeing hangs in xlog_grant_log_space
References: <20120425223845.GX9541@dastard>
	<CADLDEKvYkpUnMrqdMyqCmsYrZcUtiJ6ZRhrRu_ERTjn=r7M3Pg@mail.gmail.com>
	<20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507225944.GA5091@dastard> <20120509073507.GQ5091@dastard>
In-Reply-To: <20120509073507.GQ5091@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Juerg Haefliger <juergh@gmail.com>, xfs@oss.sgi.com

On 05/09/12 02:35, Dave Chinner wrote:

>
> Transaction	 Wait queues	 Grant head	 Write Head	 Log head	 Log tail
> -----------------------------------------------------------------------------------------
> INACTIVE         empty empty     118 438024      118 438024      118 802         118 697
> INACTIVE         empty empty     119 20240       119 20240       118 802         118 697
> REMOVE           empty empty     118 438456      118 438456      118 802         118 697
> REMOVE           empty empty     118 438772      118 438772      118 802         118 697
> CREATE           empty empty     119 35872       119 35872       118 802         118 697
> FSYNC_TS         active empty    119 205428      119 205428      118 802         118 697
> FSYNC_TS         active empty    119 202944      119 202944      118 802         118 697
> FSYNC_TS         active empty    119 200664      119 200664      118 802         118 697
> REMOVE           empty empty     118 380316      118 380316      118 724         118 652
> INACTIVE         empty empty     118 552532      118 552532      118 724         118 652
> FSYNC_TS         empty empty     118 382140      118 382140      118 724         118 652
> INACTIVE         empty empty     118 565968      118 565968      118 724         118 652
> REMOVE           empty empty     119 25404       119 25404       118 802         118 697
> INACTIVE         active empty    119 25580       119 25580       118 802         118 697



Just so you don't go down a blind alley, the timestamp on the log went 
backwards there. If you resort on the time stamps this does not go 
backwards.

Not sorted:
grep ungrant_exit trace* | awk '{print $3, $8, $20, $22, $24, $26, $28, 
$30, $32, $34, $36, $38}' | less

3501.000611: FSYNC_TS active empty 119 205428 119 205428 118 802 118 697
3501.004513: FSYNC_TS active empty 119 202944 119 202944 118 802 118 697
3501.005210: FSYNC_TS active empty 119 200664 119 200664 118 802 118 697
3500.962328: REMOVE empty empty 118 380316 118 380316 118 724 118 652
3500.962458: INACTIVE empty empty 118 552532 118 552532 118 724 118 652
3500.962770: FSYNC_TS empty empty 118 382140 118 382140 118 724 118 652
3500.964781: INACTIVE empty empty 118 565968 118 565968 118 724 118 652
3500.971259: REMOVE empty empty 119 25404 119 25404 118 802 118 697
3500.971454: INACTIVE active empty 119 25580 119 25580 118 802 118 697

Sorted on the timestamps:
grep ungrant_exit trace* | awk '{print $3, $8, $20, $22, $24, $26, $28, 
$30, $32, $34, $36, $38}' | sort | less

3500.962328: REMOVE empty empty 118 380316 118 380316 118 724 118 652
3500.962386: INACTIVE empty empty 118 555684 118 555684 118 724 118 652
3500.962402: CREATE empty empty 118 380492 118 380492 118 724 118 652
3500.962458: INACTIVE empty empty 118 552532 118 552532 118 724 118 652
3500.962466: FSYNC_TS empty empty 118 552532 118 552532 118 724 118 652
3500.962476: REMOVE empty empty 118 380936 118 380936 118 724 118 652
3500.962534: INACTIVE empty empty 118 556304 118 556304 118 724 118 652
...
3500.979002: INACTIVE empty empty 118 437672 118 437672 118 802 118 697
3500.979185: CREATE empty empty 118 437848 118 437848 118 802 118 697
3500.979269: CREATE empty empty 118 438024 118 438024 118 802 118 697
3500.979462: INACTIVE empty empty 118 438024 118 438024 118 802 118 697
3500.979627: INACTIVE empty empty 119 20240 119 20240 118 802 118 697
3500.979657: REMOVE empty empty 118 438456 118 438456 118 802 118 697
3500.979713: REMOVE empty empty 118 438772 118 438772 118 802 118 697
3500.979815: CREATE empty empty 119 35872 119 35872 118 802 118 697
3501.000611: FSYNC_TS active empty 119 205428 119 205428 118 802 118 697


Maybe I have a corrupted version of his first trace, it looks like there 
are 2 series of log grant/write/head/tail sequences. These sequences are 
not even close to each other:

188.116687: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1 1655971
188.116939: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1 1655971
188.117755: CREATE empty empty 4440 166388 4440 166388 4440 312 4440 310
188.117784: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1 1655971
188.117902: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1 1655971
188.118249: CREATE empty empty 4440 166844 4440 166844 4440 312 4440 310
188.118350: CREATE empty empty 4440 167300 4440 167300 4440 312 4440 310
188.118628: FSYNC_TS empty empty 4440 167300 4440 167300 4440 312 4440 310
188.118837: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1 1655971
188.118868: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1 1655971

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
