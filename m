Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 03:19:29 -0800 (PST)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.178])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA4BJF5q008590
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 03:19:19 -0800
Received: by py-out-1112.google.com with SMTP id u77so2534901pyb
        for <xfs@oss.sgi.com>; Sun, 04 Nov 2007 03:19:19 -0800 (PST)
Message-ID: <64bb37e0711040319l5de285c3xea64474540a51b6e@mail.gmail.com>
Date: Sun, 4 Nov 2007 12:19:19 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: writeout stalls in current -git
In-Reply-To: <20071102204258.GR995458@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_16409_14543774.1194175159246"
References: <200710221505.35397.maximlevitsky@gmail.com>
	 <393060478.03650@ustc.edu.cn>
	 <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	 <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
	 <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
	 <20071102204258.GR995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Fengguang Wu <wfg@mail.ustc.edu.cn>, Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

------=_Part_16409_14543774.1194175159246
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 11/2/07, David Chinner <dgc@sgi.com> wrote:
> That's stalled waiting on the inode cluster buffer lock. That implies
> that the inode lcuser is already being written out and the inode has
> been redirtied during writeout.
>
> Does the kernel you are testing have the "flush inodes in ascending
> inode number order" patches applied? If so, can you remove that
> patch and see if the problem goes away?

I can now confirm, that I see this also with the current mainline-git-version
I used 2.6.24-rc1-git-b4f555081fdd27d13e6ff39d455d5aefae9d2c0c
plus the fix for the sg changes in ieee1394.
Bisecting would be troublesome, as the sg changes prevent mainline to
boot with my normal config / kill my network.

treogen ~ # vmstat 10
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
-> starting emerge
 1  0      0 3627072    332 157724    0    0    97    13   41  189  2  2 94  2
 0  0      0 3607240    332 163736    0    0   599    10  332  951  2  1 93  4
 0  0      0 3601920    332 167592    0    0   380     2  218  870  1  1 98  0
 0  0      0 3596356    332 171648    0    0   404    21  182  818  0  0 99  0
 0  0      0 3579328    332 180436    0    0   878    12  147  912  1  1 97  2
 0  0      0 3575376    332 182776    0    0   236     4  244  953  1  1 95  3
 2  1      0 3571792    332 185084    0    0   232     7  256 1003  2  1 95  2
 0  0      0 3564844    332 187364    0    0   228   605  246 1167  2  1 93  4
 0  0      0 3562128    332 189784    0    0   230     4  527 1238  2  1 93  4
 0  1      0 3558764    332 191964    0    0   216    24  438 1059  1  1 93  6
 0  0      0 3555120    332 193868    0    0   199    36  406  959  0  0 92  8
 0  0      0 3552008    332 195928    0    0   197    11  458 1023  1  1 90  8
 0  0      0 3548728    332 197660    0    0   183     7  496 1086  1  1 90  8
 0  0      0 3545560    332 199372    0    0   170     8  483 1017  1  1 90  9
 0  1      0 3542124    332 201256    0    0   190     1  544 1137  1  1 88 10
 1  0      0 3536924    332 203296    0    0   195     7  637 1209  2  1 89  8
 1  1      0 3485096    332 249184    0    0   101    16 10372 4537 13  3 76  8
 2  0      0 3442004    332 279728    0    0  1086    40  219 1349  7  3 87  4
-> emerge is done reading its package database
 1  0      0 3254796    332 448636    0    0     0    27  128 8360 24  6 70  0
 2  0      0 3143304    332 554016    0    0    47    33  213 4480 16 11 72  1
-> kernel unpacked
 1  0      0 3125700    332 560416    0    0     1    20  122 1675 24  1 75  0
 1  0      0 3117356    332 567968    0    0     0   674  157 2975 24  2 73  1
 2  0      0 3111636    332 573736    0    0     0  1143  151 1924 23  1 75  1
 2  0      0 3102836    332 581332    0    0     0   890  153 1330 24  1 75  0
 1  0      0 3097236    332 587360    0    0     0   656  194 1593 24  1 74  0
 1  0      0 3086824    332 595480    0    0     0   812  235 2657 25  1 74  0
-> tar.bz2 created, installing starts now
 0  0      0 3091612    332 601024    0    0    82   708  499 2397 17  4 78  1
 0  0      0 3086088    332 602180    0    0    69  2459  769 2237  3  4 88  6
 0  0      0 3085916    332 602236    0    0     2  1752  693  949  1  2 96  1
 0  0      0 3084544    332 603564    0    0    66  4057 1176 2850  3  6 91  0
 0  0      0 3078780    332 605572    0    0    98  3194 1169 3288  5  6 89  0
 0  0      0 3077940    332 605924    0    0    17  1139  823 1547  1  2 97  0
 0  0      0 3078268    332 605924    0    0     0   888  807 1329  0  1 99  0
-> first short stall
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 3077040    332 605924    0    0     0  1950  785 1495  0  2 89  8
 0  0      0 3076588    332 605896    0    0     2  3807  925 2046  1  4 95  0
 0  0      0 3076900    332 606052    0    0    11  2564  768 1471  1  3 95  1
 0  0      0 3071584    332 607928    0    0    87  2499 1108 3433  4  6 90  0
-> second longer stall
(emerge was not able to complete a single filemove until the 'resume' line)
 0  0      0 3071592    332 607928    0    0     0   693  692 1289  0  0 99  0
 0  0      0 3072584    332 607928    0    0     0   792  731 1507  0  1 99  0
 0  0      0 3072840    332 607928    0    0     0   806  707 1521  0  1 99  0
 0  0      0 3072724    332 607928    0    0     0   782  695 1372  0  0 99  0
 0  0      0 3072972    332 607928    0    0     0   677  612 1301  0  0 99  0
 0  0      0 3072772    332 607928    0    0     0   738  681 1352  1  1 99  0
 0  0      0 3073020    332 607928    0    0     0   785  708 1328  0  1 99  0
 0  0      0 3072896    332 607928    0    0     0   833  722 1383  0  0 99  0
-> emerge resumed
 0  0      0 3069476    332 607972    0    0     2  4885  812 2062  1  4 90  5
 1  0      0 3069648    332 608068    0    0     4  4658  833 2158  1  4 93  2
 0  0      0 3064972    332 610364    0    0   106  2494 1095 3620  5  7 88  0
 0  0      0 3057536    332 612444    0    0    86  2023 1012 3440  4  6 90  0
 1  0      0 3054572    332 612368    0    0   102  1526 1024 2277  6  5 87  2
-> emerge finished, but still >100Mb of dirty data accoring to /proc/meminfo
 0  0      0 3048548    332 615764    0    0   337   659  796 1000  3  1 96  0
 0  0      0 3092100    332 615860    0    0    15   616  606 1040  1  0 99  0
 0  0      0 3092148    332 615860    0    0     0   641  622 1085  0  0 99  0
 0  0      0 3092528    332 615860    0    0     0   766  654 1055  1  1 99  0
-> slow writeout until here, might be fixed with Peters patch to scale
the background threshold
 2  0      0 3090828    332 615860    0    0     0  1804  707 1215  0  2 98  0
 0  0      0 3091056    332 615864    0    0     0  3877  831 2047  1  4 94  1
 3  0      0 3090780    332 615864    0    0     0  2048  784 1154  1  2 97  1
 0  0      0 3091096    332 615864    0    0     0  2690  751 1538  0  3 96  1
 0  1      0 3091056    332 615864    0    0     0  2018  748  866  0  2 95  2
 2  0      0 3092960    332 615864    0    0     0  2076  719 1118  0  2 97  0
-> writeout "done", /proc/meminfo showed 0kb of dirty data remaining
 0  0      0 3093072    332 615864    0    0     0   645  646 1104  0  0 99  0
 0  0      0 3093532    332 615864    0    0     0   726  658 1223  0  1 99  0
 0  0      0 3093540    332 615864    0    0     0   801  699 1314  0  1 99  0
 0  0      0 3093580    332 615864    0    0     0   783  738 1350  0  1 99  0
 0  0      0 3093284    332 615920    0    0     6   746  655 1381  1  1 98  0
 0  0      0 3092872    332 615920    0    0     0   862  703 1391  1  1 98  0
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 3093224    332 615920    0    0     0   799  676 1394  0  0 99  0
 0  0      0 3093304    332 615920    0    0     0   835  672 1514  1  1 98  0
 0  0      0 3093476    332 615920    0    0     0   784  641 1404  1  1 98  0
 0  0      0 3093264    332 615920    0    0     0   722  626 1483  1  1 99  0
 0  0      0 3093476    332 615920    0    0     0     7  328  350  0  0 99  0
 0  0      0 3093628    332 615920    0    0     0    11  332  407  0  0 99  0
-> disks finally go idle

Torsten

.config for 2.6.24-rc1+git attached

------=_Part_16409_14543774.1194175159246
Content-Type: application/x-gzip; name=config.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f8lgztwk
Content-Disposition: attachment; filename=config.gz

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

------=_Part_16409_14543774.1194175159246--
