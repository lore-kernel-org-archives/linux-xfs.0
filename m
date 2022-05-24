Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10879C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 21:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239063AbiEXV2F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 17:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiEXV2E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 17:28:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BC27A821
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 14:28:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 34273CE1B9A
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 21:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677CAC34115;
        Tue, 24 May 2022 21:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653427680;
        bh=GtAOEk4jvFspVI7+ca1NaUBy2oWJTVUBeDBYWs6wCus=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T5h2aX/bukaqNNBsJ6XEGGk/X8zu3VLr99DU2b+BgBoMcC7Zn4rB0tEwV4RBj0/Oc
         xgHBHSxaH///ZRJlK6nynHbfljZhypwRtyNMzguuy9Q40xchHJngsyvaIk7K5G2lYF
         2TBG5HcqIm5WA6zcW9x/qXFIALqkT/PQZiygIkDq0wmpa0goPlFYvlt6ETlPAjBauY
         7Ry8LQ09y2B0juZCVwGzpcKmLJZTX4VJoqO+Bt449uKCYwStiBmV//he//5yXj2CVq
         veSAxDEBEzzoikMYzGveYnYoDrLeLmHp1Cbkxov7Bcb2mBuk5XnDYJBFvlQ+QcdTHx
         Btw5WT0v+Sqcg==
Date:   Tue, 24 May 2022 14:27:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: Fix memory leak
Message-ID: <Yo1N37hILU8Y8nYL@magnolia>
References: <20220524204040.954138-1-preichl@redhat.com>
 <Yo1I5N1IMXdHKUcw@magnolia>
 <Yo1JPr6yvQGzUNBB@magnolia>
 <aca7a3d7-8808-fa79-8124-06950c6065eb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aca7a3d7-8808-fa79-8124-06950c6065eb@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 11:13:01PM +0200, Pavel Reichl wrote:
> 
> On 5/24/22 23:08, Darrick J. Wong wrote:
> > On Tue, May 24, 2022 at 02:06:44PM -0700, Darrick J. Wong wrote:
> > > On Tue, May 24, 2022 at 10:40:40PM +0200, Pavel Reichl wrote:
> > > > 'value' is allocated by strup() in getstr(). It
> > > Nit: strdup, not strup.
> > > 
> > > > needs to be freed as we do not keep any permanent
> > > > reference to it.
> > > > 
> > > > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > > With that fixed,
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > --D
> > > 
> > > > ---
> > > >   mkfs/xfs_mkfs.c | 1 +
> > > >   1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > > > index 01d2e8ca..a37d6848 100644
> > > > --- a/mkfs/xfs_mkfs.c
> > > > +++ b/mkfs/xfs_mkfs.c
> > > > @@ -1714,6 +1714,7 @@ naming_opts_parser(
> > > >   		} else {
> > > >   			cli->sb_feat.dir_version = getnum(value, opts, subopt);
> > > >   		}
> > > > +		free((char *)value);
> > ...well, that, and the ^^^^ cast here isn't necessary.
> > 
> > --D
> 
> Hi,
> 
> thanks for the comment, but w/o the cast I get this warning
> 
> xfs_mkfs.c:1717:22: warning: passing argument 1 of ‘free’ discards ‘const’
> qualifier from pointer target type [-Wdiscarded-qualifiers]
>  1717 |                 free(value);
>       |                      ^~~~~
> In file included from ../include/platform_defs.h:16,
>                  from ../include/libxfs.h:11,
>                  from xfs_mkfs.c:7:
> /usr/include/stdlib.h:555:25: note: expected ‘void *’ but argument is of
> type ‘const char *’
>   555 | extern void free (void *__ptr) __THROW;

Ah, ok.  Ignore my comment then. :)

--D

> 
> > 
> > > >   		break;
> > > >   	case N_FTYPE:
> > > >   		cli->sb_feat.dirftype = getnum(value, opts, subopt);
> > > > -- 
> > > > 2.36.1
> > > > 
> 
