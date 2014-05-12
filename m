Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FA5D7F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 07:59:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B353304032
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 05:59:03 -0700 (PDT)
Received: from mout.web.de (mout.web.de [212.227.15.3]) by cuda.sgi.com with
	ESMTP id gw0abYf8o1yEi1zG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 05:59:02 -0700 (PDT)
Received: from [134.60.2.64] ([134.60.2.64]) by smtp.web.de (mrweb102) with
	ESMTPSA (Nemesis) id 0LwHkw-1Wrw5L1MJK-0184oE for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 14:59:01 +0200
Message-ID: <5370C592.6080402@web.de>
Date: Mon, 12 May 2014 14:58:58 +0200
From: Matthias Neuer <mneuer@web.de>
MIME-Version: 1.0
Subject: xfs spanning over ssd and hdd
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi.

I have a slow and big hdd and a fast but small ssd and want to test the 
following setup but don't know if it's possible.

Use LVM to concatenate the ssd and the hdd linearly. Create a xfs 
filesystem on this device such that the sdd is filled first, i.e. data 
is written to the ssd as long as there is free space, otherwise the data 
is written to the hdd.

I have applications which may benefit from this setup but I am not sure 
so I need to do some benchmarks.

Thanks for your help
Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
