Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAQEYeKI170677 for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 08:34:40 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7AD01DB4306
	for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 06:36:17 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id AgKNyKLWvCY8wno4 for
	<xfs@oss.sgi.com>; Fri, 26 Nov 2010 06:36:17 -0800 (PST)
Date: Fri, 26 Nov 2010 15:36:14 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Verify filesystem is aligned to stripes
Message-ID: <20101126153614.3b62a557@harpe.intellique.com>
In-Reply-To: <20101126122218.GH12187@dastard>
References: <4CED5BFC.8000906@shiftmail.org> <20101125054607.GM13830@dastard>
	<4CEE0995.9030900@hardwarefreak.com>
	<20101125101537.GD12187@dastard>
	<4CEEE9BC.2030401@hardwarefreak.com>
	<20101126091622.264830fa@galadriel.home>
	<20101126122218.GH12187@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

Le Fri, 26 Nov 2010 23:22:18 +1100
Dave Chinner <david@fromorbit.com> =E9crivait:

> Assuming synchronous IO. If you are doing async IO, a single CPU
> should be able to keep hundreds of SRDs (Spinning Rust Disks) busy...
> =


What I had in mind (typical random IO) is DB access, which is AFAIK
synchronous IO, my bad :)

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
