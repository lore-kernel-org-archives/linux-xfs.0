Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9PJCNf5259038 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 14:12:23 -0500
Received: from mx2.mail.elte.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD22C1234D2
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 12:13:39 -0700 (PDT)
Received: from mx2.mail.elte.hu (mx2.mail.elte.hu [157.181.151.9]) by
	cuda.sgi.com with ESMTP id DJEFPldkCO0ygGUh for
	<xfs@oss.sgi.com>; Mon, 25 Oct 2010 12:13:39 -0700 (PDT)
Received: from hermes.teteny.elte.hu ([157.181.96.2] helo=hermes.teteny.bme.hu)
	by mx2.mail.elte.hu with esmtp (Exim) id 1PASUA-0005HU-Gq
	from <kirk@bteam.hu>
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 21:13:38 +0200
Received: from localhost (localhost [127.0.0.1])
	by hermes.teteny.bme.hu (Postfix) with ESMTP id E236A1E0357B6
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 21:13:28 +0200 (CEST)
Received: from hermes.teteny.bme.hu ([127.0.0.1])
	by localhost (hermes.teteny.bme.hu [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id c3072w2VORLg for <xfs@oss.sgi.com>;
	Mon, 25 Oct 2010 21:13:28 +0200 (CEST)
Received: from [152.66.235.7] (relax.teteny.bme.hu [152.66.235.7])
	by hermes.teteny.bme.hu (Postfix) with ESMTP id BCB371E0357B5
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 21:13:22 +0200 (CEST)
Message-ID: <4CC5D6D2.3080606@bteam.hu>
Date: Mon, 25 Oct 2010 21:13:22 +0200
From: Nagy Zoltan <kirk@bteam.hu>
MIME-Version: 1.0
Subject: md/luks/md/xfs
Content-Type: multipart/mixed; boundary="------------000802040903000809020907"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------000802040903000809020907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

hi

running the given makefile with 'test', a set of md and luks devices are created,
when i try to mount md200 the system freezes.

the system is running 2.6.35.7 (vanilla).

someone could confirm the test result with some other system ?
 -- be very careful, check that you don't have: /dev/md{10,14,18,112,200} and /dev/mapper/T-{10,14,18,112,200}
 -- you don't use any of /dev/ram{0..15}

when i use ext3 or vfat instead of xfs it works fine

best regards,
-- 
Nagy Zoltan (kirk) <kirk@bteam.hu>

--------------000802040903000809020907
Content-Type: text/plain;
 name="rdt.makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rdt.makefile"


.SECONDARY:

SHELL=/bin/bash

any:
	echo	"*** be careful!"

/dev/md1%:
	mdadm -Cv /dev/md1$* -l5 -n4 /dev/ram{$(shell echo $$[ $* + 0 ])..$(shell echo $$[ $* + 3 ])}
	# $(shell echo \$[ $* + 3 ]) }
	#mdadm -Cv /dev/md21 -l5 -n4 /dev/ram{4..7}
	#mdadm -Cv /dev/md22 -l5 -n4 /dev/ram{8..11}
	#mdadm -Cv /dev/md23 -l5 -n4 /dev/ram{12..15}

#cat /proc/mdstat

/dev/mapper/T-%:	/dev/md%
	cryptsetup luksFormat -v -q -d /etc/services /dev/md$*
	cryptsetup luksOpen -v -d /etc/services /dev/md$* T-$*

/dev/md200:	/dev/mapper/T-18 /dev/mapper/T-10 /dev/mapper/T-14 /dev/mapper/T-112
	
	mdadm -Cv $@ -l5 -n4 $^
	mkfs.xfs $@
	#echo	$^

test:	/dev/md200

--------------000802040903000809020907
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------000802040903000809020907--
