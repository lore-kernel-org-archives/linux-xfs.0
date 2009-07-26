Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6QFd5nj028454 for <xfs@oss.sgi.com>; Sun, 26 Jul 2009 10:39:05 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A54D386F43
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2009 08:39:47 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id XC0dwo86BGQMmdfE for
	<xfs@oss.sgi.com>; Sun, 26 Jul 2009 08:39:47 -0700 (PDT)
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 5B78BD480C0
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2009 17:39:41 +0200 (CEST)
Received: from galadriel.home (pla78-1-82-235-234-79.fbx.proxad.net
	[82.235.234.79])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 4DE9BD480CF
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2009 17:39:39 +0200 (CEST)
Date: Sun, 26 Jul 2009 17:39:38 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: How to solve "No space left" problem on my 32bit machine?
Message-ID: <20090726173938.4179bd18@galadriel.home>
In-Reply-To: <389deec70907252030s3524b2ecj9b35da9ea376020f@mail.gmail.com>
References: <389deec70907252030s3524b2ecj9b35da9ea376020f@mail.gmail.com>
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
To: xfs@oss.sgi.com

Le Sun, 26 Jul 2009 11:30:03 +0800 vous =E9criviez:

> If on my 32-bit machine, what should I do?

2.5TB is far from the 32 bits limit (16 TB). You're probably out of
inodes (lots of small files?). You can add some with xfs_growfs, though.

-- =

--------------------------------------------------
Emmanuel Florac               www.intellique.com   =

--------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
