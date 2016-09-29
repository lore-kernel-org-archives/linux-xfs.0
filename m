Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C2E417CA0
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 15:36:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27E52AC004
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 13:36:25 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id d18khtZWYQvqwYBB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Sep 2016 13:36:22 -0700 (PDT)
Date: Thu, 29 Sep 2016 13:35:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 3/3] block: implement (some of) fallocate for block
	devices
Message-ID: <20160929203545.GF14092@birch.djwong.org>
References: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
	<147510959149.8940.2897845352082568677.stgit@birch.djwong.org>
	<20160929021900.GA4901@birch.djwong.org>
	<423d057c-d2cc-9039-d8ee-c6526be3ae46@sandisk.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <423d057c-d2cc-9039-d8ee-c6526be3ae46@sandisk.com>
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
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

On Thu, Sep 29, 2016 at 01:08:57PM -0700, Bart Van Assche wrote:
> On 09/28/2016 07:19 PM, Darrick J. Wong wrote:
> >After much discussion, it seems that the fallocate feature flag
> >FALLOC_FL_ZERO_RANGE maps nicely to SCSI WRITE SAME; and the feature
> >FALLOC_FL_PUNCH_HOLE maps nicely to the devices that have been
> >whitelisted for zeroing SCSI UNMAP.  Punch still requires that
> >FALLOC_FL_KEEP_SIZE is set.  A length that goes past the end of the
> >device will be clamped to the device size if KEEP_SIZE is set; or will
> >return -EINVAL if not.  Both start and length must be aligned to the
> >device's logical block size.
> >
> >Since the semantics of fallocate are fairly well established already,
> >wire up the two pieces.  The other fallocate variants (collapse range,
> >insert range, and allocate blocks) are not supported.
> 
> For the FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE
> case, it's probably safer not to try to send a discard to block devices that
> do not support discard in order not to hit block driver bugs. But that's
> something we can still discuss later. Hence:

I'll just change it to check the queue flags and post a new revision.
At this point I might as well repost the whole thing to reflect the
reviewed-bys.

--D

> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
