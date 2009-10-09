Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n99JLfeE094394 for <xfs@oss.sgi.com>; Fri, 9 Oct 2009 14:21:41 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F3331D78D36
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2009 12:23:07 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id hLikr8J2JmvHl5eo for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2009 12:23:07 -0700 (PDT)
Date: Fri, 9 Oct 2009 21:21:50 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: can't mount XFS from a read-only device
Message-ID: <20091009212150.2b54cb77@galadriel.home>
In-Reply-To: <4ACF8801.7070009@sandeen.net>
References: <20091009170937.3938ff7b@harpe.intellique.com>
	<4ACF8801.7070009@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Le Fri, 09 Oct 2009 13:59:13 -0500 vous =E9criviez:

> try mount -o norecovery (and maybe -o nobarrier)

Thank you, that worked.

I can't help but think that when given the "ro" option, XFS shouldn't
try to write a single bit to the underlying device, or else what's the
point?

-- =

--------------------------------------------------
Emmanuel Florac               www.intellique.com   =

--------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
