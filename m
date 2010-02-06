Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o16KaeQ1243429 for <xfs@oss.sgi.com>; Sat, 6 Feb 2010 14:36:41 -0600
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id D54841383C07
	for <xfs@oss.sgi.com>; Sat,  6 Feb 2010 12:37:50 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id 0wkvDxkFew9OBkpe for <xfs@oss.sgi.com>;
	Sat, 06 Feb 2010 12:37:50 -0800 (PST)
Subject: Abysmal performance with XFS on LVM on md (raid1)
From: Torsten Landschoff <t.landschoff@gmx.net>
Date: Sat, 06 Feb 2010 21:37:43 +0100
Message-ID: <1265488663.2739.24.camel@sharokan.intern>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

Hi List,

A few days before I went to do a few test builds of wxWidgets on my home
system which I recently upgraded. I was quite surprised when it
performed much worse than my old notebook.

Turns out that this is related to barriers support:

$ time tar xzf wxwidgets2.8_2.8.10.1.orig.tar.gz 

real	1m10.899s
user	0m2.996s
sys	0m2.088s

$ time rm -rf wxwidgets2.8-2.8.10.1.orig

real	3m9.067s
user	0m0.036s
sys	0m1.352s

$ sudo mount -o remount,nobarrier /dev/vgsys/home /home

$ time tar xzf wxwidgets2.8_2.8.10.1.orig.tar.gz 

real	0m1.640s
user	0m1.264s
sys	0m1.200s

$ time rm -rf wxwidgets2.8-2.8.10.1.orig

real	0m2.783s
user	0m0.024s
sys	0m0.796s


I knew that barriers could cause some slowdowns but this is above my
worst estimations. Truth to be told, I did not notice that barriers are
enabled in my setup now and found the commit that affected xfs
performance the hard way (using git bisect). Here is the bisect log:

git bisect start
# bad: [b4bdd73ce865213a5653dc424873e8da37e858cc] Linux 2.6.32.7
git bisect bad b4bdd73ce865213a5653dc424873e8da37e858cc
# good: [07a2039b8eb0af4ff464efd3dfd95de5c02648c6] Linux 2.6.30
git bisect good 07a2039b8eb0af4ff464efd3dfd95de5c02648c6
# bad: [19720737187aaee006afb20e63be5e9eddc505a8] sky2: hold RTNL when
doing suspend/shutdown operations
git bisect bad 19720737187aaee006afb20e63be5e9eddc505a8
# good: [49809d6a511960e5ccfb85b780894f45ac119065] V4L/DVB (11970):
gspca - ov519: Add support for the ov518 bridge.
git bisect good 49809d6a511960e5ccfb85b780894f45ac119065
# bad: [5a4f13fad1ab5bd08dea78fc55321e429d83cddf] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6
git bisect bad 5a4f13fad1ab5bd08dea78fc55321e429d83cddf
# good: [e6423407d01168f7760cdee7270d9f51d1240301] Merge branch
'for-2.6.31' of
git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6
git bisect good e6423407d01168f7760cdee7270d9f51d1240301
# good: [a200ad22bb15fe01cf222fa631687876baad5e01] Blackfin: update
anomaly lists
git bisect good a200ad22bb15fe01cf222fa631687876baad5e01
# skip: [0c26d7cc31cd81a82be3b9d7687217d49fe9c47e] Merge branch
'release' of
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
git bisect skip 0c26d7cc31cd81a82be3b9d7687217d49fe9c47e
# bad: [71f9dacd2e4d233029e9e956ca3f79531f411827] inet: Call skb_orphan
before tproxy activates
git bisect bad 71f9dacd2e4d233029e9e956ca3f79531f411827
# good: [01c031945f2755c7afaaf456088543312f2b72ea] cleanup
__writeback_single_inode
git bisect good 01c031945f2755c7afaaf456088543312f2b72ea
# good: [b81c087f6deb049023e41ce00717202a953f3939] uwb: allow WLP to be
used with IPv6.
git bisect good b81c087f6deb049023e41ce00717202a953f3939
# good: [1962f39abbb2d5643a7d59169422661a2d58793d] ocfs2: Update atime
in splice read if necessary.
git bisect good 1962f39abbb2d5643a7d59169422661a2d58793d
# good: [caf420c68afe01acd7c458ce40b85b3db5330ff5] ACPI: pci_root: use
driver data rather than list lookup
git bisect good caf420c68afe01acd7c458ce40b85b3db5330ff5
# skip: [ba52270d18fb17ce2cf176b35419dab1e43fe4a3] SLUB: Don't pass
__GFP_FAIL for the initial allocation
git bisect skip ba52270d18fb17ce2cf176b35419dab1e43fe4a3
# good: [871043bc463e7d191e7b5b00436a8852921dd833] hp-wmi: Add support
for reporting tablet state
git bisect good 871043bc463e7d191e7b5b00436a8852921dd833
# good: [d7880f10c5d42ba182a97c1fd41d41d0b8837097] thinkpad-acpi: forbid
the use of HBRV on Lenovo ThinkPads
git bisect good d7880f10c5d42ba182a97c1fd41d41d0b8837097
# good: [0c526d96a5bd86c70507b7d9372e6a26a1e3ea43] ACPI: clean up
whitespace in drivers/acpi/scan.c
git bisect good 0c526d96a5bd86c70507b7d9372e6a26a1e3ea43
# good: [281eede0328c84a8f20e0e85b807d5b51c3de4f2] switch reiserfs to
inode->i_acl
git bisect good 281eede0328c84a8f20e0e85b807d5b51c3de4f2
# skip: [9937ac0cc087b03d6d73f46a5d6b38c43626e60e] MAINTAINERS: Change
mailing list info for CRIS
git bisect skip 9937ac0cc087b03d6d73f46a5d6b38c43626e60e
# good: [0b47b5703b1cc6c3aa89663ac70e28dadedf6ccc] w1: ds2760: add
support for EEPROM read and write
git bisect good 0b47b5703b1cc6c3aa89663ac70e28dadedf6ccc
# good: [8d8890b7751387f58ce0a6428773de2fbc0fd596] netfilter:
nf_conntrack: fix conntrack lookup race
git bisect good 8d8890b7751387f58ce0a6428773de2fbc0fd596
# skip: [c82e6d450fda56cb2d4f68534173d3cd11b32f9f] Merge branch
'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus
git bisect skip c82e6d450fda56cb2d4f68534173d3cd11b32f9f
# bad: [1f2ccd00f224a4e2d6d26f590f3e6851f3deef99] ipv6: Use
rcu_barrier() on module unload.
git bisect bad 1f2ccd00f224a4e2d6d26f590f3e6851f3deef99
# bad: [a1faa69810b2af562b70b2a71c116c7d03575dd3] ipv6: avoid wraparound
for expired preferred lifetime
git bisect bad a1faa69810b2af562b70b2a71c116c7d03575dd3
# good: [8cbeb67ad50f7d68e5e83be2cb2284de8f9c03b5] dm: avoid unsupported
spanning of md stripe boundaries
git bisect good 8cbeb67ad50f7d68e5e83be2cb2284de8f9c03b5
# good: [b6280b47a7a42970d098a3059f4ebe7e55e90d8d] ipv4 routing: Ensure
that route cache entries are usable and reclaimable with caching is off
git bisect good b6280b47a7a42970d098a3059f4ebe7e55e90d8d
# good: [c4658b4e777bebf69884f4884a9bfb2f84dd71d9] Intel-IOMMU,
intr-remap: set the whole 128bits of irte when modify/free it
git bisect good c4658b4e777bebf69884f4884a9bfb2f84dd71d9
# good: [48fe112744d1ff2e899a6491633ac58a3229aabf] ACPI: ac: use .notify
method instead of installing handler directly
git bisect good 48fe112744d1ff2e899a6491633ac58a3229aabf
# skip: [0705495d9010048e293013d9d129cf723363a0a8] ACPI: pci_root:
remove unused dev/fn information
git bisect skip 0705495d9010048e293013d9d129cf723363a0a8
# bad: [60935eb21d3c5bac79618000f38f92c249d153c4] dm ioctl: support
cookies for udev
git bisect bad 60935eb21d3c5bac79618000f38f92c249d153c4
# bad: [374bf7e7f6cc38b0483351a2029a97910eadde1b] dm: stripe support
flush
git bisect bad 374bf7e7f6cc38b0483351a2029a97910eadde1b
# good: [5aa2781d964e9835c441932110484bc454b5c207] dm: store only first
barrier error
git bisect good 5aa2781d964e9835c441932110484bc454b5c207
# good: [9015df24a8008d7bea2bd3df881783ebe0dcb9af] dm: initialise tio in
alloc_tio
git bisect good 9015df24a8008d7bea2bd3df881783ebe0dcb9af
# bad: [433bcac5645508b71eab2710b6817c3ef937eba8] dm: linear support
flush
git bisect bad 433bcac5645508b71eab2710b6817c3ef937eba8


I am actually glad that barrier support is now working, but this
performance drop is just more than I had expected. Especially, since a
single barrier would suffice here - write out all the file content and
ensure the meta data is only written after the first is completed.

Any hints how to improve on this?

Greetings and thanks in advance, Torsten


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
