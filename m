Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38537 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729184AbfBRPni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 10:43:38 -0500
Received: by mail-qt1-f194.google.com with SMTP id 2so19641761qtb.5
        for <linux-xfs@vger.kernel.org>; Mon, 18 Feb 2019 07:43:37 -0800 (PST)
MIME-Version: 1.0
References: <CABAwU-adU9ChA7XbT5_LVGvyK_5tUmq-t3eOmbPRAGCFD3Md0g@mail.gmail.com>
 <20190218143122.GA33924@bfoster> <CABAwU-Z7dSNqfpH2wxF63C=UeBWoH8Au+P+Z8j1VERg1t_aZ5w@mail.gmail.com>
In-Reply-To: <CABAwU-Z7dSNqfpH2wxF63C=UeBWoH8Au+P+Z8j1VERg1t_aZ5w@mail.gmail.com>
From: huang jun <hjwsm1989@gmail.com>
Date: Mon, 18 Feb 2019 23:43:25 +0800
Message-ID: <CABAwU-Z6sZzvzbtycZfWiembpAeaPBQT9xuQ9scqb0zh104KMw@mail.gmail.com>
Subject: Re: inode not recycled after delete file
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

The traceback paste below, and google show some bug reports,
but i don't know whether this bug resolved or not on my linux/xfs version.
[ 1266.662594] BUG: Dentry ffff8803ae02c600{i=3D68,n=3D333} still in use
(1) [unmount of xfs sdc2]
[ 1266.662705] ------------[ cut here ]------------
[ 1266.662741] kernel BUG at fs/dcache.c:891!
[ 1266.662774] invalid opcode: 0000 [#1] SMP
[ 1266.662810] Modules linked in: tcp_diag inet_diag rbd(OE)
tcm_qla2xxx_mod(OE) qla2xxx(OE) scsi_transport_fc scsi_tgt btree(OE)
tcm_loop_mod(OE) target_core_user_mod(OE) iscsi_target_mod(OE)
target_core_mod(OE) uio iptable_filter xt_conntrack nf_nat bridge stp
llc nf_conntrack_netlink nfnetlink nf_conntrack autoipv6(OE) dm_mirror
dm_region_hash dm_log dm_mod skx_edac edac_core coretemp intel_rapl
iosf_mbi kvm_intel kvm irqbypass crc32_pclmul ghash_clmulni_intel
aesni_intel lrw gf128mul glue_helper ablk_helper cryptd ses enclosure
iTCO_wdt iTCO_vendor_support sg ipmi_ssif pcspkr ipmi_si ipmi_devintf
ipmi_msghandler mei_me nfit i2c_i801 wmi mei libnvdimm shpchp lpc_ich
acpi_power_meter sunrpc ip_tables xfs libcrc32c sd_mod crc_t10dif
crct10dif_generic ast drm_kms_helper syscopyarea sysfillrect sysimgblt
[ 1266.663497]  fb_sys_fops crct10dif_pclmul ttm crct10dif_common
crc32c_intel i40e drm igb mpt3sas ahci libahci libata dca ptp
i2c_algo_bit raid_class pps_core scsi_transport_sas i2c_core
[ 1266.663656] CPU: 31 PID: 13258 Comm: umount Tainted: G           OE
 ------------   3.10.0-693.el7.x86_64 #1
[ 1266.663725] Hardware name: XSKY XSKY XSCALER 3000/RS33M2C9S, BIOS
1.00.39 08/25/2018
[ 1266.663780] task: ffff880fa9b95ee0 ti: ffff880e41bd0000 task.ti:
ffff880e41bd0000
[ 1266.663833] RIP: 0010:[<ffffffff81218c8c>]  [<ffffffff81218c8c>]
shrink_dcache_for_umount_subtree+0x1ac/0x1c0
[ 1266.663915] RSP: 0018:ffff880e41bd3e10  EFLAGS: 00010246
[ 1266.663954] RAX: 000000000000004f RBX: ffff8803ae02c600 RCX: 00000000000=
00000
[ 1266.664004] RDX: 0000000000000000 RSI: ffff8810391cf8b8 RDI: ffff8810391=
cf8b8
[ 1266.664055] RBP: ffff880e41bd3e28 R08: 0000000000000000 R09: ffff88102f5=
2c500
[ 1266.664106] R10: 0000000000000985 R11: 0000000000000001 R12: 00000000000=
00083
[ 1266.664156] R13: ffffffffc049f000 R14: ffffffff81e8af50 R15: ffff880fa9b=
966b0
[ 1266.664208] FS:  00007f17baca0880(0000) GS:ffff8810391c0000(0000)
knlGS:0000000000000000
[ 1266.664265] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1266.664307] CR2: 00007f17ba85b074 CR3: 00000006faaec000 CR4: 00000000003=
407e0
[ 1266.664358] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 1266.664409] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 1266.664458] Stack:
[ 1266.664475]  ffff88101fabc320 ffff88101fabc000 0000000000000083
ffff880e41bd3e40
[ 1266.664538]  ffffffff8121aaff ffff88101fabc000 ffff880e41bd3e68
ffffffff812036c1
[ 1266.664600]  ffff881032f40340 0000000000000083 ffff880fa9b95ee0
ffff880e41bd3e88
[ 1266.664662] Call Trace:
[ 1266.664691]  [<ffffffff8121aaff>] shrink_dcache_for_umount+0x2f/0x60
[ 1266.664740]  [<ffffffff812036c1>] generic_shutdown_super+0x21/0x100
[ 1266.664788]  [<ffffffff81203b57>] kill_block_super+0x27/0x70
[ 1266.664836]  [<ffffffff81203e99>] deactivate_locked_super+0x49/0x60
[ 1266.664883]  [<ffffffff81204606>] deactivate_super+0x46/0x60
[ 1266.664928]  [<ffffffff812216af>] cleanup_mnt+0x3f/0x80
[ 1266.664969]  [<ffffffff81221742>] __cleanup_mnt+0x12/0x20
[ 1266.665013]  [<ffffffff810ad265>] task_work_run+0xc5/0xf0
[ 1266.665056]  [<ffffffff8102ab62>] do_notify_resume+0x92/0xb0
[ 1266.665102]  [<ffffffff816b527d>] int_signal+0x12/0x17
[ 1266.665140] Code: 00 00 48 8b 40 28 4c 8b 08 48 8b 43 30 48 85 c0
74 1b 48 8b 50 40 48 89 34 24 48 c7 c7 b8 3e 91 81 48 89 de 31 c0 e8
ed 50 48 00 <0f> 0b 31 d2 eb e5 0f 0b 66 90 66 2e 0f 1f 84 00 00 00 00
00 0f
[ 1266.667389] RIP  [<ffffffff81218c8c>]
shrink_dcache_for_umount_subtree+0x1ac/0x1c0
[ 1266.669435]  RSP <ffff880e41bd3e10>


huang jun <hjwsm1989@gmail.com> =E4=BA=8E2019=E5=B9=B42=E6=9C=8818=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=8811:13=E5=86=99=E9=81=93=EF=BC=9A
>
> Thank you for reply, i notice the warning message as you mentioned,
> and found that:
>
> [root@xefs-51 ~]# abrt-cli list --since 1550483811
> id 95c775cc6f18c083fb771a27accbb9a7a03e8515
> reason:         BUG: Dentry ffff8803ae02c600{i=3D68,n=3D333} still in use
> (1) [unmount of xfs sdc2]
> time:           2019=E5=B9=B402=E6=9C=8818=E6=97=A5 =E6=98=9F=E6=9C=9F=E4=
=B8=80 18=E6=97=B619=E5=88=8651=E7=A7=92
> uid:            0 (root)
> count:          1
> Directory:      /var/spool/abrt/vmcore-127.0.0.1-2019-02-18-18:15:31
> =E5=B7=B2=E6=8A=A5=E5=91=8A=EF=BC=9A    =E6=97=A0=E6=B3=95=E6=8A=A5=E5=91=
=8A
>
> id 224daa72a910003dceebe315d59cb9c4a2a6504e
> reason:         BUG: Dentry ffff880e3f7d8540{i=3D6e,n=3D110} still in use
> (1) [unmount of xfs sdc2]
> time:           2019=E5=B9=B402=E6=9C=8818=E6=97=A5 =E6=98=9F=E6=9C=9F=E4=
=B8=80 18=E6=97=B619=E5=88=8624=E7=A7=92
> uid:            0 (root)
> count:          1
> Directory:      /var/spool/abrt/vmcore-127.0.0.1-2019-02-18-17:41:56
> =E5=B7=B2=E6=8A=A5=E5=91=8A=EF=BC=9A    =E6=97=A0=E6=B3=95=E6=8A=A5=E5=91=
=8A
>
> =E5=B7=B2=E7=A6=81=E7=94=A8=E8=87=AA=E5=8A=A8=E6=8A=A5=E5=91=8A=E5=8A=9F=
=E8=83=BD=E3=80=82=E8=AF=B7=E8=80=83=E8=99=91=E5=90=AF=E7=94=A8=E8=AF=A5=E5=
=8A=9F=E8=83=BD=EF=BC=8C=E6=96=B9=E6=B3=95=E6=98=AF
> =E4=BD=9C=E4=B8=BA=E6=9C=89 root =E7=89=B9=E6=9D=83=E7=9A=84=E7=94=A8=E6=
=88=B7=E4=BD=BF=E7=94=A8=E5=91=BD=E4=BB=A4 'abrt-auto-reporting enabled'
>
> i will check this now.
>
> >
> > On Mon, Feb 18, 2019 at 07:18:20PM +0800, huang jun wrote:
> > > Hello
> > > Recently we have a problem on xfs.
> > >
> > > The environment is:
> > > CentOS Linux release 7.4.1708 (Core)
> > > Linux xefs-51 3.10.0-693.el7.x86_64 #1 SMP Tue Aug 22 21:09:27 UTC
> > > 2017 x86_64 x86_64 x86_64 GNU/Linux
> > >
> > > [root@xefs-51 ~]# modinfo xfs
> > > filename:       /lib/modules/3.10.0-693.el7.x86_64/kernel/fs/xfs/xfs.=
ko.xz
> > > license:        GPL
> > > description:    SGI XFS with ACLs, security attributes, no debug enab=
led
> > > author:         Silicon Graphics, Inc.
> > > alias:          fs-xfs
> > > rhelversion:    7.4
> > > srcversion:     6CAAE7A01207B73522C8412
> > > depends:        libcrc32c
> > > intree:         Y
> > > vermagic:       3.10.0-693.el7.x86_64 SMP mod_unload modversions
> > > signer:         CentOS Linux kernel signing key
> > > sig_key:        DA:18:7D:CA:7D:BE:53:AB:05:BD:13:BD:0C:4E:21:F4:22:B6=
:A4:9C
> > > sig_hashalgo:   sha256
> > >
> > > We mount /dev/sdc2 on /mnt after machine boot
> > > [root@xefs-51 ~]# df -iT /mnt/
> > > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Ino=
de =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > > /dev/sdc2      xfs  107374144       6 107374138       1% /mnt
> > > [root@xefs-51 ~]# ls /mnt
> > > jjj  kkk  xfs.strace
> > >
> > > And we add files to /mnt at first,
> > > [root@xefs-51 ~]# cp /mnt/jjj /mnt/123
> > > [root@xefs-51 ~]# df -iT /mnt
> > > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Ino=
de =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > > /dev/sdc2      xfs  107374144       7 107374137       1% /mnt
> > > [root@xefs-51 ~]# cp /mnt/jjj /mnt/111
> > > [root@xefs-51 ~]# df -iT /mnt
> > > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Ino=
de =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > > /dev/sdc2      xfs  107374144       8 107374136       1% /mnt
> > > [root@xefs-51 ~]# cp /mnt/jjj /mnt/222
> > > [root@xefs-51 ~]# df -iT /mnt
> > > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Ino=
de =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > > /dev/sdc2      xfs  107374144       9 107374135       1% /mnt
> > > [root@xefs-51 ~]# cp /mnt/jjj /mnt/333
> > > [root@xefs-51 ~]# df -iT /mnt
> > > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Ino=
de =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > > /dev/sdc2      xfs  107374144      10 107374134       1% /mnt
> > >
> > > and then remove some, but the inodes used in 'df -iT /mnt' not change=
d
> > > [root@xefs-51 ~]# rm -f /mnt/jjj
> > > [root@xefs-51 ~]# df -iT /mnt
> > > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Ino=
de =E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=8C=82=E8=
=BD=BD=E7=82=B9
> > > /dev/sdc2      xfs  107374144      10 107374134       1% /mnt
> > > [root@xefs-51 ~]# rm -f /mnt/kkk
> > > [root@xefs-51 ~]# df -iT /mnt
> > > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Ino=
de =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > > /dev/sdc2      xfs  107374144      10 107374134       1% /mnt
> > >
> > > and if we umount /mnt at this time, the machine will reboot,
> > > and no related log in /var/log/messages after boot and the inodes use=
d
> > > become normal.
> >
> > You have a filesystem that causes the machine to reboot when it is
> > unmounted? If so, you need to identify why that happens first and
> > foremost. I'd start by checking the filesystem for issues with
> > 'xfs_repair -n' after a mount cycle (to perform log recovery). After
> > that, perhaps check dmesg after each operation above before the unmount
> > to rule out any preceding errors/shutdowns putting the system in an
> > unexpected state. As for the unmount itself, I suppose you'll have to
> > find a way to get a console that shows alert output or whatnot when the
> > unmount occurs.
> >
> > Brian
> >
> > > As googled a lot, we tried some ways:
> > > 1) lsof /mnt: shows nobody use this mount point.
> > > 2) lsof |grep deleted: shows empty
> > > What should i do to find the problem out?
> > >
> > > --
> > > Thank you!
>
>
>
> --
> Thank you!
> HuangJun



--=20
Thank you!
HuangJun
