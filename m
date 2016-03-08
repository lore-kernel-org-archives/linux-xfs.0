Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9FA607CA0
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 20:33:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 152E6AC001
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 18:33:49 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3nBJoUvFDDI74mI2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Mar 2016 18:33:48 -0800 (PST)
Date: Mon, 7 Mar 2016 18:33:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] xfs: ioends require logically contiguous file offsets
Message-ID: <20160308023311.GB27689@birch.djwong.org>
References: <1457300990-18300-1-git-send-email-david@fromorbit.com>
	<1457300990-18300-3-git-send-email-david@fromorbit.com>
	<20160307162644.GB19784@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160307162644.GB19784@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Mar 07, 2016 at 08:26:44AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 07, 2016 at 08:49:46AM +1100, Dave Chinner wrote:
> > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > 
> > We need to create a new ioend if the current writepage call isn't
> > logically contiguous with the range contained in the previous ioend.
> > Hopefully writepage gets called in order of increasing file offset.
> 
> This looks reasonable, but how did we manage to get away without this for
> so long?  I think as-is we do not actually require it - for setting
> i_size we just care about the highest offset, and for unwritten extent
> conversion we just need the lowest and highest offset, and we were
> making use of that fact in direct I/O extensively before I rewrote that
> code not to use ioends.

The way I found this was by one of the cow tests failing (generic/139,
I think?) -- if two non-adjacent file blocks were both CoW but mapped
to adjacent physical blocks, the ioend check behaved as if the two
file blocks were logically adjacent and combine them into one ioend.
That sounds confusing even as I write it, so let's try an example:

Say that /tmp/a block 10 and block 12 are both shared and dirty.
Writepage comes along and allocates blocks 980 and 981 as
replacements.  This means that 10 -> 980 and 12 -> 981.  The ioend
combining code seems that 980 and 981 are adjacent and submits an
ioend with offset 10 and length 2, instead of two ioends {10, 1} and
{12, 1} like you'd expect, and as a result the CoW remapping is
incorrect.

I think we used to get away with this because _vm_writepage gets a
mapping that only extends as far as the next io_type change, because
XFS_IO_OVERWRITE and XFS_IO_UNWRITTEN only change at bmbt record
boundaries and since for CoW we only deal with CoW fork bmbt records,
that still holds true.  Therefore, we performed only limited ioend
chaining that ended at every extent boundary.  Now that we collect the
ioends in a struct writepage_ctx that can span several writepage
calls, we can end up with ioends crossing bmbt record boundaries.

--D

> So this looks fine to me, but the description could use some better
> wording.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
