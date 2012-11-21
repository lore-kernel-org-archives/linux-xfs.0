Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALN82CQ106343 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 17:08:02 -0600
Received: from mout.web.de (mout.web.de [212.227.15.3]) by cuda.sgi.com with
	ESMTP id zBJnqrhNMBlswpUe for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 15:10:12 -0800 (PST)
Date: Thu, 22 Nov 2012 00:10:01 +0100
From: Julian Wollrath <jwollrath@web.de>
Subject: Re: Oops with to traces on v3.7-rc6
Message-ID: <20121122001001.27708eb1@ilfaris>
In-Reply-To: <20121121222225.GS2591@dastard>
References: <20121121141811.665a1074@ilfaris> <20121121222225.GS2591@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> > [12859.938035] Pid: 2977, comm: xfs_fsr Tainted: G         C
> > 3.7.0-rc6-wl+ #1 LENOVO 30515YG/30515YG
>                                                            ^^^^^
> 
> You have a module loaded that is tagged as "crap". IOWs, your
> using modules from the staging tree. There should be an earlier
> warning in dmesg telling you what it is. Can you reproduce the
> problem without a tainted kernel?
The module from staging is rts_pstor, a driver for my sd-card reader,
which I was not using when I got the traces. Nevertheless, I tried to
reproduce the problem with a not tainted kernel but I was not able to
do so. Furthermore, I was not able to reproduce it with the tainted
kernel either.

Since in the line you cited, comm: xfs_fsr is mentioned, maybe it is
useful to know, that I use version 3.1.7+b1 of xfsprogs out of Debian
Sid.


With best regards,
Julian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
