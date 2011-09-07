Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p87BLvd7154431 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 06:21:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F8C41419D5
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 04:21:56 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	FRwyvgahoT9IiAJ7 for <xfs@oss.sgi.com>;
	Wed, 07 Sep 2011 04:21:56 -0700 (PDT)
Date: Wed, 7 Sep 2011 07:21:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: fix possible overflow in xfs_ioc_trim()
Message-ID: <20110907112155.GA1017@infradead.org>
References: <1315322977-22736-1-git-send-email-lczerner@redhat.com>
	<20110906153301.GA21675@infradead.org>
	<alpine.LFD.2.00.1109071200480.4579@dhcp-27-109.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1109071200480.4579@dhcp-27-109.brq.redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Sep 07, 2011 at 12:05:14PM +0200, Lukas Czerner wrote:
> > > +	if (len > max_blks)
> > > +		len = max_blks - start;
> > 
> > Is this really the correct check?
> > 
> > Shouldn't it be
> > 
> > 	if (start + len > max_blks)
> > 		len = max_blks - start;
> > 
> > I'd also just use the mp->m_sb.sb_dblocks value directly instead
> > of assigning it to a local variable.
> > 
> 
> Agh, you're right. I am bit too hasty I guess. I thought that
> 
> if (start_agno >= mp->m_sb.sb_agcount)
> 	return -XFS_ERROR(EINVAL);
> 
> will cover us from the unreasonably big start, however if the file
> system has really huge number of AGs than it will fail to prevent the
> overflow, I am not sure if that is possible to happen, but what you
> proposed is definitely better.

The problem is that start could be very far into the fs, so checking
len alone won't help very much.  And we probably want a check if 
start + len is overflowing, too.

Care to update the test case to cover these cases as well?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
