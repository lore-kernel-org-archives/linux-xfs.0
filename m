Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6CF2D7F50
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 19:22:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E73C1AC002
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 17:22:05 -0800 (PST)
Received: from sabe.cs.wisc.edu (sabe.cs.wisc.edu [128.105.6.20]) by
	cuda.sgi.com with ESMTP id LUTR6iLmDFYwKNLK (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 09 Jan 2016 17:22:03 -0800 (PST)
Message-ID: <5691B208.9060001@cs.wisc.edu>
Date: Sat, 09 Jan 2016 19:21:12 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
MIME-Version: 1.0
Subject: Re: [dm-devel] [PATCH 02/35] block: add REQ_OP definitions and
	bi_op/op fields
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<1452027218-32303-3-git-send-email-mchristi@redhat.com>
	<20160109133716.GB26660@infradead.org>
	<5691AC2E.2050403@cs.wisc.edu>
In-Reply-To: <5691AC2E.2050403@cs.wisc.edu>
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
To: device-mapper development <dm-devel@redhat.com>, mchristi@redhat.com
Cc: linux-raid@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, philipp.reisner@linbit.com, drbd-dev@lists.linbit.com, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org

On 01/09/2016 06:56 PM, Mike Christie wrote:
> On 01/09/2016 07:37 AM, Christoph Hellwig wrote:
>> Seems like this is missing REQ_OP_FLUSH, which still hides as a write?
>>

Oh yeah, to answer the second part of your question, REQ_OP_FLUSH is
only a flush operation like what request_fn drivers wanted.

REQ_PREFLUSH can be set with a REQ_OP_WRITE bio when filesystems want to
do both.

There is then the case where filesystems and blkdev_issue_flush could
just want to request a flush. I left them as a REQ_PREFLUSH with
REQ_OP_WRITE set, so there would be a single code path.

> 
> I might have misunderstood what you wanted or am misunderstanding you now.
> 
> I did not change the flush related code until the last patches. I added
> REQ_OP_FLUSH in patch:
> 
> [PATCH 33/35] block, drivers: add REQ_OP_FLUSH operation
> commit 18dea20363ba245a47bc1bb54f6465b8a05b19af
> Author: Mike Christie <mchristi@redhat.com>
> Date:   Tue Jan 5 21:02:17 2016 -0600
> 
>     block, drivers: add REQ_OP_FLUSH operation
> 
> 
> and I added the REQ_PREFLUSH flag in
> 
> 
> [PATCH 35/35] block, drivers, fs: rename REQ_FLUSH to REQ_PREFLUSH
> commit 303dc6a7cc3673065538ba041562fcd833a619af
> Author: Mike Christie <mchristi@redhat.com>
> Date:   Thu Jan 7 18:17:03 2016 -0600
> 
>     block, drivers, fs: rename REQ_FLUSH to REQ_PREFLUSH
> 
> 
> I did them in separate patches, because I was not sure if they were
> correct with what you requested before, and because they were a little
> more tricky because of how request_fn drivers, make_request_fn drivers,
> and dm-multipath handle flushes differently.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
