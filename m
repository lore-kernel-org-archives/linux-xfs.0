Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:54170 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752630AbcLOUsH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 15:48:07 -0500
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
Date: Thu, 15 Dec 2016 21:48:04 +0100
Message-ID: <1905506.cKQjPTDRSm@libor-nb>
In-Reply-To: <a6e607fc-9a54-a372-7ffa-bfdef58b3dc0@sandeen.net>
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com> <2626665.Hsx8YazNWY@libor-nb> <a6e607fc-9a54-a372-7ffa-bfdef58b3dc0@sandeen.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Hello,

On úterý 13. prosince 2016 10:04:27 CET Eric Sandeen wrote:
> On 12/13/16 4:52 AM, Libor Klep�? wrote:
> > Hello,
> > should this patch possibly fix errors i reported in this thread?
> > https://www.spinics.net/lists/linux-xfs/msg01728.html
> > 
> > Is it safe to test it? (i do have backups)
> 
> It should be safe, yes.
>
ok,  will try it soon(ish) with machines named vps1 and vps3 in my mails. vps2 
is problematic to shutdown and test.
 
> (you could always run xfs_repair -n first to be extra careful).
> 
> Were those errors during mount/replay, though, or was it when the
> filesystem was up and running?
> 
It was always when running, some errors were just logged, some caused fs 
shutdown

> I ask because I also sent a patch to ignore these empty attributes
> in the verifier during log replay.
> 

> FWIW, Only some of your reported buffers look "empty" though, the one
> at 514098.682726 may have had something else wrong.
> 
Ok, i see, it has some "data" in it

> Anyway, yes, probably worth checking with xfs_repair (-n) with this
> patch added.  Let us know what you find! :)
> 
> -Eric
> 

Libor

