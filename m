Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794991199;
	b=cPASHWsCWdy9bONcILowjcXzpLZDOolMWFuWj+jNm6CVysNXeejuHGjWWCzkOJJDqvNr
	 UC+Y9UU/I03goLD3tYm3ZjIkxF2NeF9DxecTHNKhnLk/nGgT/UL+AyGO8yUEiDjsLIx6s
	 LFgOVVKsIClm3lGcwRuuaLZMU4+uYRvP1GZzp9j05Qb1eARaZzIW92m6OtfA/HjulBhaw
	 CRqnWNlP0joM/OUSOhz3fXj4/C/wLTjMAPkmKfQNAbYNn2OsaHy5GnaeZ55KeZXkjXnn7
	 SRLqTKEePz470CN/XIOoyCD1qGilk+X0rZGGQ9FYVLQKXg6FhzWgiRnrMPBCOqiRWJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794991199;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i/O8Gfo5odi9UcNdwjls24AvA6bu54eZjND9yU050Nc=;
	b=lPWnUDl+qXF623HVX/2Ip04lNdOx4SSiFt+ouQ/N4Kd87sldWfFcR2Dyonv7WpvHOMqR
	 X3YjwOmyrWgY1+0wF5BCZ0u49BIoaIdzvkGnKKRFk2O4TrA7xeM7wTSHrGNRJoVgSOmZ9
	 SP8HBcKp05Tt7Uas8o523NO4TVWyX6IxtYKu+uDE7ojsbXHAcN8d/5lCyYp0QKYO0oHtV
	 bHKqSNDp6z4iotGKo7vxEu+qzWB10kM+uptbytCIhpyjQni+rXOmMzNZq0T0Ym9FH7THu
	 TvuH06criC6K/YfTDrjX96QVNPivsu98oG7AZRTYAcPTuiL2lrrnKpLvn6SEaHjcL9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="dsMdSp/F";
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB96606A32F
	for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 08:39:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DB96606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dsMdSp/F
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8c20d68c83fso1067844b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 00:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794991198; x=1795595998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i/O8Gfo5odi9UcNdwjls24AvA6bu54eZjND9yU050Nc=;
        b=dsMdSp/FkmaXTSVXQAg8mc8lzjUFUbNLN6Wlq/a38QnhcF1UprNPPRBQ0h6Aq4vzwR
         hha0+4g4Gcz1VApfbqJx+e6YbgXcrKV3tvpI6kDOpCEvov78i0d2iWLQd9X0eXFII097
         xeOo12K946vLIUqXOFYRlD6N6TDUVcpo0qOlN2UZcS/AsiSTA4nOF+z6zmxdQU+GbhKE
         rR0eD2drxSYMVbpCT4JFxnBFKwr6f8trewBlS3j0jgAuIrF0gl7mzSwnW0bhVna1fWf6
         izKgepke02V+bDm2+K3A2C9qmtbWFg9QqeQyb/OttYTeUyhnZs3a+m2qYuXgE6b36R6C
         o0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794991198; x=1795595998;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i/O8Gfo5odi9UcNdwjls24AvA6bu54eZjND9yU050Nc=;
        b=kalEm/aJ6ZTd7sFTXbTz7Y3p9ziFNotyRxriGjx2hAo4+aL4etPKKiHuOevK+ztimi
         G0Trtxmv94goj3pk3lpDK8J8su/J5rL5mMFlFTao0TZCsA7dSYg2sOU+/smD3BAawWf0
         uh5+BDkjvsHcP9BrUsf5xhdGb+5GKlslD9bg8hzwLuV+roJ+APCUEIxicdDKEQoADeKe
         8wQbmNjVAn7X1uZ0dehDvFCfTeeFae0rNdw2Ocfuwu3rzJRdrd9PaKSgU0mXzKHO9vb3
         qd0cMlK0dVtp0T2b+yxTVJFENVEAVs5O9/Nl9BBKhyALYqY/kNl6MMAv9h7Bti7T1nxl
         KgMw==
X-Forwarded-Encrypted: i=1; AL+hErGmO6jFaDjX0a3XAAG8XIjMe1MVlHrTxmGRwN0psnFRvPuGw+sp3Rqx6bZlTMIdjE9O7e0uHYT4898=@vger.kernel.org
X-Gm-Message-State: APuU4Z+GeKmlR/g3AlXr2SVhvOWnVw0lT/RaiNf10i2Hs5QECpyJRzJW
	lCGajiWJeOWY8DKKt2gVWy4Er463cHv5emLnuuoG5tDgH6iWtFJ2Oz07
X-Gm-Gg: AYBFou2qO/p5pjZEtHBvwhjA00TWIkg7bl6x2z/e/3K/jyrLKECBLrqFVsQdcqiQcBE
	A7qeVdGo/w0Ie8eMO3upEnV1L8R0M+NvRrtSo14SPBSq/z+eVGP46efPcLKCqm0KtbKLrd56A2m
	6IiAVwVWpVhC/M6bDBpeS7D6jLgMegPbauUNMJ/BzbJ80NMTRvHKa/hoNIVztKDKzqBFBSat97s
	oBzy2KKXK6vjS7KES+tCtKodH2vl7GhCP9PnqSgFjKVYtz0/m7qQY5M740+KntlYg3jesngQuV7
	LK4f47hnXauXaTXc7jlxf64pnBUCMoc5TP3G0ksPEpcB7+ig5fqEMgPo3jRbkDrk0kB1pFl/poW
	wuaEGcdbH1nyILjIecfBRevIswn00Dmbk+s8NW6vHIj7PhlxV9Z/NAMpyMajpva7zbBUCkkC6jE
	PZ29Q6OCXXL9ryl+NaX0moV4uTpF4Tpi5VShO5SOSdTTTbXt2Vf6kuDElFWzfdR3+sxl/IwCZeU
	jiioXTQM+4z6ydLK3UjJ5ETTTlca94G8mM1+RuQnzYAbXRtwj26oEjMaxxbfjCkL03OZHHPG3Td
	XAmao5Ss/3yOEta06pKivg/6jaMUbbilVOoRhu8vKjdTb+AokAwR
X-Received: by 2002:a05:6a20:6a04:b0:3e1:e6b1:fc25 with SMTP id adf61e73a8af0-3fd2d7d0d18mr4004715637.9.1794991197552;
        Wed, 18 Nov 2026 00:39:57 -0800 (PST)
Received: from localhost.localdomain ([152.136.45.109])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde3af26c35sm783971a12.2.2026.11.18.00.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 00:39:57 -0800 (PST)
From: Qing Zhang <diasyzhangqing@gmail.com>
X-Google-Original-From: Qing Zhang <diasyzhang@tencent.com>
To: viro@zeniv.linux.org.uk
Cc: brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] namei: revalidate the symlink dentry before invoking get_link in RCU-walk
Date: Wed, 18 Nov 2026 16:39:45 +0800
Message-ID: <20261118083945.1449264-1-diasyzhang@tencent.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RCU pathwalk validates the symlink dentry before following it, but
additional work separates that validation from sampling and invoking
the get_link callback.

XFS can recycle a reclaimable inode in place without waiting for
pre-existing RCU readers to complete. The recycle path calls
xfs_reinit_inode(), which calls inode_init_always() and resets i_op
to empty_iops. A reader retaining an inode pointer from the previous
VFS lifetime can therefore sample a NULL get_link callback.

We observed this failure on an XFS filesystem running
5.4.119-19.0009.44 while codebuddy was following
/root/.codebuddy/debug/latest through access().

The complete Oops below has only its timestamps omitted:

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 14fcb5067 P4D 14fcb5067 PUD 1f2c9c7067 PMD 0
Oops: 0010 [#1] SMP NOPTI
CPU: 32 PID: 852915 Comm: codebuddy Kdump: loaded Tainted: G           O      5.4.119-19.0009.44 #1
Hardware name: Tencent Cloud CVM, BIOS seabios-1.9.1-qemu-project.org 04/01/2014
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc9001905bcd8 EFLAGS: 00010246
RAX: ffffffff8227fe80 RBX: ffffc9001905bd80 RCX: 0000000000000000
RDX: ffffc9001905bde8 RSI: ffff888654eb2798 RDI: 0000000000000000
RBP: ffffc9001905bd10 R08: 0000000000000001 R09: ffff888214aa28c0
R10: 330074736574616c R11: 0000000000000006 R12: 0000000000000000
R13: ffff888654eb2798 R14: ffff888214aa28c0 R15: ffffc9001905bde8
FS:  00007f28e6deef00(0000) GS:ffff889f41800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 0000000214f6a002 CR4: 0000000000370ee0
DR0: 0000000001e188ba DR1: 0000000002d86940 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 trailing_symlink+0x1da/0x260
 path_lookupat.isra.47+0x79/0x220
 filename_lookup.part.63+0xa0/0x170
 ? kmem_cache_alloc+0xfc/0x250
 ? getname_flags+0x4f/0x1e0
 user_path_at_empty+0x3e/0x50
 do_faccessat+0xb3/0x250
 __x64_sys_access+0x1b/0x20
 do_syscall_64+0x4d/0x150
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f28e6fbcb4b
Code: f8 ff 74 d8 8b 44 24 04 e9 77 ff ff ff e8 cd 2a 02 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa b8 15 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 99 72 10 00 f7 d8
RSP: 002b:00007fff69e37768 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 00007fff69e37910 RCX: 00007f28e6fbcb4b
RDX: 000000000000001d RSI: 0000000000000000 RDI: 0000024989890000
RBP: 00007fff69e377c0 R08: 0000000000000031 R09: 00007fff69e37410
R10: 000002498c0a5000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000001 R14: 0000024989612860 R15: 00007fff69e37938
Modules linked in: iptable_filter udp_diag ib_core(O) mlx_compat(O) fuse ipt_REJECT nf_reject_ipv4 nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd grace fscache veth tcp_diag inet_diag nf_conntrack_netlink xt_statistic xt_nat ip_set ip_vs_sh ip_vs_wrr ip_vs_rr ip_vs xt_addrtype xt_MASQUERADE xt_conntrack xt_comment xt_mark nft_chain_nat overlay nft_counter nft_compat nf_tables nfnetlink sunrpc edac_core crc32_pclmul ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper virtio_balloon xfs sch_fq_codel iptable_nat nf_nat binfmt_misc nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_tables cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm crc32c_intel virtio_net sr_mod i2c_core cdrom net_failover failover floppy autofs4
CR2: 0000000000000000

Disassembly of the faulting kernel identifies the indirect call in
get_link(), inlined into trailing_symlink():

  trailing_symlink+0x1a3: mov    0x8(%rax),%rcx
  trailing_symlink+0x1a7: testb  $0x40,0x38(%rbx)
  trailing_symlink+0x1ab: jne    trailing_symlink+0x1cf
  trailing_symlink+0x1cf: xor    %edi,%edi
  trailing_symlink+0x1d1: mov    %rcx,-0x30(%rbp)
  trailing_symlink+0x1d5: call   __x86_indirect_thunk_rcx

The return address is trailing_symlink+0x1da. RAX resolves to
empty_iops.55072, and its get_link member at offset 8 is NULL.
RCX is zero and RDI is NULL, identifying the RCU-walk invocation.
The failure occurs before entering an XFS get_link handler.

RBX identifies the walker's nameidata at 0xffffc9001905bd80.
The vmcore contains:

  nd->flags               = 81 (0x51, including LOOKUP_RCU)
  nd->depth               = 1
  nd->stack               = 0xffffc9001905bdd8
  nd->link_inode          = 0xffff888654eb2798

The saved link entry contains:

  saved.link.dentry       = 0xffff888214aa28c0
  &saved.done             = 0xffffc9001905bde8
  saved.seq               = 6154122

Thus nd->link_inode matches RSI, and &saved.done matches RDX.
The saved dentry is named "latest". In the later vmcore snapshot:

  dentry->d_inode         = NULL
  dentry->d_seq.sequence  = 6157892

The sequence to compare is the saved link's sequence, not nd->seq.
The difference establishes that the saved snapshot is stale relative
to the dump state; it does not identify a count of unlink or create
operations.

On CPU22, codebuddy PID 1034866 is executing do_unlinkat() followed
by XFS inactivation for the same objects:

  do_unlinkat:
    name                  = "/root/.codebuddy/debug/latest"
    dentry                = 0xffff888214aa28c0
    inode                 = 0xffff888654eb2798

  xfs_inactive_ifree:
    ip                    = 0xffff888654eb2640
    &ip->i_vnode           = 0xffff888654eb2798
    i_ino                 = 7522958322

The saved register state and the later inode contents must be
distinguished. At the fault, the sampled operations-table pointer
in RAX is empty_iops and the callback in RCX is NULL. By the time
the vmcore is captured, inode->i_op instead points to
xfs_inline_symlink_inode_operations, whose get_link callback is
xfs_vn_get_link_inline.

The XFS recycle path explains how this intermediate table can become
visible to an old reader:

  xfs_iget_cache_hit()
    -> xfs_reinit_inode()
      -> inode_init_always()
        -> inode->i_op = &empty_iops

Exiting the recycling task's own RCU read-side critical section does
not wait for the walker's critical section to finish. Eventual
call_rcu() freeing protects object memory, but does not prevent
in-place reinitialisation of the retained object.

These observations support recycling across the old reader's inode
snapshot. They do not identify the reinitialising task: PID 1034866
is the unlinker observed at dump time, not an established writer of
empty_iops. No scheduling delay responsible for widening the race
window was captured.

Sample the operations-table pointer and callback once, then recheck
the saved dentry sequence before invoking the callback in RCU mode.
Return -ECHILD if the sequence changed or the sampled callback is
NULL, allowing lookup to retry without invoking that callback.

This revisits Ian Kent's January 2022 proposal with additional crash
evidence identifying empty_iops as the sampled operations table.
Rejecting RCU-walk inside a filesystem get_link handler cannot
protect this pre-callback failure, since the handler is never entered.

This check targets the observed stale-snapshot callback invocation.
It does not replace filesystem guarantees about inode identity or
symlink-body lifetime, and does not protect against changes after
the revalidation.

Link: https://lore.kernel.org/all/164180589176.86426.501271559065590169.stgit@mickey.themaw.net/
Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
---

RFC notes:

The crash was observed on 5.4.119-19.0009.44. The patch targets
current mainline; a mainline reproduction has not yet been obtained.

This is additional evidence for the previously discussed failure
mode, not a claim that the NULL-callback race is new.

The diff is derived from Ian Kent's original fs/namei.c proposal,
extended to sample i_op once and to reject a NULL callback.

Would this defensive check be acceptable independently of a broader
XFS inode-lifetime change? If not, what companion change would be
required before reconsidering it?

Base:
141b164bbe186423e295b139e40e8e2d11cf1341

Testing:
Build-tested: make fs/namei.o with the change applied (rc=0, no new
warnings). The reported crash kernel is 5.4.119-19.0009.44; a
mainline reproduction has not yet been obtained, so no runtime
testing of the fix itself has been performed.
 fs/namei.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 925aeb63bfa1..20c2c06ec3e9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2063,10 +2063,16 @@ static noinline const char *pick_link(struct nameidata *nd, struct path *link,
 
 	res = READ_ONCE(inode->i_link);
 	if (!res) {
+		const struct inode_operations *i_op;
 		const char * (*get)(struct dentry *, struct inode *,
 				struct delayed_call *);
-		get = inode->i_op->get_link;
+		i_op = READ_ONCE(inode->i_op);
+		get = READ_ONCE(i_op->get_link);
 		if (nd->flags & LOOKUP_RCU) {
+			/* Reject a stale snapshot before invoking the callback. */
+			if (unlikely(read_seqcount_retry(&link->dentry->d_seq,
+							last->seq) || !get))
+				return ERR_PTR(-ECHILD);
 			res = get(NULL, inode, &last->done);
 			if (res == ERR_PTR(-ECHILD) && try_to_unlazy(nd))
 				res = get(link->dentry, inode, &last->done);
-- 
2.43.7

