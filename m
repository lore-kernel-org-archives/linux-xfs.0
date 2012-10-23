Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9N8NBKT017404 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 03:23:11 -0500
Received: from smtp-tls.univ-nantes.fr (smtptls1-cha.cpub.univ-nantes.fr
	[193.52.103.113]) by cuda.sgi.com with ESMTP id
	EKEWlLlTeQDUxU6u for <xfs@oss.sgi.com>;
	Tue, 23 Oct 2012 01:24:52 -0700 (PDT)
Message-ID: <50865453.5080708@univ-nantes.fr>
Date: Tue, 23 Oct 2012 10:24:51 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
References: <508554AF.5050005@univ-nantes.fr>
In-Reply-To: <508554AF.5050005@univ-nantes.fr>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

Le 22/10/2012 16:14, Yann Dupont a =E9crit :

Hello. This mail is a follow up of a message on XFS mailing list. I had =

hang with 3.6.1, and then , damage on XFS filesystem.

3.6.1 is not alone. Tried 3.6.2, and had another hang with quite a =

different trace this time , so not really sure the 2 problems are related .
Anyway the problem is maybe not XFS, but is just a consequence of what =

seems more like kernel problems.

cc: to linux-kernel


Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.991908] =

INFO: task ceph-osd:4409 blocked for more than 120 seconds.
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.991954] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.991999] =

ceph-osd        D ffff88084c049030     0 4409      1 0x00000000
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992003]  =

ffff88084c048d60 0000000000000086 ffff880a1421de78 ffff880a17caa820
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992054]  =

ffff880a1421dfd8 ffff880a1421dfd8 ffff880a1421dfd8 ffff88084c048d60
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992105]  =

0000000003373001 ffff88084c048d60 ffff88051775cb20 ffffffffffffffff
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992156] =

Call Trace:
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992184]  =

[<ffffffff813c52fd>] ? rwsem_down_failed_common+0xbd/0x150
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992215]  =

[<ffffffff812094a3>] ? call_rwsem_down_write_failed+0x13/0x20
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992248]  =

[<ffffffff811b83e0>] ? cap_mmap_addr+0x50/0x50
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992275]  =

[<ffffffff813c3cbc>] ? down_write+0x1c/0x1d
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992303]  =

[<ffffffff810fcf74>] ? vm_mmap_pgoff+0x64/0xb0
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992331]  =

[<ffffffff8110d4cc>] ? sys_mmap_pgoff+0x5c/0x190
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992360]  =

[<ffffffff811357f1>] ? do_sys_open+0x161/0x1e0
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992387]  =

[<ffffffff813c5ffd>] ? system_call_fastpath+0x1a/0x1f
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992423] =

INFO: task ceph-osd:25297 blocked for more than 120 seconds.
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992451] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992495] =

ceph-osd        D ffff8801bce7b1a0     0 25297      1 0x00000000
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992497]  =

ffff8801bce7aed0 0000000000000086 ffff88025d903fd8 ffff880a17cab580
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992548]  =

ffff88025d903fd8 ffff88025d903fd8 ffff88025d903fd8 ffff8801bce7aed0
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992599]  =

ffff8801bce7aed0 ffff8801bce7aed0 ffff88051775cb20 ffffffffffffffff
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992650] =

Call Trace:
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992673]  =

[<ffffffff813c52fd>] ? rwsem_down_failed_common+0xbd/0x150
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992702]  =

[<ffffffff81209474>] ? call_rwsem_down_read_failed+0x14/0x30
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992732]  =

[<ffffffff813c3c9e>] ? down_read+0xe/0x10
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992759]  =

[<ffffffff8103129c>] ? do_page_fault+0x16c/0x460
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992787]  =

[<ffffffff81305862>] ? release_sock+0xd2/0x150
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992815]  =

[<ffffffff8137aceb>] ? inet_stream_connect+0x4b/0x70
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992844]  =

[<ffffffff81302b55>] ? sys_connect+0xa5/0xe0
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992871]  =

[<ffffffff811343e3>] ? fd_install+0x33/0x70
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992898]  =

[<ffffffff813c5a75>] ? page_fault+0x25/0x30
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992925] =

INFO: task ceph-osd:32469 blocked for more than 120 seconds.
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992953] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992996] =

ceph-osd        D ffff880556237b30     0 32469      1 0x00000000
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.992999]  =

ffff880556237860 0000000000000086 ffff88059fe5dfd8 ffff880a17c742e0
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.993050]  =

ffff88059fe5dfd8 ffff88059fe5dfd8 ffff88059fe5dfd8 ffff880556237860
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.993101]  =

ffff880556237860 ffff880556237860 ffff88051775cb20 ffffffffffffffff
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.993153] =

Call Trace:
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.993175]  =

[<ffffffff813c52fd>] ? rwsem_down_failed_common+0xbd/0x150
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.993204]  =

[<ffffffff81209474>] ? call_rwsem_down_read_failed+0x14/0x30
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.993233]  =

[<ffffffff813c3c9e>] ? down_read+0xe/0x10
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.993259]  =

[<ffffffff8103129c>] ? do_page_fault+0x16c/0x460
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.993286]  =

[<ffffffff81305862>] ? release_sock+0xd2/0x150
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.993314]  =

[<ffffffff8137aceb>] ? inet_stream_connect+0x4b/0x70
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.993342]  =

[<ffffffff81302b55>] ? sys_connect+0xa5/0xe0
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994484]  =

[<ffffffff811343e3>] ? fd_install+0x33/0x70
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994510]  =

[<ffffffff813c5a75>] ? page_fault+0x25/0x30
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994538] =

INFO: task ceph-osd:9660 blocked for more than 120 seconds.
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994566] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994609] =

ceph-osd        D ffff8801659f82d0     0 9660      1 0x00000000
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994612]  =

ffff8801659f8000 0000000000000086 ffff88010f6bdfd8 ffff88084f0c9ac0
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994662]  =

ffff88010f6bdfd8 ffff88010f6bdfd8 ffff88010f6bdfd8 ffff8801659f8000
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994713]  =

ffff8801659f8000 ffff8801659f8000 ffff88051775cb20 ffffffffffffffff
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994764] =

Call Trace:
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994786]  =

[<ffffffff813c52fd>] ? rwsem_down_failed_common+0xbd/0x150
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994815]  =

[<ffffffff81209474>] ? call_rwsem_down_read_failed+0x14/0x30
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994844]  =

[<ffffffff813c3c9e>] ? down_read+0xe/0x10
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994870]  =

[<ffffffff8103129c>] ? do_page_fault+0x16c/0x460
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994898]  =

[<ffffffff81305862>] ? release_sock+0xd2/0x150
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994925]  =

[<ffffffff8137aceb>] ? inet_stream_connect+0x4b/0x70
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994953]  =

[<ffffffff81302b55>] ? sys_connect+0xa5/0xe0
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.994980]  =

[<ffffffff811343e3>] ? fd_install+0x33/0x70
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995006]  =

[<ffffffff813c5a75>] ? page_fault+0x25/0x30
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995037] =

INFO: task grep:7014 blocked for more than 120 seconds.
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995064] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995108] =

grep            D ffff8800c3f69030     0  7014 7011 0x00000000
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995110]  =

ffff8800c3f68d60 0000000000000082 0000000000000000 ffff880a17ca9410
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995161]  =

ffff88002dd2ffd8 ffff88002dd2ffd8 ffff88002dd2ffd8 ffff8800c3f68d60
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995212]  =

0000000000000000 ffff8800c3f68d60 ffff88051775cb20 ffffffffffffffff
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995264] =

Call Trace:
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995286]  =

[<ffffffff813c52fd>] ? rwsem_down_failed_common+0xbd/0x150
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995428]  =

[<ffffffff81191625>] ? proc_pid_cmdline+0xa5/0x130
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995456]  =

[<ffffffff811922e0>] ? proc_info_read+0xb0/0x110
Oct 22 20:54:29 braeval.u14.univ-nantes.prive kernel: [629576.995484]  =

[<ffffffff81136454>] ? vfs_read+0xa4/0x180
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.943923] =

INFO: task ceph-osd:4409 blocked for more than 120 seconds.
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.943954] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.943999] =

ceph-osd        D ffff88084c049030     0 4409      1 0x00000000
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944003]  =

ffff88084c048d60 0000000000000086 ffff880a1421de78 ffff880a17caa820
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944055]  =

ffff880a1421dfd8 ffff880a1421dfd8 ffff880a1421dfd8 ffff88084c048d60
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944106]  =

0000000003373001 ffff88084c048d60 ffff88051775cb20 ffffffffffffffff
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944157] =

Call Trace:
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944185]  =

[<ffffffff813c52fd>] ? rwsem_down_failed_common+0xbd/0x150
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944216]  =

[<ffffffff812094a3>] ? call_rwsem_down_write_failed+0x13/0x20
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944248]  =

[<ffffffff811b83e0>] ? cap_mmap_addr+0x50/0x50
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944275]  =

[<ffffffff813c3cbc>] ? down_write+0x1c/0x1d
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944303]  =

[<ffffffff810fcf74>] ? vm_mmap_pgoff+0x64/0xb0
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944330]  =

[<ffffffff8110d4cc>] ? sys_mmap_pgoff+0x5c/0x190
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944358]  =

[<ffffffff811357f1>] ? do_sys_open+0x161/0x1e0
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944386]  =

[<ffffffff813c5ffd>] ? system_call_fastpath+0x1a/0x1f
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944423] =

INFO: task ceph-osd:25297 blocked for more than 120 seconds.
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944451] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944494] =

ceph-osd        D ffff8801bce7b1a0     0 25297      1 0x00000000
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944496]  =

ffff8801bce7aed0 0000000000000086 ffff88025d903fd8 ffff880a17cab580
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944548]  =

ffff88025d903fd8 ffff88025d903fd8 ffff88025d903fd8 ffff8801bce7aed0
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944599]  =

ffff8801bce7aed0 ffff8801bce7aed0 ffff88051775cb20 ffffffffffffffff
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944650] =

Call Trace:
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944673]  =

[<ffffffff813c52fd>] ? rwsem_down_failed_common+0xbd/0x150
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944702]  =

[<ffffffff81209474>] ? call_rwsem_down_read_failed+0x14/0x30
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944731]  =

[<ffffffff813c3c9e>] ? down_read+0xe/0x10
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944758]  =

[<ffffffff8103129c>] ? do_page_fault+0x16c/0x460
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944786]  =

[<ffffffff81305862>] ? release_sock+0xd2/0x150
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944814]  =

[<ffffffff8137aceb>] ? inet_stream_connect+0x4b/0x70
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944843]  =

[<ffffffff81302b55>] ? sys_connect+0xa5/0xe0
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944870]  =

[<ffffffff811343e3>] ? fd_install+0x33/0x70
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944897]  =

[<ffffffff813c5a75>] ? page_fault+0x25/0x30
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944923] =

INFO: task ceph-osd:12506 blocked for more than 120 seconds.
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944951] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944994] =

ceph-osd        D ffff8800227f7480     0 12506      1 0x00000000
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.944996]  =

ffff8800227f71b0 0000000000000086 0000000000000000 ffff880a17cab580
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945048]  =

ffff880468df1fd8 ffff880468df1fd8 ffff880468df1fd8 ffff8800227f71b0
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945099]  =

0000000000000000 ffff8800227f71b0 ffff88051775cb20 ffffffffffffffff
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945150] =

Call Trace:
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945172]  =

[<ffffffff813c52fd>] ? rwsem_down_failed_common+0xbd/0x150
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945201]  =

[<ffffffff81209474>] ? call_rwsem_down_read_failed+0x14/0x30
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945231]  =

[<ffffffff813c3c9e>] ? down_read+0xe/0x10
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945257]  =

[<ffffffff8103129c>] ? do_page_fault+0x16c/0x460
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945284]  =

[<ffffffff81302fb7>] ? sys_recvfrom+0x107/0x150
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945311]  =

[<ffffffff81302b55>] ? sys_connect+0xa5/0xe0
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945339]  =

[<ffffffff8100a465>] ? read_tsc+0x5/0x20
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945366]  =

[<ffffffff810828cf>] ? ktime_get_ts+0x3f/0xe0
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945394]  =

[<ffffffff811489a4>] ? poll_select_set_timeout+0x64/0x80
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945422]  =

[<ffffffff813c5a75>] ? page_fault+0x25/0x30
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945449] =

INFO: task ceph-osd:25459 blocked for more than 120 seconds.
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945476] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945520] =

ceph-osd        D ffff8803fc809d90     0 25459      1 0x00000000
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945522]  =

ffff8803fc809ac0 0000000000000086 0000000000000000 ffff880a17c74990
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945573]  =

ffff880468e25fd8 ffff880468e25fd8 ffff880468e25fd8 ffff8803fc809ac0
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945624]  =

0000000000000000 ffff8803fc809ac0 ffff88051775cb20 ffffffffffffffff
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945675] =

Call Trace:
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945697]  =

[<ffffffff813c52fd>] ? rwsem_down_failed_common+0xbd/0x150
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945726]  =

[<ffffffff81209474>] ? call_rwsem_down_read_failed+0x14/0x30
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945755]  =

[<ffffffff813c3c9e>] ? down_read+0xe/0x10
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945781]  =

[<ffffffff8103129c>] ? do_page_fault+0x16c/0x460
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945808]  =

[<ffffffff81302fb7>] ? sys_recvfrom+0x107/0x150
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945835]  =

[<ffffffff81082892>] ? ktime_get_ts+0x2/0xe0
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945862]  =

[<ffffffff8100a465>] ? read_tsc+0x5/0x20
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945888]  =

[<ffffffff810828cf>] ? ktime_get_ts+0x3f/0xe0
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945914]  =

[<ffffffff811489a4>] ? poll_select_set_timeout+0x64/0x80
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945942]  =

[<ffffffff813c5a75>] ? page_fault+0x25/0x30
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945969] =

INFO: task ceph-osd:32469 blocked for more than 120 seconds.
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.945997] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.946041] =

ceph-osd        D ffff880556237b30     0 32469      1 0x00000000
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.946043]  =

ffff880556237860 0000000000000086 ffff88059fe5dfd8 ffff880a17c742e0
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.946096]  =

ffff88059fe5dfd8 ffff88059fe5dfd8 ffff88059fe5dfd8 ffff880556237860
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.946146]  =

ffff880556237860 ffff880556237860 ffff88051775cb20 ffffffffffffffff
Oct 22 20:56:29 braeval.u14.univ-nantes.prive kernel: [629696.946198] =

Call Trace:

Well. at least, after the hard reset, xfs volume was still good this time.

Old mail (send to xfs mailing list) for reference :

> Hello,
> Last week, I encountered problems with xfs volumes on several =

> machines. Kernel hanged under heavy load, I hard to hard reset. After =

> reboot, xfs volume was not able to mount, and xfs_repair didn't =

> managed to recover the volume cleanly on 2 different machines.
>
> Just to relax things, It wasn't production data, so it don't matter if =

> I recover data or not. But more important to me is to understand why =

> things went wrong...
>
> I'm using XFS since a long time, on lots of data, it's the first time =

> I encounter such a problem, but I was using unusual option : =

> filestreams, and was using kernel 3.6.1. So I wonder if it has =

> something to do with the crash.
>
> I have nothing very conclusive in the kernel logs, apart this :
>
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.569890] =

> INFO: task ceph-osd:17856 blocked for more than 120 seconds.
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.569941] =

> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.569987] =

> ceph-osd        D ffff88056416b1a0     0 17856      1 0x00000000
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.569993] =

> ffff88056416aed0 0000000000000086 ffff880590751fd8 ffff88000c67eb00
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570047] =

> ffff880590751fd8 ffff880590751fd8 ffff880590751fd8 ffff88056416aed0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570101] =

> 0000000000000001 ffff88056416aed0 ffff880a15240d00 ffff880a15240d60
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570156] =

> Call Trace:
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570187] =

> [<ffffffff81041335>] ? exit_mm+0x85/0x120
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570216] =

> [<ffffffff81042a94>] ? do_exit+0x154/0x8e0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570248] =

> [<ffffffff8114ec79>] ? file_update_time+0xa9/0x100
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570278] =

> [<ffffffff81043568>] ? do_group_exit+0x38/0xa0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570309] =

> [<ffffffff81051bc6>] ? get_signal_to_deliver+0x1a6/0x5e0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570341] =

> [<ffffffff8100223e>] ? do_signal+0x4e/0x970
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570371] =

> [<ffffffff81170e2e>] ? fsnotify+0x24e/0x340
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570402] =

> [<ffffffff8100c995>] ? fpu_finit+0x15/0x30
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570431] =

> [<ffffffff8100db34>] ? restore_i387_xstate+0x64/0x1c0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570464] =

> [<ffffffff8108e0d2>] ? sys_futex+0x92/0x1b0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570493] =

> [<ffffffff81002bf5>] ? do_notify_resume+0x75/0xc0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570525] =

> [<ffffffff813c60fa>] ? int_signal+0x12/0x17
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570553] =

> INFO: task ceph-osd:17857 blocked for more than 120 seconds.
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570583] =

> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570628] =

> ceph-osd        D ffff8801161fe720     0 17857      1 0x00000000
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570632] =

> ffff8801161fe450 0000000000000086 ffffffffffffffe0 ffff880a17c73c30
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570687] =

> ffff88011347ffd8 ffff88011347ffd8 ffff88011347ffd8 ffff8801161fe450
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570740] =

> ffff8801161fe450 ffff8801161fe450 ffff880a15240d00 ffff880a15240d60
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570794] =

> Call Trace:
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570818] =

> [<ffffffff81041335>] ? exit_mm+0x85/0x120
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570846] =

> [<ffffffff81042a94>] ? do_exit+0x154/0x8e0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570875] =

> [<ffffffff81043568>] ? do_group_exit+0x38/0xa0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570905] =

> [<ffffffff81051bc6>] ? get_signal_to_deliver+0x1a6/0x5e0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570935] =

> [<ffffffff8100223e>] ? do_signal+0x4e/0x970
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570967] =

> [<ffffffff81302d24>] ? sys_sendto+0x114/0x150
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570996] =

> [<ffffffff8108e0d2>] ? sys_futex+0x92/0x1b0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.571024] =

> [<ffffffff81002bf5>] ? do_notify_resume+0x75/0xc0
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.571054] =

> [<ffffffff813c60fa>] ? int_signal+0x12/0x17
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.571082] =

> INFO: task ceph-osd:17858 blocked for more than 120 seconds.
> Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.571111] =

> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>
-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
