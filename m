Return-Path: <SRS0=FhJw=5Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BD3C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Mar 2020 21:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC80C2080C
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Mar 2020 21:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="sY8uF5UO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbgCaV52 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Mar 2020 17:57:28 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35396 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgCaV52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Mar 2020 17:57:28 -0400
Received: by mail-qt1-f196.google.com with SMTP id e14so19905674qts.2
        for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2020 14:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=o61s5YBUBR1VAqgkJS0tttgqNGSjLGtkCgl58y03WGw=;
        b=sY8uF5UOZrD6JLMEM+tHNKkIrgRp5xYex8GuuQNDD2F/tMswTzTafvPFVFQFjwZPfd
         5mQxAZawgAn1wVRz+K++30SIYeWyffWHp4Olwij5R1QqGWJTvY7E/DfcJ2w4+gpYxvBu
         79NgBJ6pVIfJuVutuNFNXC7Me1vdKvJEteGGhJcdkFfk2ZKf1OAlY7yzhOKcjluaDRJW
         WaZL2+8EylN43ewvLmIYI7TFyhH/70Vli+YYCPzGh/RLquno29dsgofzq3KxRH5qnd9k
         yYPNr6qJKTuKbcfB6zGhXT/r7BXOnlMNSJD4AmBx0Ju9X9/9pbCxGDsQoLyYqWfNbVOp
         ROiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=o61s5YBUBR1VAqgkJS0tttgqNGSjLGtkCgl58y03WGw=;
        b=mX20Yq0yevRjEWscXKXW3Fg5zhyzMTapCXchcLWuVecCk/NSRVQpF1pHkb6W2fLPog
         IvF7CUmvFQxUc5NbaXFssAD3eEBVU+0TqN1DLKI+5yKTAIyz3bUiZI2hwpa6bSSxA7h/
         MtGPL92czrU8wPMufaQZ16bvBHpXiZuNisnwhBxk8fs/xrMRNiQ6Y3UNykFd5NQw7nDS
         jWMc1yGtbGX5fCkrQfuShCzwrJJ34NjibN1tOMKDlXYLhCHgexg9t9wQQWZAoVsaPinW
         64KVkKprywGiWwvJ6UlXTY8xyohOG5aFdKHCCoqJ7N8MVVseXXmpPiGf1ft6Y+8frhNU
         kDhg==
X-Gm-Message-State: ANhLgQ1lUULjR8RJ+xwd8isyIr3frhbeuq8Bdgu3mJgGyYVwMl9UTvNe
        Jx30GmyzRCtQrPyB202mHKaeHA==
X-Google-Smtp-Source: ADFU+vu41rM0BL7YZv3QyOZYxK3BZv1TiNputrpS7zQVILZhkBDhSHexhj1yScVEENhDSoHijdG3Tg==
X-Received: by 2002:ac8:470c:: with SMTP id f12mr7272809qtp.135.1585691846462;
        Tue, 31 Mar 2020 14:57:26 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id m92sm109862qtd.94.2020.03.31.14.57.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2020 14:57:25 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: linux-next: xfs metadata corruption since 30 March
Message-Id: <990EDC4E-1A4E-4AC3-84D9-078ACF5EB9CC@lca.pw>
Date:   Tue, 31 Mar 2020 17:57:24 -0400
Cc:     linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ever since two days ago, linux-next starts to trigger xfs metadata =
corruption
during compilation workloads on both powerpc and arm64,

I suspect it could be one of those commits,

https://lore.kernel.org/linux-xfs/20200328182533.GM29339@magnolia/

Especially, those commits that would mark corruption more aggressively?

      [8d57c21600a5] xfs: add a function to deal with corrupt buffers =
post-verifiers
      [e83cf875d67a] xfs: xfs_buf_corruption_error should take =
__this_address
      [ce99494c9699] xfs: fix buffer corruption reporting when =
xfs_dir3_free_header_check fails
      [1cb5deb5bc09] xfs: don't ever return a stale pointer from =
__xfs_dir3_free_read
      [6fb5aac73310] xfs: check owner of dir3 free blocks
      [a10c21ed5d52] xfs: check owner of dir3 data blocks
      [1b2c1a63b678] xfs: check owner of dir3 blocks
      [2e107cf869ee] xfs: mark dir corrupt when lookup-by-hash fails
      [806d3909a57e] xfs: mark extended attr corrupt when lookup-by-hash =
fails


[29331.182313][  T665] XFS (dm-2): Metadata corruption detected at =
xfs_inode_buf_verify+0x2b8/0x350 [xfs], xfs_inode block 0xa9b97900 =
xfs_inode_buf_verify
xfs_inode_buf_verify at fs/xfs/libxfs/xfs_inode_buf.c:101
[29331.182373][  T665] XFS (dm-2): Unmount and run xfs_repair
[29331.182386][  T665] XFS (dm-2): First 128 bytes of corrupted metadata =
buffer:
[29331.182402][  T665] 00000000: 2f 2a 20 53 50 44 58 2d 4c 69 63 65 6e =
73 65 2d  /* SPDX-License-
[29331.182426][  T665] 00000010: 49 64 65 6e 74 69 66 69 65 72 3a 20 47 =
50 4c 2d  Identifier: GPL-
[29331.182442][  T665] 00000020: 32 2e 30 2d 6f 72 2d 6c 61 74 65 72 20 =
2a 2f 0a  2.0-or-later */.
[29331.182467][  T665] 00000030: 2f 2a 0a 20 2a 20 44 65 66 69 6e 69 74 =
69 6f 6e  /*. * Definition
[29331.182492][  T665] 00000040: 73 20 61 6e 64 20 70 6c 61 74 66 6f 72 =
6d 20 64  s and platform d
[29331.182517][  T665] 00000050: 61 74 61 20 66 6f 72 20 41 6e 61 6c 6f =
67 20 44  ata for Analog D
[29331.182541][  T665] 00000060: 65 76 69 63 65 73 0a 20 2a 20 41 44 50 =
35 35 32  evices. * ADP552
[29331.182566][  T665] 00000070: 30 2f 41 44 50 35 35 30 31 20 4d 46 44 =
20 50 4d  0/ADP5501 MFD PM
[29331.182700][ T7490] XFS (dm-2): metadata I/O error in =
"xfs_imap_to_bp+0x88/0x130 [xfs]" at daddr 0xa9b97900 len 32 error 117
xfs_trans_read_buf at fs/xfs/xfs_trans.h:209
(inlined by) xfs_imap_to_bp at fs/xfs/libxfs/xfs_inode_buf.c:171
[29331.182812][ T7490] XFS (dm-2): xfs_imap_to_bp: xfs_trans_read_buf() =
returned error -117.
[29331.345347][ T7490] XFS (dm-2): xfs_do_force_shutdown(0x8) called =
from line 3754 of file fs/xfs/xfs_inode.c. Return address =3D =
0000000058be213e
[29331.345378][ T7490] XFS (dm-2): Corruption of in-memory data =
detected.  Shutting down filesystem
[29331.345402][ T7490] XFS (dm-2): Please unmount the filesystem and =
rectify the problem(s)
[29331.346474][  T498] dm-2: writeback error on inode 934606, offset 0, =
sector 961072
[29331.346502][  T498] dm-2: writeback error on inode 934607, offset 0, =
sector 961080
[29331.346624][  T498] dm-2: writeback error on inode 934608, offset 0, =
sector 961088
[29331.346683][  T498] dm-2: writeback error on inode 1074331758, offset =
0, sector 948449704
[29331.347306][  T498] dm-2: writeback error on inode 1074331762, offset =
0, sector 948558816
[29331.349165][  T498] dm-2: writeback error on inode 1074331759, offset =
0, sector 948560984
[29331.349227][  T498] dm-2: writeback error on inode 1074331760, offset =
0, sector 948562944
[29331.349303][  T498] dm-2: writeback error on inode 1074331761, offset =
0, sector 948568000

[ 7762.204313][T124538] XFS (dm-2): Metadata corruption detected at =
xfs_inode_buf_verify+0x2b8/0x350 [xfs], xfs_inode block 0x712398e0 =
xfs_inode_buf_verify
[ 7762.204599][T124538] XFS (dm-2): Unmount and run xfs_repair
[ 7762.204625][T124538] XFS (dm-2): First 128 bytes of corrupted =
metadata buffer:
[ 7762.204654][T124538] 00000000: 77 65 72 70 63 2f 69 6e 63 6c 75 64 65 =
2f 67 65  werpc/include/ge
[ 7762.204672][T124538] 00000010: 6e 65 72 61 74 65 64 2f 75 61 70 69 2f =
61 73 6d  nerated/uapi/asm
[ 7762.204699][T124538] 00000020: 2f 72 65 73 6f 75 72 63 65 2e 68 20 5c =
0a 20 69  /resource.h \. i
[ 7762.204727][T124538] 00000030: 6e 63 6c 75 64 65 2f 61 73 6d 2d 67 65 =
6e 65 72  nclude/asm-gener
[ 7762.204745][T124538] 00000040: 69 63 2f 72 65 73 6f 75 72 63 65 2e 68 =
20 69 6e  ic/resource.h in
[ 7762.204783][T124538] 00000050: 63 6c 75 64 65 2f 75 61 70 69 2f 61 73 =
6d 2d 67  clude/uapi/asm-g
[ 7762.204820][T124538] 00000060: 65 6e 65 72 69 63 2f 72 65 73 6f 75 72 =
63 65 2e  eneric/resource.
[ 7762.204858][T124538] 00000070: 68 20 5c 0a 20 69 6e 63 6c 75 64 65 2f =
6c 69 6e  h \. include/lin
[ 7762.205068][ T7510] XFS (dm-2): metadata I/O error in =
"xfs_imap_to_bp+0x88/0x130 [xfs]" at daddr 0x712398e0 len 32 error 117
[ 7762.205466][ T7510] XFS (dm-2): xfs_imap_to_bp: xfs_trans_read_buf() =
returned error -117.
[ 7762.219267][ T7510] XFS (dm-2): xfs_do_force_shutdown(0x8) called =
from line 3754 of file fs/xfs/xfs_inode.c. Return address =3D =
000000006bce0de3
[ 7762.219291][ T7510] XFS (dm-2): Corruption of in-memory data =
detected.  Shutting down filesystem
[ 7762.219306][ T7510] XFS (dm-2): Please unmount the filesystem and =
rectify the problem(s)


[ 1032.162278][ T1515] XFS (dm-2): Metadata corruption detected at =
xfs_inode_buf_verify+0x244/0x2bc [xfs], xfs_inode block 0xa2b75dc0 =
xfs_inode_buf_verify
[ 1032.176156][ T1515] XFS (dm-2): Unmount and run xfs_repair
[ 1032.181835][ T1515] XFS (dm-2): First 128 bytes of corrupted metadata =
buffer:
[ 1032.189140][ T1515] 00000000: 6e 29 20 22 22 20 76 61 6c 75 65 20 22 =
22 20 73  n) "" value "" s
[ 1032.197988][ T1515] 00000010: 75 62 73 74 72 28 6c 69 6e 65 2c 20 6c =
65 6e 20  ubstr(line, len=20
[ 1032.206723][ T1515] 00000020: 2b 20 6b 65 79 6c 65 6e 20 2b 20 33 29 =
0a 20 20  + keylen + 3). =20
[ 1032.215675][ T1515] 00000030: 20 20 20 20 6c 65 6e 20 2b 3d 20 6c 65 =
6e 67 74      len +=3D lengt
[ 1032.224537][ T1515] 00000040: 68 28 76 61 6c 75 65 29 20 2b 20 6c 65 =
6e 67 74  h(value) + lengt
[ 1032.233388][ T1515] 00000050: 68 28 66 69 65 6c 64 5b 2b 2b 69 5d 29 =
0a 20 20  h(field[++i]). =20
[ 1032.242234][ T1515] 00000060: 20 20 20 20 73 75 62 73 74 65 64 20 3d =
20 31 0a      substed =3D 1.
[ 1032.251077][ T1515] 00000070: 20 20 20 20 7d 20 65 6c 73 65 0a 20 20 =
20 20 20      } else.    =20
[ 1032.260792][ T4119] XFS (dm-2): metadata I/O error in =
"xfs_imap_to_bp+0xd8/0x18c [xfs]" at daddr 0xa2b75dc0 len 32 error 117
[ 1032.273096][ T4119] XFS (dm-2): xfs_imap_to_bp: xfs_trans_read_buf() =
returned error -117.
[ 1032.283283][ T4119] XFS (dm-2): xfs_do_force_shutdown(0x8) called =
from line 3754 of file fs/xfs/xfs_inode.c. Return address =3D =
00000000d99a2721
[ 1032.296214][ T4119] XFS (dm-2): Corruption of in-memory data =
detected.  Shutting down filesystem
[ 1032.305158][ T4119] XFS (dm-2): Please unmount the filesystem and =
rectify the problem(s) =20=
