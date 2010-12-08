Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB8EWhNi127062 for <xfs@oss.sgi.com>; Wed, 8 Dec 2010 08:32:44 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B39F1D4211
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 06:34:30 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 4iRW93YAWRhjG0GC for
	<xfs@oss.sgi.com>; Wed, 08 Dec 2010 06:34:30 -0800 (PST)
Date: Wed, 8 Dec 2010 15:34:30 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: kernel panic-xfs errors
Message-ID: <20101208153430.3f5831b3@harpe.intellique.com>
In-Reply-To: <30405587.post@talk.nabble.com>
References: <30397503.post@talk.nabble.com> <20101207222558.GC29333@dastard>
	<30403823.post@talk.nabble.com>
	<20101208115724.0b2c210a@harpe.intellique.com>
	<30405587.post@talk.nabble.com>
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
To: blacknred <leo1783@hotmail.co.uk>
Cc: xfs@oss.sgi.com

Le Wed, 8 Dec 2010 06:01:26 -0800 (PST)
blacknred <leo1783@hotmail.co.uk> =E9crivait:

> As in -is controller writing data in a different location which is not
> intended to be written to?
> Or is it case of writing incorrect data causing corruption?....
> =


This:

XFS: bad magic number
XFS: SB validate failed =


Seems to indicate that the beginning of the filesystem was somehow
corrupted. Just like the log was apparently truncated on the other
server. That's why I though that you had a power failure and that an
incomplete write operation was the culprit.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
