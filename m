Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SADP5D150323 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 05:13:36 -0500
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9508D1D61E2A
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 03:14:06 -0700 (PDT)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id WeSkrgTch0VcdJBF
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 03:14:06 -0700 (PDT)
Date: Fri, 28 Aug 2009 12:14:04 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xfs_check does not recognize fs truncation
In-Reply-To: <alpine.LSU.2.00.0908241714410.17924@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LSU.2.00.0908281210250.15292@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0908241208520.1028@fbirervta.pbzchgretzou.qr>
	<20090824144752.GA20898@infradead.org>
	<alpine.LSU.2.00.0908241714410.17924@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Monday 2009-08-24 18:04, Jan Engelhardt wrote:
>On Monday 2009-08-24 16:47, Christoph Hellwig wrote:
>>On Mon, Aug 24, 2009 at 12:12:59PM +0200, Jan Engelhardt wrote:
>>> 
>>> This I see on xfsprogs-2.10.1 with kernel 2.6.29.6:
>>
>>What does xfs_repair -n say?
>
>[success]
>
>You can get the image at
>http://dev.medozas.de/files/linux-hist.img.lzma [179MB->1782MB]
>

If I pad the image with at least 20480*512 NUL bytes to a total of
1879048192 bytes, xfs (kernel side) starts to accept the image and
will mount it.

The steps to return to the previous problematic size is as follows:
# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/loop0             1824768   1274824    549944  70% /mnt/linux-hist
# truncate --size=$((1824768*1024)) linux-hist.img

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
