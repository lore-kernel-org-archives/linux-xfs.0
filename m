Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 08:44:19 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA6GiEm2007594
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 08:44:15 -0800
Date: Tue, 6 Nov 2007 11:44:19 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfs crash
In-Reply-To: <20071106160721.GB25295@e-m.fr>
Message-ID: <Pine.LNX.4.64.0711061144100.17411@p34.internal.lan>
References: <20071105215135.GA12238@e-m.fr> <20071106082632.GU995458@sgi.com>
 <20071106092157.GB16694@e-m.fr> <20071106160721.GB25295@e-m.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1479258781-1194367459=:17411"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Cedric - Equinoxe Media <cedric@e-m.fr>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1479258781-1194367459=:17411
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 6 Nov 2007, Cedric - Equinoxe Media wrote:

> I just had exactly the same crash again today :
> /dev/sda4 on /filer type xfs (rw,noexec,nosuid,nodev,noatime)
>
> Nov  6 16:40:24 fng2 kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO a=
t line 1563 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff88113b35
> Nov  6 16:40:24 fng2 kernel:
> Nov  6 16:40:24 fng2 kernel: Call Trace:
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff88111fcb>] :xfs:xfs_free_ag_exten=
t+0x1a6/0x6b5
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff88113b35>] :xfs:xfs_free_extent+0=
xa9/0xc9
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff8811cf77>] :xfs:xfs_bmap_finish+0=
xee/0x167
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff8813c843>] :xfs:xfs_itruncate_fin=
ish+0x19b/0x2e0
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff881543c1>] :xfs:xfs_setattr+0x841=
/0xe57
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff8815c328>] :xfs:xfs_fs_get_dentry=
+0x38/0x59
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff80229db3>] task_rq_lock+0x3d/0x6f
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff80229976>] __activate_task+0x26/0=
x38
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff8815eae8>] :xfs:xfs_vn_setattr+0x=
121/0x144
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff80296791>] notify_change+0x156/0x=
2f1
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff88309aba>] :nfsd:nfsd_setattr+0x3=
34/0x4b1
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff883102e2>] :nfsd:nfsd3_proc_setat=
tr+0xa2/0xae
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff8830524d>] :nfsd:nfsd_dispatch+0x=
dd/0x19e
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff88283180>] :sunrpc:svc_process+0x=
3df/0x6ef
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff803f4cc2>] __down_read+0x12/0x9a
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff88305815>] :nfsd:nfsd+0x191/0x2ac
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff8020aba8>] child_rip+0xa/0x12
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff88305684>] :nfsd:nfsd+0x0/0x2ac
> Nov  6 16:40:24 fng2 kernel:  [<ffffffff8020ab9e>] child_rip+0x0/0x12
> Nov  6 16:40:24 fng2 kernel:
> Nov  6 16:40:24 fng2 kernel: xfs_force_shutdown(sda4,0x8) called from lin=
e 4258 of file fs/xfs/xfs_bmap.c.  Return address =3D 0xffffffff8811cfb4
> Nov  6 16:40:24 fng2 kernel: Filesystem "sda4": Corruption of in-memory d=
ata detected.  Shutting down filesystem: sda4
> Nov  6 16:40:24 fng2 kernel: Please umount the filesystem, and rectify th=
e problem(s)
>
> Seems to be again on a setattr() ?
>
> Regards.
> C=E9dric
>
>

Have you run a memory test on your server? memtest86
---1463747160-1479258781-1194367459=:17411--
