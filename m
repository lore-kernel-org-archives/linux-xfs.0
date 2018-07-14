Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:50400 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbeGNQNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Jul 2018 12:13:48 -0400
MIME-Version: 1.0
In-Reply-To: <20180713133204.3123939-1-arnd@arndb.de>
References: <20180713133204.3123939-1-arnd@arndb.de>
From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Sat, 14 Jul 2018 08:54:17 -0700
Message-ID: <CABeXuvphoYM+KOGPgtsuxzS1_XDSOO0Ta5hr3sA7gYtt-78wtQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC] y2038: globally rename compat_time to old_time32
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Thomas Gleixner <tglx@linutronix.de>, geert@linux-m68k.org, Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, alsa-devel@alsa-project.org

Right now we only have compat syscalls and native syscalls.
Until we transition all the architectures to use the new syscalls,
wouldn't it be the same sort of confusion as exists today?
These structures today are still used by compat entry points.
I'm trying to understand why such a cleanup would make sense today
rather than at the end of the transition.

-Deepa
