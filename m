Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Oct 2006 21:19:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9K4JGaG001666
	for <xfs@oss.sgi.com>; Thu, 19 Oct 2006 21:19:17 -0700
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93734D198E12
	for <xfs@oss.sgi.com>; Thu, 19 Oct 2006 21:18:33 -0700 (PDT)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162] (may be forged))
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id k9K4ITG6004035
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 13:18:29 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id k9K4IT920446 for xfs@oss.sgi.com; Fri, 20 Oct 2006 13:18:29 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id k9K4ITo19300 for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 13:18:29 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061020.132253.96801856 for <xfs@oss.sgi.com>
	; Fri, 20 Oct 2006 13:22:54 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id DFF96AE4B0
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 13:18:27 +0900 (JST)
Received: from TNESG9305.tnes.nec.co.jp (TNESG9305.bsd.tnes.nec.co.jp [10.1.104.199])
	by rifu.bsd.tnes.nec.co.jp (8.12.11/3.7W/BSD-TNES-MX01) with SMTP id k9K4IRaC009766
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 13:18:27 +0900
Message-Id: <200610200418.AA04613@TNESG9305.tnes.nec.co.jp>
Date: Fri, 20 Oct 2006 13:18:24 +0900
Subject: [PATCH] xfs_bmap -n fix
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

This patch fixes the issue that
"xfs_bmap -n [nnn]" doesn't work correctly.

Example：
# xfs_io -c "bmap -n 3" test/file2
test/file2:
        0: [0..4849151]: 41943136..46792287
        1: [4849152..51641343]: 46792768..93584959
        2: [51641344..68418047]: 93585472..110362175
# xfs_bmap -n 3 test/file2
test/file2:
        0: [0..4849151]: 41943136..46792287
        1: [4849152..51641343]: 46792768..93584959
        2: [51641344..98433535]: 93585472..140377663
        3: [98433536..131987455]: 140378176..173932095
        4: [131987456..145225727]: 173932104..187170375
        5: [145225728..192017919]: 187170880..233963071
        6: [192017920..209715199]: 233963584..251660863

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.11-orgn/io/xfs_bmap.sh 2006-06-26 14:01:15.000000000 +0900
+++ xfsprogs-2.8.11/io/xfs_bmap.sh      2006-10-20 12:22:19.771009697 +0900
@@ -14,7 +14,7 @@ do
        a)      OPTS=$OPTS" -a";;
        d)      OPTS=$OPTS" -d";;
        l)      OPTS=$OPTS" -l";;
-       n)      OPTS=$OPTS" '-n "$OPTARG"'";;
+       n)      OPTS=$OPTS" -n "$OPTARG"";;
        p)      OPTS=$OPTS" -p";;
        v)      OPTS=$OPTS" -v";;
        V)      VERSION=true;;
