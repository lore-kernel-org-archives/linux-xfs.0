Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NAdwFU195703 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 05:39:59 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2ADB15C816F
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 03:49:58 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ExQKv5ivUDsZUO9B
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 03:49:58 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 0B6AB6C3D1
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 05:43:00 -0500 (CDT)
Message-ID: <4C497233.8000401@hardwarefreak.com>
Date: Fri, 23 Jul 2010 05:42:59 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 4k sector drives
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>	<201007230809.28111@zmi.at>
	<20100723095832.GA23174@infradead.org>
In-Reply-To: <20100723095832.GA23174@infradead.org>
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

Christoph Hellwig put forth on 7/23/2010 4:58 AM:

> What values do the files
> 
> 	/sys/block/<device>/queue/logical_block_size
> 	/sys/block/<device>/queue/physical_block_size
> 	/sys/block/<device>/alignment_offset
> 
> say about your disk?

FWIW, for comparison, my 500GB Blue series WD5000AAKS-00V1A0 shows

logical_block_size	512
physical_block_size	512
alignment_offset	0

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
