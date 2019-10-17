Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74486ECE599
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 00:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AB1E21925
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 00:24:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Uk5lYJ0c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388951AbfJQAYo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 20:24:44 -0400
Received: from mout.gmx.net ([212.227.15.15]:52565 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388756AbfJQAYo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Oct 2019 20:24:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571271883;
        bh=7zBmOlM2AKxxUbW0XCQwn+hTP7ckApJ784BkSm9elCo=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=Uk5lYJ0chmgw5PlKZwp7vNfTP0BIphzesrteZCurIiZ2km8yGUb7YEl5nHb3I8Z3v
         z84alCxz/NNESywM+t582xwzjktXGkKjH3bRTGZKoK7yO5OY9jaLMnRw2wLIs5I3Fl
         vt7jmNj4tnFaqsrQvq0DGZxKMJSwStmGh1paXIzY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [2.50.152.200] ([2.50.152.200]) by web-mail.gmx.net
 (3c-app-gmx-bs59.server.lan [172.19.170.143]) (via HTTP); Thu, 17 Oct 2019
 02:24:43 +0200
MIME-Version: 1.0
Message-ID: <trinity-b2a494bf-39e0-40f4-ab08-641fbb2757c3-1571271883137@3c-app-gmx-bs59>
From:   =?UTF-8?Q?=22Marc_Sch=C3=B6nefeld=22?= <marc.schoenefeld@gmx.org>
To:     linux-xfs@vger.kernel.org
Subject: Fragmentation metadata checks incomplete in process_bmbt_reclist()
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 17 Oct 2019 02:24:43 +0200
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
X-Provags-ID: V03:K1:5HoWVm4uQUPex4BUG91PvV5hAExgPc6OleQGkP7vYNKupnt6pN8a89jLp7a5ndUYRbSpQ
 pixmr79eUPXIsTzfhYysSt6LdSB/xn+WZ1T0uMU1ijVD6YTgVBsIXoOEcnxExl94ZX3psSYIqR9n
 xfjhsJBahkTO8p77VmWFYVqtf7aBmt2a8rOOC3UAqyHWtYuqFDA7dSM6Te6eRcXTPkUi4NffjLH3
 RvZRtApfXkqPioxTvJCGECAWH9xZGVlkTlQQzrZW4sGeRHAzSol9+ti4OtbWYncXVG5jN13CR2/2
 eI=
X-UI-Out-Filterresults: notjunk:1;V03:K0:5zh1nYLt0CU=:zE5j+19gahdMlmJuiFygMR
 kfoE29k3SS6t5tDikovUgSwMPhrMSboy9USKS8Xs8wf82IDpa98bgf4At7t7SbSp+A9kCMH68
 pThd52N2liFLKpSxIiviap5Nh8MWJRdFWTz/QFqqCpK037xLjIgBPe7tk0J08DdGhnMFyHrvu
 X/kyRYJwv7NOi4tF7tLwsHdvZWrOqz6dCy20IQMYyVD9k112H/kqjF+Af+haUBXW/B3n0+nJB
 HPTDkas8OCm34pU9y0swRoLi9r0JMGpbhdNa9nelehBHUZo1/l/wrbw1p6rW4lWwW02H8IDDF
 zxzyOc1G8BIAPJLz2G34bbj14CWMHN2qQvm7ohwQ9M5zr0UIDf09fNcUZazTDMxS1D/t8ndZe
 d3WylpLmkH4YIM7eNXp8TnDI1k4gy4gbjMCepbHOch3MThu5WXdNMlGVO4C89deo/2k9dsul0
 NKYYoGAb85P4cqA8mWsCI+m+xpMtyAWTpBRLN98yi8ExPtcftYdeyhKHYsGZYSTX/DwjpqeRT
 Hj6vZeLlhSANxml1OdqRc8aNZUpFeVljSipeptHLjtMas+MnML6W5QOy0Bz3p8dz0UIEgQy2V
 p5Ox70GUKKa95Yftf2u1msAKblnkCuuSEPnup3hRrt+rkvTK8GrpgH3OKUSSic7fl7B10FZaG
 FfmQofan9iI39JbKABEnEM4Fhi61m8t+a37F2fWc5Om0qmaNjc2YqdD4ySLX6eDOIZXs=
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,=C2=A0
=C2=A0
there seems to be a problem with correctly rejecting invalid metadata when=
 using the frag command=2E This was tested with xfsprogs-dev, the 5=2E2=2E1=
 tarball, and 4=2E190 as in CentOS8)=2E=C2=A0=C2=A0
=C2=A0
xfsprogs-dev/db/xfs_db -c frag =2E=2E/xfsprogs_xfs_db_c_frag_convert_exten=
t_invalid_read=2Exfsfile
=C2=A0
Metadata CRC error detected at 0x42c836, xfs_agf block 0x1/0x200
xfs_db: cannot init perag data (74)=2E Continuing anyway=2E
Metadata CRC error detected at 0x457316, xfs_agi block 0x2/0x200
Metadata CRC error detected at 0x45e2ed, xfs_inobt block 0x18/0x1000
Metadata corruption detected at 0x429885, xfs_inode block 0x1b00/0x8000
=C2=A0
Program received signal SIGSEGV, Segmentation fault=2E
convert_extent (rp=3Drp@entry=3D0x1537000, op=3Dop@entry=3D0x7ffd95f7e020,=
 sp=3Dsp@entry=3D0x7ffd95f7e028, cp=3Dcp@entry=3D0x7ffd95f7e018,=C2=A0
=C2=A0 =C2=A0 fp=3Dfp@entry=3D0x7ffd95f7e014) at =2E=2E/include/xfs_arch=
=2Eh:249
 249 return (uint64_t)get_unaligned_be32(p) << 32 |
=C2=A0250 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0get_unaligned_be32(p + 4);
=C2=A0251 }

(gdb) bt
#0=C2=A0 convert_extent (rp=3Drp@entry=3D0x1537000, op=3Dop@entry=3D0x7ffd=
95f7e020, sp=3Dsp@entry=3D0x7ffd95f7e028,=C2=A0
=C2=A0 =C2=A0 cp=3Dcp@entry=3D0x7ffd95f7e018, fp=3Dfp@entry=3D0x7ffd95f7e0=
14) at =2E=2E/include/xfs_arch=2Eh:249
#1=C2=A0 0x0000000000416211 in process_bmbt_reclist (rp=3D0x1537000, numre=
cs=3D<optimized out>, extmapp=3Dextmapp@entry=3D0x7ffd95f7e068)
=C2=A0 =C2=A0 at frag=2Ec:229
#2=C2=A0 0x0000000000416685 in process_btinode (whichfork=3D<optimized out=
>, extmapp=3D<optimized out>, dip=3D<optimized out>)
=C2=A0 =C2=A0 at =2E=2E/include/xfs_arch=2Eh:145
#3=C2=A0 process_fork (dip=3Ddip@entry=3D0x150e800, whichfork=3Dwhichfork@=
entry=3D0) at frag=2Ec:287
#4=C2=A0 0x0000000000416a81 in process_inode (agf=3D0x1506a00, dip=3D0x150=
e800, agino=3D6913) at frag=2Ec:337
#5=C2=A0 scanfunc_ino (block=3D0x1508200, level=3Dlevel@entry=3D0, agf=3Da=
gf@entry=3D0x1506a00) at frag=2Ec:513
#6=C2=A0 0x0000000000416cc5 in scan_sbtree (agf=3Dagf@entry=3D0x1506a00, r=
oot=3D3, nlevels=3D1, btype=3DTYP_INOBT,=C2=A0
=C2=A0 =C2=A0 func=3D0x416750 <scanfunc_ino>) at frag=2Ec:416
#7=C2=A0 0x0000000000416f2d in scan_ag (agno=3D0) at =2E=2E/include/xfs_ar=
ch=2Eh:158
#8=C2=A0 frag_f (argc=3D<optimized out>, argv=3D<optimized out>) at frag=
=2Ec:155
#9=C2=A0 0x00000000004029e0 in main (argc=3D<optimized out>, argv=3D<optim=
ized out>) at init=2Ec:195
(gdb) disass $pc,$pc+10
Dump of assembler code from 0x405210 to 0x40521a:
=3D> 0x0000000000405210 <convert_extent+0>: mov=C2=A0 =C2=A0 rax,QWORD PTR=
 [rdi]
=C2=A0=C2=A0 0x0000000000405213 <convert_extent+3>: mov=C2=A0 =C2=A0 rdi,Q=
WORD PTR [rdi+0x8]
=C2=A0=C2=A0 0x0000000000405217 <convert_extent+7>: bswap=C2=A0 rax
End of assembler dump=2E
(gdb) info registers rdi
rdi=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x1537000 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 22245376
(gdb) x/4 $rdi
0x1537000: Cannot access memory at address 0x1537000
=C2=A0
If required I can provide an image that triggers the issue via pm=2E=C2=A0
=C2=A0
Regards
Marc Schoenefeld

