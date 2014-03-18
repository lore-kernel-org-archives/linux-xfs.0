Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D14D57F80
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2014 08:56:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9331304043
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2014 06:56:07 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id UVVXB7am4QHQ8fRD for
	<xfs@oss.sgi.com>; Tue, 18 Mar 2014 06:56:06 -0700 (PDT)
Date: Tue, 18 Mar 2014 14:56:05 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: elevator question
Message-ID: <20140318145605.6d7172ee@harpe.intellique.com>
In-Reply-To: <ac1d082430f0dfa45709ef3c7912a53f@zbfmail.de>
References: <ea0e10e64a65dbd39cd71a826e18985e@zbfmail.de>
	<53277C56.7000002@hardwarefreak.com>
	<20140318102657.2ba68f00@galadriel.home>
	<ac1d082430f0dfa45709ef3c7912a53f@zbfmail.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: weber@zbfmail.de
Cc: Xfs <xfs@oss.sgi.com>

Le Tue, 18 Mar 2014 11:18:04 +0100
Marko Weber|8000 <weber@zbfmail.de> =E9crivait:

> i am barely new to this issue. What would you xfs guys recommend me?
> i prefer things i can do with kernel, so its dm-cache? bcache?

The easier will be bcache because it comes included with the kernel.

> the raid is an raid5 with 3 disks at moment. xfs filesystem.
> do i have to format it again and set special things?

No, only the cache itself must be reformatted.

> i use nobarrier at moment,

if you're not using a hardware RAID controller with a battery-backed or
flash-based cache, it may be risky. Depends mostly on your write
activity and power supply stability, though.


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
