Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 812F37F51
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 16:51:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 256F4AC001
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 14:51:49 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TWpqtj2BxRFkIHJG for <xfs@oss.sgi.com>;
	Thu, 06 Feb 2014 14:51:47 -0800 (PST)
Date: Fri, 7 Feb 2014 09:51:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] support appending AIO writes
Message-ID: <20140206225132.GE13647@dastard>
References: <20140204172402.380571745@bombadil.infradead.org>
	<CA+QCeVRmDFjF9YMgEOR7UpdQMQU98cR0KeO1HMNoP9k1ZvOzaA@mail.gmail.com>
	<CA+QCeVQxTk=ZNucLG4WPrQC=oHf1sFtJ7nj5dhJg=BUyuVbsOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+QCeVQxTk=ZNucLG4WPrQC=oHf1sFtJ7nj5dhJg=BUyuVbsOQ@mail.gmail.com>
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
To: Sergey Meirovich <rathamahata@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Feb 06, 2014 at 06:29:11PM +0200, Sergey Meirovich wrote:
> On 5 February 2014 16:52, Sergey Meirovich <rathamahata@gmail.com> wrote:
> > Hi Christoph,
> >
> > Thanks a lot! Applied your patches on top of 3.13.1 and they indeed
> > make a huge difference.
> >
> >
> > Append AIO
> >
> > chunk size           w/o patches                               with patches
> > ===================================================
> > 4k               6.8834 Mb/sec 1762.15 IOps      31.542 Mb/sec 8074.75 IOps
> > 8k               15.321 Mb/sec 1961.12 IOps      62.873 Mb/sec 8047.71 IOps
> > 16k             28.257 Mb/sec 1808.46 IOps      139.35 Mb/sec 8918.45 IOps
> 
> And with simple wrapper around io_submit() difference for 4 k is even
> more impressive than with sysbench:
> 
> without patches:
> =====================
> bandwidth (MiB/s):    11.89
> IOps:                    3044.58
> 
> with patches:
> =====================
> bandwidth (MiB/s):    118.16
> IOps:                   30250.17

Thanks for providing numbers, Sergey. It's clear that we need to
make this change from them. Can I add a "Tested-by: Sergey Meirovich
<rathamahata@gmail.com>" to the patches?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
