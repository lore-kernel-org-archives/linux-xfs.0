Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35883 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdHARai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 13:30:38 -0400
Received: by mail-wm0-f44.google.com with SMTP id t201so21042755wmt.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Aug 2017 10:30:37 -0700 (PDT)
Message-ID: <A3EABCF079964F4FA6058F30EBF80FD8@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <d161b07cad6536b0baf285328cf99500@mail.gmail.com>
In-Reply-To: <d161b07cad6536b0baf285328cf99500@mail.gmail.com>
Subject: Re: Metadata corruption at xfs_attr3_leaf_write_verify()
Date: Tue, 1 Aug 2017 20:30:31 +0300
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="UTF-8";
        reply-type=original
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Shyam Kaushik <shyam@zadarastorage.com>, bfoster@redhat.com, dchinner@redhat.com, david@fromorbit.com

Greetings XFS developers, David, Brian,

We did additional debugging on this issue. The problematic flow happens to 
be the following:

- New inode (regular file) is being created.
- As part of creation, due to parent directory having a default ACL, initial 
ACL is applied to the inode.
- This ACL is applied as an extended attribute with name "SGI_ACL_FILE" and 
value length of 100 bytes.
- XFS tries to add this attribute into the inline inode attribute fork area 
(AKA shortform).
- But 100 bytes is too large for the shortform, so XFS creates an empty 
shortform and then calls xfs_attr_shortform_to_leaf()
- This calls xfs_attr3_leaf_create() and creates a leaf with zero 
attributes.
- Before XFS is able to add the attribute to the leaf, the xfsaild thread 
wants to write this leaf to disk, and trips over the assert in 
xfs_attr3_leaf_verify, that ichdr.count should not be 0

So this seems like a race condition, where xfsaild writes a 
not-fully-prepared xfs_buf to disk. To my understanding this can lead to 
different kinds of corruptions.

Proof:
We added prints in various places to catch this problem. Below [1] is the 
part of the kernel log that shows the problem. The relevant inode is 
111236446948, and the relevant xfs_buf->b_bn is 0x1156aacf60. Thread 17576 
is the one that wants to add a first attribute to an empty leaf. Thread 
13689 is the one that wants to write the xfs_buf prematurely.

Kernel is 3.18.19.

Thanks,
Alex.

[1]
Aug  1 10:44:23.787897 vsa-0000000a-vc-0 kernel: [177522.830217] 
[17576][at]xfs [xfs_attr_shortform_to_leaf:687] XFS(dm-79): 
ino[111236446948] SHORTFORM-TO-LEAF count=0
Aug  1 10:44:23.788035 vsa-0000000a-vc-0 kernel: [177522.830328] 
[25402][at]xfs [xfs_attr_remove:432] XFS(dm-79): ino[111236446947] 
xfs_attr_remove(NTACL)
Aug  1 10:44:23.788038 vsa-0000000a-vc-0 kernel: [177522.830344] 
[25402][at]xfs [xfs_attr_leaf_addname:653] XFS(dm-79): ino[111236446947] 
bp[0x1156aa1770] ADD [SAMBA_PAI] xfs_attr3_leaf_add()
Aug  1 10:44:23.788039 vsa-0000000a-vc-0 kernel: [177522.830346] 
[25402][at]xfs [xfs_attr3_leaf_add:1134] XFS(dm-79): ino[111236446947] 
bp[0x1156aa1770] LEAF ADD [SAMBA_PAI:€]
Aug  1 10:44:23.788040 vsa-0000000a-vc-0 kernel: [177522.830348] 
[25402][at]xfs [xfs_attr3_leaf_add:1194] XFS(dm-79): ino[111236446947] 
bp[0x1156aa1770] LEAF ADD [SAMBA_PAI:€] leaf.count=2
Aug  1 10:44:23.788040 vsa-0000000a-vc-0 kernel: [177522.830386] 
[17576][at]xfs [xfs_attr3_leaf_create:1004] XFS(dm-79): ino[111236446948] 
bp[0x1156aacf60] NEW LEAF
Aug  1 10:44:23.788041 vsa-0000000a-vc-0 kernel: [177522.830391] 
[17576][at]xfs [xfs_attr_shortform_to_leaf:757] XFS(dm-79): 
ino[111236446948] bp[0x1156aacf60] SHORTFORM-TO-LEAF leaf.count=0
Aug  1 10:44:23.788635 vsa-0000000a-vc-0 kernel: [177522.830780] 
[25402][at]xfs [xfs_attr_leaf_addname:653] XFS(dm-79): ino[111236446947] 
bp[0x1156aa1770] ADD [NTACL] xfs_attr3_leaf_add()
Aug  1 10:44:23.788641 vsa-0000000a-vc-0 kernel: [177522.830783] 
[25402][at]xfs [xfs_attr3_leaf_add:1134] XFS(dm-79): ino[111236446947] 
bp[0x1156aa1770] LEAF ADD [NTACL:]
Aug  1 10:44:23.788642 vsa-0000000a-vc-0 kernel: [177522.830785] 
[25402][at]xfs [xfs_attr3_leaf_add:1194] XFS(dm-79): ino[111236446947] 
bp[0x1156aa1770] LEAF ADD [NTACL:] leaf.count=3
Aug  1 10:44:23.794652 vsa-0000000a-vc-0 kernel: [177522.836690] 
[14069][at]xfs [xfs_attr_leaf_addname:653] XFS(dm-79): ino[147144507861] 
bp[0x1121416a48] ADD [SGI_ACL_FILE] xfs_attr3_leaf_add()
Aug  1 10:44:23.794666 vsa-0000000a-vc-0 kernel: [177522.836697] 
[14069][at]xfs [xfs_attr3_leaf_add:1134] XFS(dm-79): ino[147144507861] 
bp[0x1121416a48] LEAF ADD [SGI_ACL_FILE:]
Aug  1 10:44:23.794667 vsa-0000000a-vc-0 kernel: [177522.836702] 
[14069][at]xfs [xfs_attr3_leaf_add:1194] XFS(dm-79): ino[147144507861] 
bp[0x1121416a48] LEAF ADD [SGI_ACL_FILE:] leaf.count=2
Aug  1 10:44:23.794669 vsa-0000000a-vc-0 kernel: [177522.836709] 
[14069][at]xfs [xfs_attr_leaf_addname:731] XFS(dm-79): ino[147144507861] ADD 
[SGI_ACL_FILE] XFS_DA_OP_RENAME=>xfs_attr3_leaf_flipflags()
Aug  1 10:44:23.794670 vsa-0000000a-vc-0 kernel: [177522.836715] 
[14069][at]xfs [xfs_attr_leaf_addname:765] XFS(dm-79): ino[147144507861] 
bp[0x1121416a48] ADD [SGI_ACL_FILE] 
XFS_DA_OP_RENAME=>xfs_attr3_leaf_remove()
Aug  1 10:44:23.794670 vsa-0000000a-vc-0 kernel: [177522.836718] 
[14069][at]xfs [xfs_attr3_leaf_remove:1889] XFS(dm-79): ino[147144507861] 
bp[0x1121416a48] leaf.count=2 REMOVE idx=1
Aug  1 10:44:23.794671 vsa-0000000a-vc-0 kernel: [177522.836722] 
[14069][at]xfs [xfs_attr3_leaf_remove:2020] XFS(dm-79): ino[147144507861] 
bp[0x1121416a48] leaf.count=1 REMOVE DONE idx=1
Aug  1 10:44:23.800954 vsa-0000000a-vc-0 kernel: [177522.840338] 
[13689][at]xfs*[xfs_attr3_leaf_verify:202] XFS(dm-79): ichdr.count==0 
bp[0x1156aacf60]
Aug  1 10:44:23.800971 vsa-0000000a-vc-0 kernel: [177522.840370] XFS 
(dm-79): Metadata corruption detected at 
xfs_attr3_leaf_write_verify+0xe5/0x100 [xfs], block 0x1156aacf60
Aug  1 10:44:23.800972 vsa-0000000a-vc-0 kernel: [177522.841673] XFS 
(dm-79): Unmount and run xfs_repair
Aug  1 10:44:23.800973 vsa-0000000a-vc-0 kernel: [177522.842415] XFS 
(dm-79): First 64 bytes of corrupted metadata buffer:
Aug  1 10:44:23.802201 vsa-0000000a-vc-0 kernel: [177522.843467] 
ffff88083286a000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00 
................
Aug  1 10:44:23.804028 vsa-0000000a-vc-0 kernel: [177522.844637] 
ffff88083286a010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... 
..........
Aug  1 10:44:23.804032 vsa-0000000a-vc-0 kernel: [177522.845487] 
ffff88083286a020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
Aug  1 10:44:23.804034 vsa-0000000a-vc-0 kernel: [177522.846419] 
ffff88083286a030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
Aug  1 10:44:23.805714 vsa-0000000a-vc-0 kernel: [177522.847330] XFS 
(dm-79): xfs_do_force_shutdown(0x8) called from line 1244 of file 
/mnt/homes/alex/zadara-kernel-3.18-fixes//fs/xfs/xfs_buf.c.  Return address 
= 0xffffffffc1024a40
Aug  1 10:44:23.805721 vsa-0000000a-vc-0 kernel: 
[177522.847334] ------------[ cut here ]------------
Aug  1 10:44:23.805723 vsa-0000000a-vc-0 kernel: [177522.847374] WARNING: 
CPU: 3 PID: 13689 at 
/mnt/homes/alex/zadara-kernel-3.18-fixes//fs/xfs/zxfs.c:40 
zxfs_error+0x6a/0x290 [xfs]()
Aug  1 10:44:23.805724 vsa-0000000a-vc-0 kernel: [177522.847376] XFS(dm-79): 
SHUTDOWN!!! old_flags=0x0 new_flags=0x8
Aug  1 10:44:23.805726 vsa-0000000a-vc-0 kernel: [177522.847377] Modules 
linked in: xt_nat(E) veth(E) xt_addrtype(E) br_netfilter(E) xfrm_user(E) 
xfrm4_tunnel(E) tunnel4(E) ipcomp(E) xfrm_ipcomp(E) esp4(E) ah4(E) 8021q(E) 
garp(E) mrp(E) xt_multiport(E) xfs(OE) sd_mod(E) ib_iser(OE) iscsi_tcp(OE) 
libiscsi_tcp(OE) libiscsi(OE) scsi_transport_iscsi(OE) bonding(E) 
dm_zcache(OE) btrfs(OE) raid456(OE) async_raid6_recov(E) async_memcpy(E) 
async_pq(E) async_xor(E) xor(E) async_tx(E) raid6_pq(E) raid1(OE) md_mod(OE) 
rdma_ucm(OE) ib_uverbs(OE) mlx4_ib(OE) mlx4_en(OE) ipt_MASQUERADE(E) 
nf_nat_masquerade_ipv4(E) iptable_nat(E) nf_nat_ipv4(E) nf_nat(E) 
nf_conntrack_ipv4(E) nf_defrag_ipv4(E) xt_conntrack(E) nf_conntrack(E) 
ipt_REJECT(E) nf_reject_ipv4(E) xt_CHECKSUM(E) iptable_mangle(E) 
xt_tcpudp(E) bridge(E) stp(E) llc(E) vxlan(E) ip6_udp_tunnel(E) 
udp_tunnel(E) ptp(E) pps_core(E) ip6table_filter(E) ip6_tables(E) 
iptable_filter(E) ip_tables(E) x_tables(E) mlx4_core(OE) deflate(E) ctr(E) 
twofish_generic(E) twofish_avx_x86_64(E) twofish_x86_64_3way(E) 
twofish_x86_64(E) twofish_common(E) camellia_generic(E) 
camellia_aesni_avx2(E) camellia_aesni_avx_x86_64(E) camellia_x86_64(E) 
serpent_avx2(E) serpent_avx_x86_64(E) serpent_sse2_x86_64(E) xts(E) 
serpent_generic(E) blowfish_generic(E) blowfish_x86_64(E) blowfish_common(E) 
cast5_avx_x86_64(E) cast5_generic(E) cast_common(E) des3_ede_x86_64(E) 
des_generic(E) cmac(E) xcbc(E) rmd160(E) crypto_null(E) af_key(E) 
xfrm_algo(E) isert_scst(OE) rdma_cm(OE) iw_cm(OE) ib_cm(OE) ib_sa(OE) 
ib_mad(OE) ib_core(OE) ib_addr(OE) compat(OE) iscsi_scst(OE) scst_utgt(OE) 
scst_vdisk(OE) libcrc32c(E) scst(OE) kvm_intel(E) kvm(E) crct10dif_pclmul(E) 
crc32_pclmul(E) ghash_clmulni_intel(E) aesni_intel(E) aes_x86_64(E) lrw(E) 
gf128mul(E) dm_multipath(OE) glue_helper(E) ablk_helper(E) cryptd(E) 
scsi_dh(E) mac_hid(E) serio_raw(E) nls_iso8859_1(E) nfsd(OE) auth_rpcgss(E) 
nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) ttm(E) 
drm_kms_helper(E) drm(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) 
i2c_piix4(E) i6300esb(E) lp(E) parport(E) dm_iostat(OE) zadara_utils(OE) 
ata_generic(E) pata_acpi(E) ata_piix(E) libata(E) scsi_mod(OE) psmouse(E) 
[last unloaded: xfs]
Aug  1 10:44:23.805728 vsa-0000000a-vc-0 kernel: [177522.847491] CPU: 3 PID: 
13689 Comm: xfsaild/dm-79 Tainted: G           OE  3.18.19-zadara05 #1
Aug  1 10:44:23.805736 vsa-0000000a-vc-0 kernel: [177522.847493] Hardware 
name: Bochs Bochs, BIOS Bochs 01/01/2011
Aug  1 10:44:23.805738 vsa-0000000a-vc-0 kernel: [177522.847495] 
0000000000000009 ffff8806fbb5bb38 ffffffff81710c85 0000000000000000
Aug  1 10:44:23.805739 vsa-0000000a-vc-0 kernel: [177522.847498] 
ffff8806fbb5bb88 ffff8806fbb5bb78 ffffffff81072df1 2e2e202030302030
Aug  1 10:44:23.805740 vsa-0000000a-vc-0 kernel: [177522.847501] 
0000000000000000 0000000000000008 ffff880747bbd000 0000000000000000
Aug  1 10:44:23.805740 vsa-0000000a-vc-0 kernel: [177522.847504] Call Trace:
Aug  1 10:44:23.805741 vsa-0000000a-vc-0 kernel: [177522.847512] 
[<ffffffff81710c85>] dump_stack+0x4e/0x71
Aug  1 10:44:23.805741 vsa-0000000a-vc-0 kernel: [177522.847517] 
[<ffffffff81072df1>] warn_slowpath_common+0x81/0xa0
Aug  1 10:44:23.805742 vsa-0000000a-vc-0 kernel: [177522.847520] 
[<ffffffff81072e56>] warn_slowpath_fmt+0x46/0x50
Aug  1 10:44:23.805743 vsa-0000000a-vc-0 kernel: [177522.847538] 
[<ffffffffc103f423>] ? xfs_notice+0x53/0x60 [xfs]
Aug  1 10:44:23.805744 vsa-0000000a-vc-0 kernel: [177522.847566] 
[<ffffffffc107683a>] zxfs_error+0x6a/0x290 [xfs]
Aug  1 10:44:23.805744 vsa-0000000a-vc-0 kernel: [177522.847581] 
[<ffffffffc1031033>] xfs_do_force_shutdown+0x33/0x170 [xfs]
Aug  1 10:44:23.805745 vsa-0000000a-vc-0 kernel: [177522.847594] 
[<ffffffffc1024a40>] ? _xfs_buf_ioapply+0xa0/0x430 [xfs]
Aug  1 10:44:23.805745 vsa-0000000a-vc-0 kernel: [177522.847607] 
[<ffffffffc10269ab>] ? __xfs_buf_delwri_submit+0x22b/0x290 [xfs]
Aug  1 10:44:23.805746 vsa-0000000a-vc-0 kernel: [177522.847619] 
[<ffffffffc1024a40>] _xfs_buf_ioapply+0xa0/0x430 [xfs]
Aug  1 10:44:23.805747 vsa-0000000a-vc-0 kernel: [177522.847623] 
[<ffffffff8109e260>] ? wake_up_state+0x20/0x20
Aug  1 10:44:23.805754 vsa-0000000a-vc-0 kernel: [177522.847634] 
[<ffffffffc10269ab>] ? __xfs_buf_delwri_submit+0x22b/0x290 [xfs]
Aug  1 10:44:23.805755 vsa-0000000a-vc-0 kernel: [177522.847645] 
[<ffffffffc10265d8>] xfs_buf_submit+0x68/0x210 [xfs]
Aug  1 10:44:23.805756 vsa-0000000a-vc-0 kernel: [177522.847656] 
[<ffffffffc10269ab>] __xfs_buf_delwri_submit+0x22b/0x290 [xfs]
Aug  1 10:44:23.805756 vsa-0000000a-vc-0 kernel: [177522.847667] 
[<ffffffffc10277c0>] ? xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
Aug  1 10:44:23.805757 vsa-0000000a-vc-0 kernel: [177522.847683] 
[<ffffffffc1057090>] ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
Aug  1 10:44:23.805758 vsa-0000000a-vc-0 kernel: [177522.847695] 
[<ffffffffc10277c0>] xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
Aug  1 10:44:23.805759 vsa-0000000a-vc-0 kernel: [177522.847710] 
[<ffffffffc10572bb>] xfsaild+0x22b/0x630 [xfs]
Aug  1 10:44:23.805759 vsa-0000000a-vc-0 kernel: [177522.847724] 
[<ffffffffc1057090>] ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
Aug  1 10:44:23.805760 vsa-0000000a-vc-0 kernel: [177522.847728] 
[<ffffffff810911b9>] kthread+0xc9/0xe0
Aug  1 10:44:23.805760 vsa-0000000a-vc-0 kernel: [177522.847731] 
[<ffffffff810910f0>] ? kthread_create_on_node+0x180/0x180
Aug  1 10:44:23.805761 vsa-0000000a-vc-0 kernel: [177522.847736] 
[<ffffffff81717918>] ret_from_fork+0x58/0x90
Aug  1 10:44:23.805762 vsa-0000000a-vc-0 kernel: [177522.847745] 
[<ffffffff810910f0>] ? kthread_create_on_node+0x180/0x180


-----Original Message----- 
From: Shyam Kaushik
Sent: Wednesday, July 26, 2017 3:18 PM
To: Alex Lyakas ; yair@zadarastorage.com
Subject: FW: Metadata corruption at xfs_attr3_leaf_write_verify()

-----Original Message-----
From: Brian Foster [mailto:bfoster@redhat.com]
Sent: 26 July 2017 17:46
To: Shyam Kaushik
Cc: dchinner@redhat.com; Dave Chinner; linux-xfs@vger.kernel.org
Subject: Re: Metadata corruption at xfs_attr3_leaf_write_verify()

On Wed, Jul 26, 2017 at 10:52:50AM +0530, Shyam Kaushik wrote:
> Hi Dave,
>
> From time to time we hit an xfs corruption when xattr leaf is attempted
to
> be written when it has ichdr.count==0.
>
> We are on an old kernel 3.18.19. We managed to capture xfs trace buffer
> closer to the problem time.
>
> This is the corruption report
> Jul 20 05:22:27.189727 node1 kernel: [466290.765299] XFS (dm-78):
Metadata
> corruption detected at xfs_attr3_leaf_write_verify+0xe5/0x100 [xfs],
block
> 0x9698734d8
> Jul 20 05:22:27.189741 node1 kernel: [466290.767279] XFS (dm-78):
Unmount
> and run xfs_repair
> Jul 20 05:22:27.189743 node1 kernel: [466290.768022] XFS (dm-78):
First 64
> bytes of corrupted metadata buffer:
> Jul 20 05:22:27.191635 node1 kernel: [466290.768832]
ffff88002b4bf000: 00
> 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> Jul 20 05:22:27.192949 node1 kernel: [466290.770163]
ffff88002b4bf010: 10
> 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> Jul 20 05:22:27.192953 node1 kernel: [466290.771264]
ffff88002b4bf020: 00
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Jul 20 05:22:27.195921 node1 kernel: [466290.772815]
ffff88002b4bf030: 00
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>
> From xfs xattr debug trace, it appears that a file is created within a
> directory having default ACL set. This causes file creation to insert
xattr
> leaf during file creation. This completes queuing an AIL. Immediately
after
> this an explicit xfs_setattr is being done on the same file which alters
the
> default ACL & this causes default ACL to be removed/added. It looks like
> this 2nd set attr is somehow influencing the first AIL entry that it is
> being seen with ichr.count==0 during the write.
>

I didn't notice anything on a quick pass through the code that would
lead to this situation. It looks to me that the initial attr creates the
leaf (where count is initialized to 0), but then adds the xattr in the
same transaction (which should bump ichdr.count). The next set of
SGI_ACL_FILE calls xfs_attr_leaf_add[_work]() before it rolls the
transaction, which looks like it should bump ichdr.count again before we
flip the inactive flags and remove the old attr.

The output above clearly shows ichdr.count == 0, so I could easily be
missing something or something else could be going on here. Unless
somebody else chimes in with something more concrete, could you add a
trace_printk() statement to xfs_attr3_leaf_verify() at the appropriate
point where the verifier fails and re-collect the above tracepoint data?
You could print out bp->b_bno just so we can correspond the log message
to the tracepoint, but otherwise I'm just more curious to see where in
the sequence of the xattr replace that the verifier happens to trigger
and fail.

Note that when you enable the attr tracepoints, you may have to include
'-e print' to make sure the trace_printk() is enabled as well. E.g.,
something like 'trace-cmd start -e xfs:xfs_attr_* -e print' should work.

Brian

> I can pass the full xfs debug trace if required. Here is the snippet of
> debug trace causing the issue
>
>            <...>-18953 [004] ...1 466290.749358: xfs_attr_sf_create: dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.749359: xfs_attr_sf_addname:
dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.749361: xfs_attr_sf_lookup: dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.749362: xfs_attr_sf_to_leaf:
dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.749430: xfs_attr_leaf_create:
dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.749454: xfs_attr_leaf_addname:
dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.749456: xfs_attr_leaf_lookup:
dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.749457: xfs_attr_leaf_add: dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.749458: xfs_attr_leaf_add_work:
dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.749649: xfs_getattr: dev 253:78
ino
> 0x1749833903
>            <...>-18953 [004] ...1 466290.749908: xfs_attr_leaf_get: dev
> 253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 1024 hashval
> 0xea9061c8 op_flags
>            <...>-18953 [004] ...1 466290.749910: xfs_attr_leaf_lookup:
dev
> 253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 1024 hashval
> 0xea9061c8 op_flags
>            <...>-18953 [004] ...1 466290.749918: xfs_getattr: dev 253:78
ino
> 0x1749833903
>            <...>-18953 [004] ...1 466290.749931: xfs_attr_leaf_get: dev
> 253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 1024 hashval
> 0x487716dd op_flags
>            <...>-18953 [004] ...1 466290.749932: xfs_attr_leaf_lookup:
dev
> 253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 1024 hashval
> 0x487716dd op_flags
>            <...>-18953 [004] ...1 466290.749984: xfs_getattr: dev 253:78
ino
> 0x1749833903
>            <...>-18953 [004] ...1 466290.749990: xfs_getattr: dev 253:78
ino
> 0x1749833903
>            <...>-18953 [004] ...1 466290.750063: xfs_setattr: dev 253:78
ino
> 0x1749833903
>            <...>-18953 [004] ...1 466290.750257: xfs_attr_leaf_addname:
dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750260: xfs_attr_leaf_lookup:
dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750261: xfs_attr_leaf_replace:
dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750262: xfs_attr_leaf_add: dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags RENAME|ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750262: xfs_attr_leaf_add_work:
dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags RENAME|ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750270:
xfs_attr_leaf_flipflags:
> dev 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
> hashval 0x275b19c4 op_flags RENAME|ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750275: xfs_attr_leaf_remove:
dev
> 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval
> 0x275b19c4 op_flags RENAME|ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750461:
xfs_attr_leaf_removename:
> dev 253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 0 hashval
> 0xea9061c8 op_flags OKNOENT
>            <...>-18953 [004] ...1 466290.750463: xfs_attr_leaf_lookup:
dev
> 253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 0 hashval
0xea9061c8
> op_flags OKNOENT
>            <...>-18953 [004] ...1 466290.750474: xfs_attr_leaf_addname:
dev
> 253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 49 hashval
> 0x487716dd op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750475: xfs_attr_leaf_lookup:
dev
> 253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 49 hashval
> 0x487716dd op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750476: xfs_attr_leaf_add: dev
> 253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 49 hashval
> 0x487716dd op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750476: xfs_attr_leaf_add_work:
dev
> 253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 49 hashval
> 0x487716dd op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750645: xfs_getattr: dev 253:78
ino
> 0x1749833903
>            <...>-18953 [004] ...1 466290.750648: xfs_getattr: dev 253:78
ino
> 0x1749833903
>            <...>-18953 [004] ...1 466290.750645: xfs_getattr: dev 253:78
ino
> 0x1749833903
>            <...>-18953 [004] ...1 466290.750648: xfs_getattr: dev 253:78
ino
> 0x1749833903
>            <...>-18953 [004] ...1 466290.750659: xfs_attr_leaf_get: dev
> 253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 1024 hashval
> 0x487716dd op_flags
>            <...>-18953 [004] ...1 466290.750661: xfs_attr_leaf_lookup:
dev
> 253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 1024 hashval
> 0x487716dd op_flags
>            <...>-18953 [004] ...1 466290.750744: xfs_getattr: dev 253:78
ino
> 0x1749833903
>            <...>-18953 [004] ...1 466290.750791: xfs_attr_leaf_addname:
dev
> 253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 444 hashval
0xea9061c8
> op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750793: xfs_attr_leaf_lookup:
dev
> 253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 444 hashval
0xea9061c8
> op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750794: xfs_attr_leaf_add: dev
> 253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 444 hashval
0xea9061c8
> op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.750794: xfs_attr_leaf_add_work:
dev
> 253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 444 hashval
0xea9061c8
> op_flags ADDNAME|OKNOENT
>            <...>-18953 [004] ...1 466290.751029: xfs_attr_leaf_get: dev
> 253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 1024 hashval
> 0xea9061c8 op_flags
>            <...>-18953 [004] ...1 466290.751031: xfs_attr_leaf_lookup:
dev
> 253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 1024 hashval
> 0xea9061c8 op_flags
>
>
> Any pointers/input to check this further is greatly appreciated! Thanks.
>
> --Shyam
>
> On Tue, Apr 26, 2016 at 4:10 PM, Shyam Kaushik <shyam@zadarastorage.com>
> wrote:
> Hi Eric,
>
> Yes this is a non-CRC FS. The workload is we a custom application that
> does several (16 threads) file create/read/writes/update xattrs on a XFS
> mounted over raw disk.
>
> There is no messages prior to this & we hit this once in a few days
(like
> every 4-5 days). I will try your suggestion of running with xfs_attr_*
> tracepoints all the time so that when we hit this error we have better
> info. Please let me know if you prefer to add further debug prints.
> Thanks.
>
> --Shyam
>
> > Eric Sandeen sandeen at sandeen.net wrote:
> > On Mon Apr 25 16:57:11 CDT 2016
> >
> > Is this a non-crc filesystem?
> >
> >
> > XFS_ATTR_LEAF_MAGIC is ok (if it's a non-crc filesystem)
> >
> > Looks the same as the other report, tripping on:
> >
> >        if (ichdr.count == 0)
> >                return false;
> >
> > A reproducer would be super here.  At least maybe a description of the
> > workload that hits it?
> >
> > Count is manipulated in things like attr leaf compaction...
> > Any other messages prior to this?
> >
> > How often do you hit it?
> >
> > You could also turn on xfs_attr_* tracepoints, maybe.
> >
> > -Eric
>
> -----Original Message-----
> From: Shyam Kaushik [mailto:shyam@zadarastorage.com]
> Sent: 25 April 2016 22:22
> To: 'xfs@oss.sgi.com'
> Cc: Alex Lyakas
> Subject: Metadata corruption detected at
> xfs_attr3_leaf_write_verify+0xe5/0x100
>
> Hi Dave et al,
>
> We are periodically hitting the below metadata corruption with XFS over
a
> raw disk running several file copies with xattr operations on kernel
> 3.18.19. Unmounting & running xfs_repair doesn't report any corruption.
I
> see that this was last reported here
> http://oss.sgi.com/archives/xfs/2015-12/msg00224.html
>
> Unfortunately we dont have a reproducer, but this issue happens
> periodically. We can add more debug prints & allow this issue to happen
> again. Can you pls suggest any options to debug this further? Thanks
>
> Apr 20 21:58:03 node1 kernel: [16736.286370] XFS (dm-26): Metadata
> corruption detected at xfs_attr3_leaf_write_verify+0xe5/0x100 [xfs],
block
> 0x19c5c728
> Apr 20 21:58:03 node1 kernel: [16736.289084] XFS (dm-26): Unmount and
run
> xfs_repair
> Apr 20 21:58:03 node1 kernel: [16736.290257] XFS (dm-26): First 64 bytes
> of corrupted metadata buffer:
> Apr 20 21:58:03 node1 kernel: [16736.291797] ffff880123668000: 00 00 00
00
> 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> Apr 20 21:58:03 node1 kernel: [16736.293823] ffff880123668010: 10 00 00
00
> 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> Apr 20 21:58:03 node1 kernel: [16736.297504] ffff880123668020: 00 00 00
00
> 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Apr 20 21:58:03 node1 kernel: [16736.299343] ffff880123668030: 00 00 00
00
> 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Apr 20 21:58:03 node1 kernel: [16736.301465] XFS (dm-26):
> xfs_do_force_shutdown(0x8) called from line 1244 of file
fs/xfs/xfs_buf.c.
> Return address = 0xffffffffc095cee0
> Apr 20 21:58:03 node1 kernel: [16736.301469] ------------[ cut here
> ]------------
> Apr 20 21:58:03 node1 kernel: [16736.301551] XFS(dm-26): SHUTDOWN!!!
> old_flags=0x0 new_flags=0x8
> Apr 20 21:58:03 node1 kernel: [16736.301703] CPU: 1 PID: 7857 Comm:
> xfsaild/dm-26 Tainted: G           OE  3.18.19 #1
> Apr 20 21:58:03 node1 kernel: [16736.301705] Hardware name: Bochs Bochs,
> BIOS Bochs 01/01/2011
> Apr 20 21:58:03 node1 kernel: [16736.301707]  0000000000000009
> ffff88020c5ffb38 ffffffff81710c85 0000000000000000
> Apr 20 21:58:03 node1 kernel: [16736.301711]  ffff88020c5ffb88
> ffff88020c5ffb78 ffffffff81072df1 2e2e202030302030
> Apr 20 21:58:03 node1 kernel: [16736.301715]  0000000000000000
> 0000000000000008 ffff88020c127000 0000000000000000
> Apr 20 21:58:03 node1 kernel: [16736.301718] Call Trace:
> Apr 20 21:58:03 node1 kernel: [16736.301769]  [<ffffffff81710c85>]
> dump_stack+0x4e/0x71
> Apr 20 21:58:03 node1 kernel: [16736.301780]  [<ffffffff81072df1>]
> warn_slowpath_common+0x81/0xa0
> Apr 20 21:58:03 node1 kernel: [16736.301784]  [<ffffffff81072e56>]
> warn_slowpath_fmt+0x46/0x50
> Apr 20 21:58:03 node1 kernel: [16736.301860]  [<ffffffffc09693f3>]
> xfs_do_force_shutdown+0x33/0x170 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.301921]  [<ffffffffc095cee0>] ?
> _xfs_buf_ioapply+0xa0/0x430 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.301951]  [<ffffffffc095ee4b>] ?
> __xfs_buf_delwri_submit+0x22b/0x290 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302066]  [<ffffffffc095cee0>]
> _xfs_buf_ioapply+0xa0/0x430 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302137]  [<ffffffff8109e260>] ?
> wake_up_state+0x20/0x20
> Apr 20 21:58:03 node1 kernel: [16736.302162]  [<ffffffffc095ee4b>] ?
> __xfs_buf_delwri_submit+0x22b/0x290 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302183]  [<ffffffffc095ea78>]
> xfs_buf_submit+0x68/0x210 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302241]  [<ffffffffc095ee4b>]
> __xfs_buf_delwri_submit+0x22b/0x290 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302267]  [<ffffffffc095fc60>] ?
> xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302291]  [<ffffffffc098f440>] ?
> xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302308]  [<ffffffffc095fc60>]
> xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302333]  [<ffffffffc098f66b>]
> xfsaild+0x22b/0x630 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302513]  [<ffffffffc098f440>] ?
> xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302518]  [<ffffffff810911b9>]
> kthread+0xc9/0xe0
> Apr 20 21:58:03 node1 kernel: [16736.302522]  [<ffffffff810910f0>] ?
> kthread_create_on_node+0x180/0x180
> Apr 20 21:58:03 node1 kernel: [16736.302530]  [<ffffffff81717918>]
> ret_from_fork+0x58/0x90
> Apr 20 21:58:03 node1 kernel: [16736.302549]  [<ffffffff810910f0>] ?
> kthread_create_on_node+0x180/0x180
> Apr 20 21:58:03 node1 kernel: [16736.302551] ---[ end trace
> 0bb81b88fdd6a298 ]---
>
> --Shyam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

