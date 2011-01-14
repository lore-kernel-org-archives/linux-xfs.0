Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0EKkIvn085886 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 14:46:18 -0600
Received: from zixvpm02.zixvpm.davisvision.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5476410006F8
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 12:48:32 -0800 (PST)
Received: from zixvpm02.zixvpm.davisvision.com
	(zixvpm02.zixvpm.davisvision.com [65.213.99.45]) by
	cuda.sgi.com with ESMTP id y4iQHfXtInvETaMw for
	<xfs@oss.sgi.com>; Fri, 14 Jan 2011 12:48:32 -0800 (PST)
Received: from zixvpm02.zixvpm.davisvision.com (ZixVPM [127.0.0.1])
	by Outbound.davisvision.com (Proprietary) with ESMTP id 700255DC022
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 15:48:31 -0500 (EST)
Message-ID: <27616_1295038110_4D30B69E_27616_233_1_4D30B69E.4020506@davisvision.com>
Date: Fri, 14 Jan 2011 15:48:30 -0500
From: Cory Coager <ccoager@davisvision.com>
MIME-Version: 1.0
Subject: Re: extremely slow write performance plaintext
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>	<20110113233527.6dca104d@galadriel.home>	<18993_1294964274_4D2F9632_18993_1387_1_F79CF9ADB27B2646B59221B7355263830CC143B1@NYL-EXCH1.HVHCVision.com>
	<4D30A945.4060000@hardwarefreak.com>
In-Reply-To: <4D30A945.4060000@hardwarefreak.com>
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
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>

On 01/14/2011 02:51 PM, Stan Hoeppner wrote:
> Make sure the write cache on the P600 (what size is it BTW?) is enabled and that
> the BBU is in working order.  Also make sure the P600 is disabling the write
> caches on the drives themselves.  Then...
>
Write cache is enabled on the controller, the size is 512MB, BBU is in 
good conditioned (checked with the HP utility).  How do I check the 
write cache on the drives?
> Mount with 'nobarrier' so XFS isn't interfering with the hardware cache
> performance of the P600.  With barriers enabled (the default) XFS will
> periodically flush the cache on the RAID card causing write performance problems.
>
Already using nobarrier.



------------------------------------------------------------------------
The information contained in this communication is intended
only for the use of the recipient(s) named above. It may
contain information that is privileged or confidential, and
may be protected by State and/or Federal Regulations. If
the reader of this message is not the intended recipient,
you are hereby notified that any dissemination,
distribution, or copying of this communication, or any of
its contents, is strictly prohibited. If you have received
this communication in error, please return it to the sender
immediately and delete the original message and any copy
of it from your computer system. If you have any questions
concerning this message, please contact the sender.
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
