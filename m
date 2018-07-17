Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52988 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731431AbeGQNbd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 09:31:33 -0400
Date: Tue, 17 Jul 2018 05:58:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [RFC] y2038: globally rename compat_time to old_time32
Message-ID: <20180717125855.GA3681@infradead.org>
References: <20180713133204.3123939-1-arnd@arndb.de>
 <CABeXuvphoYM+KOGPgtsuxzS1_XDSOO0Ta5hr3sA7gYtt-78wtQ@mail.gmail.com>
 <CAK8P3a2xu4KGVM1BvTjtXKHfXpBQ2PMynAPybW4cRt7FB8ktwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2xu4KGVM1BvTjtXKHfXpBQ2PMynAPybW4cRt7FB8ktwg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, y2038 Mailman List <y2038@lists.linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, alsa-devel@alsa-project.org

On Mon, Jul 16, 2018 at 12:11:53PM +0200, Arnd Bergmann wrote:
> I don't think it makes a big difference whether we change it now or later,
> but if Christoph feels that it addresses his concern about the compat_
> namespace being reused during the transition, doing it earlier would
> enable us to finish the remaining syscalls.

Yes, I've been looking at your new series and the reuse of compat_*
is really confusing
