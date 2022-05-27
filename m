Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA095C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 12:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344728AbiE0Mua (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 08:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350651AbiE0MuM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 08:50:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AE8C17E23
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 05:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653655809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uzkCgLZFicm92sd4jMDKy5q3y3VnoqrenB36HkaKEQ8=;
        b=Zo99oVqs1gqnj80PyTr8LK3gw4eOThtLPIe/wAkIiz88nCR5sOriZvLJ2NSTo9y3LKVT4S
        KCuRaSWLI2RPQENDr5+utTNQlBMCH+J78cfgMcZuyMvVNnSMFt/0usmJYn+iPzrYrJ3aeo
        c9QuayjMUeYgREVDfdvlFjxdHgSGAlM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-8hqfxHkoPJ6feR-Uc-4SiQ-1; Fri, 27 May 2022 08:50:08 -0400
X-MC-Unique: 8hqfxHkoPJ6feR-Uc-4SiQ-1
Received: by mail-qv1-f69.google.com with SMTP id de12-20020ad4584c000000b0046266e975ddso3434059qvb.8
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 05:50:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uzkCgLZFicm92sd4jMDKy5q3y3VnoqrenB36HkaKEQ8=;
        b=t8hr37xDnl5LG0tgo6HuZZSqt344ZO5+U/Anvqhzg+b3vfPB3DHNstBPJ9DpqE8e0o
         +fJcZce3hkeBSveph3TduYbVspVPqZZZPUszEQbnqVpFftBWKgTx6Mw0P6Nr1epou0yG
         +OQj4Ungf1FU/WjwO3bZurW4xUzzySFBcS6k+W/35ndsqI604J7H4OMaUKAh8kIl2MK8
         ocgxWpu6XpgTRV9lEgF6cvbIlEpJsw5lGkcsFYVtR/QZUwmcaWmhJ8IeXTlPeLM8gvGQ
         IEtsBF5ewrlwQ6F32jZGr+NaysdbNFgm/AMGa9OBYgdQtxMOzAxwCoqu5fe0jPNiKu6b
         O+DA==
X-Gm-Message-State: AOAM532AMl7e1h00y+ntcOVAWI2jVu5Wz7mPgyxAEtCapsmj/LKM6Ytp
        a4tUzljWL7BoatooFDLvzS4nBnBr0cVIti8kTd6BBDf3+5WsVAATtLALECW40vjKdFPMCM78EOq
        bkRPFajVUQTQPGAufaIlw
X-Received: by 2002:ad4:5945:0:b0:45a:ff7c:15c9 with SMTP id eo5-20020ad45945000000b0045aff7c15c9mr34871539qvb.100.1653655807914;
        Fri, 27 May 2022 05:50:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwcx0GBeeDXCQcpD/+qdyu+gFdXv4jXLsjSyEhil9L0Dj4Db1qy0aqLPdsSEHMy915QudHlA==
X-Received: by 2002:ad4:5945:0:b0:45a:ff7c:15c9 with SMTP id eo5-20020ad45945000000b0045aff7c15c9mr34871525qvb.100.1653655807700;
        Fri, 27 May 2022 05:50:07 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id q185-20020ae9dcc2000000b0069fc13ce205sm2809256qkf.54.2022.05.27.05.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 05:50:07 -0700 (PDT)
Date:   Fri, 27 May 2022 08:50:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
Message-ID: <YpDI/WdB9FuX2XXt@bfoster>
References: <20210222153442.897089-1-bfoster@redhat.com>
 <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster>
 <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
 <Yo+M6Jhjwt/ruOfi@bfoster>
 <CAOQ4uxjoLm_xwD1GBMNteHsd4zv_4vr+g7xF9_HoCquhq4yoFQ@mail.gmail.com>
 <Yo/ZZtqa5rkuh7VC@bfoster>
 <CAOQ4uxh0NE4zHUSEqHv8nbpD4RR49Wd_S_DnXhiWCbNqgC0dSQ@mail.gmail.com>
 <CAOQ4uxjB3L3eVd6WF-pqAx12P_bMpW0O1Om_p6Xnue-edif-cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjB3L3eVd6WF-pqAx12P_bMpW0O1Om_p6Xnue-edif-cA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 27, 2022 at 10:06:46AM +0300, Amir Goldstein wrote:
> On Thu, May 26, 2022 at 11:56 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > > > I tested it on top of 5.10.109 + these 5 patches:
> > > > https://github.com/amir73il/linux/commits/xfs-5.10.y-1
> > > >
> > > > I can test it in isolation if you like. Let me know if there are
> > > > other forensics that you would like me to collect.
> > > >
> > >
> > > Hm. Still no luck if I move to .109 and pull in those few patches. I
> > > assume there's nothing else potentially interesting about the test env
> > > other than the sparse file scratch dev (i.e., default mkfs options,
> >
> > Oh! right, this guest is debian/10 with xfsprogs 4.20, so the defaults
> > are reflink=0.
> >
> > Actually, the section I am running is reflink_normapbt, but...
> >
> > ** mkfs failed with extra mkfs options added to "-f -m
> > reflink=1,rmapbt=0, -i sparse=1," by test 076 **
> > ** attempting to mkfs using only test 076 options: -m crc=1 -i sparse **
> > ** mkfs failed with extra mkfs options added to "-f -m
> > reflink=1,rmapbt=0, -i sparse=1," by test 076 **
> > ** attempting to mkfs using only test 076 options: -d size=50m -m
> > crc=1 -i sparse **
> >
> > mkfs.xfs does not accept double sparse argument, so the
> > test falls back to mkfs defaults (+ sparse)
> >
> > I checked and xfsprogs 5.3 behaves the same, I did not check newer
> > xfsprogs, but that seems like a test bug(?)
> >
> 
> xfsprogs 5.16 still behaves the same, meaning that xfs/076 and many many
> other tests ignore the custom mkfs options for the specific sections.
> That is a big test coverage issue!
> 
> > IWO, unless xfsprogs was changed to be more tolerable to repeating
> > arguments, then maybe nobody is testing xfs/076 with reflink=0 (?)
> >
> 
> Bingo!
> Test passes 100 runs with debian/testing - xfsprogs v5.16
> 
> I shall try to amend the test to force reflink=0 to see what happens.
> You should try it as well.
> 

Interesting. If I set -mreflink=0 xfs/076 seems to do the right thing
and format the scratch device as expected, but I'm still not seeing a
failure on my system for whatever reason.

Brian

> Thanks,
> Amir.
> 

