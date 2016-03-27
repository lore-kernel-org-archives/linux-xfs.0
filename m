Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F3217CA0
	for <xfs@oss.sgi.com>; Sun, 27 Mar 2016 07:43:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A886304032
	for <xfs@oss.sgi.com>; Sun, 27 Mar 2016 05:43:28 -0700 (PDT)
Received: from mail-io0-f173.google.com (mail-io0-f173.google.com
	[209.85.223.173]) by cuda.sgi.com with ESMTP id
	STyprJ6aqyzPwVRX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 27 Mar 2016 05:43:25 -0700 (PDT)
Received: by mail-io0-f173.google.com with SMTP id e3so39414324ioa.1
	for <xfs@oss.sgi.com>; Sun, 27 Mar 2016 05:43:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXx80zs5VoA_aYc_wMn37O=fa6oXk-ovteHq0hGQYUUzg@mail.gmail.com>
References: <CAMuHMdXx80zs5VoA_aYc_wMn37O=fa6oXk-ovteHq0hGQYUUzg@mail.gmail.com>
Date: Sun, 27 Mar 2016 14:43:24 +0200
Message-ID: <CAMuHMdW3dfhZVT0e4tiqsbEPjYYA_hGUXQer1bQDeF2Gbs4WJg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v4.6-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linux-sh list <linux-sh@vger.kernel.org>, Rich Felker <dalias@libc.org>, Cris <linux-cris-kernel@axis.com>, xfs@oss.sgi.com

On Sun, Mar 27, 2016 at 2:39 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v4.6-rc1[1] compared to v4.5[2].
>
> Summarized:
>   - build errors: +9/-6

> [1] http://kisskb.ellerman.id.au/kisskb/head/10114/ (all 262 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/head/10047/ (all 262 configs)

> 9 error regressions:
>   + /home/kisskb/slave/src/fs/xfs/xfs_ondisk.h: error: call to
> '__compiletime_assert_79' declared with attribute error: XFS:
> sizeof(xfs_attr_shortform_t) is wrong, expected 8:  => 79:2

cris-allyesconfig, cris-allmodconfig

>   + error: smp-shx3.c: undefined reference to `local_timer_setup':  =>
> .text+0xadec)

shx3_defconfig

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
