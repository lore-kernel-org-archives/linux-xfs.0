Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F8347CA3
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 18:40:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9AE37AC002
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 16:40:35 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	fgmjUS0gX8lIncGj for <xfs@oss.sgi.com>;
	Thu, 14 Jul 2016 16:40:33 -0700 (PDT)
Date: Fri, 15 Jul 2016 09:40:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs -d su=XXX,sw=YYY and future volume resize
Message-ID: <20160714234011.GU1922@dastard>
References: <CACNifpVsOMKQyshHk8B7WrmsbGAN_fOz6qpHLBTc_N=K1xY0Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACNifpVsOMKQyshHk8B7WrmsbGAN_fOz6qpHLBTc_N=K1xY0Dw@mail.gmail.com>
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
To: Marcin Sura <mailing-lists@sura.pl>
Cc: xfs@oss.sgi.com

On Thu, Jul 14, 2016 at 10:19:02PM +0200, Marcin Sura wrote:
> Hi,
> 
> When I create filesystem I can specify su and sw paramteres which match
> underlying storage device.
> So for example, If I have raid 6 volume made of 6 + 2 disks with stripe
> size of 256k I create xfs with:
> 
> mkfs.xfs -d su=256k,sw=6 <disk>
> 
> But what if I will extend original volume by 2 disks. sw will 8. Will be
> there a performance panelty compared to filesystem created from scratch
> with correct sw parameter?

That depends on your workload more than anything. If the workload
benefits from correct stripe alignment of your data and IO, then it
will definitely perform worse if you change the stripe width so that
allocation is no longer able to align correctly to the physical
geometry of the storage.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
