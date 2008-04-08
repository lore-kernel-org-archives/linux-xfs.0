Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 03:50:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m38AnFnY000649
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 03:49:20 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4F6D1286083
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2008 03:49:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id SxGY1haGtGmLE5IT for <xfs@oss.sgi.com>; Tue, 08 Apr 2008 03:49:53 -0700 (PDT)
Date: Tue, 8 Apr 2008 06:48:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW #2] cleanup - remove bhv_vname_t
Message-ID: <20080408104851.GA25647@infradead.org>
References: <op.t897ipuu3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080408085153.GA19699@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408085153.GA19699@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, Apr 08, 2008 at 04:51:53AM -0400, Christoph Hellwig wrote:
> > +static inline int
> > +xfs_dir_check_canenter(uint resblks, struct xfs_trans *tp,
> > +				struct xfs_inode *dp, struct xfs_name *name)
> > +{
> > +	if (resblks)
> > +		return 0;
> > +	return xfs_dir_canenter(tp, dp, name);;
> > +}
> 
> Probably makes sense to have this out of line.

Actuallt this is the only caller of xfs_dir_canenter with your patch so
you should merge the resblks check into xfs_dir_canenter.  Please also
add a comment on why we do the check.  Also resblks is normally the
last argument to functions, we should follow that convention here.
