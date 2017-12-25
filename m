Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hacer.buildnet.ru ([91.214.224.3]:45574 "EHLO hacer.buildnet.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751958AbdLYLdu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Dec 2017 06:33:50 -0500
Received: from [185.29.130.2] (helo=[172.23.197.15])
        by hacer.buildnet.ru with esmtpa (Exim 4.72)
        (envelope-from <nnovikov@binmail.ru>)
        id 1eTR0u-0006b1-Cm
        for linux-xfs@vger.kernel.org; Mon, 25 Dec 2017 15:33:48 +0400
From: Nickolay Novikov <nnovikov@binmail.ru>
Subject: Metadata corruption
Message-ID: <99f455cd-4773-a051-98ff-2cd25fbb5fca@binmail.ru>
Date: Mon, 25 Dec 2017 14:33:43 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello!

I have some servers with XFS metadata corruption. XFS works on softRAID 
devices (/dev/mdXX, RAID1, HDD). I try to find same errors in google, 
but search yielded no results :(

What I can do for investigate this error?

Big thanks for any help.


Server info:

Debian GNU/Linux 8.9 (jessie)
ii  linux-image-4.9.0-0.bpo.4-amd64 4.9.51-1~bpo8+1                  
amd64        Linux 4.9 for 64-bit PCs

Kernel log:

Dec 25 11:39:15 srv701 kernel: [287080.542782] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.544365] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.545909] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.547406] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.548962] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.550554] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.552069] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.553832] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.555311] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.556899] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.558365] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.559817] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.561274] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.562707] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.564114] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.565664] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.567067] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.638691] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.639776] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.640775] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.641765] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.642707] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.643679] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.644649] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.645593] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.646561] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.647624] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.648688] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.649652] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.650629] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.651613] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.652883] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.653839] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.654859] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.655806] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.656762] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.657734] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.658730] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.659665] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.660624] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.661563] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.662556] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.663548] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.664581] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.665515] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.666587] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.667533] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.668547] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.669536] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.670490] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.671483] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.672518] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.673430] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.674464] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.675379] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.676351] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.677359] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.678348] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.679282] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.680216] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.681261] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.682227] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.683164] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.684081] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.685011] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.685945] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.686873] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.687792] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.688739] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.689673] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.690629] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.691716] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.692765] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.693884] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.694816] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.695848] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.696883] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.697826] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.698756] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.699703] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.700669] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.701594] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.702532] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.703485] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.704419] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.705374] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.706309] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.707243] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.708173] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.709117] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.710107] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.711034] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.711952] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.712892] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.713827] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.714767] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.715711] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.716657] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.717585] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.718525] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.719457] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.720405] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.721394] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.722326] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.723325] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.724244] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.725193] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.726143] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.727091] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.728018] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.728990] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.729920] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.730847] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.731768] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.732747] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.733748] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.734714] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.735647] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.736596] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.737501] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.738323] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.739332] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.740271] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.741250] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.742186] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.743150] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.744072] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.745095] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.746194] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.747155] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.748100] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.749079] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.750124] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.751043] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.751987] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.752938] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.753911] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.754940] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.755849] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.756796] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.757742] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.758669] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.759609] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.760549] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.761461] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.762423] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.763355] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.764303] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.765330] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.766273] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.767195] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.768145] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.769321] XFS (md25): Metadata 
corruption detected at xfs_inode_buf_verify+0x68/0xe0 [xfs], xfs_inode 
block 0x2ebd50
Dec 25 11:39:15 srv701 kernel: [287080.770254] XFS (md25): Unmount and 
run xfs_repair
Dec 25 11:39:15 srv701 kernel: [287080.771171] XFS (md25): First 64 
bytes of corrupted metadata buffer:
Dec 25 11:39:15 srv701 kernel: [287080.772102] ffff8bae1cf22000: 2a 2e 
19 d8 64 9f 0c 9c 01 b0 22 9e 8f ab dc 48  *...d....."....H
Dec 25 11:39:15 srv701 kernel: [287080.773052] ffff8bae1cf22010: 80 c9 
d1 7a 84 6e c4 e1 75 c0 d8 fb 44 98 aa 6a  ...z.n..u...D..j
Dec 25 11:39:15 srv701 kernel: [287080.774074] ffff8bae1cf22020: 49 da 
06 8a 74 56 ba 8a 7e ac 92 29 b8 6f 6e ce  I...tV..~..).on.
Dec 25 11:39:15 srv701 kernel: [287080.775027] ffff8bae1cf22030: a6 91 
43 61 a1 88 81 b0 00 e0 6d 9d a8 bd 02 e6  ..Ca......m.....
Dec 25 11:39:15 srv701 kernel: [287080.775947] XFS (md25): metadata I/O 
error: block 0x2ebd50 ("xfs_trans_read_buf_map") error 117 numblks 16
Dec 25 11:39:15 srv701 kernel: [287080.777306] XFS (md25): 
xfs_do_force_shutdown(0x1) called from line 315 of file 
/build/linux-HB2ADw/linux-4.9.51/fs/xfs/xfs_trans_buf.c.  Return address 
= 0xffffffffc05d37c5
Dec 25 11:39:15 srv701 kernel: [287080.936114] XFS (md25): I/O Error 
Detected. Shutting down filesystem
Dec 25 11:39:15 srv701 kernel: [287080.937405] XFS (md25): Please umount 
the filesystem and rectify the problem(s)
Dec 25 11:39:15 srv701 kernel: [287080.939087] XFS (md25): 
xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
Dec 25 11:39:15 srv701 kernel: [287080.940622] XFS (md25): 
xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.

