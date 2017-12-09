Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:40738 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbdLIVEa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Dec 2017 16:04:30 -0500
Received: by mail-qt0-f180.google.com with SMTP id u42so30778408qte.7
        for <linux-xfs@vger.kernel.org>; Sat, 09 Dec 2017 13:04:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADb94503vRdng4T_sTGimZPWhmZE4D9BAC0_OKCGDBAc06PMVw@mail.gmail.com>
References: <CADb94503vRdng4T_sTGimZPWhmZE4D9BAC0_OKCGDBAc06PMVw@mail.gmail.com>
From: Alex Gorbachev <ag@iss-integration.com>
Date: Sat, 9 Dec 2017 16:04:29 -0500
Message-ID: <CADb9450KPb6h-eU8yQavdmAfP-9vQKbur2goTkdAqGT9td+MVw@mail.gmail.com>
Subject: Re: XFS on RBD crash
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Sat, Dec 9, 2017 at 4:01 PM, Alex Gorbachev <ag@iss-integration.com> wrote:
> I have experienced a crash today (in a sense of filesystem going
> offline) of a 25TB XFS filesystem.  Tried searching the list and
> google, and not much specific info I can use, so very much appreciate
> any insight:
>
> System: Ubuntu 16.04, kernel 4.10.17-041017-generic
>
> Mount info:
>
> /dev/rbd0 on /srv/exports/sclun63 type xfs
> (rw,relatime,attr2,inode64,logbsize=256k,sunit=8192,swidth=8192,noquota)
>
> Failure trace:
>
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.769776] XFS (rbd1):
> Internal error XFS_WANT_CORRUPTED_GOTO at line 3505 of file
> /home/kernel/COD/linux/fs/xfs/libxfs/xfs_btree.c.  Caller
> xfs_free_ag_extent+0x352/0x740 [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.769890] CPU: 20 PID:
> 724783 Comm: kworker/20:4 Tainted: G           OE
> 4.10.17-041017-generic #201705201051
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.769963] Hardware name:
> Dell Inc. Precision Rack 7910/01J90F, BIOS 1.1.4 11/04/2014
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770058] Workqueue:
> xfs-conv/rbd1 xfs_end_io [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770098] Call Trace:
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770136]  dump_stack+0x63/0x81
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770198]
> xfs_error_report+0x3c/0x40 [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770257]  ?
> xfs_free_ag_extent+0x352/0x740 [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770317]
> xfs_btree_insert+0x16d/0x1c0 [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770375]
> xfs_free_ag_extent+0x352/0x740 [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770433]
> xfs_free_extent+0xa8/0x140 [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770501]
> xfs_trans_free_extent+0x43/0x110 [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770568]
> xfs_extent_free_finish_item+0x26/0x40 [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770630]
> xfs_defer_finish+0x151/0x430 [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770694]
> xfs_iomap_write_unwritten+0xd3/0x2e0 [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770737]  ?
> propagate_entity_cfs_rq.isra.66+0x271/0xa30
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770802]
> xfs_end_io+0xa0/0xb0 [xfs]
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770840]
> process_one_work+0x1fc/0x4b0
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770877]  worker_thread+0x4b/0x500
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770914]  kthread+0x109/0x140
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770949]  ?
> process_one_work+0x4b0/0x4b0
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.770987]  ?
> kthread_create_on_node+0x60/0x60
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.771028]  ret_from_fork+0x2c/0x40
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.771093] XFS (rbd1):
> xfs_do_force_shutdown(0x8) called from line 236 of file
> /home/kernel/COD/linux/fs/xfs/libxfs/xfs_defer.c.  Return address =
> 0xffffffffc0f0d366
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.772151] XFS (rbd1):
> Corruption of in-memory data detected.  Shutting down filesystem
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.772219] XFS (rbd1):
> Please umount the filesystem and rectify the problem(s)
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.772292] Buffer I/O
> error on dev rbd1, logical block 5078005778, lost async page write
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.772362] Buffer I/O
> error on dev rbd1, logical block 5078005779, lost async page write
> Dec  9 14:05:45 roc01r-scd224 kernel: [3455811.777755] Buffer I/O
> error on dev rbd1, logical block 5078005780, lost async page write
>
> xfs_repair (had to do -L):
>
> root@roc01r-scd224:~# xfs_repair -L /dev/rbd0
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
> ALERT: The filesystem has valuable metadata changes in a log which is being
> destroyed because the -L option was used.
>         - scan filesystem freespace and inode maps...
> freeblk count 3 != flcount 4 in ag 47
> freeblk count 3 != flcount 4 in ag 45
> freeblk count 3 != flcount 4 in ag 46
> freeblk count 3 != flcount 4 in ag 53
> freeblk count 3 != flcount 4 in ag 49
> freeblk count 3 != flcount 4 in ag 52
> freeblk count 3 != flcount 4 in ag 56
> freeblk count 3 != flcount 4 in ag 51
> freeblk count 3 != flcount 4 in ag 48
> freeblk count 3 != flcount 4 in ag 57
> freeblk count 3 != flcount 4 in ag 54
> freeblk count 3 != flcount 4 in ag 50
> freeblk count 3 != flcount 4 in ag 58
> freeblk count 3 != flcount 4 in ag 55
> freeblk count 3 != flcount 4 in ag 59
> freeblk count 3 != flcount 4 in ag 61
> freeblk count 3 != flcount 4 in ag 62
> freeblk count 3 != flcount 4 in ag 63
> freeblk count 3 != flcount 4 in ag 60
> freeblk count 3 != flcount 4 in ag 70
> freeblk count 3 != flcount 4 in ag 65
> freeblk count 3 != flcount 4 in ag 66
> freeblk count 3 != flcount 4 in ag 71
> freeblk count 3 != flcount 4 in ag 68
> freeblk count 3 != flcount 4 in ag 69
> freeblk count 3 != flcount 4 in ag 64
> freeblk count 3 != flcount 4 in ag 73
> freeblk count 3 != flcount 4 in ag 67
> freeblk count 3 != flcount 4 in ag 78
> freeblk count 3 != flcount 4 in ag 76
> freeblk count 3 != flcount 4 in ag 72
> freeblk count 3 != flcount 4 in ag 80
> freeblk count 3 != flcount 4 in ag 83
> freeblk count 3 != flcount 4 in ag 84
> freeblk count 3 != flcount 4 in ag 75
> freeblk count 3 != flcount 4 in ag 74
> freeblk count 3 != flcount 4 in ag 85
> freeblk count 3 != flcount 4 in ag 79
> freeblk count 3 != flcount 4 in ag 81
> freeblk count 3 != flcount 4 in ag 77
> freeblk count 3 != flcount 4 in ag 82
> freeblk count 3 != flcount 4 in ag 88
> freeblk count 3 != flcount 4 in ag 91
> freeblk count 3 != flcount 4 in ag 86
> freeblk count 3 != flcount 4 in ag 87
> freeblk count 3 != flcount 4 in ag 93
> freeblk count 3 != flcount 4 in ag 92
> freeblk count 3 != flcount 4 in ag 90
> freeblk count 3 != flcount 4 in ag 94
> freeblk count 3 != flcount 4 in ag 89
> freeblk count 3 != flcount 4 in ag 97
> freeblk count 3 != flcount 4 in ag 95
> freeblk count 3 != flcount 4 in ag 96
> freeblk count 3 != flcount 4 in ag 98
> freeblk count 3 != flcount 4 in ag 100
> freeblk count 3 != flcount 4 in ag 99
> freeblk count 3 != flcount 4 in ag 103
> freeblk count 3 != flcount 4 in ag 101
> freeblk count 3 != flcount 4 in ag 104
> freeblk count 3 != flcount 4 in ag 102
> freeblk count 3 != flcount 4 in ag 105
> freeblk count 3 != flcount 4 in ag 110
> freeblk count 3 != flcount 4 in ag 106
> freeblk count 3 != flcount 4 in ag 113
> freeblk count 3 != flcount 4 in ag 115
> freeblk count 3 != flcount 4 in ag 111
> freeblk count 3 != flcount 4 in ag 109
> freeblk count 3 != flcount 4 in ag 107
> freeblk count 3 != flcount 4 in ag 116
> freeblk count 3 != flcount 4 in ag 114
> freeblk count 3 != flcount 4 in ag 108
> freeblk count 3 != flcount 4 in ag 117
> freeblk count 3 != flcount 4 in ag 124
> freeblk count 3 != flcount 4 in ag 119
> freeblk count 3 != flcount 4 in ag 118
> freeblk count 3 != flcount 4 in ag 120
> freeblk count 3 != flcount 4 in ag 121
> freeblk count 3 != flcount 4 in ag 122
> freeblk count 3 != flcount 4 in ag 126
> freeblk count 3 != flcount 4 in ag 125
> freeblk count 3 != flcount 4 in ag 127
> freeblk count 3 != flcount 4 in ag 131
> freeblk count 3 != flcount 4 in ag 123
> freeblk count 3 != flcount 4 in ag 130
> freeblk count 3 != flcount 4 in ag 133
> freeblk count 3 != flcount 4 in ag 128
> freeblk count 3 != flcount 4 in ag 137
> freeblk count 3 != flcount 4 in ag 136
> freeblk count 3 != flcount 4 in ag 138
> freeblk count 3 != flcount 4 in ag 135
> freeblk count 3 != flcount 4 in ag 132
> freeblk count 3 != flcount 4 in ag 139
> freeblk count 3 != flcount 4 in ag 134
> freeblk count 3 != flcount 4 in ag 129
> freeblk count 3 != flcount 4 in ag 145
> freeblk count 3 != flcount 4 in ag 147
> freeblk count 3 != flcount 4 in ag 144
> freeblk count 3 != flcount 4 in ag 140
> freeblk count 3 != flcount 4 in ag 149
> freeblk count 3 != flcount 4 in ag 143
> freeblk count 3 != flcount 4 in ag 142
> freeblk count 3 != flcount 4 in ag 141
> freeblk count 3 != flcount 4 in ag 152
> freeblk count 3 != flcount 4 in ag 148
> freeblk count 3 != flcount 4 in ag 151
> freeblk count 3 != flcount 4 in ag 146
> freeblk count 3 != flcount 4 in ag 154
> freeblk count 3 != flcount 4 in ag 150
> freeblk count 3 != flcount 4 in ag 155
> freeblk count 3 != flcount 4 in ag 157
> freeblk count 3 != flcount 4 in ag 156
> freeblk count 3 != flcount 4 in ag 160
> freeblk count 3 != flcount 4 in ag 158
> freeblk count 3 != flcount 4 in ag 153
> freeblk count 3 != flcount 4 in ag 159
> sb_ifree 667, counted 615
> sb_fdblocks 3930698117, counted 1111093367
>         - 15:06:10: scanning filesystem freespace - 193 of 193
> allocation groups done
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - 15:06:10: scanning agi unlinked lists - 193 of 193
> allocation groups done
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 30
>         - agno = 60
>         - agno = 15
>         - agno = 75
>         - agno = 45
>         - agno = 150
>         - agno = 31
>         - agno = 105
>         - agno = 61
>         - agno = 46
>         - agno = 135
>         - agno = 76
>         - agno = 120
>         - agno = 151
>         - agno = 90
>         - agno = 180
>         - agno = 165
>         - agno = 91
>         - agno = 32
>         - agno = 62
>         - agno = 106
>         - agno = 121
>         - agno = 166
>         - agno = 136
>         - agno = 47
>         - agno = 92
>         - agno = 16
>         - agno = 1
>         - agno = 181
>         - agno = 33
>         - agno = 167
>         - agno = 93
>         - agno = 122
>         - agno = 63
>         - agno = 152
>         - agno = 77
>         - agno = 2
>         - agno = 168
>         - agno = 48
>         - agno = 34
>         - agno = 182
>         - agno = 123
>         - agno = 107
>         - agno = 78
>         - agno = 153
>         - agno = 17
>         - agno = 3
>         - agno = 137
>         - agno = 35
>         - agno = 64
>         - agno = 79
>         - agno = 169
>         - agno = 138
>         - agno = 183
>         - agno = 108
>         - agno = 94
>         - agno = 65
>         - agno = 124
>         - agno = 36
>         - agno = 154
>         - agno = 80
>         - agno = 49
>         - agno = 184
>         - agno = 109
>         - agno = 37
>         - agno = 95
>         - agno = 125
>         - agno = 170
>         - agno = 50
>         - agno = 66
>         - agno = 81
>         - agno = 110
>         - agno = 139
>         - agno = 155
>         - agno = 185
>         - agno = 96
>         - agno = 126
>         - agno = 38
>         - agno = 171
>         - agno = 127
>         - agno = 140
>         - agno = 97
>         - agno = 51
>         - agno = 128
>         - agno = 67
>         - agno = 111
>         - agno = 82
>         - agno = 156
>         - agno = 186
>         - agno = 141
>         - agno = 172
>         - agno = 98
>         - agno = 129
>         - agno = 52
>         - agno = 130
>         - agno = 39
>         - agno = 142
>         - agno = 173
>         - agno = 53
>         - agno = 99
>         - agno = 157
>         - agno = 68
>         - agno = 112
>         - agno = 40
>         - agno = 83
>         - agno = 131
>         - agno = 54
>         - agno = 187
>         - agno = 113
>         - agno = 69
>         - agno = 143
>         - agno = 174
>         - agno = 84
>         - agno = 158
>         - agno = 41
>         - agno = 100
>         - agno = 159
>         - agno = 175
>         - agno = 144
>         - agno = 188
>         - agno = 42
>         - agno = 85
>         - agno = 70
>         - agno = 132
>         - agno = 101
>         - agno = 114
>         - agno = 55
>         - agno = 176
>         - agno = 160
>         - agno = 145
>         - agno = 86
>         - agno = 71
>         - agno = 189
>         - agno = 102
>         - agno = 43
>         - agno = 115
>         - agno = 161
>         - agno = 177
>         - agno = 56
>         - agno = 133
>         - agno = 72
>         - agno = 103
>         - agno = 44
>         - agno = 87
>         - agno = 190
>         - agno = 134
>         - agno = 73
>         - agno = 162
>         - agno = 116
>         - agno = 57
>         - agno = 146
>         - agno = 74
>         - agno = 191
>         - agno = 104
>         - agno = 117
>         - agno = 147
>         - agno = 163
>         - agno = 88
>         - agno = 178
>         - agno = 58
>         - agno = 192
>         - agno = 118
>         - agno = 148
>         - agno = 89
>         - agno = 164
>         - agno = 59
>         - agno = 179
>         - agno = 119
>         - agno = 149
>         - agno = 4
>         - agno = 5
>         - agno = 18
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - agno = 25
>         - agno = 26
>         - agno = 27
>         - agno = 28
>         - agno = 29
>         - 15:10:19: process known inodes and inode discovery - 896 of
> 896 inodes done
>         - process newly discovered inodes...
>         - 15:10:19: process newly discovered inodes - 193 of 193
> allocation groups done
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - 15:10:19: setting up duplicate extent list - 193 of 193
> allocation groups done
>         - check for inodes claiming duplicate blocks...
>         - agno = 1
>         - agno = 0
>         - agno = 2
>         - agno = 3
>         - agno = 9
>         - agno = 12
>         - agno = 6
>         - agno = 8
>         - agno = 4
>         - agno = 10
>         - agno = 7
>         - agno = 13
>         - agno = 31
>         - agno = 29
>         - agno = 35
>         - agno = 38
>         - agno = 40
>         - agno = 42
>         - agno = 43
>         - agno = 45
>         - agno = 18
>         - agno = 19
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - agno = 26
>         - agno = 51
>         - agno = 52
>         - agno = 25
>         - agno = 53
>         - agno = 54
>         - agno = 55
>         - agno = 32
>         - agno = 14
>         - agno = 33
>         - agno = 61
>         - agno = 62
>         - agno = 30
>         - agno = 5
>         - agno = 65
>         - agno = 66
>         - agno = 37
>         - agno = 16
>         - agno = 39
>         - agno = 68
>         - agno = 69
>         - agno = 70
>         - agno = 17
>         - agno = 44
>         - agno = 73
>         - agno = 74
>         - agno = 75
>         - agno = 76
>         - agno = 77
>         - agno = 78
>         - agno = 79
>         - agno = 50
>         - agno = 27
>         - agno = 81
>         - agno = 28
>         - agno = 11
>         - agno = 34
>         - agno = 85
>         - agno = 86
>         - agno = 59
>         - agno = 87
>         - agno = 60
>         - agno = 63
>         - agno = 90
>         - agno = 91
>         - agno = 64
>         - agno = 93
>         - agno = 94
>         - agno = 95
>         - agno = 41
>         - agno = 71
>         - agno = 72
>         - agno = 36
>         - agno = 20
>         - agno = 46
>         - agno = 47
>         - agno = 102
>         - agno = 48
>         - agno = 104
>         - agno = 105
>         - agno = 106
>         - agno = 108
>         - agno = 84
>         - agno = 110
>         - agno = 56
>         - agno = 112
>         - agno = 113
>         - agno = 115
>         - agno = 116
>         - agno = 117
>         - agno = 118
>         - agno = 96
>         - agno = 97
>         - agno = 98
>         - agno = 99
>         - agno = 100
>         - agno = 101
>         - agno = 103
>         - agno = 49
>         - agno = 126
>         - agno = 127
>         - agno = 107
>         - agno = 82
>         - agno = 83
>         - agno = 131
>         - agno = 109
>         - agno = 133
>         - agno = 111
>         - agno = 134
>         - agno = 57
>         - agno = 58
>         - agno = 89
>         - agno = 92
>         - agno = 67
>         - agno = 142
>         - agno = 143
>         - agno = 119
>         - agno = 120
>         - agno = 145
>         - agno = 146
>         - agno = 123
>         - agno = 148
>         - agno = 149
>         - agno = 150
>         - agno = 151
>         - agno = 152
>         - agno = 129
>         - agno = 154
>         - agno = 130
>         - agno = 157
>         - agno = 135
>         - agno = 136
>         - agno = 88
>         - agno = 114
>         - agno = 137
>         - agno = 162
>         - agno = 164
>         - agno = 139
>         - agno = 140
>         - agno = 166
>         - agno = 141
>         - agno = 168
>         - agno = 122
>         - agno = 171
>         - agno = 124
>         - agno = 173
>         - agno = 174
>         - agno = 128
>         - agno = 176
>         - agno = 177
>         - agno = 155
>         - agno = 156
>         - agno = 132
>         - agno = 180
>         - agno = 158
>         - agno = 159
>         - agno = 160
>         - agno = 161
>         - agno = 186
>         - agno = 138
>         - agno = 188
>         - agno = 189
>         - agno = 15
>         - agno = 144
>         - agno = 191
>         - agno = 192
>         - agno = 170
>         - agno = 147
>         - agno = 172
>         - agno = 125
>         - agno = 80
>         - agno = 175
>         - agno = 153
>         - agno = 178
>         - agno = 179
>         - agno = 181
>         - agno = 182
>         - agno = 183
>         - agno = 184
>         - agno = 185
>         - agno = 163
>         - agno = 187
>         - agno = 165
>         - agno = 167
>         - agno = 190
>         - agno = 169
>         - agno = 121
>         - 15:10:22: check for inodes claiming duplicate blocks - 896
> of 896 inodes done
> Phase 5 - rebuild AG headers and trees...
>         - 15:10:22: rebuild AG headers and trees - 193 of 193
> allocation groups done
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> Maximum metadata LSN (792:1294080) is ahead of log (1:64).
> Format log to cycle 795.
> done
> root@roc01r-scd224:~# mount -t xfs /dev/rbd0 /mnt
>
>
> No other errors in logs, Ceph or hardware.
>
>
> Thank you in advance!

Forgot to include xfs_info output:

xfs_info /srv/exports/sclun63
meta-data=/dev/rbd0              isize=512    agcount=193, agsize=33553408 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0
data     =                       bsize=4096   blocks=6442450944, imaxpct=5
         =                       sunit=1024   swidth=1024 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
