Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B97DC33CAD
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 13:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66090207FD
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 13:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgAMNze (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 08:55:34 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:60239 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMNzd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 08:55:33 -0500
Received: from mail-qk1-f173.google.com ([209.85.222.173]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MILnm-1iuFJg0qpA-00ELhD; Mon, 13 Jan 2020 14:55:32 +0100
Received: by mail-qk1-f173.google.com with SMTP id x1so8443156qkl.12;
        Mon, 13 Jan 2020 05:55:31 -0800 (PST)
X-Gm-Message-State: APjAAAUoMeyZ4851b0bykETfwKLaoIzyy6SM0hdtkFvYJOuLM5VtjeM9
        Z9G3LYyYUr0bF8rll+dwXq31DFKHay2Vrrc1pyU=
X-Google-Smtp-Source: APXvYqzpZZVph0MjS+DlAaNeNouGEph6LrCzFGzHPEREhJcSiguG2Kb7QdWG7PA/XqIeqnlNXrQCWCx4VeBRIPwRa9c=
X-Received: by 2002:a37:2f02:: with SMTP id v2mr15882483qkh.3.1578923731021;
 Mon, 13 Jan 2020 05:55:31 -0800 (PST)
MIME-Version: 1.0
References: <20200109141459.21808-1-vincenzo.frascino@arm.com>
 <c43539f2-aa9b-4afa-985c-c438099732ff@sandeen.net> <1a540ee4-6597-c79e-1bce-6592cb2f3eae@arm.com>
 <20200109165048.GB8247@magnolia> <435bcb71-9126-b1f1-3803-4977754b36ff@arm.com>
In-Reply-To: <435bcb71-9126-b1f1-3803-4977754b36ff@arm.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 13 Jan 2020 14:55:15 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0eY6Vm5PNdzR8Min9MrwAqH8vnMZ3C+pxTQhiFVNPyWA@mail.gmail.com>
Message-ID: <CAK8P3a0eY6Vm5PNdzR8Min9MrwAqH8vnMZ3C+pxTQhiFVNPyWA@mail.gmail.com>
Subject: Re: [PATCH] xfs: Fix xfs_dir2_sf_entry_t size check
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:vvFFm/UvIgiFyFiiE52HR/hez2RRMgZKYxLJN87Nv1zqozfLmW7
 Qz/5bISlCaBpSGGJh4Fe6ChfER/cS1ffNk+JFmFQLTRwOCIMgb3yNSrdnAQ4Z4ymtNBwSqG
 X7rISgiNgrE/JTc6pgaLnIxTtgaGGfdX3c0PVQtNdm9NmCKGJO8Y5E2K1Xbmei0/oi9A8+E
 2uVNhuRNsV2x/W5KzV/rQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/Mx5sHqj+xM=:dvR//8icbbKtjoXiS1bzCm
 zl2h3P69PLOjYZfiCUN/Fkeh5R1BZaebon5dKZZVSoFpNNHZVhSAP9sDts9zeywRMJHZBHtMk
 XkZwOH+Lb1/EQu5DR92jP6pTlaLXEfOl7kzPDaCAnt8wy7/OlxMKvLtLzOg1bv6sFQ5duI0OR
 Ksb7QZIpFaE9GUYzgQ+VJJv9ZOaKVHasKakYYEm0dB5i7v/oRzZuts/rjO1VMXwrs09m4IGpn
 p2bw/2bpGKXV6P2X+adfGbNo/AkIzghfMOmKSCnXzR8VeSbDFca3d2MNVYRogjU3yPD0ML08Y
 BOe1cpdZd9JjwZ9kOU5O4JXd9RhCw8fnLlD0P9uafGDefoJn0yYTsCaZlHihDGCIzZpbDvX4n
 WQrAILlgUFTeeYWZ52MLrMy1+W0qYDGyDAgdAYRHLZTv7B4tlQ2hAXkM6A5RXb7Gc1w0BP4Wh
 HcwBtIrqMZGSNaq+3tc+hqIEURgi/UvZmds7j1bFpGXseKdEEe5nwF82PcJsHoD3+angPW1K2
 G+XwhZbhfGtJUrQL9xv1UhfTRXAiDPfhZuJ/OHG7O+vKv0F3MscYycoxk+wS5H9xp6U2gJ74Q
 D6WeTt16CMXXE9mdhnGYsE1ITjJTDKpDTNGuvPyb3tZiUTynwYwM3VaAdmNAXBq+cZ/AZlAta
 6zIJ+7kK+vLCIiAv5gX2NVpSq6pjyrpfIi9kCGNTD84kJlzezddpgUWPLxXqccWClT7Zh7/8R
 A5oEcYuzOj6wG7dLj+trdedibEk1CVfv1X7uoKzA5v6HAHA8GhEBhj2mzB+6hV2KzPb9MjvBa
 dxek3wzbHCLVZxmDsDS2WbgKz9mxkGXnGEwdP90UcyObN66wushQQpHfAlUo9vep8iYu4WRhF
 lD6KtAHrNfmKOGh6QR/w==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 9, 2020 at 10:01 PM Vincenzo Frascino
<vincenzo.frascino@arm.com> wrote:
>
> Hi Darrick,
>
> On 09/01/2020 16:50, Darrick J. Wong wrote:
> > This sounds like gcc getting confused by the zero length array.  Though
> > it's odd that randconfig breaks, but defconfig doesn't?  This sounds
> > like one of the kernel gcc options causing problems.
> >
>
> This is what I started suspecting as well.

The important bit into the configuration is

# CONFIG_AEABI is not set

With ARM OABI (which you get when EABI is disabled), structures are padded
to multiples of 32 bits. See commits 8353a649f577 ("xfs: kill
xfs_dir2_sf_off_t")
and aa2dd0ad4d6d ("xfs: remove __arch_pack"). Those could be partially
reverted to fix it again, but it doesn't seem worth it as there is
probably nobody
running XFS on OABI machines (actually with the build failure we can
be fairly sure there isn't ;-).

I am testing randconfig builds with OABI and a few other things like ARCH_RPC
disabled because of random issues like this.

      Arnd
