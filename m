Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 120757F58
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 04:39:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F41C8304039
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 02:39:29 -0700 (PDT)
Received: from smtp-tls.univ-nantes.fr (smtptls2-lmb.cpub.univ-nantes.fr
	[193.52.103.111]) by cuda.sgi.com with ESMTP id
	jGRF9OqAl35cj1PN for <xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 02:39:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 5686E40174D
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 11:39:27 +0200 (CEST)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtptls2-lmb.cpub.univ-nantes.fr [127.0.0.1])
	(amavisd-new, port 10024)
	with LMTP id ItPMMruBiSRt for <xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 11:39:27 +0200 (CEST)
Received: from [IPv6:2001:660:7220:0:2da5:fb76:c9be:5314] (unknown
	[IPv6:2001:660:7220:0:2da5:fb76:c9be:5314])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id 391A34016E1
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 11:39:27 +0200 (CEST)
Message-ID: <516BCACE.1040900@univ-nantes.fr>
Date: Mon, 15 Apr 2013 11:39:26 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: kernels 3.4 slower due to allocation workqueue
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,
last week we received new machines (DELL R720xd) for an extension of our =

ceph cluster.
(64 Gb ram, 2x Xeon E5-2650, PERC H710P (really LSI MEGARAID), and 12x3 =

TB disks + 2SSD (not used as cachecade))

I was doing test on the raid card with kernel 3.4.38 to try to find what =

I can get of this beast with RAID5, when I noticed an unusual slow =

values on compilebench. The difference is very visible on the initial =

create tests (can detail more if needed).

I finally observed that ONLY 3.4 kernels exhibit that behaviour ; =

3.3.xxx and before are OK, 3.5.xxx and later are back to good values.

I bisected the problem to this commit

c999a223c2f0d31c64ef7379814cea1378b2b800 is the first bad commit
commit c999a223c2f0d31c64ef7379814cea1378b2b800
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Mar 22 05:15:07 2012 +0000

  xfs: introduce an allocation workqueue

I understand this regression is not a bug, and probably just a corner =

case of the new code, that was certainly corrected after during 3.5 =

development (didn't tried to bisect this one, maybe dave know what is =

the corrective patch ?)

The problem is that 3.4 is the last long-term kernel for the moment, and =

it's unfortunate it shows this regression.

Maybe a backport of the fix (if this backport is possible AND not very =

intrusive) could be a good idea ?

Cheers,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
