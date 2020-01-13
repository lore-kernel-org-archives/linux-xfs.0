Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBBCC33CAD
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 14:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4542E207E0
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 14:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgAMOHJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 09:07:09 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:35129 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgAMOHJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 09:07:09 -0500
Received: from mail-qk1-f179.google.com ([209.85.222.179]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N0X4e-1jcMEZ463Y-00wWND; Mon, 13 Jan 2020 15:07:08 +0100
Received: by mail-qk1-f179.google.com with SMTP id k6so8532932qki.5;
        Mon, 13 Jan 2020 06:07:07 -0800 (PST)
X-Gm-Message-State: APjAAAVrp3DPzmx5zotCL57FzjiGgwLVKfosWMbGTu+Fq01mxp6keCTm
        n67IGLrF0P2SoDXICI3fzx3FNez/SLiMo73BD6s=
X-Google-Smtp-Source: APXvYqy4pDVP1tTP4+KiIyv9AaHZPjEdv86Ykem+8ug+bu8k+5zBm8SYa1YYYY2i0Ku4ZH0NQ653JbuPCdT85EHvOpM=
X-Received: by 2002:a05:620a:a5b:: with SMTP id j27mr16336077qka.286.1578924426747;
 Mon, 13 Jan 2020 06:07:06 -0800 (PST)
MIME-Version: 1.0
References: <20200109141459.21808-1-vincenzo.frascino@arm.com>
 <c43539f2-aa9b-4afa-985c-c438099732ff@sandeen.net> <1a540ee4-6597-c79e-1bce-6592cb2f3eae@arm.com>
 <20200109165048.GB8247@magnolia> <435bcb71-9126-b1f1-3803-4977754b36ff@arm.com>
 <CAK8P3a0eY6Vm5PNdzR8Min9MrwAqH8vnMZ3C+pxTQhiFVNPyWA@mail.gmail.com> <20200113135800.GA8635@lst.de>
In-Reply-To: <20200113135800.GA8635@lst.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 13 Jan 2020 15:06:50 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0MZdDhY1DmdxjCSMXFqyu0G1ijsQdo7fmN9Ebxgr9cNw@mail.gmail.com>
Message-ID: <CAK8P3a0MZdDhY1DmdxjCSMXFqyu0G1ijsQdo7fmN9Ebxgr9cNw@mail.gmail.com>
Subject: Re: [PATCH] xfs: Fix xfs_dir2_sf_entry_t size check
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:MDZdv87PspSiRCBd2OKASowIhCrd3dbWlOcvIGcE4pC5YSIymsm
 MO01UcVXmYr8ss0o1h/WxxRng+weIrxLMTAJJdDQFRwySLSD1VgGoP7TaZSpnqxeG8puca9
 9+wvyBDqop/oJq+I3W5KrP6HJxGjVJafHl/18hYekvaNq8RdqFGqLLqd3RKll2PMK9RHpmV
 Az8owFv9K5utX8C7+EFJQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qwqY+JrhnYA=:hjm96v+cRRK4dY23FrlCUn
 dwM83iaWQRnryuKoZhozWKOQoGDbWIJUljZkVFBW1g4bieNr6OWMcKWfcIw17mqNH6xSLlKE5
 wD9DLp82qu4x3KAwEIGVUX0xvz9jOs2gd2UU4ji8yVqnnwCslNYzOzTtWhsarLOaEnw6I/viz
 zIPNlw631HW4VvqjjfnwoH4lKJsWLKUCSRmZdbzkkFXA4YZs+7g331c1ESlRls2sZqb/3FtUc
 wd1GT5TbNqCcKreDQ3IRMidefZsxQLkc7H7KMa2W4YzIYmt1V9vYpiRXfHW+BTijgYKQJ8bs/
 Gy0/DH9iO3SryT1C6SO92Upi7PsFT+VDhy/vSE1xR2SIkA0FzvrnSFETdH2jKIJcydUyCin/s
 sSrTR5JEZUqHK7SZbAj2BISB8rL0X0mAhdpGhv0ZF2+AHYvGjCVRqPrHEA/WBNKFa5RommC9L
 n4Cex7qRFSIc9Us7my6aJJ97kYFgfWqZyTqwTJYlYdUtE4rlYi/ftVHcSBtGqpn4E7I+fhy9H
 0pyymeYgeHCA70Wvpe7ptl5hExfOVyMR+fLLeCC599ATOSxP5QkmnMA6x9hq9KQmv2HXu+Z8S
 PR0G0o7jIG/tq9C59gaEraYhHwerrRp0vIo6M3F3/qVQzeLzapjAZVG2+O4+4rtIOgmqn5VHP
 lJfoAi5Sk4wBn+jA/gGDBnnzlTR8fMHc7hS+lgBYEJfwwYeb/h+kxgk7vHMjLxygdhXf32t/8
 wcJ2iXc6sgqow6Nkcr++5q1/u67sY628zxyOW9ypbU5oz0e6wpisH+xcqOu5pIbRzgYv3zO9b
 WT9Uz5aGz5sOFyewSuP+CnaunQZMm6E6eMmEx3ka94J23Py/ZLYG23gAd1HaDlU4c7luxcRJb
 2ZlpZMLWejRj/LrHVv8A==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 13, 2020 at 2:58 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Jan 13, 2020 at 02:55:15PM +0100, Arnd Bergmann wrote:
> > With ARM OABI (which you get when EABI is disabled), structures are padded
> > to multiples of 32 bits. See commits 8353a649f577 ("xfs: kill
> > xfs_dir2_sf_off_t")
> > and aa2dd0ad4d6d ("xfs: remove __arch_pack"). Those could be partially
> > reverted to fix it again, but it doesn't seem worth it as there is
> > probably nobody
> > running XFS on OABI machines (actually with the build failure we can
> > be fairly sure there isn't ;-).
>
> Or just try adding a __packed to the xfs_dir2_sf_entry definition?

Yes, that should be correct on all architectures, and I just noticed
that this is what we already have on xfs_dir2_sf_hdr_t directly
above it for the same reason.

       Arnd
