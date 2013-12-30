Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A87F7F3F
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 07:19:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08C15AC005
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 05:19:08 -0800 (PST)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id HHLnvjObeg8bHDoj for
	<xfs@oss.sgi.com>; Mon, 30 Dec 2013 05:19:04 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [xfs_check Out of memory: ]
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <52C0D281.7040704@hardwarefreak.com>
Date: Mon, 30 Dec 2013 13:19:02 +0000
Message-Id: <1F5B96C2-84EB-43B2-ACE5-7C14E7803C9F@filmlight.ltd.uk>
References: <tencent_3F12563342ED1D4E049D1123@qq.com>	<201312270907.22638.arekm@maven.pl>	<20131227224212.GK20579@dastard>	<201312280020.39244.arekm@maven.pl>
	<20131229095033.GL20579@dastard>
	<52C0D281.7040704@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: Stor?? <289471341@qq.com>, xfs@oss.sgi.com, Jeff Liu <jeff.liu@oracle.com>, Roger Willcocks <roger@filmlight.ltd.uk>


On 30 Dec 2013, at 01:55, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 12/29/2013 3:50 AM, Dave Chinner wrote:
> ...
>> I think you are forgetting that developer time is *expensive* and
>> *scarce*. This is essentially a solved problem: An SSD in a USB3
>> enclosure as a temporary swap device is by far the most cost
>> effective way to make repair scale to arbitrary amounts of metadata.
>> It certainly scales far better than developer time and testing
>> resources...
> 
> Now this is an interesting idea Dave.  I hadn't considered temporary
> swap.  Would USB be reliable enough for this?  I've seen lots problem
> reports with folks using USB storage with Linux, random disconnections
> and what not.
> 

I'll just chip in here and mention that we get around this problem by
exporting the broken xfs volume over iscsi and run xfs-repair on another
machine with more memory / swap space.

--
Roger


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
