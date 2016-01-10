Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 824537F52
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2016 01:16:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1CF37AC001
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 23:16:02 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id CVNY8zrOhZMtWdlI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 09 Jan 2016 23:16:00 -0800 (PST)
Date: Sat, 9 Jan 2016 23:15:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH 02/35] block: add REQ_OP definitions and
	bi_op/op fields
Message-ID: <20160110071558.GB12831@infradead.org>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<1452027218-32303-3-git-send-email-mchristi@redhat.com>
	<20160109133716.GB26660@infradead.org>
	<5691AC2E.2050403@cs.wisc.edu> <5691B208.9060001@cs.wisc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5691B208.9060001@cs.wisc.edu>
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
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-raid@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-bcache@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, mchristi@redhat.com, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, philipp.reisner@linbit.com, drbd-dev@lists.linbit.com, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org

On Sat, Jan 09, 2016 at 07:21:12PM -0600, Mike Christie wrote:
> Oh yeah, to answer the second part of your question, REQ_OP_FLUSH is
> only a flush operation like what request_fn drivers wanted.

And that's the odd part that trips me up.

> 
> REQ_PREFLUSH can be set with a REQ_OP_WRITE bio when filesystems want to
> do both.
> 
> There is then the case where filesystems and blkdev_issue_flush could
> just want to request a flush. I left them as a REQ_PREFLUSH with
> REQ_OP_WRITE set, so there would be a single code path.

But the pure flush without data transfer case is pretty different,
so it seems rather odd to handle it like that.  But I suspec we could
just fix that up later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
