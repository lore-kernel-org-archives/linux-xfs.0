Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBO62SVU075305 for <xfs@oss.sgi.com>; Fri, 24 Dec 2010 00:02:28 -0600
Received: from passage.avira.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 778DD147F28B
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 22:04:26 -0800 (PST)
Received: from passage.avira.com (passage.avira.com [89.238.222.20]) by
	cuda.sgi.com with ESMTP id ZTaoxvujhQ1F73Em for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 22:04:26 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by passage.avira.com (Postfix/AVIRA) with ESMTP id 45964124A05
	for <xfs@oss.sgi.com>; Fri, 24 Dec 2010 08:04:24 +0200 (EET)
Received: from naliboat.bu.avira.com (dasapass.avira.com [89.238.222.18])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "mail.bu.avira.com",
	Issuer "Avira Intermediate Certificate Authority 2010-2020" (not
	verified))
	by passage.avira.com (Postfix/AVIRA) with ESMTPS id 3673B124A05
	for <xfs@oss.sgi.com>; Fri, 24 Dec 2010 08:04:24 +0200 (EET)
Date: Fri, 24 Dec 2010 08:02:46 +0200
From: Petre Rodan <petre.rodan@simplex.ro>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20101224060246.GA2308@peter.simplex.ro>
References: <20101223165532.GA23813@peter.simplex.ro>
	<4D13A30A.3090600@hardwarefreak.com>
	<20101223211650.GA19694@peter.simplex.ro>
	<4D13EF3B.2050401@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D13EF3B.2050401@hardwarefreak.com>
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
To: xfs@oss.sgi.com


Hello Stan,

On Thu, Dec 23, 2010 at 06:54:19PM -0600, Stan Hoeppner wrote:
> Petre Rodan put forth on 12/23/2010 3:16 PM:
> 
> > but my original mail had a different target really. I have to recognize that I don't know much about the inner-workings of a filesystem, but I find it odd that once there is no input from the outside, a process keeps writing to the drive indefinitely. in my very narrow thinking the fact that these writes dissapear after a remount would prove their redundance.
> 
> Ahh, quite right.  Sorry Petre.  This might shed some light on your
> issue.  Old background thread:
> 
> http://oss.sgi.com/archives/xfs/2003-09/msg00674.html
> 
> Current documentation on this turnable knob:
> 
> http://www.mjmwired.net/kernel/Documentation/filesystems/xfs.txt

I appreciate your quick replies, but rest assured that I did search the archives and the documentation that came with the kernel.

I would be delighted to know the underlying reason why internal xfs processes need to flush things to the drive more than once. can't it be as easy as 

accept write command -> cache -> actual write to the hardware -> clean cache/log/dirty metadata -> sleep until next command comes (and not touch the drive in any way until then)

what am I missing in this picture? if anything needs to be flushed, why do it over and over again, once is not enough ?

what I found (see first mail from thread) is that a write to an xfs partition triggers an xfssyncd process to continually write to the drive for no apparent reason. and keeps writing at regulated intervals long after any other read or write request has been made from the outside. I left the drive untouched for 12 hours and xfssyncd was still pinging the drive. and there is no xfssyncd process pinging if I do not do initiate a write to the disk after the partition is mounted, so to me that means that xfs would function without constant writing to the underlying device.

> fs.xfs.xfssyncd_centisecs	(Min: 100  Default: 3000  Max: 720000)
> fs.xfs.age_buffer_centisecs	(Min: 100  Default: 1500  Max: 720000)

just increasing the delay until an inevitable and seemingly redundant disk write is not what I want.
I was searching for an option to make internal xfs processes not touch the drive after the buffers/log/dirty metadata have been flushed (once).

thanks,
peter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
