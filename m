Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAQDC3Lc165793 for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 07:12:04 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46A0E13EFE10
	for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 05:13:41 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id Cc2eU7pAPoMPO9FJ for
	<xfs@oss.sgi.com>; Fri, 26 Nov 2010 05:13:41 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUPR4GEI0GLS4YB0@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Fri, 26 Nov 2010 14:13:30 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUPR4FLWJ4LS4T43@mx.isti.cnr.it> for xfs@oss.sgi.com; Fri,
	26 Nov 2010 14:13:26 +0100 (MET)
Received: from [192.168.7.52] (firewall.itb.cnr.it [155.253.6.254])
	by mx.isti.cnr.it (PMDF V6.5 #31826)
	with ESMTPSA id <01NUPR4EEJ6YLOF4VD@mx.isti.cnr.it> for xfs@oss.sgi.com;
	Fri, 26 Nov 2010 14:13:24 +0100 (MET)
Date: Fri, 26 Nov 2010 14:15:35 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Verify filesystem is aligned to stripes
In-reply-to: <20101126122218.GH12187@dastard>
Message-id: <4CEFB2F7.5070103@shiftmail.org>
MIME-version: 1.0
References: <4CED5BFC.8000906@shiftmail.org> <20101125054607.GM13830@dastard>
	<4CEE0995.9030900@hardwarefreak.com>
	<20101125101537.GD12187@dastard>
	<4CEEE9BC.2030401@hardwarefreak.com>
	<20101126091622.264830fa@galadriel.home>
	<20101126122218.GH12187@dastard>
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

On 11/26/2010 01:22 PM, Dave Chinner wrote:
>
> FWIW, for workloads that do random, small IO, XFS works best when you
> _turn off_ aligned allocation and just let it spray the IO at the
> disks. This works best if you are using RAID 0/1/10. All the numbers
> I've been posting are with aligned allocation turned off (i.e. no
> sunit/swidth set).
>    

I think I also noticed this...

The thing is, for large sequential I/O it seems to me it's indifferent 
if XFS is aligned or not, because the resulting file will anyway be 
sequential, and if you have raid10 or even parity raid with a large 
stripe cache there won't be any reads anyway. Ok maybe with alignment 
you could avoid reads on the first stripe (not sure, it might read 
anyway if the RAID reacts fast, before enough output is sent to it), but 
that's the only one.

So when is alignment to be turned on?

Thanks for the info

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
