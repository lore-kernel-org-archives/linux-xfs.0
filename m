Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674E4C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 16:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 306F020723
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 16:42:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MD634DwB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgEZQmt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 12:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728350AbgEZQmt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 12:42:49 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AAAC03E96D
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 09:42:49 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id p20so9313879iop.11
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 09:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sYeCAyQMl2kZTCFyIgJ8T5aHtEt2FfJCvBf0D7z8mhc=;
        b=MD634DwB76dBRidvN3JdgGCJgFtJkVhOyZ4SXeyeQZhswjyWC2jH8/Hm667OfXsI3w
         ty6T/OmohuwZXI2rSG+/pFRI2dLKqZAIp23dXvPZ2Ri6vOOjJzGWbY27bO+eA96maOBw
         VeHXLOwesJ+HQuP5ab29qdlqosYlsBSJoGFAjPjdKK/pRFxsOydQGxioL5EtU5d3Zdx9
         YVmW4fQ77NQim60nf1fm1aHbwqj4At6j9irlt3mxvaZDyq87NQJkeaY7LMJ/8pY+/tmg
         MEDQahw2/vJd/HJRplgggywZot4NVweF7i6LZZTGuUUUn+qKLTlfS9MAXl53S4FWLjGz
         Fqhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sYeCAyQMl2kZTCFyIgJ8T5aHtEt2FfJCvBf0D7z8mhc=;
        b=empUKhA0xFUchMjlSLCXzmssZOSDtYklkvIo3MDLvakRl8k30CqxDwKHg352Yuy4nV
         ngoQlTzEPBiAhK7m9v4ul5SR55z3Gh4Qteor/8XDCWMGaEOrZPwhvK9h+sa8z61coQA6
         PSQACdKfEFkaJmRJo8f0xd6tTj9w2JwfEbBTByWiF7kpU3KBpFjh3bPJa4y2G9AZyjuJ
         7ThQGn8LfKeePVI7TF/B1RwyVK3YrEHqLcp5qO8UtPe4qrgBz4DOKydLChcDngVhnw1b
         gZJNuT4+Yb09VVm64em1Sg3YxlxokMaUy3SdrZ3ozvinFmQ0S22wAvPVTcop43uQe3Mk
         rKtw==
X-Gm-Message-State: AOAM531VdHyLLvJTtBlj5BmR3gsy5na4SIGFEHfPKfSRJU4TpOOHSWxm
        yJ8kCeceVVmk3GwcWDVqx2mXWXknbBJn7iLyjJ0=
X-Google-Smtp-Source: ABdhPJw4z+pp/iGtoXlRX5mwI5Sn4fWYdRaNh5IDgGtb3obc4WQVtN4ATEyVI/HnWfVwSzw5CEDXqMW+iVEzCwgyqyo=
X-Received: by 2002:a02:58c3:: with SMTP id f186mr1899946jab.120.1590511368156;
 Tue, 26 May 2020 09:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <CAOQ4uxjhrW3EkzNm8y7TmCTWQS82VreAVy608X7naaLPfWSFeA@mail.gmail.com> <20200526155724.GJ8230@magnolia>
In-Reply-To: <20200526155724.GJ8230@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 26 May 2020 19:42:37 +0300
Message-ID: <CAOQ4uxgq+i1+q1=_bT=M_HoWWMuDaA8dqQK3m+iJZ8d+LBgA0w@mail.gmail.com>
Subject: Re: [PATCH 00/14] xfs: widen timestamps to deal with y2038
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 26, 2020 at 6:59 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Tue, May 26, 2020 at 12:20:59PM +0300, Amir Goldstein wrote:
> > On Wed, Jan 1, 2020 at 3:11 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > Hi all,
> > >
> > > This series performs some refactoring of our timestamp and inode
> > > encoding functions, then retrofits the timestamp union to handle
> > > timestamps as a 64-bit nanosecond counter.  Next, it refactors the quota
> > > grace period expiration timer code a bit before implementing bit
> > > shifting to widen the effective counter size to 34 bits.  This enables
> > > correct time handling on XFS through the year 2486.
> > >
> >
> > I intend to start review of this series.
> > I intend to focus on correctness of conversions and on backward
> > forward compatibility.
> >
> > I saw Eric's comments on quota patches and that you mentioned
> > you addressed some of them. I do not intend to review correctness
> > of existing quota code anyway ;-)
> >
> > I see that you updated the branch 3 days ago and that patch 2/14
> > was dropped. I assume the rest of the series is mostly unchanged,
> > but I can verify that before reviewing each patch.
> >
> > As far as you are concerned, should I wait for v2 or can I continue
> > to review this series?
>
> I plan to rebase the whole series after 5.8-rc1, but if you'd like to
> look at the higher level details (particularly in the quota code, which
> is a bit murky) sooner than later, I don't mind emailing out what I have
> now.
>

No need. I can look at high level details on your branch.
Will hold off review comments until rebase unless I find something
that calls for your attention.

Thanks,
Amir.
