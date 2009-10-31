Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9VGn9B8093616 for <xfs@oss.sgi.com>; Sat, 31 Oct 2009 11:49:10 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8234614CAC2F
	for <xfs@oss.sgi.com>; Sat, 31 Oct 2009 09:49:18 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id NLxw4Rn0gb9AUuU5 for
	<xfs@oss.sgi.com>; Sat, 31 Oct 2009 09:49:18 -0700 (PDT)
Date: Sat, 31 Oct 2009 17:48:36 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS and DPX files
Message-ID: <20091031174836.3fc9505b@galadriel.home>
In-Reply-To: <4AEC4BAA.20606@aol.com>
References: <4AEC2CF4.8040703@aol.com> <20091031151825.46210b6a@galadriel.home>
	<4AEC4BAA.20606@aol.com>
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
To: "AndrewL733@aol.com" <AndrewL733@aol.com>
Cc: xfs@oss.sgi.com

Le Sat, 31 Oct 2009 10:37:30 -0400 vous =E9criviez:

>  =

> Thanks.  Already doing that -- 3ware controller does not support =

> barriers, so that's automatically ruled out (you see a message in the =

> syslog when mounting the filesystem that barriers will not be used).  =

> Already mounting with "noatime".  Also have been trying "filestreams".

3Ware controller definitely supports barriers... What model are you
using BTW? On the 9650, the latest firmware gave me a solid 15-20%
performance boost! Did you apply the recommended optimizations like
these :

echo 512 > /sys/block/sdXX/queue/nr_requests
blockdev --setra 65536 /dev/sdXX

for the read-ahead, usual values depends heavily on the disks make and
number, usually ranging from 4096 to 65536.

Another trick is to mkfs the drive with su and sw matching the
underlying RAID, for instance for a 15 drives RAID6 with 64K stripe use
something like (beware, unverified syntax from memory):

mkfs -t xfs -d su=3D65536,sw=3D15 /dev/sdXX


-- =

--------------------------------------------------
Emmanuel Florac               www.intellique.com   =

--------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
