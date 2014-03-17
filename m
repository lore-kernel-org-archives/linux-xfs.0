Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9F4617F6D
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 17:51:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3298DAC004
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 15:51:03 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id MeBIBEfoqAGPcoAp
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 15:51:02 -0700 (PDT)
Message-ID: <53277C56.7000002@hardwarefreak.com>
Date: Mon, 17 Mar 2014 17:51:02 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: elevator question
References: <ea0e10e64a65dbd39cd71a826e18985e@zbfmail.de>
In-Reply-To: <ea0e10e64a65dbd39cd71a826e18985e@zbfmail.de>
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
To: weber@zbfmail.de, Xfs <xfs@oss.sgi.com>

On 3/17/2014 10:35 AM, Marko Weber|8000 wrote:
> 
> hello list,
> in the xfs faq i read elevator=noop is best when using ssd.
> i have the gentoo system on a ssd, but the larger data storage partition
> on softraid with some sata disks.
> is elevator=noop in this combo still best?

The elevator is per physical device.  For SSD use noop.  But with your
setup is doesn't matter as md/RAID will run at rust speed.

A better solution is to remove the SSD partition from the md/RAID array,
reshape/shrink/rebuild the array to make it happy, whatever is necessary
after removing the SSD partition.

Now configure the SSD partition as bcache and enable writeback policy.
This will increase the performance of the rust array to SSD level for
writes, and for reads after frequently accessed data is cached in your SSD.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
