Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC61C2D0A8
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 03:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 656D821534
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 03:06:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="GHFxIxLa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgI2DGq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 23:06:46 -0400
Received: from sonic306-3.consmr.mail.bf2.yahoo.com ([74.6.132.42]:42566 "EHLO
        sonic306-3.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727212AbgI2DGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 23:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1601348804; bh=fkLh/zm7uI2gcbiNg5d3JIKRWAcEkjWLqg4ZsqtmAYA=; h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject; b=GHFxIxLaqhvL3GZfunlCiuDaOqeQRVaI0iBRcG3EcsBYtxeAWP8aGRFMFWULdaQ1yQniBDDeAN8h3vEWk1oKDG2g3vGU8b08M9CtiyjuSbBhRjLBQDTAlCXB80XgPexAY7Mm7tuCwftdHaNfPGFQoN9IkTcw+55oTfAZC27rWNiFhX+H/UkUtvWjwVbXcFRQpmHE6tNCGoHDn/1J1rDQpjOXM90g+Ycopi3GA4p5CXmZrOzKJcbmNs1PRfx8CvI0swyxNHmtTuui+VrVhS4OQHw7dzvwVtmhodY/4QJaXE3MXWhmEiHlzVc42erwRrYIcR+L4YqDU6Eu8245U6L0MQ==
X-YMail-OSG: aVZg_OcVM1nZ_o412WX.XeEDMDZO7trQFzmxB5tsfi2E9Eq46E9z1A029xeGUJr
 5CUocb3C4iDrHEgSY10WfOFwqoBxipK2.76DyzNapFBSlYaq2aohB_PhooDnr.ACK0SO5qNizge4
 NB1ZfeM5pyCcVYtM6bes30DJq3KdaxEnVUI7BOXRijk2c2mP.MFyIO2puThX150zTVnJLFNV5zI3
 i6zeEGmEkdB3S._D7_doeJsWohAUkAhqrBYzMpd2hy0uqOBGlo7I2d5LJDwbQaIc9.3kxMLuqAkl
 y0PoqLbWdvKebTPUXsEPjZN1BOOznYQ2Qyt7o5ZN8LsM0gzn_CgUS_8sfE3w3XgBBIRabNV_.ahg
 Ki8H755.69KDvh2YKMQmUcUJKzhUkhmumV9Tw.oabDppn6y8SnBymkPnBRZ6XAK0nVOZgvuwXvrZ
 Au.QzierbnrJyO.TyVmB5XyAc4Ga1Y88_xiGXJLbb5jWTW_Ia5duKLcD_xc.ofanClbhkqYJg124
 ir6UI5jDaJ0YIiCJ9D9GI.EuH4oxFacCZeRBf7LXQYeWoIMWO0Pojk4Gsav41bcybL619KeFj.aF
 w5cd2Z7MKI4.BakcvD8QRD0.ai8fLksSUB0_4tUExMU9ksyJ7Koz0E3dZflg4hHmHtoO8HbINlr9
 QYhjiCjLp_sAgl1f4oZXX0zge_9dJygiaNW22p0KmLBip.0VKwKTYT0JGM4aTTOlcJqs7aMS12jW
 NZfunI97w6LLO_SyJmOWThmAaXh21YzQZhB8JoIo3MB8sVauWaWA3xqGfRmHBpzuqkPbnxjrOaQ4
 a11NJD7SS.TtxdtwCam0PdCm5eJmZYNRa63_WJf1H2EN0bxxNPkhCXxoQfH91bH4OhSiHqE6la5r
 0xYSgSNl3.M5XKPMhKCnrvITWgvy9N3hA1C8LROcmbZ7LTtyCm384vXKWEMvknFiRPAHYKslAP2H
 0SS.Sf7me63gAkqhfP_wqYYTRnIgiwFws7pYeKMimpzxpmupZQxxHBzgrwNcE4P4eoZ2nMdTd0kT
 .TtGeyTeTVkcQFwK4.6KwcI6usOsculSDO.RMGxZvtjjTHkQhYAIZ4WsZuIXrjcjDIGQAD1yPjDo
 r96rGJqHM9q1xpdpCMPqxWGbozYVVKdEdCncIAqxH5aRO10l_cs51jTWReoEG6HTQwmViEsirNa0
 OsMapoXhEaccE9pYapIpSiI6Fh7zxULHX9Yz56_W8wcZ7SNAmttu6Bsfj62BOkDFQwQWVmUlFWvD
 0_7ynTwqEwGBrrbt9WVDtH7.E2LofNv2Z_ur71PJ3i.kf.d2A_u6YvQNoY7EFjWvquJ5hjkpWGv_
 OZ1JT6Ul22_1mCda7.jniiZbmjwrFyjnIVOV0TC76UqZ6gxd_GeA2GTMasmSwXKFoNzIlj.AXKsZ
 WS.9RR7iteGtr5avJr8q2HMdCWdJb1fDX18VVO9aaQ1fUUtpyLLFOPdviGjNAoizy2c03u90Jr_n
 PZ1AOoumCVuHMScNgUC3Fg02AdKRtz1IyJokJCQ0dGTEkqByy9ytIr_IldaKYqP_GRKt9p42V4J1
 SiwYmj1Zq0tJBprWh
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Tue, 29 Sep 2020 03:06:44 +0000
Received: by smtp409.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 54b61b389dfa3433cf9f94de29cec44c;
          Tue, 29 Sep 2020 03:06:40 +0000 (UTC)
Date:   Tue, 29 Sep 2020 11:06:30 +0800
From:   Gao Xiang <hsiangkao@aol.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3] mkfs.xfs: introduce sunit/swidth validation helper
Message-ID: <20200929030627.GA21419@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20200804160015.17330-1-hsiangkao@redhat.com>
 <20200806130301.27937-1-hsiangkao@redhat.com>
 <f5df6861-7932-4c5e-f6da-6d5afc2cbf62@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5df6861-7932-4c5e-f6da-6d5afc2cbf62@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailer: WebService/1.1.16674 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric,

On Mon, Sep 28, 2020 at 06:18:37PM -0500, Eric Sandeen wrote:
> On 8/6/20 8:03 AM, Gao Xiang wrote:

...

> >  mkfs/xfs_mkfs.c    | 62 ++++++++++++++++++++++++----------------------
> >  po/pl.po           |  4 +--
> >  5 files changed, 124 insertions(+), 43 deletions(-)
> 
> Sorry this sat w/o review for a while... I'm going to kind of suggest a new
> approach here, since this seems to have gotten rather complicated.

Yeah, that is fine.

> 
> > +/*
> > + * This accepts either
> > + *  - (sectersize != 0) dsu (in bytes) / dsw (which is multiplier of dsu)
> > + * or
> > + *  - (sectersize == 0) sunit / swidth (in 512B sectors)
> > + * and return sunit/swidth in sectors.
> > + */
> 
> I'm still troubled by the complicated behavior of this function, even if it's
> fully described in the comment.
> 
> What if this function:
> 
> * only accepts bytes, and does not convert sectors <-> bytes
>   - i.e. callers should convert to bytes first
> 
> * directly prints the error using xfs_notice/warn() and an i8n'd _("...") string
>   - this gets rid of enums & cases for strings, etc
>   - kernelspace may need a #define to handle _("...")
> 
> * becomes a boolean and returns true (geom ok) or false (geom bad)
>   - caller can print more context if needed, i.e. "Device returned bad geometry..."
> 
> * sectorsize check could be optional if we are calling from somewhere that
>   does not need to or cannot validate against sector size (?)
> 

I'm fine with the above proposal. I'll figout out a new patch
for this later (I'm outside now, will seek time).

The reason why it used enum here was to follow Darrick's
original suggestion in
https://lore.kernel.org/linux-xfs/20200515211011.GP6714@magnolia/

For such wrappers, Dave suggested updating xfs_notice() / xfs_warn()
in libxfs/libxfs_priv.h on IRC. So I will go on in that way.

If all people agree on this approach, I'm fine with all of that.

Thanks,
Gao Xiang

