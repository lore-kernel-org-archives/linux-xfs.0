Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBL9BFeL248429 for <xfs@oss.sgi.com>; Wed, 21 Dec 2011 03:11:15 -0600
Received: from smtp-tls.univ-nantes.fr (smtp-tls1.univ-nantes.fr
	[193.52.101.145]) by cuda.sgi.com with ESMTP id
	XOcFSnZ4Ot8nUy5P for <xfs@oss.sgi.com>;
	Wed, 21 Dec 2011 01:11:12 -0800 (PST)
Received: from localhost (debian [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 388EB94DB4
	for <xfs@oss.sgi.com>; Wed, 21 Dec 2011 10:11:11 +0100 (CET)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtp-tls1.d101.univ-nantes.fr [127.0.0.1]) (amavisd-new,
	port 10024) with LMTP id Q9TVtUguLF59 for <xfs@oss.sgi.com>;
	Wed, 21 Dec 2011 10:11:11 +0100 (CET)
Received: from [172.20.13.9] (tomintoul.cri.univ-nantes.prive [172.20.13.9])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id 1EF0594DB3
	for <xfs@oss.sgi.com>; Wed, 21 Dec 2011 10:11:11 +0100 (CET)
Message-ID: <4EF1A224.2070508@univ-nantes.fr>
Date: Wed, 21 Dec 2011 10:08:52 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
	<20111211233929.GI14273@dastard>
	<CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
	<20111212010053.GM14273@dastard>
	<CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
In-Reply-To: <CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Le 12/12/2011 03:00, Xupeng Yun a =E9crit :
>
>
> On Mon, Dec 12, 2011 at 09:00, Dave Chinner <david@fromorbit.com
> <mailto:david@fromorbit.com>> wrote:
>
>     Oh, of course, now I remember what the problem is - it's a locking
>     issue that was fixed in 3.0.11, 3.1.5 and 3.2-rc1.
>
>
> Got it, thanks.
>
> --
> Xupeng Yun
> http://about.me/xupeng
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

I'm seeing more or less the same here.

Generally speaking XFS code in recent kernels seems to decrease CPU =

usage and be faster, which is a very good thing (good works, guy). But...

On two particular server, with recent kernels, I experience a much =

higher load than expected, but it's very hard to tell what's wrong. The =

system seems more in I/O wait. Older kernels (2.6.32.xx and 2.6.26.xx) =

gives better results.

Following this thread, I thought I have the same problems, but it's =

probably not the case, as I have tested 2.6.38.xx, 3.0.13, 3.1.5 with =

same results.

Thoses servers are mail (dovecot) servers, with lots of simultaneous =

imap clients (5000+) an lots of simultaneous message delivery.

These are linux-vservers, on top of LVM volumes. The storage is SAN with =

15k RPM SAS drives (and battery backup).

I know barriers were disabled in older kernels, so with recents kernels, =

XFS volumes were mounted with nobarrier.

As those servers are critical for us, I can't really test, hardly give =

you more precise numbers, and I don't know how to accurately reproduce =

this platform to test what's wrong. I know this is NOT a precise bug =

report and it won't help much.

All I can say IS :

- read operations seems no slower with recent kernels, backups take =

approximatively the same time ;
- I'd say (but I have no proof) that delivery of new mails takes more =

time and is more synchronous than before, like nobarrier have no effect.

Does this ring a bell to some of you ?

Thanks,
-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
