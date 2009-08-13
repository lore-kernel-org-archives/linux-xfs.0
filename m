Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DLJHi4051988 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 16:19:28 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBE2314AF272
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 14:19:14 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id HWxYNKurXR09W2Fj for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 14:19:14 -0700 (PDT)
Date: Thu, 13 Aug 2009 23:17:39 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS corruption with failover
Message-ID: <20090813231739.5c7db91d@galadriel.home>
In-Reply-To: <4A8474D2.7050508@jquigley.com>
References: <4A8474D2.7050508@jquigley.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: John Quigley <jquigley@jquigley.com>
Cc: XFS Development <xfs@oss.sgi.com>

Le Thu, 13 Aug 2009 15:17:22 -0500 vous =E9criviez:

> Any advice or insight into what we're doing wrong would be very much
> appreciated.  My apologies in advance for the somewhat off-topic
> question.

By killing abruptly the primary server while doing IO, you're probably
pushing the envelope... You may have a somewhat better luck with a
cluster fs, OCFS2 works very well for me usually (GFS is a complete
PITA to setup). =


The better option would be to disallow completely write
caching on the client side (because this is probably where it's going
wrong) however I don't know how. You can get it to flush extremely
often by playing with  /proc/sys/vm/dirty_expire_centiseconds
and /proc/sys/vm/dirty_writeback_centisecs, though. Safer settings
generally imply terrible performance, though, you've been warned.

Ah another thing may be some cache option in the iSCSI target. what
target are you using?  =


-- =

--------------------------------------------------
Emmanuel Florac               www.intellique.com   =

--------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
