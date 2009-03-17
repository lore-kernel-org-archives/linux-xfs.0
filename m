Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2HLRY9O183650 for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 16:27:55 -0500
Subject: lockdep report with 2.6.29-rc8-wl-18593-gef1cb6f-dirty
From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 17 Mar 2009 19:45:20 +0100
Message-Id: <1237315521.31814.17.camel@johannes.local>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6122827039794955311=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-masters@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com


--===============6122827039794955311==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-59nMbdlnTLjLok6jFJY5"


--=-59nMbdlnTLjLok6jFJY5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

(ignore the -wl-... stuff, it's a wireless tree, but everything but
wireless is plain -rc8)

This happened about 20 minutes into a long rsync session where I was
writing a lot of data to the XFS filesystem:

[ 2182.810987] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 2182.811372] [ INFO: possible circular locking dependency detected ]
[ 2182.811669] 2.6.29-rc8-wl-18593-gef1cb6f-dirty #30
[ 2182.811894] -------------------------------------------------------
[ 2182.812189] rsync/4528 is trying to acquire lock:
[ 2182.812408]  (iprune_mutex){--..}, at: [<c000000000124160>] .prune_icach=
e+0x58/0x2c4
[ 2182.812802]=20
[ 2182.812803] but task is already holding lock:
[ 2182.813073]  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0000000001ff73c>]=
 .xfs_ilock+0x30/0x9c
[ 2182.813499]=20
[ 2182.813501] which lock already depends on the new lock.
[ 2182.813503]=20
[ 2182.813876]=20
[ 2182.813877] the existing dependency chain (in reverse order) is:
[ 2182.814223]=20
[ 2182.814225] -> #1 (&(&ip->i_iolock)->mr_lock){----}:
[ 2182.814544]        [<c00000000008a7c0>] .validate_chain+0x740/0x928
[ 2182.814846]        [<c00000000008b1d0>] .__lock_acquire+0x828/0x908
[ 2182.815148]        [<c00000000008b354>] .lock_acquire+0xa4/0xec
[ 2182.815433]        [<c00000000007867c>] .down_write_nested+0x70/0x110
[ 2182.815744]        [<c0000000001ff73c>] .xfs_ilock+0x30/0x9c
[ 2182.816016]        [<c0000000001ff8b8>] .xfs_ireclaim+0xc0/0x1f0
[ 2182.828398]        [<c00000000022f424>] .xfs_reclaim_inode+0x16c/0x198
[ 2182.840760]        [<c00000000021cbfc>] .xfs_reclaim+0xc0/0xf0
[ 2182.853054]        [<c00000000022d41c>] .xfs_fs_destroy_inode+0x4c/0x84
[ 2182.865273]        [<c000000000123f58>] .destroy_inode+0x58/0x8c
[ 2182.877335]        [<c000000000124094>] .dispose_list+0x108/0x17c
[ 2182.889251]        [<c000000000124390>] .prune_icache+0x288/0x2c4
[ 2182.901023]        [<c0000000001243f8>] .shrink_icache_memory+0x2c/0x64
[ 2182.912715]        [<c0000000000de4f8>] .shrink_slab+0x168/0x27c
[ 2182.924301]        [<c0000000000dea04>] .balance_pgdat+0x3f8/0x614
[ 2182.935746]        [<c0000000000ded74>] .kswapd+0x154/0x158
[ 2182.947235]        [<c000000000073320>] .kthread+0x78/0xc4
[ 2182.958620]        [<c0000000000227c0>] .kernel_thread+0x54/0x70
[ 2182.969955]=20
[ 2182.969956] -> #0 (iprune_mutex){--..}:
[ 2182.992430]        [<c00000000008b1d0>] .__lock_acquire+0x828/0x908
[ 2183.003723]        [<c00000000008b354>] .lock_acquire+0xa4/0xec
[ 2183.014986]        [<c000000000428ce8>] .mutex_lock_nested+0x194/0x4c8
[ 2183.026210]        [<c000000000124160>] .prune_icache+0x58/0x2c4
[ 2183.037321]        [<c0000000001243f8>] .shrink_icache_memory+0x2c/0x64
[ 2183.048365]        [<c0000000000de4f8>] .shrink_slab+0x168/0x27c
[ 2183.059271]        [<c0000000000df37c>] .do_try_to_free_pages+0x2bc/0x43=
8
[ 2183.070142]        [<c0000000000df598>] .try_to_free_pages+0xa0/0xcc
[ 2183.080867]        [<c0000000000d60f4>] .__alloc_pages_internal+0x32c/0x=
55c
[ 2183.091593]        [<c0000000000ce8c8>] .grab_cache_page_write_begin+0x8=
0/0xf0
[ 2183.102345]        [<c000000000139798>] .block_write_begin+0x60/0x13c
[ 2183.113136]        [<c000000000223eb8>] .xfs_vm_write_begin+0x24/0x3c
[ 2183.123933]        [<c0000000000cd3f8>] .generic_perform_write+0x100/0x2=
94
[ 2183.134731]        [<c0000000000cfb88>] .generic_file_buffered_write+0x8=
8/0x15c
[ 2183.145447]        [<c00000000022c0d0>] .xfs_write+0x4ac/0x70c
[ 2183.156132]        [<c000000000227c30>] .xfs_file_aio_write+0x78/0x8c
[ 2183.166837]        [<c00000000010a8b4>] .do_sync_write+0xcc/0x130
[ 2183.177399]        [<c00000000010b4c0>] .vfs_write+0xd0/0x1bc
[ 2183.188041]        [<c00000000010b6b4>] .SyS_write+0x58/0xa0
[ 2183.198645]        [<c000000000007554>] syscall_exit+0x0/0x40
[ 2183.209296]=20
[ 2183.209297] other info that might help us debug this:
[ 2183.209299]=20
[ 2183.240399] 3 locks held by rsync/4528:
[ 2183.250633]  #0:  (&sb->s_type->i_mutex_key#5){--..}, at: [<c00000000022=
bdec>] .xfs_write+0x1c8/0x70c
[ 2183.261377]  #1:  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0000000001ff=
73c>] .xfs_ilock+0x30/0x9c
[ 2183.272194]  #2:  (shrinker_rwsem){----}, at: [<c0000000000de3f0>] .shri=
nk_slab+0x60/0x27c
[ 2183.283115]=20
[ 2183.283116] stack backtrace:
[ 2183.304318] Call Trace:
[ 2183.314712] [c0000001b096ab60] [c00000000000fef8] .show_stack+0x6c/0x174=
 (unreliable)
[ 2183.325448] [c0000001b096ac10] [c000000000089528] .print_circular_bug_ta=
il+0xd8/0xfc
[ 2183.336117] [c0000001b096ace0] [c00000000008a7c0] .validate_chain+0x740/=
0x928
[ 2183.346633] [c0000001b096ada0] [c00000000008b1d0] .__lock_acquire+0x828/=
0x908
[ 2183.356978] [c0000001b096aea0] [c00000000008b354] .lock_acquire+0xa4/0xe=
c
[ 2183.367329] [c0000001b096af60] [c000000000428ce8] .mutex_lock_nested+0x1=
94/0x4c8
[ 2183.377555] [c0000001b096b070] [c000000000124160] .prune_icache+0x58/0x2=
c4
[ 2183.387589] [c0000001b096b130] [c0000000001243f8] .shrink_icache_memory+=
0x2c/0x64
[ 2183.397649] [c0000001b096b1b0] [c0000000000de4f8] .shrink_slab+0x168/0x2=
7c
[ 2183.407654] [c0000001b096b280] [c0000000000df37c] .do_try_to_free_pages+=
0x2bc/0x438
[ 2183.417842] [c0000001b096b380] [c0000000000df598] .try_to_free_pages+0xa=
0/0xcc
[ 2183.427975] [c0000001b096b470] [c0000000000d60f4] .__alloc_pages_interna=
l+0x32c/0x55c
[ 2183.438101] [c0000001b096b5a0] [c0000000000ce8c8] .grab_cache_page_write=
_begin+0x80/0xf0
[ 2183.448275] [c0000001b096b650] [c000000000139798] .block_write_begin+0x6=
0/0x13c
[ 2183.458381] [c0000001b096b710] [c000000000223eb8] .xfs_vm_write_begin+0x=
24/0x3c
[ 2183.468545] [c0000001b096b790] [c0000000000cd3f8] .generic_perform_write=
+0x100/0x294
[ 2183.478770] [c0000001b096b8a0] [c0000000000cfb88] .generic_file_buffered=
_write+0x88/0x15c
[ 2183.489036] [c0000001b096b980] [c00000000022c0d0] .xfs_write+0x4ac/0x70c
[ 2183.499291] [c0000001b096bad0] [c000000000227c30] .xfs_file_aio_write+0x=
78/0x8c
[ 2183.509609] [c0000001b096bb40] [c00000000010a8b4] .do_sync_write+0xcc/0x=
130
[ 2183.519935] [c0000001b096bce0] [c00000000010b4c0] .vfs_write+0xd0/0x1bc


--=-59nMbdlnTLjLok6jFJY5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJv+++AAoJEKVg1VMiehFYxIAP/Ay6Rfkfqo9fdoEOO8dlXdzI
J02xVr/YDHrPUPONH8872W4whgxVSlxYoZuOdzPGw723bw21lU8cDc3fDjHojClX
bXGEYBmGBJMP78koZuT2TzrV1eEXtVOU1i1Vb2ekk2cHvzJlg2OuvI5LcIvLOA6C
PNc1gCOzCEq9M0iMtltpYYBzCmpCbxWpB7WVEIDefqzfEGxDIy/IlpMgiR4nsBXX
yh3cXr7/Xm78/leCEyOEvkSpFAakkdUHttT7hLU0sTRNCr5El+37j6TtzeWuJfF6
Lpbm32wBwXsEmH9xMY3RE7GJN1eaAf9QHNQWHJmp4snICmEWcRwsaSGFNoSZqGXO
YEMojOJ9McoFHrVoeoZhrNeDuwTQVfZj+nixDhRXEMG+YEVHO3cisCcmP2gZeQVo
SOiOnssIWBo5zPKwlBp18uR84dGf9Sr+1IUnl4yl/5RXPyAt5pHnn4bkUgGE4Q85
1giGspYGiv9xlhwDR2CcVI1QbKwRL2eeoQsGlYxPAVrFS4rKszjgrazXdX5AhwOe
I5wwCSmOf04cHN8HniOLOujIyM2fPZtprruPAwP1Qd6Sq+nqllBLeoE3qcNu/m8d
G5nAM5qspnqn1P93j4jnUjynbGuVotlvvyf8cBINKz3qkZHxn2CVIGMbnwrl3A1u
BoXR6Wdf4maT2ixtZ4RW
=Nhvg
-----END PGP SIGNATURE-----

--=-59nMbdlnTLjLok6jFJY5--


--===============6122827039794955311==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6122827039794955311==--
