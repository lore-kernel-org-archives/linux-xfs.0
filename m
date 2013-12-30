Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 63EBE7F3F
	for <xfs@oss.sgi.com>; Sun, 29 Dec 2013 19:55:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 417FC304048
	for <xfs@oss.sgi.com>; Sun, 29 Dec 2013 17:55:20 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id oVUlBfBtfasvxTdr
	for <xfs@oss.sgi.com>; Sun, 29 Dec 2013 17:55:19 -0800 (PST)
Message-ID: <52C0D281.7040704@hardwarefreak.com>
Date: Sun, 29 Dec 2013 19:55:13 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: [xfs_check Out of memory: ]
References: <tencent_3F12563342ED1D4E049D1123@qq.com>	<201312270907.22638.arekm@maven.pl>	<20131227224212.GK20579@dastard>	<201312280020.39244.arekm@maven.pl>
	<20131229095033.GL20579@dastard>
In-Reply-To: <20131229095033.GL20579@dastard>
Reply-To: stan@hardwarefreak.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3?= =?UTF-8?B?aWN6?= <arekm@maven.pl>
Cc: Stor?? <289471341@qq.com>, Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com

On 12/29/2013 3:50 AM, Dave Chinner wrote:
...
> I think you are forgetting that developer time is *expensive* and
> *scarce*. This is essentially a solved problem: An SSD in a USB3
> enclosure as a temporary swap device is by far the most cost
> effective way to make repair scale to arbitrary amounts of metadata.
> It certainly scales far better than developer time and testing
> resources...

Now this is an interesting idea Dave.  I hadn't considered temporary
swap.  Would USB be reliable enough for this?  I've seen lots problem
reports with folks using USB storage with Linux, random disconnections
and what not.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
