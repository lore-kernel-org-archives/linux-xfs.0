Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBBBgqvB181525 for <xfs@oss.sgi.com>; Fri, 11 Dec 2009 05:42:54 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2C0DDFE353
	for <xfs@oss.sgi.com>; Fri, 11 Dec 2009 03:43:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id japDkH5VvWkVmhr3 for
	<xfs@oss.sgi.com>; Fri, 11 Dec 2009 03:43:27 -0800 (PST)
Date: Fri, 11 Dec 2009 06:43:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] [XFS] Replace per-ag array with a radix tree
Message-ID: <20091211114325.GA5436@infradead.org>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
	<1259734299-20306-6-git-send-email-david@fromorbit.com>
	<20091210234547.GA28289@infradead.org>
	<20091211004353.GF30608@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091211004353.GF30608@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Dec 11, 2009 at 11:43:53AM +1100, Dave Chinner wrote:
> Filestreams keeps reference counts and state on the per-ag
> structure. If it was to be re-allocated, then all the references had
> to be dropped before reallocation, hence the flush. Now there is
> no reallocation, I don't think we need the flush anymore. Removing
> it also means updating comments in the filestream code, so I was
> going to do all that in a subsequent patch....

Ok.

> > Just assign it to error first and then later to mp->m_maxagi to avoid
> > the cast?
> 
> Actually, to avoid all such sign issues, I think that mp->m_maxagi
> sho???ld be assigned in xfs_initialize_perag() and it only returns
> error or success. Does that make sense?

It does make sense.  Although in the growfs case we currently store the
maxagi count in a local variable and only set it later.  That might need
some auditing.

> Agreed - mp->m_growlock already does this and this patch series did
> not touch it at all so it should still work ;)

Doh, indeed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
