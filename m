Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o86DgFjo178004 for <xfs@oss.sgi.com>; Mon, 6 Sep 2010 08:42:15 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98D5650086
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 06:42:56 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id TxC6i3mwpLI6HXlE for
	<xfs@oss.sgi.com>; Mon, 06 Sep 2010 06:42:56 -0700 (PDT)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 0AE364C8129
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 15:42:48 +0200 (CEST)
Date: Mon, 6 Sep 2010 15:42:54 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
Message-ID: <20100906154254.5542426c@harpe.intellique.com>
In-Reply-To: <201008191312.49346@zmi.at>
References: <201008191312.49346@zmi.at>
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

Le Thu, 19 Aug 2010 13:12:45 +0200
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> The subject is a bit harsh, but overall the article says:
> XFS is slowest on creating and deleting a billion files
> XFS fsck needs 30GB RAM to fsck that 100TB filesystem.

Just to go on this subject : a colleague (following my suggestion :)
tried to create 1 billion files in the same XFS directory.
Unfortunately the directories themselves don't scale well that far :
after 1 million files in the first 30 minutes, file creation slows down
gradually, so after 100 hours we had about 230 million files. The
directory size at that point was 5,3 GB.

Now we're starting afresh with 1000 directories with 1 million files
each :)

(Kernel version used : vanilla 2.6.32.11 x86_64 smp)

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
