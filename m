Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PH9Zkj016175 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 12:09:35 -0500
Date: Mon, 25 Jul 2011 13:09:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12 v3] xfs: Remove the macro XFS_BUF_ZEROFLAGS
Message-ID: <20110725170932.GA1937@infradead.org>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722233945.14612.1955.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110724113959.GD26332@infradead.org>
	<1311609452.2914.23.camel@doink>
	<20110725162718.GC2434@infradead.org>
	<1311613642.2914.40.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311613642.2914.40.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Mon, Jul 25, 2011 at 12:07:22PM -0500, Alex Elder wrote:
> - Look into having xfs_qm_dqalloc() return ENOMEM when
>   it is unable to allocate a buffer, and fix all the
>   callers up the chain so they handle such a situation
>   appropriately.  Right now such errors get reset.

It's not.  We allocate buffers inside dirty transactions, so we
really cannot handle errors there.  I've been trying to fix that
last time in about 2002 or 2003, and it didn't go very far.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
