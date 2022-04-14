Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955ACC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 19:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345406AbiDNT2G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 15:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbiDNT2G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 15:28:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F18BE2F65
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 12:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649964339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vz8fKQ34kYYKMPo5KdkIJGvJSY9HED+T+YqP2FdVtC4=;
        b=VEYQ0vubAukQWhECEh5P1joK7C0Dcp77eqTPAElOz+w86o9pfqbC+goQApPk0dB9Gwf+/1
        aj/4sBb8oLcrKIdSJahnvBwIwyHXIdIl2B/+sumHtfR/ArSoZ3CLc+8WGsXsX89EQgXLGo
        lB0WzmSyq3w8lqOcfzRG32YCHVQKkOQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-B87YbN-SOK-ds93PiMbXgg-1; Thu, 14 Apr 2022 15:25:38 -0400
X-MC-Unique: B87YbN-SOK-ds93PiMbXgg-1
Received: by mail-qv1-f70.google.com with SMTP id z12-20020a0ce60c000000b0044632eb79b3so758046qvm.7
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 12:25:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=vz8fKQ34kYYKMPo5KdkIJGvJSY9HED+T+YqP2FdVtC4=;
        b=sZELHfDb8auB1X19Ee7vict6JH2cI06jZa9uE4K13N86Gc+XCnMiHwKXCeWCbm5npY
         eEd8u0IzOvGhvxcghKu9A2+61Vbqx8jxeUAL3p97e4+ufBpDsQl/vcmStrTol1DIMdH+
         T/4n0NGatLInvkHkhGbRxu1PcJRtIkp2dW/6gXOh9SYyGHAg+Voku+4Xgh00//5pV9Pn
         HJTlCKzKeLuH9vqni/iIXgmFU7+M9+5Ts4iptTm+hUjQu6r2dMuQlUzpOlQSPa1zuUUR
         keoaGatUdDKcWR+IGpu4FqHtBWBzNbPsp1Zdcc9p/R1Oc1ONjxDPkT4GULPMc14/Jwn5
         UzeA==
X-Gm-Message-State: AOAM533MSTgykklsEyJgu2735yWHNfnWaKm69MyCmRB4WXSB3yZ5lerT
        Ndwpvbolu/Dx9ZRYcqkNzkMB7/S/uArAsRsXlMsru0hAe8X32vtJXmoWHZMTf4+4U18CaAo+KlJ
        FI73t+tkx48iuRzCuWTpv
X-Received: by 2002:a05:622a:6111:b0:2f1:d6c1:723c with SMTP id hg17-20020a05622a611100b002f1d6c1723cmr3023988qtb.600.1649964337674;
        Thu, 14 Apr 2022 12:25:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+BLoJeWviqAztUP8/OC8JzmlO/Y0HKfxF95cEOZzpRrA87gTXwDhBb+7MAgXPl2Ilf2/ukw==
X-Received: by 2002:a05:622a:6111:b0:2f1:d6c1:723c with SMTP id hg17-20020a05622a611100b002f1d6c1723cmr3023978qtb.600.1649964337421;
        Thu, 14 Apr 2022 12:25:37 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l18-20020a05622a051200b002e1e5e57e0csm1704984qtx.11.2022.04.14.12.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 12:25:36 -0700 (PDT)
Date:   Fri, 15 Apr 2022 03:25:31 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/216: handle larger log sizes
Message-ID: <20220414192531.56hn4igvgqikdryf@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
 <164971771391.170109.16368399851366024102.stgit@magnolia>
 <20220413174400.kvbihaz6bcsgz4hy@zlang-mailbox>
 <20220414015149.GD16774@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414015149.GD16774@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 13, 2022 at 06:51:49PM -0700, Darrick J. Wong wrote:
> On Thu, Apr 14, 2022 at 01:44:00AM +0800, Zorro Lang wrote:
> > On Mon, Apr 11, 2022 at 03:55:13PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > mkfs will soon refuse to format a log smaller than 64MB, so update this
> > > test to reflect the new log sizing calculations.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/xfs/216.out |   14 +++++++-------
> > >  1 file changed, 7 insertions(+), 7 deletions(-)
> > > 
> > > 
> > > diff --git a/tests/xfs/216.out b/tests/xfs/216.out
> > > index cbd7b652..3c12085f 100644
> > > --- a/tests/xfs/216.out
> > > +++ b/tests/xfs/216.out
> > > @@ -1,10 +1,10 @@
> > >  QA output created by 216
> > > -fssize=1g log      =internal log           bsize=4096   blocks=2560, version=2
> > > -fssize=2g log      =internal log           bsize=4096   blocks=2560, version=2
> > > -fssize=4g log      =internal log           bsize=4096   blocks=2560, version=2
> > > -fssize=8g log      =internal log           bsize=4096   blocks=2560, version=2
> > > -fssize=16g log      =internal log           bsize=4096   blocks=2560, version=2
> > > -fssize=32g log      =internal log           bsize=4096   blocks=4096, version=2
> > > -fssize=64g log      =internal log           bsize=4096   blocks=8192, version=2
> > > +fssize=1g log      =internal log           bsize=4096   blocks=16384, version=2
> > > +fssize=2g log      =internal log           bsize=4096   blocks=16384, version=2
> > > +fssize=4g log      =internal log           bsize=4096   blocks=16384, version=2
> > > +fssize=8g log      =internal log           bsize=4096   blocks=16384, version=2
> > > +fssize=16g log      =internal log           bsize=4096   blocks=16384, version=2
> > > +fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
> > > +fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2
> > 
> > So this will break downstream kernel testing too, except it follows this new
> > xfs behavior change. Is it possible to get the minimal log size, then help to
> > avoid the failure (if it won't mess up the code:)?
> 
> Hmm.  I suppose we could do a .out.XXX switcheroo type thing, though I
> don't know of a good way to detect which mkfs behavior you've got.

Don't need to take much time to handle it :) How about use a specified filter function,
filter all log blocks number <= 16384, if the number of blocks=$number <= 16384, transform
it to blocks=* or what anything else do you like ?

I think we don't really care how much the log size less than 64M, right? Just hope it
works (can be mounted and read/write)?

Thanks,
Zorro

> 
> --D
> 
> > 
> > >  fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
> > >  fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
> > > 
> > 
> 

