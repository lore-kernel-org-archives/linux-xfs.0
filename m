Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5MGTEfA245888 for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 11:29:14 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C94315A080A
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 09:36:04 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id c1NgOfD6IoeGcHOW for
	<xfs@oss.sgi.com>; Tue, 22 Jun 2010 09:36:04 -0700 (PDT)
Date: Tue, 22 Jun 2010 18:31:54 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: advice for repair after IO error on raid device
Message-ID: <20100622183154.24e84e0d@harpe.intellique.com>
In-Reply-To: <cone.1277218412.674723.87295.1001@bork.lsof.org>
References: <cone.1277217402.916517.87295.1001@bork.lsof.org>
	<cone.1277218412.674723.87295.1001@bork.lsof.org>
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
To: Roel van Meer <rolek@bokxing.nl>
Cc: xfs@oss.sgi.com

Le Tue, 22 Jun 2010 16:53:32 +0200
Roel van Meer <rolek@bokxing.nl> =E9crivait:

> If someone could confirm (or reject) that, that would be great.

Confirmation granted.

> (By the way, is it necessary to run xfs_repair with -n first? If not,
> are there advantages that would justify the extra time it takes?)

It will indicate what modifications he would have done, before actually
doing them... Like "inode 038953095 corrupted, would remove it" then
"directory not connected, would move content moved to lost+found"

I found that usually xfs_repair is quit quick and never takes much more
than a couple of minutes (even on very big arrays) so you have no valid
reason to skip the "xfs_repair -n" part.

It may be nice to dump the filesystem metadata with xfs_metadump
prior to using xfs_repair too. In the case where the repair's really
gone bad, you could at least revert to the prior less broken state using
xfs_mdrestore...

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
