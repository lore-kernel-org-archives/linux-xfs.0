Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jan 2008 01:33:02 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m089Wlss011999
	for <xfs@oss.sgi.com>; Tue, 8 Jan 2008 01:32:50 -0800
Received: from ug-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9A6CC25D2E
	for <xfs@oss.sgi.com>; Tue,  8 Jan 2008 01:33:03 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174]) by cuda.sgi.com with ESMTP id Fcb660kOoiwZsDO5 for <xfs@oss.sgi.com>; Tue, 08 Jan 2008 01:33:03 -0800 (PST)
Received: by ug-out-1314.google.com with SMTP id o29so3671041ugd.20
        for <xfs@oss.sgi.com>; Tue, 08 Jan 2008 01:33:02 -0800 (PST)
Message-ID: <96c268400801080105h68a75233ia82e05d8debaabe6@mail.gmail.com>
Date: Tue, 8 Jan 2008 12:05:07 +0300
From: "Maxim Gordienko" <mgordienko@gmail.com>
Subject: Re: xfs_repair core dump
In-Reply-To: <op.t4lfpunc3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <96c268400801061801i62853e5xdda1b93cc864dda5@mail.gmail.com>
	 <op.t4lfpunc3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com

On Jan 8, 2008 7:21 AM, Barry Naujok <bnaujok@sgi.com> wrote:
> On Mon, 07 Jan 2008 13:01:00 +1100, Maxim Gordienko <mgordienko@gmail.com>
> wrote:
>
> > Hello!
> >
> > I'm trying to repair damaged xfs partition, but xfs_repair crashes
> > with core dump
> > distribution is fully updated ubuntu 7.10, xfsprogs are 2.9.0.
> > Have tried xfs_repair from other dists like knoppix or gparted livecd,
> > compiled from source last stable (2.9.4-1)
> > same result. Could you please help? Thank you.
>
> Would it be possible to obtain an image or metadump image of your
> filesystem so I can diagnose the xfs_repair problem here?
>
> xfs_metadump obfuscates most filenames if privacy is an issue.
>

I shared metadump at https://mastubuntu.dyndns.org/xfs.dump.bz2
sorry, partition is 175gb big, i cannot create full dump.

> Regards,
> Barry.
>
>
> > Phase 5 - rebuild AG headers and trees...
> > *** glibc detected *** xfs_repair: munmap_chunk(): invalid pointer:
> > 0xb514d008 ***
> > ======= Backtrace: =========
> > /lib/tls/i686/cmov/libc.so.6(cfree+0x1bb)[0xb7ead92b]
> > xfs_repair[0x8062d9a]
> > xfs_repair[0x806c896]
> > xfs_repair[0x8080515]
> > /lib/tls/i686/cmov/libpthread.so.0[0xb7f9846b]
> > /lib/tls/i686/cmov/libc.so.6(clone+0x5e)[0xb7f136de]
> >
> >
>
>
>
