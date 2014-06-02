Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E15A7F54
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 02:09:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CDF2FAC001
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 00:09:28 -0700 (PDT)
Received: from mail-ig0-f178.google.com (mail-ig0-f178.google.com
	[209.85.213.178]) by cuda.sgi.com with ESMTP id
	K25V2ZmFHPlpQuW5 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 00:09:24 -0700 (PDT)
Received: by mail-ig0-f178.google.com with SMTP id hl10so3050770igb.17
	for <xfs@oss.sgi.com>; Mon, 02 Jun 2014 00:09:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140602022211.GN6677@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<538995D4.9050702@zytor.com>
	<alpine.LFD.2.11.1405311055410.17310@knanqh.ubzr>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<20140602022211.GN6677@dastard>
Date: Mon, 2 Jun 2014 09:09:23 +0200
Message-ID: <CAMuHMdX=5WEpySgtd5xvt=4ZVNesonJc7k3=GJmuVS9KEiwrMA@mail.gmail.com>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
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
To: Dave Chinner <david@fromorbit.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Linux-Arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, John Stultz <john.stultz@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Ley Foon Tan <lftan@altera.com>, Thomas Gleixner <tglx@linutronix.de>, "Joseph S. Myers" <joseph@codesourcery.com>

On Mon, Jun 2, 2014 at 4:22 AM, Dave Chinner <david@fromorbit.com> wrote:
> Filesystems place all sorts of userspace visible limits on storage -
> ever tried to create a file >16TB on ext4? The on-disk format
> doesn't support it, so it returns an out of range error (E2BIG, I
> think) if you try. XFS, OTOH, handles this just fine and so it
> continues to work. It's exactly the same with timestamps - there's a
> physical limit to what can sanely be stored in any given filesystem
> and it's an *error condition* to go beyond that limit....

This comparison doesn't fly.
File sizes do not depend on the current time (except for the increase of
megapixels in your new camera ;-).
Writing a 15 GiB file to ext4 is not something that magically stops working
tomorrow.

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
