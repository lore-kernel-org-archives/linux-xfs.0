Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4A2A88S142794 for <xfs@oss.sgi.com>; Wed, 9 May 2012 21:10:08 -0500
Message-ID: <4FAB237D.5050608@sgi.com>
Date: Wed, 09 May 2012 21:10:05 -0500
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
	<4FAADCA8.6030702@sgi.com>
In-Reply-To: <4FAADCA8.6030702@sgi.com>
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

On 05/09/12 16:07, Mark Tinguely wrote:
>
>
> Maybe I have a corrupted version of his first trace, it looks like there
> are 2 series of log grant/write/head/tail sequences. These sequences are
> not even close to each other:
>
> 188.116687: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1
> 1655971
> 188.116939: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1
> 1655971
> 188.117755: CREATE empty empty 4440 166388 4440 166388 4440 312 4440 310
> 188.117784: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1
> 1655971
> 188.117902: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1
> 1655971
> 188.118249: CREATE empty empty 4440 166844 4440 166844 4440 312 4440 310
> 188.118350: CREATE empty empty 4440 167300 4440 167300 4440 312 4440 310
> 188.118628: FSYNC_TS empty empty 4440 167300 4440 167300 4440 312 4440 310
> 188.118837: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1
> 1655971
> 188.118868: FSYNC_TS empty empty 1 847894476 1 847894476 1 1655998 1
> 1655971

Oops, there are multiple devices in that trace.


I notice in the trace_report_180secs.txt file, lsn (ail_push and the 
ungrants) displays are not correct. It acts like the BLOCK_LSN() is 
shifting too much. Block sequence numbers never make it too far above 
1100 before incrementing the cycle. I think the problem is the trace not 
the sequence numbers.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
