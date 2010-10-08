Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o98Ke1qC060844 for <xfs@oss.sgi.com>; Fri, 8 Oct 2010 15:40:02 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4ECF2150EB28
	for <xfs@oss.sgi.com>; Fri,  8 Oct 2010 13:55:01 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id V2TtQlWbNCvEf7hh for
	<xfs@oss.sgi.com>; Fri, 08 Oct 2010 13:55:01 -0700 (PDT)
Date: Fri, 8 Oct 2010 22:40:57 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: ENOSPC at 90% with plenty of inodes
Message-ID: <20101008224057.53e97770@galadriel.home>
In-Reply-To: <AANLkTinwnOm0V=9WwbXiUGFnyjCwT3GUHo0hiQahQNUV@mail.gmail.com>
References: <AANLkTinwnOm0V=9WwbXiUGFnyjCwT3GUHo0hiQahQNUV@mail.gmail.com>
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
To: James Braid <jamesb@loreland.org>
Cc: xfs@oss.sgi.com

Le Fri, 8 Oct 2010 18:17:52 +0100 vous =E9criviez:

> On a fairly busy mail server hosting about 1000 cyrus mailboxes (each
> message is stored as a separate file), we are observing ENOSPC errors
> from the cyrus pop/imap daemons when attempting to create (tiny)
> files. e.g.

You must be running out of inodes, this probably should be a FAQ...
Check with xfs_info how much space is dedicated to inodes, and expand
it with xfs_growfs -m.

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
