Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29965 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935838AbdCJMEF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Mar 2017 07:04:05 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v2AC3hh1030730
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 10 Mar 2017 12:03:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v2AC3gLD025079
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 10 Mar 2017 12:03:43 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v2AC3gBH015462
        for <linux-xfs@vger.kernel.org>; Fri, 10 Mar 2017 12:03:42 GMT
Date: Fri, 10 Mar 2017 13:04:06 +0100
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Subject: XFS race on umount
Message-ID: <20170310120406.GU16870@chrystal>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4dbYIUm7Fhfg+fSv"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>


--4dbYIUm7Fhfg+fSv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Guys,

We've been using XFS recently on our build system because we found that it
scales pretty well and we have good use for the reflink feature :)

I think our setup is relivatively unique in that on every one of our build
server, we mount hundreds of XFS filesystem from NBD devices in parallel,
where our build environment are stored on qcow2 images and connected with
qemu-nbd, then umount them when the build is finished.  Those qcow2 images
are stored on a NFS mount, which leads to some (expected) hickups when
reading/writing blocks where sometimes the NBD layer will return some
errors to the block layer, which in turn will pass them on to XFS.  It
could be due to network contention, very high load on the server, or any
transcient error really, and in those cases, XFS will normally force shut
down the filesystem and wait for a umount.

All of this is fine and is exactly the behaviour we'd expect, though it
turns out that we keep hiting what I think is a race condition between
umount and a force shutdown from XFS itself, where I have a umount process
completely stuck in xfs_ail_push_all_sync():

  [<ffffffff813d987e>] xfs_ail_push_all_sync+0x9e/0xe0
  [<ffffffff813c20c7>] xfs_unmountfs+0x67/0x150
  [<ffffffff813c5540>] xfs_fs_put_super+0x20/0x70
  [<ffffffff811cba7a>] generic_shutdown_super+0x6a/0xf0
  [<ffffffff811cbb2b>] kill_block_super+0x2b/0x80
  [<ffffffff811cc067>] deactivate_locked_super+0x47/0x80
  [<ffffffff811ccc19>] deactivate_super+0x49/0x70
  [<ffffffff811e7b3e>] cleanup_mnt+0x3e/0x90
  [<ffffffff811e7bdd>] __cleanup_mnt+0xd/0x10
  [<ffffffff810e1b39>] task_work_run+0x79/0xa0
  [<ffffffff810c2df7>] exit_to_usermode_loop+0x4f/0x75
  [<ffffffff8100134b>] syscall_return_slowpath+0x5b/0x70
  [<ffffffff81a2cbe3>] entry_SYSCALL_64_fastpath+0x96/0x98
  [<ffffffffffffffff>] 0xffffffffffffffff

This is on a v4.10.1 kernel.  I've had a look at xfs_ail_push_all_sync()
and I wonder if there isn't a potential lost wake up problem, where I can't
see that we retest the condition after setting the current process to
TASK_UNINTERRUPTIBLE and before calling schedule() (though I know nothing
about XFS internals...).

Here's an exerpt of relevant dmesg messages that very likely happened at
the same time the unmount process was started:

  [29961.767707] block nbd74: Other side returned error (22)
  [29961.837518] XFS (nbd74): metadata I/O error: block 0x6471ba0 ("xfs_tra=
ns_read_buf_map") error 5 numblks 32
  [29961.838172] block nbd74: Other side returned error (22)
  [29961.838179] block nbd74: Other side returned error (22)
  [29961.838184] block nbd74: Other side returned error (22)
  [29961.838203] block nbd74: Other side returned error (22)
  [29961.838208] block nbd74: Other side returned error (22)
  [29962.259551] XFS (nbd74): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
  [29962.356376] XFS (nbd74): xfs_do_force_shutdown(0x8) called from line 3=
454 of file fs/xfs/xfs_inode.c.  Return address =3D 0xffffffff813bf471
  [29962.503003] XFS (nbd74): Corruption of in-memory data detected.  Shutt=
ing down filesystem
  [29963.166314] XFS (nbd74): Please umount the filesystem and rectify the =
problem(s)

I'm pretty sure the process isn't deadlocking on the spinlock because it
doesn't burn any CPU and is really out of the scheduler pool.  It should be
noted that when I noticed the hung umount process, I've manually tried to
unmount the corresponding XFS mountpoint and that was fine, though it
obviously didn't "unhang" the stuck umount process.

Any help would be appreciated :)

Thanks,
Quentin

--4dbYIUm7Fhfg+fSv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJYwpY2AAoJEB5Tt01po9cNCJwQALVGmoxLODVgIYjUl1sJHUzs
X/28QMl3rb2U47jB/YUveIBFD4x7Ghy919sAR84+6TjnUMSS5/jf193rySUTNc91
9c+vZM9MGr6S9J8HGc1PmlirIY/mTJCRuzv84Z7BPW30QxJG1Ga0Dnw2Ucbojt5M
zmXQMEuKp8qBJQtb9w5GnYkNsMrMbvOzexrMFe785wvaNy37t7ODgT/OQaAxA23X
IYXluk039B4C0qdGrbdb+eULVq8+luCepV/qh/GuWfnjtoxO0l6qc6oTr4+A3nnG
Mt5owE80BSM3h9ybJ2AJhasYho/Arq+Tqw6F6uFsJBxNlsxw0RLMuxYxXBwpPtJE
ZpZ5xOWgXBz0OWfes5WVRT6dziQFOm7EG3sO/XgG/lJcnchwKv9FUp5MWTAFsuVn
0exagaP1tn+p5HP49zcdpoy0gn05dkx4vtDi30UDBqYZsGSF7+H1YCK976VJx3yG
DXiAsJp+10CW3jMGt4oeOeYP34XbIg0uldEa9oaXIv4j4kh+Brg0rp5DIPgNl9/c
Jk3iS3SvgtxOsEXqYg7EvFMm1vAeQLYw3MAUlnqRwWjL+1IzgkxmBH48bfFX9g/h
X8Yb005LZv9QHIqG5CLZTxtotjULdapBbvXFfeqpQopsy5gR2bvXrkhqvyzJLTm0
p7/0UDOo0XnMSfvIvvKJ
=UjEj
-----END PGP SIGNATURE-----

--4dbYIUm7Fhfg+fSv--
