Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92D147F62
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 02:29:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2E6E6AC001
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 00:29:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id HHMjDuFEiIFmNimB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 00:29:45 -0700 (PDT)
Date: Mon, 14 Oct 2013 00:29:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: always take the iolock around xfs_setattr_size
Message-ID: <20131014072943.GA21013@infradead.org>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075639.940898263@bombadil.infradead.org>
	<20131014045007.GF4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131014045007.GF4446@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Oct 14, 2013 at 03:50:07PM +1100, Dave Chinner wrote:
> I think there should be a bit more cleanup of this lock_flags
> variable. There's quite a few error paths that now "goto out_unlock"
> without actually holding a lock. i.e. they could just become a
> straight "return error", and lock_flags can probably go away
> completely...

I'll look into that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
