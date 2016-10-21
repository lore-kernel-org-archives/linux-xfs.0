Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-he1eur02hn0214.outbound.protection.outlook.com ([104.47.5.214]:22476
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932745AbcJUNbf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Oct 2016 09:31:35 -0400
From: =?iso-8859-2?Q?Libor_Klep=E1=E8?= <libor.klepac@bcom.cz>
Subject: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Date: Fri, 21 Oct 2016 12:46:21 +0000
Message-ID: <3764770.FZr9v1sA2Y@libor-nb>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <1730BC2316747B4FB4CBF3C81E386689@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Hello,
last week we have started to have problems with one virtual machine running=
 debian jessie, with kernel 3.16.7-ckt20-1+deb8u4.

There are some logs,=20


I don't have complete logs, but filesystem shutdown twice with

Oct 14 12:00:24 bajkonur2 kernel: [18872956.205316] XFS (dm-2): Metadata co=
rruption detected at xfs_attr3_leaf_write_verify+0xd5/0xe0 [xfs], block 0x1=
2f63f40
Oct 14 12:00:24 bajkonur2 kernel: [18872956.208382] XFS (dm-2): Unmount and=
 run xfs_repair
Oct 14 12:00:24 bajkonur2 kernel: [18872956.209385] XFS (dm-2): First 64 by=
tes of corrupted metadata buffer:
Oct 14 12:00:24 bajkonur2 kernel: [18872956.210187] ffff88011dadd000: 00 00=
 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Oct 14 12:00:24 bajkonur2 kernel: [18872956.211816] ffff88011dadd010: 10 00=
 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Oct 14 12:00:24 bajkonur2 kernel: [18872956.213390] ffff88011dadd020: 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 14 12:00:24 bajkonur2 kernel: [18872956.214983] ffff88011dadd030: 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Oct 14 12:00:24 bajkonur2 kernel: [18872956.216598] XFS (dm-2): xfs_do_forc=
e_shutdown(0x8) called from line 1330 of file /build/linux-U7H2aZ/linux-3.1=
6.7-ckt20/fs/xfs/xfs_buf.c.  Return address =3D 0xffffffffa03ef820
Oct 14 12:00:24 bajkonur2 kernel: [18872956.217448] XFS (dm-2): Corruption =
of in-memory data detected.  Shutting down filesystem
Oct 14 12:00:24 bajkonur2 kernel: [18872956.218338] XFS (dm-2): Please umou=
nt the filesystem and rectify the problem(s)=
