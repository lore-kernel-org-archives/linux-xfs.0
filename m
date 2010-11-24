Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO0XfpR035819 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 18:33:41 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FE6A19FB2F
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 16:35:18 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id KDnL0xBRH7TUuNPD for
	<xfs@oss.sgi.com>; Tue, 23 Nov 2010 16:35:18 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUM81T9XVKLGYSFA@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Wed, 24 Nov 2010 01:34:30 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUM81T4XZKLGYJQD@mx.isti.cnr.it> for xfs@oss.sgi.com; Wed,
	24 Nov 2010 01:34:30 +0100 (MET)
Date: Wed, 24 Nov 2010 01:36:37 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Xfs delaylog hanged up
In-reply-to: <20101123234811.0ea3c41c@galadriel.home>
Message-id: <4CEC5E15.7080307@shiftmail.org>
MIME-version: 1.0
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org> <20101123204609.GW22876@dastard>
	<20101123234811.0ea3c41c@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On 11/23/2010 11:48 PM, Emmanuel Florac wrote:
> So Spelic, you're using the 3Ware as a SATA controller, but not a RAID
> controller? This is quite unexpected, though going with md
> instead provides better IOPS.
>    

Yep, because I know MD better, I can see the code, it's more flexible 
and customizable, can be controlled with scripts more easily... Also 
parameters to the underlying drives can be controlled if I use MD, and 
it's easier to align filesystem to stripes. Also my time is better spent 
learning it as MD won't change the next time I buy a different hw 
controller.
What would be the advantage of using hardware raid?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
