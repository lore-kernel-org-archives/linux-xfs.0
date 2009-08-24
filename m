Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7OHei4g138993 for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 12:41:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFBA73F3825
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 10:41:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HTIMB9StzhllD7CP for
	<xfs@oss.sgi.com>; Mon, 24 Aug 2009 10:41:36 -0700 (PDT)
Date: Mon, 24 Aug 2009 13:41:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Changing a file system from case sensitive to case insensitive...
Message-ID: <20090824174134.GA25187@infradead.org>
References: <4A928413.4050205@tlinx.org> <20090824144904.GB20898@infradead.org>
	<4A92C43B.1060604@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A92C43B.1060604@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Aug 24, 2009 at 09:47:55AM -0700, Linda A. Walsh wrote:
>
>
> Christoph Hellwig wrote: 
>> It's not theoretically impossible, but not implemented right now.
> ----
> 	How difficult -- would it just be changing a flag
> in the super, in the simple case -- i.e. with the result that
> a user could lose access to any files of alternate cases?

The CI flag relaly only hcanges on thing in the on disk format, and
that is the hash used for calculating the directory b+tree indices.
So what you need to do is the following algorithm


foreach diretory {
	read the whole directory structure into memory
	rewrite the btree with the case insensitive hash
}

handling of conflicts would be a pretty natural fallout of this,
by checking for hash conflicts with the new case-sensitive flag.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
