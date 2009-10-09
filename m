Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n99JoO6x096089 for <xfs@oss.sgi.com>; Fri, 9 Oct 2009 14:50:24 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C807EBF6957
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2009 12:51:48 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id H0yweAKU1q5iNzTl for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2009 12:51:48 -0700 (PDT)
Date: Fri, 9 Oct 2009 21:50:27 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: can't mount XFS from a read-only device
Message-ID: <20091009215027.71cf86b9@galadriel.home>
In-Reply-To: <4ACF8EEF.1040809@sandeen.net>
References: <20091009170937.3938ff7b@harpe.intellique.com>
	<4ACF8801.7070009@sandeen.net>
	<20091009212150.2b54cb77@galadriel.home>
	<4ACF8EEF.1040809@sandeen.net>
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

Le Fri, 09 Oct 2009 14:28:47 -0500 vous =E9criviez:

> For a clean log I agree; what kernel was this?  I vaguely remember a
> fix in this area.

It's a 2.6.24.7. I did a quick try with 2.6.27.25 and got exactly the
same error.

> Which option solved it?  (norecovery I'm guessing)

Yes, norecovery was the missing part.

-- =

--------------------------------------------------
Emmanuel Florac               www.intellique.com   =

--------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
