Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 10:23:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4EHNAcR009525
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 10:23:12 -0700
Received: from hp3.statik.tu-cottbus.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 183CD16BCDA8
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 10:23:55 -0700 (PDT)
Received: from hp3.statik.tu-cottbus.de (hp3.statik.tu-cottbus.de [141.43.120.68]) by cuda.sgi.com with ESMTP id Qi6R1TwHT4GlWYvi for <xfs@oss.sgi.com>; Wed, 14 May 2008 10:23:55 -0700 (PDT)
Message-ID: <482B1FD7.70108@s5r6.in-berlin.de>
Date: Wed, 14 May 2008 19:22:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org> <alpine.LNX.1.10.0805130115090.25441@fbirervta.pbzchgretzou.qr> <482952F2.3080608@unixsol.org>
In-Reply-To: <482952F2.3080608@unixsol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Georgi Chorbadzhiyski <gf@unixsol.org>
Cc: Jan Engelhardt <jengelh@medozas.de>, xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Georgi Chorbadzhiyski wrote:
> Jan Engelhardt mumbled something about, On 5/13/08 2:21 AM:
>> On Tuesday 2008-05-13 00:55, Georgi Chorbadzhiyski wrote:
>>>>  1148 ?        S<     0:00  \_ [khpsbpkt]
>>> What is this?
>> 
>> ieee1394/ieee1394_core.c:static struct task_struct *khpsbpkt_thread;
> 
> Strange names :)

Fixed in drivers/firewire/.  :-)

PS:
"k" = kernel
"hpsb" = High Performance Serial Bus ( = IEEE 1394)
"pkt" = packet  (The thread completes split transactions associated with
outbound request packets.)
-- 
Stefan Richter
-=====-==--- -=-= -===-
http://arcgraph.de/sr/
