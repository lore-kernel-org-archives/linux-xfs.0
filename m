Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 68D607CB5
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 15:56:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8833AC005
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 13:56:40 -0700 (PDT)
Received: from albireo.enyo.de (albireo.enyo.de [5.158.152.32]) by
	cuda.sgi.com with ESMTP id LbCWjb1JB3D2ZtXA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2016 13:56:33 -0700 (PDT)
From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: Excessive xfs_inode allocations trigger OOM killer
References: <87a8f2pd2d.fsf@mid.deneb.enyo.de> <20160920203039.GI340@dastard>
Date: Tue, 20 Sep 2016 22:56:31 +0200
In-Reply-To: <20160920203039.GI340@dastard> (Dave Chinner's message of "Wed,
	21 Sep 2016 06:30:39 +1000")
Message-ID: <87mvj2mgsg.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

* Dave Chinner:

>>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME=20
>> 4121208 4121177  99%    0.88K 1030302        4   4121208K xfs_inode
>> 986286 985229  99%    0.19K  46966       21    187864K dentry
>> 723255 723076  99%    0.10K  18545       39     74180K buffer_head
>> 270263 269251  99%    0.56K  38609        7    154436K radix_tree_node
>> 140310  67409  48%    0.38K  14031       10     56124K mnt_cache
>
> That's not odd at all. It means your workload is visiting millions
> on inodes in your filesystem between serious memory pressure events.

Okay.

>> (I have attached the /proc/meminfo contents in case it offers further
>> clues.)
>>=20
>> Confronted with large memory allocations (from =E2=80=9Cmake -j12=E2=80=
=9D and
>> compiling GCC, so perhaps ~8 GiB of memory), the OOM killer kicks in
>> and kills some random process.  I would have expected that some
>> xfs_inodes are freed instead.
>
> The oom killer is unreliable and often behaves very badly, and
> that's typicaly not an XFS problem.
>
> What is the full output off the oom killer invocations from dmesg?

I've attached the dmesg output (two events).

>> The last time I saw
>> something like the slabtop output above, I could do =E2=80=9Csysctl
>> vm.drop_caches =3D 3=E2=80=9D, and the amount of memory allocated report=
ed by
>> slabtop was reduced considerably.  (I have not checked if the memory
>> was actually returned to the system.)  I have not done this now so
>> that I can gather further data for debugging.i
>
> How long did the sysctl take to run to free those inodes? A few
> seconds, or minutes?

Seconds.  Very few of them.  Definitely not minutes.

>> I am not sure what
>> triggers this huge allocation.  It could be related to my Gnus mail
>> spool (which contains lots and lots of small files).
>
> OK - does that regularly dirty lots of those small files?

I use relatime for the file system, and the atime of old mail does not
show any recent access (certainly not since the last boot).

During normal operation, Gnus doesn't even read individual files or
list mail spool directories (which contain one message per file,
similar to Maildir).  I don't do much else on the box, and the GCC
compilation I started only involes 300,000 files or so.

> What sort of storage are you using, and what fs config?

It's a Samsung SATA SSD (MZ7WD960HAGP), supposedly enterprise-grade.

Mount flags:

/dev/sda1 on / type xfs (rw,relatime,attr2,inode64,noquota)

xfs_info:

meta-data=3D/dev/sda1              isize=3D256    agcount=3D4, agsize=3D576=
90368 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D0
         =3D                       crc=3D0        finobt=3D0
data     =3D                       bsize=3D4096   blocks=3D230761472, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D112676, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_whe=
n_reporting_a_problem.3F

Core i7 X980 CPU, 6 cores, 12 threads, hyperthreading enabled.

What is BBWC?

>> Dirty:                28 kB
>> Writeback:             0 kB
>
> There's no dirty data, and dropping caches makes progress, so this
> doesn't /sound/ like reclaim is getting stalled by dirty object
> writeback. More info needed.

Sorry, this is all new to me, I don't really know where to look.


--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=oom.txt
Content-Description: OOM output

[51669.515086] make invoked oom-killer: gfp_mask=0x27000c0(GFP_KERNEL_ACCOUNT|__GFP_NOTRACK), order=2, oom_score_adj=0
[51669.515092] CPU: 1 PID: 1202 Comm: make Tainted: G          I     4.7.1fw #1
[51669.515093] Hardware name: System manufacturer System Product Name/P6X58D-E, BIOS 0701    05/10/2011
[51669.515095]  0000000000000000 ffffffff812a7d39 0000000000000000 0000000000000000
[51669.515098]  ffffffff8114e4da ffff880018707d98 0000000000000000 000000000066ca81
[51669.515100]  ffffffff8170e88d ffffffff810fe69e ffff88033fc38728 0000000200000006
[51669.515102] Call Trace:
[51669.515108]  [<ffffffff812a7d39>] ? dump_stack+0x46/0x5d
[51669.515113]  [<ffffffff8114e4da>] ? dump_header.isra.12+0x51/0x176
[51669.515116]  [<ffffffff810fe69e>] ? oom_kill_process+0x32e/0x420
[51669.515119]  [<ffffffff811003a0>] ? page_alloc_cpu_notify+0x40/0x40
[51669.515120]  [<ffffffff810fdcdc>] ? find_lock_task_mm+0x2c/0x70
[51669.515122]  [<ffffffff810fea6d>] ? out_of_memory+0x28d/0x2d0
[51669.515125]  [<ffffffff81103137>] ? __alloc_pages_nodemask+0xb97/0xc90
[51669.515128]  [<ffffffff81076d9c>] ? copy_process.part.54+0xec/0x17a0
[51669.515131]  [<ffffffff81123318>] ? handle_mm_fault+0xaa8/0x1900
[51669.515133]  [<ffffffff81078614>] ? _do_fork+0xd4/0x320
[51669.515137]  [<ffffffff81084ecc>] ? __set_current_blocked+0x2c/0x40
[51669.515140]  [<ffffffff810013ce>] ? do_syscall_64+0x3e/0x80
[51669.515144]  [<ffffffff8151433c>] ? entry_SYSCALL64_slow_path+0x25/0x25
[51669.515159] Mem-Info:
[51669.515164] active_anon:258060 inactive_anon:168997 isolated_anon:0
 active_file:404481 inactive_file:249476 isolated_file:0
 unevictable:8 dirty:17709 writeback:0 unstable:0
 slab_reclaimable:1538480 slab_unreclaimable:36079
 mapped:83111 shmem:89394 pagetables:5437 bounce:0
 free:89994 free_pcp:166 free_cma:0
[51669.515173] DMA free:15900kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB managed:15900kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[51669.515175] lowmem_reserve[]: 0 2968 11989 11989
[51669.515182] DMA32 free:183052kB min:16708kB low:20884kB high:25060kB active_anon:190432kB inactive_anon:183380kB active_file:349404kB inactive_file:290772kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3120640kB managed:3047016kB mlocked:0kB dirty:18152kB writeback:0kB mapped:71680kB shmem:69528kB slab_reclaimable:1492180kB slab_unreclaimable:33920kB kernel_stack:3872kB pagetables:4580kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[51669.515183] lowmem_reserve[]: 0 0 9021 9021
[51669.515191] Normal free:161024kB min:50784kB low:63480kB high:76176kB active_anon:841808kB inactive_anon:492608kB active_file:1268520kB inactive_file:707132kB unevictable:32kB isolated(anon):0kB isolated(file):0kB present:9437184kB managed:9237892kB mlocked:32kB dirty:52684kB writeback:112kB mapped:260764kB shmem:288048kB slab_reclaimable:4661740kB slab_unreclaimable:110396kB kernel_stack:5904kB pagetables:17168kB unstable:0kB bounce:0kB free_pcp:636kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[51669.515192] lowmem_reserve[]: 0 0 0 0
[51669.515194] DMA: 1*4kB (U) 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15900kB
[51669.515202] DMA32: 45619*4kB (UME) 73*8kB (UM) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 183060kB
[51669.515209] Normal: 39979*4kB (UE) 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 159916kB
[51669.515215] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[51669.515217] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[51669.515218] 743552 total pagecache pages
[51669.515220] 17 pages in swap cache
[51669.515221] Swap cache stats: add 2664, delete 2647, find 1052/1309
[51669.515222] Free swap  = 14645000kB
[51669.515223] Total swap = 14645244kB
[51669.515224] 3143452 pages RAM
[51669.515225] 0 pages HighMem/MovableOnly
[51669.515226] 68250 pages reserved
[51669.515226] 0 pages hwpoisoned
[51669.515227] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[51669.515234] [  645]     0   645    10290     3790      26       3        0             0 systemd-journal
[51669.515237] [  660]     0   660    10042      876      22       3        0         -1000 systemd-udevd
[51669.515239] [ 1082]     0  1082     7243      618      18       3        0             0 cron
[51669.515241] [ 1084]     0  1084     4756      447      16       3        0             0 atd
[51669.515243] [ 1086]     0  1086    13796     1184      33       3        0         -1000 sshd
[51669.515245] [ 1088]     0  1088     2650      422      11       3        0             0 inetd
[51669.515247] [ 1094]     0  1094     6112      923      18       3        0             0 smartd
[51669.515249] [ 1101]     0  1101     7067      679      19       4        0             0 systemd-logind
[51669.515251] [ 1115]   111  1115     8058      681      21       3        0             0 avahi-daemon
[51669.515253] [ 1123]   104  1123    10633      942      26       3        0          -900 dbus-daemon
[51669.515255] [ 1129]     7  1129     3178      276      11       3        0             0 lpd
[51669.515257] [ 1130]     0  1130     4819      524      15       3        0             0 irqbalance
[51669.515259] [ 1138]     0  1138     3180      290      11       3        0             0 mcelog
[51669.515261] [ 1145]   119  1145    17614      805      24       4        0             0 dictd
[51669.515263] [ 1164]     0  1164     6175      983      17       3        0             0 openvpn
[51669.515265] [ 1169]     0  1169     6102      712      17       3        0             0 openvpn
[51669.515267] [ 1175]     0  1175     6167      713      17       3        0             0 openvpn
[51669.515269] [ 1178]     0  1178     6176      982      17       4        0             0 openvpn
[51669.515272] [ 1186]   111  1186     8025       64      20       3        0             0 avahi-daemon
[51669.515274] [ 1204]     0  1204    98664     3285     125       3        0             0 libvirtd
[51669.515276] [ 1206]     0  1206    64668      836      28       3        0             0 rsyslogd
[51669.515278] [ 1217]     0  1217    17959     1142      40       3        0             0 cups-browsed
[51669.515280] [ 1223]     0  1223     1064      411       8       3        0             0 acpid
[51669.515282] [ 1281]     0  1281     3971      461      13       3        0             0 agetty
[51669.515284] [ 1285]   109  1285   563886    20472      82       4        0          -900 postgres
[51669.515286] [ 1287]     0  1287    69621     1514      40       4        0             0 lightdm
[51669.515287] [ 1295]     0  1295    69111    25134     133       4        0             0 Xorg
[51669.515289] [ 1300]   109  1300   564143      993      45       4        0             0 postgres
[51669.515291] [ 1301]   109  1301   564143     5242      53       4        0             0 postgres
[51669.515293] [ 1302]   109  1302   564143      993      43       4        0             0 postgres
[51669.515295] [ 1303]   109  1303   564219     1634      50       4        0             0 postgres
[51669.515297] [ 1304]   109  1304    20834     1080      40       3        0             0 postgres
[51669.515299] [ 1331]   126  1331     8915      979      23       3        0             0 systemd
[51669.515301] [ 1334]   126  1334    14661      567      31       3        0             0 (sd-pam)
[51669.515303] [ 1343]   126  1343     6126      455      17       3        0             0 dbus-launch
[51669.515305] [ 1344]   126  1344    10531      619      24       3        0             0 dbus-daemon
[51669.515307] [ 1346]   126  1346    84389     1348      33       3        0             0 at-spi-bus-laun
[51669.515309] [ 1350]   126  1350    10531      855      26       3        0             0 dbus-daemon
[51669.515311] [ 1353]   126  1353    31330     1541      32       3        0             0 at-spi2-registr
[51669.515313] [ 1371]   116  1371    12643     2685      25       3        0             0 unbound
[51669.515315] [ 1382]     0  1382    25854      656      21       3        0             0 chronyd
[51669.515317] [ 1392]   101  1392    25537     1097      48       3        0             0 exim4
[51669.515320] [ 1519]     0  1519    60178     1540      55       3        0             0 lightdm
[51669.515322] [ 1531]  1000  1531     8915      990      24       3        0             0 systemd
[51669.515324] [ 1534]  1000  1534    14661      568      31       3        0             0 (sd-pam)
[51669.515326] [ 1537]  1000  1537     1084      386       8       3        0             0 sh
[51669.515328] [ 1563]  1000  1563     2675      618      10       3        0             0 ssh-agent
[51669.515330] [ 1564]  1000  1564     5282      536      15       3        0             0 gpg-agent
[51669.515332] [ 1567]  1000  1567     6126      489      17       3        0             0 dbus-launch
[51669.515334] [ 1568]  1000  1568    10622      679      24       3        0             0 dbus-daemon
[51669.515336] [ 1579]  1000  1579    79791     3406      88       4        0             0 xfce4-session
[51669.515338] [ 1581]     0  1581    69853     1692      37       3        0             0 polkitd
[51669.515340] [ 1586]  1000  1586     9381     1044      22       3        0             0 xfconfd
[51669.515342] [ 1589]  1000  1589    40623     4705      83       3        0             0 xfwm4
[51669.515344] [ 1591]  1000  1591    40400     2633      80       3        0             0 Thunar
[51669.515346] [ 1592]  1000  1592    39951     3917      81       3        0             0 xfce4-panel
[51669.515348] [ 1594]  1000  1594    82142     3744      93       4        0             0 xfdesktop
[51669.515350] [ 1595]  1000  1595    81256     3647      88       4        0             0 xfsettingsd
[51669.515352] [ 1598]  1000  1598   146160    29558     186       3        0             0 emacs
[51669.515354] [ 1600]  1000  1600    57071     2670      76       3        0             0 xfce4-power-man
[51669.515356] [ 1604]  1000  1604    52829     1506      38       4        0             0 gvfsd
[51669.515358] [ 1611]  1000  1611    72407     1523      39       4        0             0 gvfsd-fuse
[51669.515360] [ 1613]     0  1613    59994     1910      50       3        0             0 upowerd
[51669.515362] [ 1620]  1000  1620    84398     1375      33       3        0             0 at-spi-bus-laun
[51669.515364] [ 1625]  1000  1625    10531      838      26       3        0             0 dbus-daemon
[51669.515366] [ 1629]  1000  1629    31299     1249      30       4        0             0 at-spi2-registr
[51669.515368] [ 1659]  1000  1659    13402     1257      31       3        0             0 gconfd-2
[51669.515370] [ 1682]  1000  1682    55945     3369      76       3        0             0 polkit-gnome-au
[51669.515372] [ 1690]  1000  1690    57664     4893      77       3        0             0 applet.py
[51669.515374] [ 1692]  1000  1692    15527     1045      36       3        0             0 xscreensaver
[51669.515376] [ 1696]  1000  1696   108808     3728     112       3        0             0 xfce4-volumed
[51669.515378] [ 1711]  1000  1711    99299     5693      96       4        0             0 xfce4-appfinder
[51669.515380] [ 1717]  1000  1717   366719    79558     576       5        0             0 firefox-esr
[51669.515382] [ 1829]  1000  1829   102836     8600     100       3        0             0 gnome-terminal-
[51669.515384] [ 1832]  1000  1832     3673      441      12       3        0             0 gnome-pty-helpe
[51669.515386] [ 1833]  1000  1833     5859      869      17       3        0             0 bash
[51669.515388] [ 2093]  1000  2093    11107     1254      26       3        0             0 ssh
[51669.515390] [ 2094]  1000  2094    11107     1273      26       3        0             0 ssh
[51669.515392] [ 2649]     0  2649    22039     1504      45       3        0             0 cupsd
[51669.515395] [ 8085]  1000  8085     5858      921      17       3        0             0 bash
[51669.515397] [ 8110]  1000  8110     3679      722      12       3        0             0 activate-dummy
[51669.515399] [ 8217]     0  8217    15269      901      35       3        0             0 sudo
[51669.515400] [ 8221]  1001  8221     6710     1809      19       3        0             0 bash
[51669.515402] [ 8270]  1001  8270     6126      488      15       3        0             0 dbus-launch
[51669.515405] [ 8271]  1001  8271    10531      587      25       3        0             0 dbus-daemon
[51669.515406] [ 8285]  1001  8285    13401     1324      33       3        0             0 gconfd-2
[51669.515409] [10494]  1000 10494     5807      831      16       3        0             0 bash
[51669.515411] [26375]  1000 26375     5904     1019      18       3        0             0 bash
[51669.515413] [29839]  1000 29839     5856      953      17       3        0             0 bash
[51669.515415] [13026]  1000 13026     5855      936      16       3        0             0 bash
[51669.515417] [13076]  1000 13076     5862      955      16       4        0             0 bash
[51669.515419] [27388]  1000 27388     5855      952      18       3        0             0 bash
[51669.515421] [ 4591]  1001  4591   266002    51643     350       4        0             0 firefox
[51669.515423] [ 4676]  1001  4676   162765    35982     234       4        0             0 Web Content
[51669.515425] [ 5764]  1000  5764     5861      974      18       3        0             0 bash
[51669.515427] [ 7237]  1000  7237     2864     1009      10       3        0             0 make
[51669.515429] [ 7252]  1000  7252     3698      739      13       3        0             0 bash
[51669.515431] [ 7266]  1000  7266     2880     1050      11       3        0             0 make
[51669.515433] [ 7271]  1000  7271     3709      764      12       3        0             0 bash
[51669.515435] [ 7316]  1000  7316     2928     1102      11       3        0             0 make
[51669.515437] [ 1174]  1000  1174     3728      794      12       3        0             0 bash
[51669.515438] [ 1202]  1000  1202     5147     3313      15       3        0             0 make
[51669.515440] [ 1983]  1000  1983     3696      690      12       3        0             0 bash
[51669.515442] [ 1985]  1000  1985    47919    39059      99       3        0             0 makeinfo
[51669.515444] [ 2249]  1000  2249     3696      673      12       3        0             0 bash
[51669.515446] [ 2250]  1000  2250    46107    37289      95       3        0             0 makeinfo
[51669.515448] [ 4754]  1000  4754     2806      636      11       3        0             0 gcc
[51669.515450] [ 4755]  1000  4755    35634    25911      73       3        0             0 gnat1
[51669.515452] [ 4776]  1000  4776     2806      616      11       3        0             0 gcc
[51669.515454] [ 4783]  1000  4783    30507    21035      67       3        0             0 gnat1
[51669.515456] [ 4819]  1000  4819     2806      627      10       3        0             0 gcc
[51669.515457] [ 4821]  1000  4821    34540    22991      69       4        0             0 gnat1
[51669.515459] [ 4938]  1000  4938     2806      616      11       3        0             0 gcc
[51669.515461] [ 4939]  1000  4939    26683    17074      56       3        0             0 gnat1
[51669.515463] [ 5029]  1000  5029     2806      627      10       3        0             0 gcc
[51669.515465] [ 5031]  1000  5031    21775    11848      45       3        0             0 gnat1
[51669.515467] [ 5082]  1000  5082     2806      618      10       3        0             0 gcc
[51669.515469] [ 5083]  1000  5083    19179     9473      44       3        0             0 gnat1
[51669.515471] [ 5111]  1000  5111     2806      629      10       3        0             0 gcc
[51669.515472] [ 5118]  1000  5118     2806      609      11       3        0             0 gcc
[51669.515474] [ 5119]  1000  5119    17218     7307      37       3        0             0 gnat1
[51669.515476] [ 5120]  1000  5120    17341     7286      36       3        0             0 gnat1
[51669.515478] [ 5134]  1000  5134     2806      635      11       3        0             0 gcc
[51669.515480] [ 5135]  1000  5135    17140     6229      36       3        0             0 gnat1
[51669.515481] Out of memory: Kill process 1717 (firefox-esr) score 11 or sacrifice child
[51669.515554] Killed process 1717 (firefox-esr) total-vm:1466876kB, anon-rss:235460kB, file-rss:82704kB, shmem-rss:68kB
[52522.292996] perf: interrupt took too long (3347 > 3345), lowering kernel.perf_event_max_sample_rate to 59750
[52595.619013] systemd-udevd invoked oom-killer: gfp_mask=0x27000c0(GFP_KERNEL_ACCOUNT|__GFP_NOTRACK), order=2, oom_score_adj=0
[52595.619016] CPU: 3 PID: 14387 Comm: systemd-udevd Tainted: G          I     4.7.1fw #1
[52595.619017] Hardware name: System manufacturer System Product Name/P6X58D-E, BIOS 0701    05/10/2011
[52595.619019]  0000000000000000 ffffffff812a7d39 0000000000000000 0000000000000000
[52595.619021]  ffffffff8114e4da ffff8802d371bd98 0000000000000000 000000000066ca81
[52595.619022]  ffffffff8170e88d ffffffff810fe69e ffff88033fc78728 0000000200000006
[52595.619024] Call Trace:
[52595.619028]  [<ffffffff812a7d39>] ? dump_stack+0x46/0x5d
[52595.619032]  [<ffffffff8114e4da>] ? dump_header.isra.12+0x51/0x176
[52595.619035]  [<ffffffff810fe69e>] ? oom_kill_process+0x32e/0x420
[52595.619037]  [<ffffffff811003a0>] ? page_alloc_cpu_notify+0x40/0x40
[52595.619038]  [<ffffffff810fdcdc>] ? find_lock_task_mm+0x2c/0x70
[52595.619039]  [<ffffffff810fea6d>] ? out_of_memory+0x28d/0x2d0
[52595.619041]  [<ffffffff81103137>] ? __alloc_pages_nodemask+0xb97/0xc90
[52595.619044]  [<ffffffff81076d9c>] ? copy_process.part.54+0xec/0x17a0
[52595.619045]  [<ffffffff8116734a>] ? inode_init_always+0xca/0x170
[52595.619047]  [<ffffffff81142a46>] ? kmem_cache_alloc+0x86/0x90
[52595.619048]  [<ffffffff81078614>] ? _do_fork+0xd4/0x320
[52595.619051]  [<ffffffff81158a6a>] ? __do_pipe_flags+0x5a/0xc0
[52595.619052]  [<ffffffff810013ce>] ? do_syscall_64+0x3e/0x80
[52595.619055]  [<ffffffff8151433c>] ? entry_SYSCALL64_slow_path+0x25/0x25
[52595.619056] Mem-Info:
[52595.619059] active_anon:551391 inactive_anon:190012 isolated_anon:0
 active_file:620904 inactive_file:319281 isolated_file:0
 unevictable:8 dirty:78102 writeback:12376 unstable:0
 slab_reclaimable:1142619 slab_unreclaimable:26701
 mapped:73319 shmem:90689 pagetables:5784 bounce:0
 free:99617 free_pcp:0 free_cma:0
[52595.619065] DMA free:15900kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB managed:15900kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[52595.619066] lowmem_reserve[]: 0 2968 11989 11989
[52595.619071] DMA32 free:277864kB min:16708kB low:20884kB high:25060kB active_anon:464736kB inactive_anon:234000kB active_file:392768kB inactive_file:404400kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3120640kB managed:3047016kB mlocked:0kB dirty:76304kB writeback:12216kB mapped:62640kB shmem:68512kB slab_reclaimable:1127152kB slab_unreclaimable:24608kB kernel_stack:3248kB pagetables:5044kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:256 all_unreclaimable? no
[52595.619072] lowmem_reserve[]: 0 0 9021 9021
[52595.619077] Normal free:104704kB min:50784kB low:63480kB high:76176kB active_anon:1740828kB inactive_anon:526048kB active_file:2090848kB inactive_file:872724kB unevictable:32kB isolated(anon):0kB isolated(file):0kB present:9437184kB managed:9237892kB mlocked:32kB dirty:236104kB writeback:37288kB mapped:230636kB shmem:294244kB slab_reclaimable:3443324kB slab_unreclaimable:82196kB kernel_stack:5664kB pagetables:18092kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[52595.619078] lowmem_reserve[]: 0 0 0 0
[52595.619079] DMA: 1*4kB (U) 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15900kB
[52595.619086] DMA32: 69433*4kB (UME) 71*8kB (UME) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 278300kB
[52595.619092] Normal: 26106*4kB (UME) 149*8kB (UM) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 105616kB
[52595.619097] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[52595.619098] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[52595.619098] 1030885 total pagecache pages
[52595.619100] 8 pages in swap cache
[52595.619101] Swap cache stats: add 2715, delete 2707, find 1052/1309
[52595.619101] Free swap  = 14644796kB
[52595.619102] Total swap = 14645244kB
[52595.619102] 3143452 pages RAM
[52595.619103] 0 pages HighMem/MovableOnly
[52595.619104] 68250 pages reserved
[52595.619104] 0 pages hwpoisoned
[52595.619105] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[52595.619109] [  645]     0   645    12443     4503      30       3        0             0 systemd-journal
[52595.619111] [  660]     0   660    10042      876      22       3        0         -1000 systemd-udevd
[52595.619113] [ 1082]     0  1082     7243      617      18       3        0             0 cron
[52595.619114] [ 1084]     0  1084     4756      446      16       3        0             0 atd
[52595.619115] [ 1086]     0  1086    13796     1095      33       3        0         -1000 sshd
[52595.619117] [ 1088]     0  1088     2650      407      11       3        0             0 inetd
[52595.619118] [ 1094]     0  1094     6112      922      18       3        0             0 smartd
[52595.619120] [ 1101]     0  1101     7067      678      19       4        0             0 systemd-logind
[52595.619121] [ 1115]   111  1115     8058      679      21       3        0             0 avahi-daemon
[52595.619122] [ 1123]   104  1123    10633      939      26       3        0          -900 dbus-daemon
[52595.619124] [ 1129]     7  1129     3178      275      11       3        0             0 lpd
[52595.619125] [ 1130]     0  1130     4819      522      15       3        0             0 irqbalance
[52595.619126] [ 1138]     0  1138     3180      270      11       3        0             0 mcelog
[52595.619128] [ 1145]   119  1145    17614      803      24       4        0             0 dictd
[52595.619129] [ 1164]     0  1164     6175      877      17       3        0             0 openvpn
[52595.619131] [ 1169]     0  1169     6102      625      17       3        0             0 openvpn
[52595.619132] [ 1175]     0  1175     6167      609      17       3        0             0 openvpn
[52595.619133] [ 1178]     0  1178     6176      872      17       4        0             0 openvpn
[52595.619135] [ 1186]   111  1186     8025       64      20       3        0             0 avahi-daemon
[52595.619136] [ 1204]     0  1204    98664     3096     125       3        0             0 libvirtd
[52595.619138] [ 1206]     0  1206    64668      831      28       3        0             0 rsyslogd
[52595.619139] [ 1217]     0  1217    17959     1136      40       3        0             0 cups-browsed
[52595.619140] [ 1223]     0  1223     1064      410       8       3        0             0 acpid
[52595.619142] [ 1281]     0  1281     3971      460      13       3        0             0 agetty
[52595.619143] [ 1285]   109  1285   563886    20317      82       4        0          -900 postgres
[52595.619145] [ 1287]     0  1287    69621     1455      40       4        0             0 lightdm
[52595.619146] [ 1295]     0  1295    69115    23661     133       4        0             0 Xorg
[52595.619147] [ 1300]   109  1300   564143      993      45       4        0             0 postgres
[52595.619149] [ 1301]   109  1301   564143     5242      53       4        0             0 postgres
[52595.619150] [ 1302]   109  1302   564143      993      43       4        0             0 postgres
[52595.619151] [ 1303]   109  1303   564219     1634      50       4        0             0 postgres
[52595.619153] [ 1304]   109  1304    20834     1065      40       3        0             0 postgres
[52595.619154] [ 1331]   126  1331     8915      901      23       3        0             0 systemd
[52595.619156] [ 1334]   126  1334    14661      567      31       3        0             0 (sd-pam)
[52595.619157] [ 1343]   126  1343     6126      454      17       3        0             0 dbus-launch
[52595.619158] [ 1344]   126  1344    10531      616      24       3        0             0 dbus-daemon
[52595.619160] [ 1346]   126  1346    84389     1333      33       3        0             0 at-spi-bus-laun
[52595.619161] [ 1350]   126  1350    10531      852      26       3        0             0 dbus-daemon
[52595.619163] [ 1353]   126  1353    31330     1532      32       3        0             0 at-spi2-registr
[52595.619164] [ 1371]   116  1371    12643     2610      25       3        0             0 unbound
[52595.619165] [ 1382]     0  1382    25854      587      21       3        0             0 chronyd
[52595.619167] [ 1392]   101  1392    25537     1097      48       3        0             0 exim4
[52595.619168] [ 1519]     0  1519    60178     1433      55       3        0             0 lightdm
[52595.619169] [ 1531]  1000  1531     8915      908      24       3        0             0 systemd
[52595.619171] [ 1534]  1000  1534    14661      568      31       3        0             0 (sd-pam)
[52595.619172] [ 1537]  1000  1537     1084      386       8       3        0             0 sh
[52595.619174] [ 1563]  1000  1563     2675      555      10       3        0             0 ssh-agent
[52595.619175] [ 1564]  1000  1564     5282      497      15       3        0             0 gpg-agent
[52595.619176] [ 1567]  1000  1567     6126      489      17       3        0             0 dbus-launch
[52595.619178] [ 1568]  1000  1568    10622      676      24       3        0             0 dbus-daemon
[52595.619179] [ 1579]  1000  1579    79791     3283      88       4        0             0 xfce4-session
[52595.619181] [ 1581]     0  1581    69853     1675      37       3        0             0 polkitd
[52595.619182] [ 1586]  1000  1586     9381     1025      22       3        0             0 xfconfd
[52595.619183] [ 1589]  1000  1589    40623     4487      83       3        0             0 xfwm4
[52595.619185] [ 1591]  1000  1591    40400     2590      80       3        0             0 Thunar
[52595.619186] [ 1592]  1000  1592    39951     3833      81       3        0             0 xfce4-panel
[52595.619187] [ 1594]  1000  1594    82142     3662      93       4        0             0 xfdesktop
[52595.619189] [ 1595]  1000  1595    81256     3506      88       4        0             0 xfsettingsd
[52595.619190] [ 1598]  1000  1598   149306    31397     193       3        0             0 emacs
[52595.619192] [ 1600]  1000  1600    57071     2586      76       3        0             0 xfce4-power-man
[52595.619193] [ 1604]  1000  1604    52829     1466      38       4        0             0 gvfsd
[52595.619194] [ 1611]  1000  1611    72407     1514      39       4        0             0 gvfsd-fuse
[52595.619196] [ 1613]     0  1613    59994     1866      50       3        0             0 upowerd
[52595.619197] [ 1620]  1000  1620    84398     1353      33       3        0             0 at-spi-bus-laun
[52595.619198] [ 1625]  1000  1625    10531      835      26       3        0             0 dbus-daemon
[52595.619200] [ 1629]  1000  1629    31299     1233      30       4        0             0 at-spi2-registr
[52595.619201] [ 1659]  1000  1659    13402     1246      31       3        0             0 gconfd-2
[52595.619203] [ 1682]  1000  1682    55945     3331      76       3        0             0 polkit-gnome-au
[52595.619204] [ 1690]  1000  1690    57664     4393      77       3        0             0 applet.py
[52595.619205] [ 1692]  1000  1692    15527     1038      36       3        0             0 xscreensaver
[52595.619207] [ 1696]  1000  1696   108808     3625     112       3        0             0 xfce4-volumed
[52595.619208] [ 1711]  1000  1711    99299     5448      96       4        0             0 xfce4-appfinder
[52595.619210] [ 1829]  1000  1829   103820     9054     103       3        0             0 gnome-terminal-
[52595.619211] [ 1832]  1000  1832     3673      441      12       3        0             0 gnome-pty-helpe
[52595.619212] [ 1833]  1000  1833     5859      869      17       3        0             0 bash
[52595.619214] [ 2093]  1000  2093    11107     1037      26       3        0             0 ssh
[52595.619215] [ 2094]  1000  2094    11107     1051      26       3        0             0 ssh
[52595.619216] [ 2649]     0  2649    22039     1496      45       3        0             0 cupsd
[52595.619218] [ 8085]  1000  8085     5858      921      17       3        0             0 bash
[52595.619219] [ 8110]  1000  8110     3679      722      12       3        0             0 activate-dummy
[52595.619220] [ 8217]     0  8217    15269      901      35       3        0             0 sudo
[52595.619222] [ 8221]  1001  8221     6710     1809      19       3        0             0 bash
[52595.619223] [ 8270]  1001  8270     6126      488      15       3        0             0 dbus-launch
[52595.619224] [ 8271]  1001  8271    10531      584      25       3        0             0 dbus-daemon
[52595.619226] [ 8285]  1001  8285    13401     1313      33       3        0             0 gconfd-2
[52595.619227] [10494]  1000 10494     5807      831      16       3        0             0 bash
[52595.619228] [26375]  1000 26375     5904     1006      18       3        0             0 bash
[52595.619230] [29839]  1000 29839     5856      953      17       3        0             0 bash
[52595.619231] [13026]  1000 13026     5855      936      16       3        0             0 bash
[52595.619232] [13076]  1000 13076     5862      955      16       4        0             0 bash
[52595.619234] [27388]  1000 27388     5855      952      18       3        0             0 bash
[52595.619236] [ 4591]  1001  4591   272499    52043     362       4        0             0 firefox
[52595.619237] [ 4676]  1001  4676   162765    35629     234       4        0             0 Web Content
[52595.619238] [ 5764]  1000  5764     5861      974      18       3        0             0 bash
[52595.619240] [ 7237]  1000  7237     2864     1009      10       3        0             0 make
[52595.619241] [ 7252]  1000  7252     3698      739      13       3        0             0 bash
[52595.619242] [ 7266]  1000  7266     2880     1057      11       3        0             0 make
[52595.619244] [ 7563]  1000  7563   266061    65632     376       4        0             0 firefox-esr
[52595.619245] [ 8324]  1000  8324     6866      815      18       3        0             0 top
[52595.619247] [18137]  1000 18137     3712      757      13       3        0             0 bash
[52595.619248] [18227]  1000 18227     2941     1081      12       3        0             0 make
[52595.619249] [ 6255]  1000  6255     3757      811      12       3        0             0 bash
[52595.619251] [ 6291]  1000  6291     5979     4181      18       3        0             0 make
[52595.619252] [14351]  1000 14351     2892      667      11       3        0             0 xg++
[52595.619253] [14354]  1000 14354     2858      658      10       3        0             0 xg++
[52595.619255] [14356]  1000 14356     2858      667      11       3        0             0 xg++
[52595.619256] [14361]  1000 14361     2721      555      11       3        0             0 collect2
[52595.619257] [14362]  1000 14362     2721      538      11       3        0             0 collect2
[52595.619259] [14363]  1000 14363     2722      539       9       3        0             0 collect2
[52595.619260] [14366]  1000 14366    97431    90358     191       3        0             0 ld
[52595.619262] [14367]  1000 14367   106377    99270     208       3        0             0 ld
[52595.619263] [14368]  1000 14368   107894   100615     209       3        0             0 ld
[52595.619264] [14377]  1000 14377     2859      642      10       3        0             0 xg++
[52595.619266] [14379]  1000 14379     2859      667      10       3        0             0 xg++
[52595.619267] [14380]  1000 14380     2721      538      10       3        0             0 collect2
[52595.619268] [14381]  1000 14381     2721      552      10       3        0             0 collect2
[52595.619270] [14382]  1000 14382   108547   101443     214       3        0             0 ld
[52595.619271] [14384]  1000 14384   102031    94943     199       3        0             0 ld
[52595.619273] [14387]     0 14387    10042      622      20       3        0             0 systemd-udevd
[52595.619274] [14388]     0 14388    10042      507      20       3        0             0 systemd-udevd
[52595.619276] Out of memory: Kill process 14382 (ld) score 15 or sacrifice child
[52595.619279] Killed process 14382 (ld) total-vm:434188kB, anon-rss:402236kB, file-rss:3536kB, shmem-rss:0kB

--=-=-=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-=-=--
