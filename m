Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13JgrfW156346 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 13:42:53 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id oAe0Cq8aYYjWmEHm
	for <xfs@oss.sgi.com>; Fri, 03 Feb 2012 11:42:52 -0800 (PST)
Message-ID: <4F2C38BE.2010002@hardwarefreak.com>
Date: Fri, 03 Feb 2012 13:42:54 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Performance problem - reads slower than writes
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org>
	<20120131145205.GA6607@infradead.org>
	<20120203115434.GA649@nsrc.org>
In-Reply-To: <20120203115434.GA649@nsrc.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Candler <B.Candler@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 2/3/2012 5:54 AM, Brian Candler wrote:

> and the drives are Hitachi Deskstar 5K3000 HDS5C3030ALA630:

3TB, 32MB cache, 5940 RPM

> The files have an average size of 0.65MB

You stated you're writing 100,000 of these files across 1,000
directories, with Bonnie, then reading them back with dd in your custom
script.  You state this is similar to your production workload.

You've hit the peak read rate of these Hitachi drives.  As others
pointed out, if you need more read performance than the dozen of these
you plan to RAID stripe, then you'll need to swap them for units with a
faster spindle:

7.2k 	 1.21x
 10k	 1.68x
 15k	 2.53x

or with SSDs, which will yield an order of magnitude increase.  Your
stated need is 20M 500-800KB files, or 20GB if my math is correct.  Four
of these enterprise Intel SLC SSDs in a layered mdRAID0 over mdRAID1
will give you ~375 file reads/sec at 800KB per file, again if my math is
correct:
http://www.newegg.com/Product/Product.aspx?Item=N82E16820167062

for $480 USD total investment.  You might get by with a mirrored pair
depending on your actual space needs, but performance would be half.

You're probably wondering why I didn't recommend an mdRAID10 instead, or
a 3 SSD RAID5.  All of the mdRAID striped RAID codes serialize on a
single master thread, except for RAID0 and the linear concatenation
(--linear).  With storage devices capable of 35K IOPS each, that single
thread, even running on a 3+GHz core, has trouble keeping up.

The LSI 9201-16 you have is based on the SAS2116 chip, which isn't fast
enough in RAID10 mode to keep up with the SSDs.  In straight HBA mode it
is.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
