Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F23C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Apr 2022 03:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349063AbiDOD0v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 23:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349043AbiDOD0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 23:26:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 641F22F0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 20:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649993062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Um4fjBzeHQ10qKNZixo0Va4U4pwUtXY2GsKE47NG4EE=;
        b=ituzw+InVikVdnFcwnnNajeFmbZSr13Xaajrzx85/3swAv1vCJIzR/pFDfBLYMeCeN/NEI
        +uQSme9/w6FIXylD66rgR2FIngRehTAe/JPOpqFRJYf4bl1jvgbIPoqZO4q+yfEO+z0GBu
        NT3xOK6MTdnL8gh1IONRkhQr/qFKjpU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-TmKIi4YWPF6wgxps9WRwsA-1; Thu, 14 Apr 2022 23:24:21 -0400
X-MC-Unique: TmKIi4YWPF6wgxps9WRwsA-1
Received: by mail-qk1-f198.google.com with SMTP id l68-20020a378947000000b0067df0c430d8so4767542qkd.13
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 20:24:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=Um4fjBzeHQ10qKNZixo0Va4U4pwUtXY2GsKE47NG4EE=;
        b=7PqgiD4qJgtpFYUWPXuiolKhmTquaqkSoXl42cixOGRyUn8rqZC4lJz9d3awPZMah/
         BRzMHOUAjhO+akxN4C9K6ovZnvDPzWgUfEhrHYQFzjcwwYT8H8qbAGCwxZUvFwCM60HW
         EnLQjnqrPfGm3xEUabGyxpFrmYLwA3Bb0w+ju6Oj9nl2m9/2LE5Ax5DqzujlepbtIfD4
         TsqF0P7d1SeY68tnUbt0HuTeNy7fIaDXcWkTzMeQJQSUIQjevqriick39xeeWCafi8vT
         3+AMwVh8Zfd9wWg0paykqmhmQjF7SXuYdvEkBYLWA+2mxwlqCyfh+ifUbzQEwR8WpOwM
         sxbQ==
X-Gm-Message-State: AOAM530LJv/h1zmIR/eFqdjmG3TncrHGSDVzwSngTXBWEh+ADczHCg3G
        nwnWvmR2lSOpunsUNNafKrLLmyu8MeYwd7fGG040l1y0OpLqw667xoN9TD37KpVWcqJVLreXRtm
        EAprLxaXfDI9T/ayLa/r4
X-Received: by 2002:ac8:7e8a:0:b0:2f1:ebd6:b28b with SMTP id w10-20020ac87e8a000000b002f1ebd6b28bmr1077963qtj.286.1649993060308;
        Thu, 14 Apr 2022 20:24:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzr9SrzQmDAsOKxXMckb5iz840Rr+yv4emphB+PIekWgVrj6pMWSr6AjurcbcBcKIT/yvTasA==
X-Received: by 2002:ac8:7e8a:0:b0:2f1:ebd6:b28b with SMTP id w10-20020ac87e8a000000b002f1ebd6b28bmr1077955qtj.286.1649993060054;
        Thu, 14 Apr 2022 20:24:20 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g12-20020ac8774c000000b002f1d0cc56dbsm2099720qtu.71.2022.04.14.20.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 20:24:19 -0700 (PDT)
Date:   Fri, 15 Apr 2022 11:24:14 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/216: handle larger log sizes
Message-ID: <20220415032414.g4ojkpz3ssrhhhy5@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
 <164971771391.170109.16368399851366024102.stgit@magnolia>
 <20220413174400.kvbihaz6bcsgz4hy@zlang-mailbox>
 <20220414015149.GD16774@magnolia>
 <20220414192531.56hn4igvgqikdryf@zlang-mailbox>
 <20220414193635.GA17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414193635.GA17025@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 12:36:35PM -0700, Darrick J. Wong wrote:
> On Fri, Apr 15, 2022 at 03:25:31AM +0800, Zorro Lang wrote:
> > On Wed, Apr 13, 2022 at 06:51:49PM -0700, Darrick J. Wong wrote:
> > > On Thu, Apr 14, 2022 at 01:44:00AM +0800, Zorro Lang wrote:
> > > > On Mon, Apr 11, 2022 at 03:55:13PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > mkfs will soon refuse to format a log smaller than 64MB, so update this
> > > > > test to reflect the new log sizing calculations.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  tests/xfs/216.out |   14 +++++++-------
> > > > >  1 file changed, 7 insertions(+), 7 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/tests/xfs/216.out b/tests/xfs/216.out
> > > > > index cbd7b652..3c12085f 100644
> > > > > --- a/tests/xfs/216.out
> > > > > +++ b/tests/xfs/216.out
> > > > > @@ -1,10 +1,10 @@
> > > > >  QA output created by 216
> > > > > -fssize=1g log      =internal log           bsize=4096   blocks=2560, version=2
> > > > > -fssize=2g log      =internal log           bsize=4096   blocks=2560, version=2
> > > > > -fssize=4g log      =internal log           bsize=4096   blocks=2560, version=2
> > > > > -fssize=8g log      =internal log           bsize=4096   blocks=2560, version=2
> > > > > -fssize=16g log      =internal log           bsize=4096   blocks=2560, version=2
> > > > > -fssize=32g log      =internal log           bsize=4096   blocks=4096, version=2
> > > > > -fssize=64g log      =internal log           bsize=4096   blocks=8192, version=2
> > > > > +fssize=1g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > > +fssize=2g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > > +fssize=4g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > > +fssize=8g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > > +fssize=16g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > > +fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > > +fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > 
> > > > So this will break downstream kernel testing too, except it follows this new
> > > > xfs behavior change. Is it possible to get the minimal log size, then help to
> > > > avoid the failure (if it won't mess up the code:)?
> > > 
> > > Hmm.  I suppose we could do a .out.XXX switcheroo type thing, though I
> > > don't know of a good way to detect which mkfs behavior you've got.
> > 
> > Don't need to take much time to handle it :) How about use a specified filter function,
> > filter all log blocks number <= 16384, if the number of blocks=$number <= 16384, transform
> > it to blocks=* or what anything else do you like ?
> > 
> > I think we don't really care how much the log size less than 64M, right? Just hope it
> > works (can be mounted and read/write)?
> 
> <shrug> Well I already reworked this patch to create 216.out.64mblog and
> 216.out.classic, and symlink them to 216.out as appropriate given the
> log size for a 512m log format, since it probably *is* a good idea to
> make sure older mkfs doesn't stray.

Thanks for doing this! I saw Dave has described the history reason[1] of this test, so
I think your new change on this patch is good to me. I've acked two other patches, I'll
give RVB to this one ASAP after you send the new version.

Thanks,
Zorro


[1]
05:58 < dchinner> sandeen: I'm betting that I wrote that test to ensure the changes I made in mkfs commit a6634fba3dec ("mkfs: allow to make larger logs") didn't change the log size for 
                  small filesystems
05:58 < dchinner> that was the commit that changed the max log size from 128MB to 2GB

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > > > 
> > > > >  fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
> > > > >  fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
> > > > > 
> > > > 
> > > 
> > 
> 

