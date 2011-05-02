Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p424Vw6a208923 for <xfs@oss.sgi.com>; Sun, 1 May 2011 23:31:58 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DA6A1EC6C89
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 21:35:33 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 1wPCy2XWKpBExEpI
	for <xfs@oss.sgi.com>; Sun, 01 May 2011 21:35:33 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 37CA66C0F2
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 23:35:33 -0500 (CDT)
Message-ID: <4DBE3492.4060303@hardwarefreak.com>
Date: Sun, 01 May 2011 23:35:30 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: op-journaled fs, journal size and storage speeds
References: <19900.8703.214676.218477@tree.ty.sabi.co.UK>
	<20110501092758.GG13542@dastard>
In-Reply-To: <20110501092758.GG13542@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 5/1/2011 4:27 AM, Dave Chinner wrote:

> Got a supplier for the custom hardware you'd need? Just use a PCIe
> SSD....

50GB OCZ RevoDrive PCIe x4 SSD MLC NAND
Dual SandForce 1200 controllers, internal RAID 0 design
70,000 write IOPS, 4KB aligned
350MB/s write sustained

$200 USD at Newegg:
http://www.newegg.com/Product/Product.aspx?Item=N82E16820227596

Current best value for a PCIe SSD suitable for dedicated log drive use, 
can fit ~22 maximum size (2GB) XFS logs.  Note the MLC NAND.  If all 
your filesystems will sustain constant high rate metadata writes, an SLC 
based product is more suitable, though price is 10-50x higher for PCIe 
SLC cards.  If you want/need the 10x increase in flash cell life of SLC 
NAND, go with this Intel SLC SATAII SSD for ~2x the $$ of the Revo. 
Note it's write IOPS is 'only' 33k, size is 32GB, 18GB less.

http://www.newegg.com/Product/Product.aspx?Item=N82E16820167013

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
