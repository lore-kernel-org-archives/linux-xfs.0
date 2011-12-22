Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBM9QFcL143695 for <xfs@oss.sgi.com>; Thu, 22 Dec 2011 03:26:16 -0600
Received: from smtp-tls.univ-nantes.fr (smtp-tls1.univ-nantes.fr
	[193.52.101.145]) by cuda.sgi.com with ESMTP id
	pnRUvM8EalEwbygV for <xfs@oss.sgi.com>;
	Thu, 22 Dec 2011 01:26:14 -0800 (PST)
Message-ID: <4EF2F702.4050902@univ-nantes.fr>
Date: Thu, 22 Dec 2011 10:23:14 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
	<20111211233929.GI14273@dastard>
	<CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
	<20111212010053.GM14273@dastard>
	<CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
	<4EF1A224.2070508@univ-nantes.fr>
	<4EF1F6DD.8020603@hardwarefreak.com>
	<4EF21DD2.3060004@univ-nantes.fr> <20111221222623.GF23662@dastard>
In-Reply-To: <20111221222623.GF23662@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

Le 21/12/2011 23:26, Dave Chinner a =E9crit :
> On Wed, Dec 21, 2011 at 06:56:34PM +0100, Yann Dupont wrote:
>> Le 21/12/2011 16:10, Stan Hoeppner a =E9crit :
>>
>>
>>> 1.  What mailbox format are you using?  Is this a constant or variable?
>>
>> Maildir++
>
> Which is what?

Each message is saved as an individual files. With loaded mailboxex, you =

can end with thousands of files under one directory.

>
> Can you run a block trace on both kernels (for say five minutes)
> when the load differential is showing up and provide that to us so
> we can see how the IO patterns are differing?
>

Yes. Keep in mind that I can have very different load in 5 minutes distance.
I have 2 options here :

Case 1 : For server 1, running with kernel 2.6.26, blktrace it, reboot =

in 3.1.5, blktrace it. OR

Case 2 : Server 1 running 2.6.26 and Server 2 running 3.1.5

in Case 1 you have the same set of users and the same config garantied.

in case 2, you don't have the same set of users, but the load can be =

quite symetric (think of mailing list)


I will go for case 2 I think.

Last question :

The volumes are on top of lvm2 (sitting on top of multipath dm)


I'll try to blktrace the volume itself, but I can end blktracing the =

scsi primary path (don't know if it make a difference)

Is there any option you want in blktrace ???

Thanks,


-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
