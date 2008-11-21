Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALNDFOP021823 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 17:13:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8426A15C296B
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 15:13:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IHE9X9NKWyRBW6Zl for
	<xfs@oss.sgi.com>; Fri, 21 Nov 2008 15:13:15 -0800 (PST)
Date: Fri, 21 Nov 2008 18:12:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix spurious gcc warnings
Message-ID: <20081121231214.GA25602@infradead.org>
References: <20081112114738.GC15216@infradead.org>
	<20081121230948.GZ4144@josefsipek.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081121230948.GZ4144@josefsipek.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Nov 21, 2008 at 06:09:48PM -0500, Josef 'Jeff' Sipek wrote:
> >  	for (i=j=len = 0; i < ARRAY_SIZE(xstats); i++) {
> > -		len += sprintf(buffer + len, xstats[i].desc);
> > +		len += sprintf(buffer + len, "%s", xstats[i].desc);
> 
> Why not use strcpy here?

I applies the principle of minimal change.  strcpy would work, too and
be a tidbit more efficient.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
