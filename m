Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANDOkLU212613 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 07:24:46 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3195F1DB1D9C
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 05:26:23 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id x589IwFzRmYG6Lgw for
	<xfs@oss.sgi.com>; Tue, 23 Nov 2010 05:26:23 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NULKP3TTLCLGYIH4@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Tue, 23 Nov 2010 14:26:07 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NULKP2N2K0LGYHG4@mx.isti.cnr.it> for xfs@oss.sgi.com; Tue,
	23 Nov 2010 14:26:05 +0100 (MET)
Date: Tue, 23 Nov 2010 14:28:09 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Xfs delaylog hanged up
In-reply-to: <4CEBA2D5.2020708@shiftmail.org>
Message-id: <4CEBC169.4020407@shiftmail.org>
MIME-version: 1.0
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org>
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
Cc: xfs@oss.sgi.com

On 11/23/2010 12:17 PM, Spelic wrote:
> mdadm --create /dev/md5 --raid-devices=16 --chunk=1024 --level=5 
> --metadata=1.0 pci-0000:05:00.0-scsi-0:0:{15..0}:0 
> --name=backup:perftest --assume-clean

I forgot one setting: md/stripe_cache_size was set to 32768
I forgot to check stripe_cache_active during the hang... but I don't 
think it was an MD bug
Regards

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
