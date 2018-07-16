Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36844 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730552AbeGPKih (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Jul 2018 06:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <CABeXuvphoYM+KOGPgtsuxzS1_XDSOO0Ta5hr3sA7gYtt-78wtQ@mail.gmail.com>
References: <20180713133204.3123939-1-arnd@arndb.de> <CABeXuvphoYM+KOGPgtsuxzS1_XDSOO0Ta5hr3sA7gYtt-78wtQ@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 16 Jul 2018 12:11:53 +0200
Message-ID: <CAK8P3a2xu4KGVM1BvTjtXKHfXpBQ2PMynAPybW4cRt7FB8ktwg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] y2038: globally rename compat_time to old_time32
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, alsa-devel@alsa-project.org

On Sat, Jul 14, 2018 at 5:54 PM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> Right now we only have compat syscalls and native syscalls.
> Until we transition all the architectures to use the new syscalls,
> wouldn't it be the same sort of confusion as exists today?
> These structures today are still used by compat entry points.
> I'm trying to understand why such a cleanup would make sense today
> rather than at the end of the transition.

I don't think it makes a big difference whether we change it now or later,
but if Christoph feels that it addresses his concern about the compat_
namespace being reused during the transition, doing it earlier would
enable us to finish the remaining syscalls.

We are running a little late with the remaining syscalls for 4.19 as we
now have an rc5. At this point we probably won't have time to finish
the discussion about all of clock_adjtime, getrusage/waitid and getitimer(),
but I'd really like to get utimensat, futex, sched_rr_get_interval,
recvmmsg, sys_io_getevents, rt_sigtimedwait, ppoll and pselect6
done for 4.19 so we can finalize the ABI for 4.20 along with doing
the actual conversion.

      Arnd
