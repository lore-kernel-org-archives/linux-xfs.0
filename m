Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBEIXJF9223144 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 12:33:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 091A62BF1DF
	for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 10:33:16 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	muxUPasDc50cgE5i for <xfs@oss.sgi.com>;
	Wed, 14 Dec 2011 10:33:16 -0800 (PST)
Date: Wed, 14 Dec 2011 13:33:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC, PATCH 0/12] xfs: compound buffers for directory blocks
Message-ID: <20111214183314.GA18724@infradead.org>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323238703-13198-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

I've been really busy the last days and only managed to look over this
a bit while waiting for compiles and benchmarks.

The only really major comment I have is that I start to really dislike
the way struct xfs_bmbt_irec is used in the compound buffers.  The
XFS_EXT_DADDR flag basically gives the data types in there a totally
different meaning and is really confusing for anyone reading the code:
either we're using a "normal" one passes in from the directory code,
or an artificial one used internally, which uses different units.

I suspect we'd really be much better off introducing a new, smaller type
here, especially as it's only seen inside the buffer code:

struct xfs_buf_map {
	sector_t	bm_bno;
	size_t		bm_len;
};

any use it consistently, that is also use it to replace
b_file_offset/b_buffer_length and b_bn.    This will also make my number
two suggestion a lot cleaner, that is make sure the new abstraction can
be implemented for reading/writing log buffers that wrap around, and
allow to kill off xfs_buf_associate_memory entirely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
