Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52938 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753839AbcLPIUE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Dec 2016 03:20:04 -0500
Date: Fri, 16 Dec 2016 09:20:01 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] xfs: adjust allocation length in
        xfs_alloc_space_available
Message-ID: <20161216082001.GA32288@lst.de>
References: <1481644767-9098-1-git-send-email-hch@lst.de> <1481644767-9098-4-git-send-email-hch@lst.de> <4769689.jYzaBPWb0Z@libor-nb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4769689.jYzaBPWb0Z@libor-nb>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Dec 15, 2016 at 09:41:39PM +0100, Libor Klepáč wrote:
> > index 91a6c17..87328a8 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1149,11 +1104,6 @@ xfs_alloc_ag_vextent_near(
> >  		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> >  		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)-
> >agf_length));
> >  		args->len = blen;
> > -		if (!xfs_alloc_fix_minleft(args)) {
> > -			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> > -			trace_xfs_alloc_near_nominleft(args);
> > -			return 0;
> > -		}
> >  		blen = args->len;
> >  		/*
> >  		 * We are allocating starting at bnew for blen blocks.
> 
> Doesn't this produce this code?
> 
>   		args->len = blen;
>   		blen = args->len;

Yes, that second line could be removed, and I'll do that in the next
iteration.
