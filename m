Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2HELbNP244433 for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 09:21:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B42C1EBC014
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 07:24:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eSIQsnn8J3hCiKBS for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2011 07:24:23 -0700 (PDT)
Date: Thu, 17 Mar 2011 10:24:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: flush vmap aliases when mapping fails
Message-ID: <20110317142418.GB32673@infradead.org>
References: <1299713876-7747-1-git-send-email-david@fromorbit.com>
	<20110310073751.GB25374@infradead.org>
	<20110310224945.GA15097@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110310224945.GA15097@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, npiggin@kernel.dk, xfs@oss.sgi.com

On Fri, Mar 11, 2011 at 09:49:45AM +1100, Dave Chinner wrote:
> > IMHO this should be done by vm_map_ram internally.  If we can't get the
> > core code fixes we can put this in as a last resort.
> 
> OK. The patch was done as part of the triage for this bug:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=27492
> 
> where the vmalloc space on 32 bit systems is getting exhausted. I
> can easily move this flush-and-retry into the vmap code.

Looks like we're not going to make any progress on the VM side for this,
so I think we'll need the XFS variant for 2.6.39.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
