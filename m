Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC801C00144
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Jul 2022 01:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbiG3Bah (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiG3Bah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jul 2022 21:30:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2F112A9B
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jul 2022 18:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C12CB82925
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jul 2022 01:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19713C433D6;
        Sat, 30 Jul 2022 01:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659144633;
        bh=CWr+jBhv9DDlFiUivJU422TBv2vJE9leZtsdEWJZPJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GYXh1wDpcCAtG6L72PQrWskbbR45gCiRy9j1700EQsObj6v5zDT5WNIHFLIBBprAc
         5AARWgXFJz5Unp4Wx/Lnqfqn9id+ql5t/qMvvdZRv+r7hNcSAamWCaQ3WDarC2RglH
         bnL2j/3ReFvB9Xzfy/6S6KlLB9cTXnJ7y2SzyjfN94nrLIrMZ143fGRoPtYPOhaPeF
         U7syeqV+92GHhEzFRZeKbeTFyZJaR5AmcOtQEEFyP4D0qDwSvIQhdjMCKXUTUP9rb6
         2nrWHF2icaS7FGKfavTkyLzHQ2cxK1DDsnlU12dav259IGq4txH6E1o0xmmwtbQBoC
         bkQIB83zSvdcA==
Date:   Fri, 29 Jul 2022 18:30:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stephen Zhang <starzhangzsd@gmail.com>
Cc:     sandeen@redhat.com, hch@lst.de, zhangshida@kylinos.cn,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libfrog: fix the if condition in xfrog_bulk_req_v1_setup
Message-ID: <YuSJuF55dZLsbO8Z@magnolia>
References: <20220729075746.1918783-1-zhangshida@kylinos.cn>
 <YuQATS8/CujZV3lh@magnolia>
 <CANubcdVqkeyG5AP56AQ+x3QayRmLZ=zULShhxha-a4N16gPKYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANubcdVqkeyG5AP56AQ+x3QayRmLZ=zULShhxha-a4N16gPKYg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 30, 2022 at 09:25:25AM +0800, Stephen Zhang wrote:
> Darrick J. Wong <djwong@kernel.org> 于2022年7月29日周五 23:44写道：
> >
> > On Fri, Jul 29, 2022 at 03:57:46PM +0800, Stephen Zhang wrote:
> > > when scanning all inodes in each ag, hdr->ino serves as a iterator to
> > > specify the ino to start scanning with.
> > >
> > > After hdr->ino-- , we can get the last ino returned from the previous
> > > iteration.
> > >
> > > But there are cases that hdr->ino-- is pointless, that is,the case when
> > > starting to scan inodes in each ag.
> > >
> > > Hence the condition should be cvt_ino_to_agno(xfd, hdr->ino) ==0, which
> > > represents the start of scan in each ag,
> >
> > Er, cvt_ino_to_agno extracts the AG number from an inumber;
> > cvt_ino_to_agino extracts the inumber within an AG.  Given your
> > description of the problem (not wanting hdr->ino to go backwards in the
> > inumber space when it's already at the start of an AG), I think you want
> > the latter here?
> >
> > > instead of hdr->ino ==0, which represents the start of scan in ag 0 only.
> > >
> > > Signed-off-by: Stephen Zhang <zhangshida@kylinos.cn>
> > > ---
> > >  libfrog/bulkstat.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> > > index 195f6ea0..77a385bb 100644
> > > --- a/libfrog/bulkstat.c
> > > +++ b/libfrog/bulkstat.c
> > > @@ -172,7 +172,7 @@ xfrog_bulk_req_v1_setup(
> > >       if (!buf)
> > >               return -errno;
> > >
> > > -     if (hdr->ino)
> > > +     if (cvt_ino_to_agno(xfd, hdr->ino))
> >
> > ...because I think this change means that we go backwards for any inode
> > in AG 0, and we do not go backwards for any other AG.
> >
> > --D
> >
> > >               hdr->ino--;
> > >       bulkreq->lastip = (__u64 *)&hdr->ino,
> > >       bulkreq->icount = hdr->icount,
> > > --
> > > 2.25.1
> > >
> 
> Yeah, i mean the latter. Sorry for the mistake.
> Hence the patch will be like:
> =====
> @@ -172,7 +172,7 @@ xfrog_bulk_req_v1_setup(
>         if (!buf)
>                 return -errno;
> 
> -       if (hdr->ino)
> +       if (cvt_ino_to_agino(xfd, hdr->ino))
>                 hdr->ino--;
>         bulkreq->lastip = (__u64 *)&hdr->ino,
>         bulkreq->icount = hdr->icount,
> ====
> Should i resend the patch later, or do you have any other idea about
> this change?

It's probably ok to resend with that change, but ... what were you doing
to trip over this error, anyway?

--D

> Thanks,
> 
> Stephen.
