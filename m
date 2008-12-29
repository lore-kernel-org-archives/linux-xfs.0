Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBT5nrwm032485 for <xfs@oss.sgi.com>; Sun, 28 Dec 2008 23:49:53 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF9BD1792328
	for <xfs@oss.sgi.com>; Sun, 28 Dec 2008 21:49:52 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id nbes8iaLUGjFk8B5 for
	<xfs@oss.sgi.com>; Sun, 28 Dec 2008 21:49:52 -0800 (PST)
Message-ID: <495864E1.9070403@sandeen.net>
Date: Sun, 28 Dec 2008 23:49:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS corruption on ARM
References: <20081228123305.GE30805@themel.com>
	<20081229002851.GD22525@disturbed>
In-Reply-To: <20081229002851.GD22525@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Thomas Themel <thomas@themel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Dave Chinner wrote:
> [CC'd the xfs list.]
> 
> On Sun, Dec 28, 2008 at 01:33:05PM +0100, Thomas Themel wrote:
>> Hi,
>>
>> there was a thread[0] on this list in 2008-10 about XFS corrupting
>> rather quickly on recent ARM kernels, which seems to have petered out
>> without any apparent results. I'm still seeing the same problems with
>> 2.6.28, and I suspect that this qualifies as a kind of regression
>> (though ancient), since the devices I'm running this on (Buffalo
>> LinkStations) originally ship with a (vendor-modified) 2.6.16 kernel,
>> where XFS seems to be working.
>>
>> Is this still on anyone's radar? I'm willing to test proposed fixes and
>> supply data[1], but lack any deep knowledge of either ARM or XFS internals.
>>
>> (Please Cc: me, I'm not on the list.)

could be related to http://oss.sgi.com/bugzilla/show_bug.cgi?id=755

-Eric

>> [0] http://lkml.org/lkml/2008/10/1/382
>> [1] Though mine doesn't look any different from what was posted in [0]
>>     to the little-trained eye.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
