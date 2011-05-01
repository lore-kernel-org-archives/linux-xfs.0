Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41GTY5D183806 for <xfs@OSS.SGI.com>; Sun, 1 May 2011 11:29:34 -0500
Received: from hermes1.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25C55424B3D
	for <xfs@OSS.SGI.com>; Sun,  1 May 2011 09:33:09 -0700 (PDT)
Received: from hermes1.dur.ac.uk (hermes1.dur.ac.uk [129.234.248.1]) by
	cuda.sgi.com with ESMTP id fUGo2QTVKKWGGR0F for
	<xfs@OSS.SGI.com>; Sun, 01 May 2011 09:33:09 -0700 (PDT)
Received: from smtphost2.dur.ac.uk (smtphost2.dur.ac.uk [129.234.252.2])
	by hermes1.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p41GWrFY014021
	for <xfs@OSS.SGI.com>; Sun, 1 May 2011 17:32:57 +0100
Received: from ty.sabi.co.UK (o1.phyip3.dur.ac.uk [129.234.186.1])
	by smtphost2.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p41GWZis018868
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@OSS.SGI.com>; Sun, 1 May 2011 17:32:35 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1QGZZN-0004vI-8F
	for <xfs@OSS.SGI.com>; Sun, 01 May 2011 17:32:29 +0100
MIME-Version: 1.0
Message-ID: <19901.35612.784066.862671@tree.ty.sabi.co.UK>
Date: Sun, 1 May 2011 17:32:28 +0100
Subject: Re: xfs performance problem
In-Reply-To: <4DB75C6D.1080901@inf.ethz.ch>
References: <4DB72084.8020205@inf.ethz.ch> <4DB74331.3030804@hardwarefreak.com>
	<4DB75C6D.1080901@inf.ethz.ch>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

> [ ... ]

> This is of course with delaylog enabled. I don't think a
> difference of a factor 7 is normal, given that writing to a
> raid-0 (xfs numbers) is supposed to be faster than writing to
> raid-1 (ext3 numbers) [ ... ]

To summarize some previous detailed discussion the actual
"performance" difference is either a factor of around 2 (12m for
'ext3', 24m for XFS) in the regular case or a factor of around 1.2
(27s for 'ext3', 33s for XFS) in the EatMyData (plus 'umount')
case (the one giving you over 1,300 transactions second).

Numbers like a bit over 2m for XFS with 'delaylog' and a bit
over 4m without are for intermediate cases between the regular
and EatMyData case, depending on how infrequently data and
metadata are committed by XFS.

If you want best "performance" with XFS, 'exec eatmydata "$SHELL"'
might be the top solution ;-).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
