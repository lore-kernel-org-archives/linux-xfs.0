Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Dec 2007 14:02:10 -0800 (PST)
Received: from ninsei.hu (ninsei.hu [212.92.23.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB3M21ja018837
	for <xfs@oss.sgi.com>; Mon, 3 Dec 2007 14:02:05 -0800
Received: from luba (lns-bzn-35-82-250-243-147.adsl.proxad.net [82.250.243.147])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chatsubo.ninsei.hu (Postfix) with ESMTP id B941D7A8D
	for <xfs@oss.sgi.com>; Mon,  3 Dec 2007 23:01:27 +0100 (CET)
Date: Mon, 3 Dec 2007 23:02:00 +0100
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: 2.6.24-rc3 oopses while mounting fs
Message-ID: <20071203220200.GC13667@luba>
References: <20071128134523.GF7793@luba> <474E003A.7020000@sgi.com> <20071130223154.GB13589@luba> <47537709.9040406@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47537709.9040406@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Lachlan Mcilroy (lachlan@sgi.com) [20071203 14:24]:

Lachlan,

> Okay, sounds like it might be a corrupt log.

Yep.

> Can you run xfs_logprint on the device or saved log?

Sure.

http://cern.ch/fuji/lxfsre1103/xfs_logprint1.txt.bz2
It aborted though, with the following message:

	xfs_logprint: unknown log operation type (343b)
	Bad data in log

> Also give xfs_logprint -t -i a go.

http://cern.ch/fuji/lxfsre1103/xfs_logprint2.txt.bz2

> You've saved the log into a file?  You can get the filesystem
> mounted again by deleting the log with xfs_repair -L <dev>.
> You'll probably need to run xfs_repair over the filesystem to be
> safe.

I conserved this filesystem away for further analysis, I'm not
sure how helpful it can be.

Thanks,
Peter

-- 
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+''
 Kelemen Péter     /       \       /       \     Peter.Kelemen@cern.ch
.+'         `+...+'         `+...+'         `+...+'         `+...+'
