Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6I7NvbU170396 for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 02:23:57 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	qykNqIIfqtaoDtaY (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Jul 2012 00:23:56 -0700 (PDT)
Received: by obbup19 with SMTP id up19so1922332obb.26
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 00:23:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50066115.7070807@hardwarefreak.com>
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
	<5004875D.1020305@hardwarefreak.com>
	<CAAxjCEw-NJzZmX3Q5CJ+aZ_Q7Yo39pMU=-hiXk0ghTMq7q3PWA@mail.gmail.com>
	<5004C243.6040404@hardwarefreak.com>
	<20120717052621.GB23387@dastard>
	<50061CEA.4070609@hardwarefreak.com>
	<CAAxjCEwgDKLF=RY0aCCNTMsc1oefXWfyHKh+morYB9zVUrnH-A@mail.gmail.com>
	<50066115.7070807@hardwarefreak.com>
Date: Wed, 18 Jul 2012 09:22:34 +0200
Message-ID: <CAAxjCExFUJOKaD-LMPfZvCrS34V1VHgtrhgvPP0jZ3Hm1YV=6g@mail.gmail.com>
Subject: Re: A little RAID experiment
From: Stefan Ring <stefanrin@gmail.com>
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

> *Gasp*  EXT3?  Not XFS?  Why are posting this thread on XFS?  The two
> will likely have (significantly) different behavior.

Because it was XFS originally which hammered the controller with this
disadvantageous pattern. Except for the concurrency, it doesn't matter
much on which filesystem sysbench operates. I've previously verified
this on another system.

> Also, to make any meaningful comparison, we kinda need to know which
> controller was targeted by these 3 runs below. ;)

It was the Fibre Channel controller, the one with the collapsing
throughput. (P2000 G3 MSA, QLogic Corp. ISP2532-based 8Gb Fibre
Channel to PCI Express HBA)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
