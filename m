Return-Path: <SRS0=k6ZN=2G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4443C43603
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 16:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A24E22067C
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 16:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfLPQbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Dec 2019 11:31:22 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:47097 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 11:31:22 -0500
Received: from mail-qt1-f179.google.com ([209.85.160.179]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N33AR-1hi1pd1iLl-013NI2; Mon, 16 Dec 2019 17:31:20 +0100
Received: by mail-qt1-f179.google.com with SMTP id j5so6222442qtq.9;
        Mon, 16 Dec 2019 08:31:20 -0800 (PST)
X-Gm-Message-State: APjAAAX8r4JFFfDb+URF2+0dv9wpxYsfc6tPwgTB3pNYceSUqK5U8lM1
        mEzo1YaW1xqu1O1Nuwo+LboE3ILCP3ehXEgiyv0=
X-Google-Smtp-Source: APXvYqyDdl4YObPLYJ8R0MeObOKirvavLeNWBoY3j+5T4cY33rojfyImnRl+bBhsXB9ZfA7RUwOnAcwR4yfhS80V0kU=
X-Received: by 2002:ac8:47d3:: with SMTP id d19mr82497qtr.142.1576513879287;
 Mon, 16 Dec 2019 08:31:19 -0800 (PST)
MIME-Version: 1.0
References: <20191213204936.3643476-1-arnd@arndb.de> <20191213205417.3871055-10-arnd@arndb.de>
 <20191213211840.GM99875@magnolia>
In-Reply-To: <20191213211840.GM99875@magnolia>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 16 Dec 2019 17:31:02 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0x6E7PjtFVi9UW9_61c_AQbRVSyU=+YGaVTn2W0PgtzQ@mail.gmail.com>
Message-ID: <CAK8P3a0x6E7PjtFVi9UW9_61c_AQbRVSyU=+YGaVTn2W0PgtzQ@mail.gmail.com>
Subject: Re: [PATCH v2 19/24] xfs: rename compat_time_t to old_time32_t
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Nick Bowler <nbowler@draconx.ca>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:H7fMeyzbYOCqjgAcpR4WxQVcP/KjmTWIG1zY7p7sRuMOpcB6XxH
 TloYBnCEJ4TYVnRd5j1tco6aDGOFgBSI8S1G3mK6bAVgwWG5ZzwhsMM3xzQb0ESbiqGWufH
 SsoVynB9iLdphoRpUicOQtoquSvwK/z/bpmGjnlb2Rqh5WRvMoTyo+P0mzT06gmvmd9biw1
 MyqRHBTf6U759Bu7njsYw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ioG57M6zXYo=:ZK4QKZDKnhV4rm+cisNDRP
 RuNCYDi5icTgReDFx9cXUQTiBj2PhBNeCFh72HwoGcvVbbFF5HQqDChnPlKH7WMH5taEcFiyl
 t4639rW00EptkkwTjEEVvnxc8A49qoWagofrI0PFsIfEabJ9WROpulxKba6Tq6QJc1FjEjwX9
 mJ/ZAhkFlxm89YXCkFzxHDjh4sAQITGmAq0ViSHo3OWI+jY/0r/s3+7t/y6PuoLrBB8hoMSpr
 6zN5gxYVTS+LVIqtJ7OsHq2g0u7nUoDYvaLZInXzb5kUYRrqaCuN2xedrmwy6HHZBOP+Tm55O
 Z/r5AiYPXq+qVeNLB6lcmsT/49v2cNnKBkGQvJ2+xiXzIFzUlfAGR25Vz/M/8PBLBV9o2rRJH
 nogbJLyp8EOULb1RuQ1bSs9UQFalu9HwnE5zSDznaVSKbrkzZTjobs4gD4A48Td9dcvllfZiI
 IpKc8rtPUcnEzqmpKk402Nmw7p/rnn1Ek2l3ekglAhNwga+1nJ+4sqGTCx6Z15xkgHJmDyApN
 znAVVSmEeVH8TcdQihpcVeWuGcDFsvHqHJZ9DZx87cKEJMptojjWij2T59VcujDyiBAHs4bdg
 v1AYOBTa9DBSl1bx6iiqoI8LbFLYFZ+G7vVhRE69vLFfZRi7w4npE/IFFhfjKcYrr56qiwsqw
 iwdShckXCCqFiLWUlIN9bmxTN+wTuz+SdXVTe2Nr7TDMHTa6CRUffI6Jbh2QUpOBTffyMGLYJ
 AGjs7foTcjJfc4MyUFTuJXKur3R3LKcoO5HPF4oFy3XDpNpD58aEsZ4IGlkzyuYQpMgsdBCvx
 eAZylywPDUJOrjIIfD3uRNjDhH7NfIecab6a1FwGWPLLqeb8icbDEgztlATGrbCrSOkThIGuI
 h+pjUe627bXK47Ds9tjQ==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 10:18 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> On Fri, Dec 13, 2019 at 09:53:47PM +0100, Arnd Bergmann wrote:
> > The compat_time_t type has been removed everywhere else,
> > as most users rely on old_time32_t for both native and
> > compat mode handling of 32-bit time_t.
> >
> > Remove the last one in xfs.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Looks fine to me, assuming that compat_time_t -> old_time32_t.

Yes, that's the idea. Christoph asked for the global change last year
as a cleanup,
but I left out xfs and a few others at the time when I was missing
other patches.

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks,

     Arnd
