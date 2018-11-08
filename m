Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41025 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbeKIJeM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 04:34:12 -0500
Received: by mail-lj1-f196.google.com with SMTP id z80-v6so50742ljb.8
        for <linux-xfs@vger.kernel.org>; Thu, 08 Nov 2018 15:56:13 -0800 (PST)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id v17-v6sm954167ljg.32.2018.11.08.15.56.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 15:56:11 -0800 (PST)
Received: by mail-lj1-f174.google.com with SMTP id t9-v6so56994ljh.6
        for <linux-xfs@vger.kernel.org>; Thu, 08 Nov 2018 15:56:11 -0800 (PST)
MIME-Version: 1.0
References: <20181108224000.GB15721@magnolia>
In-Reply-To: <20181108224000.GB15721@magnolia>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Nov 2018 17:55:54 -0600
Message-ID: <CAHk-=wgd6HgnbLZ8ngvBj-WS9X5Mi01jhRqbG-zvg4UsA6nHNg@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: fixes for v4.20-rc2
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: david@fromorbit.com, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Thu, Nov 8, 2018 at 4:40 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> - fix incorrect dropping of error code from bmap
>
> - print buffer offsets instead of useless hashed pointers when dumping
>   corrupt metadata
>
> - fix integer overflow in attribute verifier

Pulled,

              Linus
