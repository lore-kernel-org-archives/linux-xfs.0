Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47DvgC6059563 for <xfs@oss.sgi.com>; Mon, 7 May 2012 08:57:43 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id EjtnT79cBBu9QrzJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 06:57:40 -0700 (PDT)
Message-ID: <4FA7D4D1.6070609@profihost.ag>
Date: Mon, 07 May 2012 15:57:37 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: suddenly slow writes on XFS Filesystem
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag>
	(sfid-20120507_095413_656560_122EB192)
	<201205071031.38856.Martin@lichtvoll.de>
In-Reply-To: <201205071031.38856.Martin@lichtvoll.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

Am 07.05.2012 10:31, schrieb Martin Steigerwald:
> Am Montag, 7. Mai 2012 schrieb Stefan Priebe - Profihost AG:
> Did you verify that at the time you perceive slowness the servers you
> backup can deliver data fast enough?
Yes. It works fine to another partition.

> I would like to now, whether there are really processes waiting for I/O
> during rsync workload.
> 
> Can you try vmstat 5 and 
> while true; do ps aux | grep " D" | grep -v grep ; sleep 1; done

Here it is:
# vmstat 5
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 0  1      0 396688     48 7728136    0    0   229   374   22   32  1 12
85  2
 2  0      0 421744     48 7717348    0    0  3722  1169 9015 8389  1  2
95  2
 0  1      0 405780     48 7751904    0    0  8937   207 10780 9290  2
2 88  7
 0  0      0 486928     48 7733300    0    0  2526  1277 8275 7791  1  2
96  1
 0  0      0 416692     48 7778164    0    0  5046 43750 8548 8141  1  2
95  2
 0  0      0 444968     48 7777792    0    0  8021  1709 9315 8573  2  2
94  2
 2  0      0 357924     48 7946532    0    0 48181  1031 17646 12684 10
 4 87  0
 1  0      0 348696     48 8137200    0    0 74366  1056 24362 16775 15
 5 81  0
 1  0      0 391552     48 8279000    0    0 54693  1242 19224 13957 11
 4 85  0

# while true; do ps aux | grep " D" | grep -v grep ; sleep 1; done
root     12493  2.0  0.2 101780 48392 ?        D    15:35   0:24 rsync
--daemon
root     13581  3.5  0.1  76832 20828 ?        D    15:50   0:10 rsync
--daemon
root     12493  2.0  0.2 101268 48508 ?        D    15:35   0:24 rsync
--daemon
root     12494  3.9  0.2 128220 44328 ?        D    15:35   0:47 rsync
--daemon
root     12493  2.0  0.2 101268 48508 ?        D    15:35   0:24 rsync
--daemon
root     13581  3.5  0.1  76832 20828 ?        D    15:50   0:10 rsync
--daemon
root     12493  2.0  0.2 101268 48508 ?        D    15:35   0:24 rsync
--daemon
root     13581  3.5  0.1  76832 20828 ?        D    15:50   0:10 rsync
--daemon
root     12493  2.0  0.2  86420 48120 ?        D    15:35   0:25 rsync
--daemon
root     12493  2.0  0.2  86420 48120 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 21720 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86420 48120 ?        D    15:35   0:25 rsync
--daemon
root     12493  2.0  0.2  86420 48120 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 21720 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86420 48120 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 21980 ?        D    15:50   0:11 rsync
--daemon
root     13582  1.7  0.0  74308 13280 ?        D    15:50   0:05 rsync
--daemon
root     12493  2.0  0.2  87956 48212 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 21980 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86420 48156 ?        D    15:35   0:25 rsync
--daemon
root     12493  2.0  0.2  86420 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22244 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22244 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22244 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22244 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22244 ?        D    15:50   0:11 rsync
--daemon
root     13581  3.5  0.1  76832 22508 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22508 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22508 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22772 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22772 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22772 ?        D    15:50   0:11 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22772 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.5  0.1  76832 22772 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root      3378  0.1  0.0      0     0 ?        D    13:59   0:09
[flush-8:16]
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon
root     12493  2.0  0.2  86676 48180 ?        D    15:35   0:25 rsync
--daemon
root     13581  3.4  0.1  76832 23036 ?        D    15:50   0:12 rsync
--daemon


Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
