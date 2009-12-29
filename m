Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBTBRQaT144533 for <xfs@oss.sgi.com>; Tue, 29 Dec 2009 05:27:27 -0600
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6A461C1F485
	for <xfs@oss.sgi.com>; Tue, 29 Dec 2009 03:28:11 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id sRw3HL2s66jxGezT for
	<xfs@oss.sgi.com>; Tue, 29 Dec 2009 03:28:11 -0800 (PST)
Date: Tue, 29 Dec 2009 12:27:44 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: benchmark results
Message-ID: <20091229122744.40a4b707@galadriel.home>
In-Reply-To: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Le Thu, 24 Dec 2009 02:31:10 -0800 (PST) vous =E9criviez:

>     - btrfs, ext4 are the overall winners
>     - xfs to, but creating/deleting many files was *very* slow

xfs is slow at file creation/deletion if you mount it with barriers on
standard disk drives (not so with hardware RAID controllers).

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
