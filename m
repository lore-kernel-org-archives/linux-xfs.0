Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0EAB67F3F
	for <xfs@oss.sgi.com>; Sat, 12 Dec 2015 04:24:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D588E304048
	for <xfs@oss.sgi.com>; Sat, 12 Dec 2015 02:24:36 -0800 (PST)
Received: from mail1.xortex.at (mail1.xortex.at [95.130.251.167]) by
	cuda.sgi.com with ESMTP id n6LbrOPIyc01wem8 for
	<xfs@oss.sgi.com>; Sat, 12 Dec 2015 02:24:33 -0800 (PST)
Received: from mail1.xortex.at (localhost.localdomain [127.0.0.1])
	by mail1.xortex.at (Postfix) with ESMTP id 7D4E05E0AD
	for <xfs@oss.sgi.com>; Sat, 12 Dec 2015 11:24:31 +0100 (CET)
Received: from TIGER2010.xortex.local (tiger.xortex.com [91.234.229.218])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail1.xortex.at (Postfix) with ESMTPS id 515EC5E0AD
	for <xfs@oss.sgi.com>; Sat, 12 Dec 2015 11:24:31 +0100 (CET)
From: =?iso-8859-1?Q?Georg_Sch=F6nberger?= <g.schoenberger@xortex.com>
Subject: XFS and nobarrier with SSDs
Date: Sat, 12 Dec 2015 10:24:25 +0000
Message-ID: <E127700EFE58FD45BD6298EAC813FA42020D8173@TIGER2010.xortex.local>
Content-Language: en-US
MIME-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi folks!

We are using a lot of SSDs in our Ceph clusters with XFS. Our SSDs have Pow=
er Loss Protection
via capacitors, so is it safe in all cases to run XFS with nobarrier on the=
m? Or is there indeed
a need for a specific I/O scheduler?

I have found a recent discussion on the Ceph mailing list, anyone from XFS =
that can help us?

*http://www.spinics.net/lists/ceph-users/msg22053.html
*https://bugzilla.redhat.com/show_bug.cgi?id=3D1104380

Thanks for your help,
Georg Sch=F6nberger
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
