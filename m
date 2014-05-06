Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9ACD27F8D
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 06:00:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7FB4E8F8E73
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 04:00:10 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id t38y3HlzDN3cCW4G for
	<xfs@oss.sgi.com>; Tue, 06 May 2014 04:00:09 -0700 (PDT)
Date: Tue, 6 May 2014 13:00:08 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS tune to adaptec ASR71605
Message-ID: <20140506130008.13a1a7ee@harpe.intellique.com>
In-Reply-To: <alpine.LRH.2.02.1405061104580.24742@becks.mcs.st-and.ac.uk>
References: <alpine.LRH.2.02.1405061104580.24742@becks.mcs.st-and.ac.uk>
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
To: xfs@oss.sgi.com, Steve Brooks <steveb@mcs.st-and.ac.uk>

Le Tue, 6 May 2014 11:25:24 +0100 (BST)
Steve Brooks <steveb@mcs.st-and.ac.uk> =E9crivait:
> =

> My question is are the "mkfs.xfs" and the mount options I used
> sensible? The RAID is to be used to store data from "numerical
> simulations" that were run on a high performance cluster and is not
> mission critical in the sense that it can be regenerated if lost. Of
> course that would take the user/cluster some time.
> =


Looks fine to me. In my experience, using non default mkfs.xfs settings
makes very little to no difference at all, anyway. In case you're
interested, here are some benchmarks I've made on a similar setup with
bonnie++ (Raid controller 71604, 16x 3 To HGST, RAID-6 + spare (13 data
drives)).

1.96,1.96,storiq,1,1386247609,32160M,,,,886148,94,511728,76,,,1364991,99,69=
9.9,36,50,,,,,32874,93,
+++++,+++,37064,95,32901,96,+++++,+++,33100,93,,22110us,348ms,,62214us,141m=
s,11973us,111us,141us,131us,10us,134us
1.96,1.96,storiq,1,1386247609,32160M,,,,989408,95,568600,82,,,1623220,95,86=
9.3,17,50,,,,,34624,96,
+++++,+++,39390,94,34764,94,+++++,+++,37472,96,,22037us,213ms,,253ms,232ms,=
324us,109us,140us,319us,7us,108us
1.96,1.96,storiq,1,1386247609,32160M,,,,1023291,97,580413,81,,,1634417,98,7=
25.4,35,50,,,,,34913,96,
+++++,+++,41099,99,34578,97,+++++,+++,33708,94,,186us,216ms,,54367us,63127u=
s,1016us,104us,5508us,1029us,7us,138us
1.96,1.96,storiq,1,1386247609,32160M,,,,942138,97,578247,81,,,1643345,96,90=
9.4,19,50,,,,,33042,96,
+++++,+++,36391,95,33893,95,+++++,+++,34003,93,,1813us,222ms,,83887us,69003=
us,1032us,108us,144us,133us,7us,133us
1.96,1.96,storiq,1,1386247609,32160M,,,,939598,97,580680,82,,,1611637,97,72=
8.1,34,50,,,,,34819,96,
+++++,+++,39870,96,34614,97,+++++,+++,37632,96,,2053us,210ms,,71363us,84645=
us,990us,108us,139us,1030us,6us,1042us
1.96,1.96,storiq,1,1386247609,32160M,,,,972033,98,576180,81,,,1656062,98,72=
2.0,35,50,,,,,34923,97,
+++++,+++,39788,96,33449,95,+++++,+++,32783,95,,3608us,279ms,,82386us,46777=
us,1026us,105us,137us,1059us,17us,142us
1.96,1.96,storiq,1,1386247609,32160M,,,,937764,98,578995,83,,,1496290,96,73=
1.3,36,50,,,,,34852,97,
+++++,+++,39990,96,34625,97,+++++,+++,35387,96,,185us,206ms,,52160us,41925u=
s,344us,106us,136us,993us,5us,128us
1.96,1.96,storiq,1,1386247609,32160M,,,,1037074,97,580587,81,,,1681379,98,7=
19.0,36,50,,,,,34673,96,
+++++,+++,39961,96,34799,97,+++++,+++,37775,96,,175us,252ms,,29845us,78347u=
s,1035us,113us,137us,1011us,7us,3389us



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
