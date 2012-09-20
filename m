Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KC4TXT077508 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 07:04:29 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id ubhZsJejWrQYrhQB for
	<xfs@oss.sgi.com>; Thu, 20 Sep 2012 05:05:40 -0700 (PDT)
Date: Thu, 20 Sep 2012 14:05:37 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Questions on RAID alignment
Message-ID: <20120920140537.11a50638@harpe.intellique.com>
In-Reply-To: <505AF9EA.7030603@shiftmail.org>
References: <505AF9EA.7030603@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

Le Thu, 20 Sep 2012 13:11:38 +0200
Spelic <spelic@shiftmail.org> =E9crivait:

> 1- Does XFS support alignment to concatenation RAIDs (e.g. linear
> over raid1) similarly to striped ones? I am guessing probably su and
> sw should not be specified and the agcount should be multiple of the
> number of the concatenated devices, is that correct?

No, it's better to set your sw/su accordingly to your RAID setup
(example: 8 drives RAID-10 256k stripe -> su=3D256k,sw=3D4) and let
mkfs.xfs determine itself how many ag it wants, to adapt it both to the
striping and filesystem size. =


> 2- Can mkfs parameters be altered after creation, e.g. after growing
> a RAID and then growing the XFS fs, can I also alter su, sw, agcount
> somehow?

agcount will be adjusted by xfs_growfs AFAIK. For the other parameters,
not so much.
 =

> 3- I seem to remember there was an xattr that one could attach
> to /home (if /home was under XFS) so that every user (subdir
> of /home) would get a different AG in a different RAID device. I
> cannot find that information anymore on the internet; could you
> refresh my mind?
> =


I really have no idea on this.

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
