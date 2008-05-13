Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 01:35:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4D8ZH6r010785
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:35:18 -0700
Received: from ns.unixsol.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D001D1225EDE
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:36:04 -0700 (PDT)
Received: from ns.unixsol.org (ns.unixsol.org [193.110.159.2]) by cuda.sgi.com with ESMTP id pMryDR90uLVScHpL for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:36:04 -0700 (PDT)
Message-ID: <482952F2.3080608@unixsol.org>
Date: Tue, 13 May 2008 11:36:02 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org> <alpine.LNX.1.10.0805130115090.25441@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0805130115090.25441@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Jan Engelhardt mumbled something about, On 5/13/08 2:21 AM:
> On Tuesday 2008-05-13 00:55, Georgi Chorbadzhiyski wrote:
>> Not needed here, because no jfs partition is in use.
>> Not needed here, because no xfs partition is in use.
>> I dont use gfs2
> 
> You miss the best of Linux. So, why not unload the modules?

ext3 is working just fine for now, thanks (:

>>>  1141 ?        S<     0:00  \_ [block-osm/1]
>> What is osm? Can't find anything in kernel config?
> 
> drivers/message/i2o/i2o_block.c:#define OSM_NAME        "block-osm"
> 
>>>  1148 ?        S<     0:00  \_ [khpsbpkt]
>> What is this?
> 
> ieee1394/ieee1394_core.c:static struct task_struct *khpsbpkt_thread;

Strange names :)

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
