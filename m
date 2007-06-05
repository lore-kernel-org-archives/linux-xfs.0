Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 19:21:12 -0700 (PDT)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.227])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l552L5Wt008672
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 19:21:06 -0700
Received: by nz-out-0506.google.com with SMTP id 4so1043848nzn
        for <xfs@oss.sgi.com>; Mon, 04 Jun 2007 19:21:06 -0700 (PDT)
Message-ID: <d9c0b9d90706041921h19a54addl4398f1f888a5affc@mail.gmail.com>
Date: Mon, 4 Jun 2007 22:21:05 -0400
From: "=?ISO-8859-1?Q?Germ=E1n_Po=F3-Caama=F1o?=" <german.poo@gmail.com>
Subject: Re: Reporting a bug
In-Reply-To: <d9c0b9d90706041910t15584e05y16e7eba660c96d51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Disposition: inline
References: <d9c0b9d90706041910t15584e05y16e7eba660c96d51@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Adding a little more information:

Sysrescue has kernel 2.6.20.

Filesystem "sda5": corrupt dinode 786561, (btree extents).  Unmount
and run xfs_repair.
Filesystem "sda5": XFS internal error xfs_bmap_read_extents(1) at line
4565 of file fs/xfs/xfs_bmap.c.  Caller 0xc02e7c99
 [<c02ca11e>] xfs_bmap_read_extents+0x488/0x4a2
 [<c02e7c99>] xfs_iread_extents+0xa0/0xbb
 [<c02e5b5f>] xfs_iext_realloc_direct+0xb3/0xc1
 [<c02e7c99>] xfs_iread_extents+0xa0/0xbb
 [<c02c2a54>] xfs_bmap_last_offset+0x94/0xdc
 [<c02d5269>] xfs_dir2_isblock+0x1b/0x60
 [<c0324085>] __make_request+0x384/0x495
 [<c02d59fb>] xfs_dir_lookup+0x8e/0xeb
 [<c02c7615>] xfs_bmapi+0x25b/0x1fd7
 [<c02fb04f>] xfs_dir_lookup_int+0x2c/0xd4
 [<c01230c4>] down_write+0x8/0x10
 [<c02e41ad>] xfs_ilock+0x47/0x67
 [<c02fe944>] xfs_lookup+0x50/0x76
 [<c05ff4cc>] __mutex_lock_slowpath+0x1ac/0x1b4
 [<c030a580>] xfs_vn_lookup+0x3b/0x70
 [<c0149b58>] do_lookup+0xa3/0x140
 [<c014b369>] __link_path_walk+0x61d/0xa24
 [<c014b7b2>] link_path_walk+0x42/0xaf
 [<c03000d8>] xfs_setattr+0xdbe/0xe7c
 [<c014ba67>] do_path_lookup+0x144/0x164
 [<c0145349>] get_empty_filp+0x4f/0xca
 [<c014c3d9>] __path_lookup_intent_open+0x43/0x72
 [<c014c47c>] path_lookup_open+0x20/0x25
 [<c014c546>] open_namei+0x6e/0x523
 [<c010b7cd>] do_page_fault+0x278/0x53f
 [<c0143049>] do_filp_open+0x2a/0x3e
 [<c03000d8>] xfs_setattr+0xdbe/0xe7c
 [<c01430a4>] do_sys_open+0x47/0xcf
 [<c0143165>] sys_open+0x1c/0x1e
 [<c0102c94>] syscall_call+0x7/0xb
 [<c05f0033>] svcauth_gss_accept+0x76a/0xadb
 =======================
Filesystem "sda5": corrupt dinode 786561, (btree extents).  Unmount
and run xfs_repair.
Filesystem "sda5": XFS internal error xfs_bmap_read_extents(1) at line
4565 of file fs/xfs/xfs_bmap.c.  Caller 0xc02e7c99
 [<c02ca11e>] xfs_bmap_read_extents+0x488/0x4a2
 [<c02e7c99>] xfs_iread_extents+0xa0/0xbb
 [<c02e5b5f>] xfs_iext_realloc_direct+0xb3/0xc1
 [<c02e7c99>] xfs_iread_extents+0xa0/0xbb
 [<c0324085>] __make_request+0x384/0x495
 [<c02c2a54>] xfs_bmap_last_offset+0x94/0xdc
 [<c02d5269>] xfs_dir2_isblock+0x1b/0x60
 [<c02d59fb>] xfs_dir_lookup+0x8e/0xeb
 [<c02d59ea>] xfs_dir_lookup+0x7d/0xeb
 [<c02fb04f>] xfs_dir_lookup_int+0x2c/0xd4
 [<c01230c4>] down_write+0x8/0x10
 [<c02e41ad>] xfs_ilock+0x47/0x67
 [<c02fe944>] xfs_lookup+0x50/0x76
 [<c05ff4cc>] __mutex_lock_slowpath+0x1ac/0x1b4
 [<c02fb04f>] xfs_dir_lookup_int+0x2c/0xd4
 [<c030a580>] xfs_vn_lookup+0x3b/0x70
 [<c0149b58>] do_lookup+0xa3/0x140
 [<c014b369>] __link_path_walk+0x61d/0xa24
 [<c014b7b2>] link_path_walk+0x42/0xaf
 [<c014ba67>] do_path_lookup+0x144/0x164
 [<c014c236>] __user_walk_fd+0x30/0x45
 [<c0146b8a>] vfs_stat_fd+0x19/0x40
 [<c0146c3c>] sys_stat64+0xf/0x23
 [<c0102c94>] syscall_call+0x7/0xb

and so on.

-- 
Germán Poó Caamaño
http://www.gnome.org/~gpoo/
