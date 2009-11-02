Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2HqgKv078986 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 11:52:42 -0600
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26971180B3D5
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 09:52:53 -0800 (PST)
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2]) by
	cuda.sgi.com with ESMTP id GvamCvdpdq1ECvU7 for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2009 09:52:53 -0800 (PST)
Date: Mon, 2 Nov 2009 18:52:49 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS and DPX files
Message-ID: <20091102185249.0da8e388@harpe.intellique.com>
In-Reply-To: <200911021205.28006@zmi.at>
References: <4AEC2CF4.8040703@aol.com> <4AEC4BAA.20606@aol.com>
	<20091031174836.3fc9505b@galadriel.home>
	<200911021205.28006@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Le Mon, 2 Nov 2009 12:05:27 +0100
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> I believe for a 15 drive RAID-6, where 2 disks are used for
> redundancy, the correct mkfs would be:
> mkfs -t xfs -d su=3D65536,sw=3D13 /dev/sdXX

Yes you're right, I replied a bit too quickly :)


> Another thing to try is if it would help to turn disk cache writes
> *on*, despite all warnings if the FAQ. =


The 3Ware is so slow it's almost unusable without write cache. I bet he
already uses it anyway.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Intellique
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
