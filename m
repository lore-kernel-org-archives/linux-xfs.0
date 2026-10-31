Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.252
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793540563;
	b=LSLgnLiJUZTyb/7h84rKZGjRVlSMrIoJn6VL09/bSucV8uDmUMbzJK5EU9AXYhipN8au
	 //1/wZgDpRsintL/PtQ++yVYNHhbXkYNJNPK3fu/6GINY3LQ/ePHNRzbVS6JFfG+xKEGA
	 JDmy+grH62CYaD5+LXFUH7U7O+L6HS8MHXgrnW3WRJw0kam/j2G4u+BaOSAzBxrONsxXz
	 Yvh7BB4AAVGVKohXXp8rnLPLWPAgchggnNEtktJNxKHSccKQyO0jGijR2EygbALCghkU8
	 zPXvpNAYBj64+Wr0LDa8RZF5y12JA6eWl5pIgUkIMCCgUueGIU631OUyAl+XLQ3SI+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793540563;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:X-OQ-MSGID:Date:
	 X-Mailer:Content-Type:Content-Transfer-Encoding;
	bh=+rFqPtpOKSgYGgwlfLCuTsYFjJDRM4yv8R90ThyhwV4=;
	b=5jTn7pAB8EMqVvq7YmKaQ1oypGFr2sJzlQpE6B9vhRYhcPc/8oKhbcaaTvADnkpE1F4c
	 CA7x/2Wb+wp/6DD1SqVUofEtD4vL2skXM8B+Vd10WpOV8lzappa3wh4sVrI0+uD7X/mT8
	 ZqzOHxKbP+cI3mhMW1j9pVcRRuq3urt56kDc9u/XKK1/aVbguQNOiIBFuJ7nx+yfdO+zC
	 aEo/21g0bioI0h5cPja7KuarhXpETQ2fSNbzyO6QQM9aHP4F5NHxuzuw11cbeLNBtgk6Q
	 DHK7TTU11Ot/ANLRPJHF8B5WCpjovHZYc/f1FMCMbJFZWr3bcxFGsIKOyFaDh5iNiVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=zAeLlG1w;
	arc=none smtp.remote-ip=162.62.57.252
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B64606A324;
	Sun,  1 Nov 2026 13:42:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86B64606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=zAeLlG1w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793540549; bh=+rFqPtpOKSgYGgwlfLCuTsYFjJDRM4yv8R90ThyhwV4=;
	h=From:To:Cc:Subject:Date;
	b=zAeLlG1wuqd4si1jzurWBJ1FRVMK5FKJCcFQD0up/IPAogUx2Tv0wVHhmJLVhSaD5
	 FfKgFvfsl+Dp5Kslxz6Cd49pnIVhzmeHwqncexpCexuapg6hVS7P6l8om4trIyWmht
	 RtoZjBbn1HvJk8cv5wk3ZTPlKwaEUrDY6zEY59dQ=
Received: from [172.18.4.77] ([111.31.227.58])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id A9AB3EFC; Sun, 01 Nov 2026 21:42:26 +0800
X-QQ-mid: xmsmtpt1793540546tr24hbe3n
Message-ID: <tencent_5CB7D308BBD38D6945D4934F61147E2AF206@qq.com>
X-QQ-XMAILINFO: NmRjDopJZVxOgqNQTomBAKp4cGjSxtXtjSvjfMnMKb4BincwdPrTDacdXnF/yD
	 kGBz/zKQUgooTyhpmbpkQPPu/izS8PE061iDWRSIGW/0YhumB15mZI88W8G0llfoTsvLT0AnAvWc
	 YnnC0tsF3S/KbAbHYuZYOtDCvskee1lX8gidhG5h7TPlhLHn6S7VHgpueA/U4fQIz9sqKzNdWiCi
	 Uugn2/kt7xsIUEvd4BH1C4J54TheLc31SoxCeAKnOyy8Uyo7Cz3jfD+DVUWF3zVn6XvvP/GIbMBb
	 Qm1yXWn4+gvtrG3zG6nxD+Uh5JJIhOQskZd8eqXCl2MG89VgLeOHAAIt4+eskJZ3r3H9AxJtjs5I
	 eUFfgwrEtz6XfoWdrGBxRD674Njut1XuyhwuLexi/2EFtO4dLPb4jAA3VIB2W3g5ABMTnWnXhS+i
	 NjN1WPK68B/BmTKvwF0t21byIKQIOtM8RYOLw+LXzk1/3ftQRYMBN8kihFuz08itRJQdQii0GyGb
	 IehfyNaHd3eztP17gpC7FVUppl6PqWPWEedqyxGSpqQhIA+uRhRFKbLZSm3ldXJIhEwDodbomm7X
	 yDRaMzLqn8DKSgQxuq0AVtI/cMf7py9/mNe9jW/FHDYP2yIUQyjGxtif4pJxMgdGfc0IE2fROR9x
	 O679htkUULLRYjLWUeyUz4+Qnm7EMjXWix7gJlHb7Wh75CpG91y5I4X3MHMswykUbBCW+5SEdQKA
	 8ll+REF5YRfiAtYfImt1U1hNcCrgRs1BPiS9tFZTCequ9BhYe/hII8pCMcm+ZFF73K3e3/khbfkm
	 Pft7bjEA1xs0i4td4bYDDMck7Fgt3Ew46Fr0wj1HBHEqWjdbIuyIPEnf/vgn4XxD4Nnt5F8QK4hk
	 jVH7bb68U9zE1fxY4Iuub7wVsyGC2OvB6Z3Qe5EXSUlaAojN/drN9Hn9h/PP/0TtRwGyODABdvgO
	 n6sQbVzIVi4+Oxvh+uq+BoKIAJUBKY4WOQNSCVHaoLrcTBC7VpTJAMAJiEMCiR25eQzt+jom0l6h
	 MRHqCGV0BFjblqS+49es7qV5yPDAM0yhSydACPGV+x/hcvtJ56
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Guikun Yang <yangguikun19@qq.com>
To: linux-xfs@vger.kernel.org, Darrick J. Wong <djwong@kernel.org>,
 Carlos Maiolino <cem@kernel.org>, Dave Chinner <dgc@kernel.org>
Cc: linux-kernel@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: [BUG REPORT] xfs: log recovery dereferences an unvalidated
 ilf_boffset - KASAN use-after-free / page fault at mount time
X-OQ-MSGID: <x1-xfs-ilf-boffset-20261031@qq.com>
Date: Sat, 31 Oct 2026 12:00:00 +0800
X-Mailer: SMTP script
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list

Hi,

We found that xlog_recover_inode_commit_pass2() uses the on-disk
ilf_boffset field to index into the inode cluster buffer without any
bounds validation, and we can drive a KASAN use-after-free or an
unrecoverable page fault at mount time with a crafted log record.

We are aware of the RFC series "[PATCH 00/48] Validate journal log
items during log recovery" (2026-10-13), whose 35/48 validates the
inode item format header via xfs_imap()-derived boffset/blkno. This
report is not a proposal to fix it differently: it provides an
independent reproducer plus KASAN traces for the vulnerability as it
stands in mainline today (7.3.0 and current master both still carry
the unvalidated dereference), which may be useful as a test case for
the series.

The code, current mainline (fs/xfs/xfs_inode_item_recover.c:356):

    error =3D xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
                    0, &bp, &xfs_inode_buf_ops);
    if (error)
            goto error;
    ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
    dip =3D xfs_buf_offset(bp, in_f->ilf_boffset);       /* no check */

    if (XFS_IS_CORRUPT(mp, !xfs_verify_magic16(bp, dip->di_magic)))

xfs_buf_offset() is bp->b_addr + offset with no check. ilf_boffset is
an int32_t read straight from the log item format region
(libxfs/xfs_log_format.h:301). The only writers are the in-memory
im_boffset copy and the 32-bit format converter, which copies the
value verbatim. On the read side we could not find any validation:
the magic check above dereferences the resulting pointer, and on
v3 inodes dip->di_lsn / di_version / di_flushiter are read next.
xfs_log_dinode_to_disk() then writes a full log dinode through the
same pointer if the checks happen to pass. On a CONFIG_XFS_DEBUG=3Dn
kernel the ASSERT()s compile away entirely.

The buffer item path in the same recovery machinery had this class
of bug fixed in July (813f8136a2ce, "xfs: bounds-check buffer log
item's dirty bitmap"), which added the comment at
xfs_buf_item_recover.c:490-497 stating the logged fields are
attacker-controlled and that a real check is needed rather than an
ASSERT(). ilf_boffset is the same pattern in the inode item path and
is, as of today, still unprotected in mainline.

Trigger (no special mount options):

 1. mount an XFS filesystem, create a couple of files, crash the
    machine (sysrq-c) without unmounting, so the log holds inode log
    items;
 2. edit one inode log item's ilf_boffset in the log area to a wild
    value (the record CRC must be recomputed; CRC only protects
    against accidental corruption);
 3. mount the image again. Mount-time recovery replays the inode
    item and dereferences b_addr + ilf_boffset.

With ilf_boffset =3D 0x10000000 on a 64MB image (KASAN kernel, 7.3.0):

    BUG: KASAN: use-after-free in xlog_recover_inode_commit_pass2+0x1187/0x1f=
70
    Read of size 2 at addr ffff888014914000 by task init/1
    CPU: 0 UID: 0 PID: 1 Comm: init Not tainted 7.3.0 #23
    Call Trace:
     xlog_recover_inode_commit_pass2+0x1187/0x1f70
     xlog_recover_items_pass2+0x105/0x280
     xlog_recover_commit_trans+0x7e6/0x9d0
     xlog_recovery_process_trans+0x1a1/0x1c0
     xlog_recover_process_ophdr+0x1ea/0x400
     xlog_recover_process_data+0x12d/0x3c0
     xlog_recover_process+0x10d/0x390
     xlog_do_recovery_pass+0x8cf/0xd40
     xlog_do_log_recovery+0x89/0xb0
     xlog_do_recover+0x78/0x410
     xlog_recover+0x2d0/0x4e0
     xfs_log_mount+0x23a/0x480
     xfs_mountfs+0xfe7/0x20b0
     xfs_fs_fill_super+0x15dc/0x1e00
     get_tree_bdev_flags+0x36b/0x5f0

    Kernel panic - not syncing: KASAN: panic_on_warn set ...

With ilf_boffset =3D 0x40000000 instead:

    BUG: unable to handle page fault for address: ffffed10088a2800
    Oops: Oops: 0000 [#1] SMP KASAN PTI
    Kernel panic - not syncing: Fatal exception

With the original value the same log replays cleanly and the
filesystem mounts; the behavior difference is solely the unchecked
offset. Deterministic, reproduced 3/3 on a self-built 7.3.0 kernel
(CONFIG_KASAN_GENERIC=3Dy, CONFIG_XFS_FS=3Dy, CONFIG_XFS_DEBUG=3Dn).

Two sibling fields in log-replay formats share the shape (offset or
count from disk feeding a buffer access with only an ASSERT, or
nothing): qlf_boffset applied via xfs_buf_offset() at
xfs_dquot_item_recover.c:135, and bb_numrecs used as the memcpy count
in xfs_bmbt_to_bmdr() (libxfs/xfs_bmap_btree.c:174-176). We mention
them as context only; we expect the RFC series covers them as part of
"every log item type".

ilf_boffset has been unvalidated since it was introduced:

    Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

A natural fix mirrors 813f8136a2ce: validate that ilf_boffset lies
within the buffer that was just read (bp->b_length) with
XFS_IS_CORRUPT() and fail recovery with -EFSCORRUPTED. The RFC 35/48
approach (derive from ilf_ino via xfs_imap() and require a match) is
stronger and we are happy to test the series against our reproducer
if that is useful.

We frame this the same way 813f8136a2ce was framed: the input is the
log itself, which recovery must already treat as untrusted on
unclean mounts; we are not claiming a privilege-boundary crossing
beyond "whoever controls the device image controls the log".

The reproducer bundle (image builder + log patcher + CRC
recomputation matching xlog_cksum(), guest init, run script, and a
pre-baked dirty image) is available on request.

Environment: QEMU/KVM x86_64, 1 vCPU, kernel 7.3.0 self-built with
CONFIG_KASAN_GENERIC=3Dy, CONFIG_UBSAN=3Dy, CONFIG_XFS_FS=3Dy,
CONFIG_XFS_DEBUG=3Dn.

Thanks,
Guikun Yang

