Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 20:45:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3E3TEnn010423
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 20:29:15 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB7AD550E2
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 20:29:52 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 8gmSWdQ72BBHI2vV for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 20:29:52 -0700 (PDT)
Date: Mon, 14 Apr 2008 05:29:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] split xfs_ioc_xattr
Message-ID: <20080414032940.GA10579@lst.de>
References: <20080319204014.GA23644@lst.de> <ncciqylf7q0.fsf@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ncciqylf7q0.fsf@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@cxhome.ath.cx>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Apr 14, 2008 at 01:14:47PM +1000, Niv Sardi wrote:
> 
> 
> Christoph Hellwig <hch@lst.de> writes:
> > The three subcases of xfs_ioc_xattr don't share any semantics and almost
> > no code, so split it into three separate helpers.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good to me, aren't the likely() unlinkely() deprecated ? shouldn't
> they be killed ?

Why would they be deprecated?
