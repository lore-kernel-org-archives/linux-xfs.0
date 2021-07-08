Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C89C07E96
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 22:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBA461876
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 22:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhGHWek (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jul 2021 18:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhGHWek (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jul 2021 18:34:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94882617ED;
        Thu,  8 Jul 2021 22:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625783517;
        bh=xukJBS4hmHAAnAvwCR7qAwMSB7S/Vmi6z6oNJgv9kyI=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=UdMNFb6/tyNU6oYHalxk6N2xCozDoqceE+im+lLVjWFF1DsbvdGgUMLOljqTQwCE8
         U1SWa24J4il/g+oJc6nL3m828aQV9z9tursKFupSxYeVU7HVikeb7xon+kc6SM6zn2
         LXZy9cRU3gzMkh66VuxTKa6PMuEX3ZN0zMO2goEaqe9PgXS+QT6U8UW+EpzLvl8z4G
         2hgD4IkCA9VkLuSU/ibDWX1Ybej3SbwZ3UU93g2/DJCQI8sERYA4/ZYWeuTVWx870g
         CSwBAYgi1jzPzQ10p2c55Sqple0w1LvhdS4RelHeA7J40QktUyAywJBYeZsXZYx4NI
         T9+q84SkrWpTg==
Date:   Thu, 8 Jul 2021 15:31:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/2] xfs_repair: validate alignment of inherited rt
 extent hints
Message-ID: <20210708223157.GJ11588@locust>
References: <162528106460.36302.18265535074182102487.stgit@locust>
 <162528107024.36302.9037961042426880362.stgit@locust>
 <YOF2n+aIKG/cqhyX@infradead.org>
 <20210708071116.njicib4zsxkdny3k@omega.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210708071116.njicib4zsxkdny3k@omega.lan>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 08, 2021 at 09:11:16AM +0200, Carlos Maiolino wrote:
> On Sun, Jul 04, 2021 at 09:51:43AM +0100, Christoph Hellwig wrote:
> > On Fri, Jul 02, 2021 at 07:57:50PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > If we encounter a directory that has been configured to pass on an
> > > extent size hint to a new realtime file and the hint isn't an integer
> > > multiple of the rt extent size, we should turn off the hint because that
> > > is a misconfiguration.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  repair/dinode.c |   28 +++++++++++++++++++++++++++-
> > >  1 file changed, 27 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/repair/dinode.c b/repair/dinode.c
> > > index 291c5807..1275c90b 100644
> > > --- a/repair/dinode.c
> > > +++ b/repair/dinode.c
> > > @@ -2178,6 +2178,31 @@ _("Bad %s nsec %u on inode %" PRIu64 ", "), name, be32_to_cpu(t->t_nsec), lino);
> > >  		*dirty = 1;
> > >  	}
> > >  }
> > > +/*
> > > + * Inode verifiers on older kernels don't check that the extent size hint is an
> > > + * integer multiple of the rt extent size on a directory with both rtinherit
> > > + * and extszinherit flags set.  If we encounter a directory that is
> > > + * misconfigured in this way, or a regular file that inherited a bad hint from
> > > + * a directory, clear the hint.
> > > + */
> > > +static bool
> > > +zap_bad_rt_extsize_hint(
> > 
> > The name suggests this function does the zapping itself, while it
> > actually leaves that to the caller.
> 
> +1 here, I also led me to believe this was actually zeroing the extsize, but the
> patch's logic is fine.
> 
> Maybe something like
> 
> {is,has}_bad_rt_extsize_hint()?

Renamed to is_misaligned_extsize_hint().

--D

> 
> > 
> > Oterwise looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> -- 
> Carlos
> 
