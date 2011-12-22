Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBMB5u19154849 for <xfs@oss.sgi.com>; Thu, 22 Dec 2011 05:05:56 -0600
Received: from smtp-tls.univ-nantes.fr (smtp-tls1.univ-nantes.fr
	[193.52.101.145]) by cuda.sgi.com with ESMTP id
	DPxEUJoJ4QoaRHXg for <xfs@oss.sgi.com>;
	Thu, 22 Dec 2011 03:05:54 -0800 (PST)
Message-ID: <4EF30E5D.7060608@univ-nantes.fr>
Date: Thu, 22 Dec 2011 12:02:53 +0100
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
	<4EF2F702.4050902@univ-nantes.fr>
In-Reply-To: <4EF2F702.4050902@univ-nantes.fr>
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
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

Le 22/12/2011 10:23, Yann Dupont a =E9crit :
>
>> Can you run a block trace on both kernels (for say five minutes)
>> when the load differential is showing up and provide that to us so
>> we can see how the IO patterns are differing?


here we go.

1st server : Birnie, is running 2.6.26. This is normally the more loaded =

server (more active users)

2nd server : Penderyn, is runing a freshly compiled 3.1.6.


blktrace of relevent volumes during 10 minutes. The 2 machines are =

identical (poweredge M1610) : same mem & proc, disks, fibre channel =

cards, SAN disks ...

birnie:~/TRACE# uptime
  11:48:34 up 17:18,  3 users,  load average: 0.04, 0.18, 0.23

penderyn:~/TRACE# uptime
  11:48:30 up 23 min,  3 users,  load average: 4.03, 3.82, 3.21

As you can see, very sensible load difference. keep in mind my =

university is on holiday right now, so the load is really _very much =

lower_ than usual. In normal times, with 2.6.26 kernels, birnie has a =

load in 2 .. 6 range.

here are the results :


birnie:~/TRACE# blktrace /dev/gromelac/gromelac =

/dev/POMEROL-R0-P0/gromeldi -w 600
=3D=3D=3D dm-18 =3D=3D=3D
   CPU  0:                26787 events,     1256 KiB data
   CPU  1:                  530 events,       25 KiB data
   CPU  2:                 1811 events,       85 KiB data
   CPU  3:                  104 events,        5 KiB data
   CPU  4:                 5824 events,      274 KiB data
   CPU  5:                  146 events,        7 KiB data
   CPU  6:                 1958 events,       92 KiB data
   CPU  7:                  176 events,        9 KiB data
   CPU  8:                 5456 events,      256 KiB data
   CPU  9:                  175 events,        9 KiB data
   CPU 10:                 1161 events,       55 KiB data
   CPU 11:                  216 events,       11 KiB data
   CPU 12:                  118 events,        6 KiB data
   CPU 13:                   25 events,        2 KiB data
   CPU 14:                  287 events,       14 KiB data
   CPU 15:                  425 events,       20 KiB data
   Total:                 45199 events (dropped 0),     2119 KiB data
=3D=3D=3D dm-16 =3D=3D=3D
   CPU  0:                27966 events,     1311 KiB data
   CPU  1:                  311 events,       15 KiB data
   CPU  2:                 1403 events,       66 KiB data
   CPU  3:                 1699 events,       80 KiB data
   CPU  4:                 1706 events,       80 KiB data
   CPU  5:                 1515 events,       72 KiB data
   CPU  6:                   30 events,        2 KiB data
   CPU  7:                  428 events,       21 KiB data
   CPU  8:                 6774 events,      318 KiB data
   CPU  9:                  252 events,       12 KiB data
   CPU 10:                 1299 events,       61 KiB data
   CPU 11:                 1391 events,       66 KiB data
   CPU 12:                  111 events,        6 KiB data
   CPU 13:                 2317 events,      109 KiB data
   CPU 14:                  130 events,        7 KiB data
   CPU 15:                  504 events,       24 KiB data
   Total:                 47836 events (dropped 0),     2243 KiB data


and

penderyn:~/TRACE# blktrace /dev/gromeljo/gromeljo /dev/gromelpz/gromelpz =

/dev/POMEROL-R1-P0/gromelpz -w 600
=3D=3D=3D dm-14 =3D=3D=3D
   CPU  0:                12672 events,      595 KiB data
   CPU  1:                13248 events,      621 KiB data
   CPU  2:                  545 events,       26 KiB data
   CPU  3:                  285 events,       14 KiB data
   CPU  4:                  574 events,       27 KiB data
   CPU  5:                   94 events,        5 KiB data
   CPU  6:                  569 events,       27 KiB data
   CPU  7:                  172 events,        9 KiB data
   CPU  8:                  666 events,       32 KiB data
   CPU  9:                 3231 events,      152 KiB data
   CPU 10:                  610 events,       29 KiB data
   CPU 11:                  221 events,       11 KiB data
   CPU 12:                   11 events,        1 KiB data
   CPU 13:                   20 events,        1 KiB data
   CPU 14:                    6 events,        1 KiB data
   CPU 15:                   30 events,        2 KiB data
   Total:                 32954 events (dropped 0),     1545 KiB data
=3D=3D=3D dm-13 =3D=3D=3D
   CPU  0:                    0 events,        0 KiB data
   CPU  1:                    0 events,        0 KiB data
   CPU  2:                    1 events,        1 KiB data
   CPU  3:                    0 events,        0 KiB data
   CPU  4:                    0 events,        0 KiB data
   CPU  5:                    0 events,        0 KiB data
   CPU  6:                    0 events,        0 KiB data
   CPU  7:                    0 events,        0 KiB data
   CPU  8:                    0 events,        0 KiB data
   CPU  9:                    0 events,        0 KiB data
   CPU 10:                    0 events,        0 KiB data
   CPU 11:                    0 events,        0 KiB data
   CPU 12:                    0 events,        0 KiB data
   CPU 13:                    0 events,        0 KiB data
   CPU 14:                    0 events,        0 KiB data
   CPU 15:                    0 events,        0 KiB data
   Total:                     1 events (dropped 0),        1 KiB data
=3D=3D=3D dm-16 =3D=3D=3D
   CPU  0:                17499 events,      821 KiB data
   CPU  1:                15320 events,      719 KiB data
   CPU  2:                 1037 events,       49 KiB data
   CPU  3:                  667 events,       32 KiB data
   CPU  4:                  278 events,       14 KiB data
   CPU  5:                   91 events,        5 KiB data
   CPU  6:                  888 events,       42 KiB data
   CPU  7:                   67 events,        4 KiB data
   CPU  8:                 2317 events,      109 KiB data
   CPU  9:                 3662 events,      172 KiB data
   CPU 10:                 1756 events,       83 KiB data
   CPU 11:                  801 events,       38 KiB data
   CPU 12:                   20 events,        1 KiB data
   CPU 13:                  618 events,       29 KiB data
   CPU 14:                    3 events,        1 KiB data
   CPU 15:                   18 events,        1 KiB data
   Total:                 45042 events (dropped 0),     2112 KiB data



And The blktrace files are there  (for five days) :

http://filex.univ-nantes.fr/get?k=3DRDxGitXYOf4HKHd7Tan

Hope it can be helpfull,
Thanks,
-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
