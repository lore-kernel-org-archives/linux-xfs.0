Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 16:21:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4CNKZBo030096
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 16:20:38 -0700
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0A5716A24AF
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 16:21:20 -0700 (PDT)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de [85.214.69.204]) by cuda.sgi.com with ESMTP id 8RsuRBLQH1SFnHOB for <xfs@oss.sgi.com>; Mon, 12 May 2008 16:21:20 -0700 (PDT)
Date: Tue, 13 May 2008 01:21:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
In-Reply-To: <4828CAC6.3090402@unixsol.org>
Message-ID: <alpine.LNX.1.10.0805130115090.25441@fbirervta.pbzchgretzou.qr>
References: <4828CAC6.3090402@unixsol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Georgi Chorbadzhiyski <gf@unixsol.org>
Cc: xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>


On Tuesday 2008-05-13 00:55, Georgi Chorbadzhiyski wrote:
>
>Not needed here, because no jfs partition is in use.
>Not needed here, because no xfs partition is in use.
>I dont use gfs2

You miss the best of Linux. So, why not unload the modules?

>>  1141 ?        S<     0:00  \_ [block-osm/1]
>
>What is osm? Can't find anything in kernel config?

drivers/message/i2o/i2o_block.c:#define OSM_NAME        "block-osm"

>>  1148 ?        S<     0:00  \_ [khpsbpkt]
>
>What is this?

ieee1394/ieee1394_core.c:static struct task_struct *khpsbpkt_thread;
