Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FGEFKi198234 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 11:14:15 -0500
Received: from ppsw-30.csi.cam.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 177F44E5745
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 09:15:02 -0700 (PDT)
Received: from ppsw-30.csi.cam.ac.uk (ppsw-30.csi.cam.ac.uk [131.111.8.130])
	by cuda.sgi.com with ESMTP id UXqSyIQBiAgZPT8d for
	<xfs@oss.sgi.com>; Wed, 15 Sep 2010 09:15:02 -0700 (PDT)
Received: from mail.mrc-lmb.cam.ac.uk ([131.111.85.9]:60706
	helo=mail.lmb.internal)
	by ppsw-30.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.136]:25)
	with esmtp id 1OvudM-0008Nq-fu (Exim 4.72) for xfs@oss.sgi.com
	(return-path <dhoworth@mrc-lmb.cam.ac.uk>);
	Wed, 15 Sep 2010 17:14:57 +0100
Received: from cpepc210-3.lmb.internal ([10.14.0.2])
	by mail.lmb.internal with esmtp (Exim 4.63)
	(envelope-from <dhoworth@mrc-lmb.cam.ac.uk>) id 1OvudM-0006p4-T6
	for xfs@oss.sgi.com; Wed, 15 Sep 2010 17:14:56 +0100
Message-ID: <4C90F100.3080807@mrc-lmb.cam.ac.uk>
Date: Wed, 15 Sep 2010 17:14:56 +0100
From: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
MIME-Version: 1.0
Subject: Re: no space left on device with 662G free
References: <4C90D080.5090004@mrc-lmb.cam.ac.uk>	<1284561000.2452.1.camel@doink>	<4C90DA52.8090507@mrc-lmb.cam.ac.uk>
	<4C90DF38.3070909@dermichi.com>
In-Reply-To: <4C90DF38.3070909@dermichi.com>
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

Michael Weissenbacher wrote:
> Try:
> # xfs_growfs -m 10 /dev/mapper/vg--storage-lv--data
> 
> It will increase your inode max percentage from 5 to 10.

Thanks. That seems to have fixed it.
Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
