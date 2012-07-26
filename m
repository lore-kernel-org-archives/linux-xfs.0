Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9ScnF006864 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:38 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LZf2uWlOgiAdqZby for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:31 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMr-0001B2-CH
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:25 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMr-0005Vr-96
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/18] xfstests: move xfs specific tests out of top directory
Date: Thu, 26 Jul 2012 19:28:06 +1000
Message-Id: <1343294892-20991-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1343294892-20991-1-git-send-email-david@fromorbit.com>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

And into tests/xfs. Tests found and moved via:

$ grep "supported_fs xfs$" [0-2]* | cut -d : -f 1 > xfs.tests
$ for i in `cat xfs.tests`; do
> git mv $i* tests/xfs/
> grep ^$i group >> tests/xfs/group
> sed -i -e "/^$i/d" group
> done

Output now looks like:

 sudo ./check -g quick -r
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test-1 3.5.0-rc5-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

xfs/170  4s
generic/120      16s
generic/248      0s
generic/213      0s
generic/256      39s
xfs/121  6s
xfs/026  11s
generic/131      1s
xfs/187  1s
generic/135      0s
....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 check                                              |    3 +-
 group                                              |  169 --------------------
 003 => tests/xfs/003                               |    0
 003.out => tests/xfs/003.out                       |    0
 004 => tests/xfs/004                               |    0
 004.out => tests/xfs/004.out                       |    0
 008 => tests/xfs/008                               |    0
 008.out => tests/xfs/008.out                       |    0
 009 => tests/xfs/009                               |    0
 009.out => tests/xfs/009.out                       |    0
 012 => tests/xfs/012                               |    0
 012.out => tests/xfs/012.out                       |    0
 016 => tests/xfs/016                               |    0
 016.out => tests/xfs/016.out                       |    0
 017 => tests/xfs/017                               |    0
 017.out => tests/xfs/017.out                       |    0
 018 => tests/xfs/018                               |    0
 018.op.irix => tests/xfs/018.op.irix               |    0
 018.op.linux => tests/xfs/018.op.linux             |    0
 018.out => tests/xfs/018.out                       |    0
 018.trans_buf => tests/xfs/018.trans_buf           |    0
 018.trans_inode => tests/xfs/018.trans_inode       |    0
 019 => tests/xfs/019                               |    0
 019.out => tests/xfs/019.out                       |    0
 021 => tests/xfs/021                               |    0
 021.out => tests/xfs/021.out                       |    0
 022 => tests/xfs/022                               |    0
 022.out.irix => tests/xfs/022.out.irix             |    0
 022.out.linux => tests/xfs/022.out.linux           |    0
 023 => tests/xfs/023                               |    0
 023.out.irix => tests/xfs/023.out.irix             |    0
 023.out.linux => tests/xfs/023.out.linux           |    0
 024 => tests/xfs/024                               |    0
 024.out => tests/xfs/024.out                       |    0
 025 => tests/xfs/025                               |    0
 025.out => tests/xfs/025.out                       |    0
 026 => tests/xfs/026                               |    0
 026.out => tests/xfs/026.out                       |    0
 027 => tests/xfs/027                               |    0
 027.out => tests/xfs/027.out                       |    0
 028 => tests/xfs/028                               |    0
 028.out => tests/xfs/028.out                       |    0
 029 => tests/xfs/029                               |    0
 029.out => tests/xfs/029.out                       |    0
 030 => tests/xfs/030                               |    0
 030.out.irix => tests/xfs/030.out.irix             |    0
 030.out.linux => tests/xfs/030.out.linux           |    0
 031 => tests/xfs/031                               |    0
 031.out.irix => tests/xfs/031.out.irix             |    0
 031.out.linux => tests/xfs/031.out.linux           |    0
 032 => tests/xfs/032                               |    0
 032.out => tests/xfs/032.out                       |    0
 033 => tests/xfs/033                               |    0
 033.out.irix => tests/xfs/033.out.irix             |    0
 033.out.linux => tests/xfs/033.out.linux           |    0
 034 => tests/xfs/034                               |    0
 034.out => tests/xfs/034.out                       |    0
 035 => tests/xfs/035                               |    0
 035.out.irix => tests/xfs/035.out.irix             |    0
 035.out.linux => tests/xfs/035.out.linux           |    0
 036 => tests/xfs/036                               |    0
 036.out.irix => tests/xfs/036.out.irix             |    0
 036.out.linux => tests/xfs/036.out.linux           |    0
 037 => tests/xfs/037                               |    0
 037.out => tests/xfs/037.out                       |    0
 038 => tests/xfs/038                               |    0
 038.out => tests/xfs/038.out                       |    0
 039 => tests/xfs/039                               |    0
 039.out.irix => tests/xfs/039.out.irix             |    0
 039.out.linux => tests/xfs/039.out.linux           |    0
 041 => tests/xfs/041                               |    0
 041.out => tests/xfs/041.out                       |    0
 042 => tests/xfs/042                               |    0
 042.out => tests/xfs/042.out                       |    0
 043 => tests/xfs/043                               |    0
 043.out.irix => tests/xfs/043.out.irix             |    0
 043.out.linux => tests/xfs/043.out.linux           |    0
 044 => tests/xfs/044                               |    0
 044.out => tests/xfs/044.out                       |    0
 045 => tests/xfs/045                               |    0
 045.out => tests/xfs/045.out                       |    0
 046 => tests/xfs/046                               |    0
 046.out => tests/xfs/046.out                       |    0
 047 => tests/xfs/047                               |    0
 047.out => tests/xfs/047.out                       |    0
 048 => tests/xfs/048                               |    0
 048.out => tests/xfs/048.out                       |    0
 049 => tests/xfs/049                               |    0
 049.out => tests/xfs/049.out                       |    0
 050 => tests/xfs/050                               |    0
 050.out => tests/xfs/050.out                       |    0
 052 => tests/xfs/052                               |    0
 052.out => tests/xfs/052.out                       |    0
 054 => tests/xfs/054                               |    0
 054.out => tests/xfs/054.out                       |    0
 055 => tests/xfs/055                               |    0
 055.out.irix => tests/xfs/055.out.irix             |    0
 055.out.linux => tests/xfs/055.out.linux           |    0
 056 => tests/xfs/056                               |    0
 056.out => tests/xfs/056.out                       |    0
 057 => tests/xfs/057                               |    0
 057.out => tests/xfs/057.out                       |    0
 058 => tests/xfs/058                               |    0
 058.out => tests/xfs/058.out                       |    0
 059 => tests/xfs/059                               |    0
 059.out => tests/xfs/059.out                       |    0
 060 => tests/xfs/060                               |    0
 060.out => tests/xfs/060.out                       |    0
 061 => tests/xfs/061                               |    0
 061.out => tests/xfs/061.out                       |    0
 063 => tests/xfs/063                               |    0
 063.out => tests/xfs/063.out                       |    0
 064 => tests/xfs/064                               |    0
 064.out => tests/xfs/064.out                       |    0
 065 => tests/xfs/065                               |    0
 065.out => tests/xfs/065.out                       |    0
 066 => tests/xfs/066                               |    0
 066.out => tests/xfs/066.out                       |    0
 067 => tests/xfs/067                               |    0
 067.out => tests/xfs/067.out                       |    0
 071 => tests/xfs/071                               |    0
 071.out => tests/xfs/071.out                       |    0
 071.out.32 => tests/xfs/071.out.32                 |    0
 071.out.64 => tests/xfs/071.out.64                 |    0
 072 => tests/xfs/072                               |    0
 072.out => tests/xfs/072.out                       |    0
 073 => tests/xfs/073                               |    0
 073.out => tests/xfs/073.out                       |    0
 078 => tests/xfs/078                               |    0
 078.out => tests/xfs/078.out                       |    0
 080 => tests/xfs/080                               |    0
 080.out => tests/xfs/080.out                       |    0
 081 => tests/xfs/081                               |    0
 081.out => tests/xfs/081.out                       |    0
 .../xfs/081.ugquota.trans_inode                    |    0
 082 => tests/xfs/082                               |    0
 082.op.irix => tests/xfs/082.op.irix               |    0
 082.op.linux => tests/xfs/082.op.linux             |    0
 082.out => tests/xfs/082.out                       |    0
 082.trans_buf => tests/xfs/082.trans_buf           |    0
 082.trans_inode => tests/xfs/082.trans_inode       |    0
 084 => tests/xfs/084                               |    0
 084.out => tests/xfs/084.out                       |    0
 085 => tests/xfs/085                               |    0
 085.out => tests/xfs/085.out                       |    0
 086 => tests/xfs/086                               |    0
 086.out => tests/xfs/086.out                       |    0
 087 => tests/xfs/087                               |    0
 087.out => tests/xfs/087.out                       |    0
 090 => tests/xfs/090                               |    0
 090.out => tests/xfs/090.out                       |    0
 092 => tests/xfs/092                               |    0
 092.out => tests/xfs/092.out                       |    0
 094 => tests/xfs/094                               |    0
 094.out => tests/xfs/094.out                       |    0
 095 => tests/xfs/095                               |    0
 095.out => tests/xfs/095.out                       |    0
 096 => tests/xfs/096                               |    0
 096.external => tests/xfs/096.external             |    0
 096.internal => tests/xfs/096.internal             |    0
 103 => tests/xfs/103                               |    0
 103.out => tests/xfs/103.out                       |    0
 104 => tests/xfs/104                               |    0
 104.out => tests/xfs/104.out                       |    0
 106 => tests/xfs/106                               |    0
 106.out => tests/xfs/106.out                       |    0
 107 => tests/xfs/107                               |    0
 107.out => tests/xfs/107.out                       |    0
 108 => tests/xfs/108                               |    0
 108.out => tests/xfs/108.out                       |    0
 109 => tests/xfs/109                               |    0
 109.out => tests/xfs/109.out                       |    0
 110 => tests/xfs/110                               |    0
 110.out => tests/xfs/110.out                       |    0
 111 => tests/xfs/111                               |    0
 111.out => tests/xfs/111.out                       |    0
 114 => tests/xfs/114                               |    0
 114.out => tests/xfs/114.out                       |    0
 115 => tests/xfs/115                               |    0
 115.out => tests/xfs/115.out                       |    0
 116 => tests/xfs/116                               |    0
 116.out => tests/xfs/116.out                       |    0
 118 => tests/xfs/118                               |    0
 118.out => tests/xfs/118.out                       |    0
 119 => tests/xfs/119                               |    0
 119.out => tests/xfs/119.out                       |    0
 121 => tests/xfs/121                               |    0
 121.out => tests/xfs/121.out                       |    0
 122 => tests/xfs/122                               |    0
 122.out => tests/xfs/122.out                       |    0
 134 => tests/xfs/134                               |    0
 134.out => tests/xfs/134.out                       |    0
 136 => tests/xfs/136                               |    0
 136.out => tests/xfs/136.out                       |    0
 137 => tests/xfs/137                               |    0
 137.out => tests/xfs/137.out                       |    0
 138 => tests/xfs/138                               |    0
 138.out => tests/xfs/138.out                       |    0
 139 => tests/xfs/139                               |    0
 139.out => tests/xfs/139.out                       |    0
 140 => tests/xfs/140                               |    0
 140.out => tests/xfs/140.out                       |    0
 142 => tests/xfs/142                               |    0
 142.out => tests/xfs/142.out                       |    0
 143 => tests/xfs/143                               |    0
 143.out => tests/xfs/143.out                       |    0
 144 => tests/xfs/144                               |    0
 144.out => tests/xfs/144.out                       |    0
 145 => tests/xfs/145                               |    0
 145.out => tests/xfs/145.out                       |    0
 146 => tests/xfs/146                               |    0
 146.out.irix => tests/xfs/146.out.irix             |    0
 146.out.linux => tests/xfs/146.out.linux           |    0
 147 => tests/xfs/147                               |    0
 147.out => tests/xfs/147.out                       |    0
 148 => tests/xfs/148                               |    0
 148.out => tests/xfs/148.out                       |    0
 149 => tests/xfs/149                               |    0
 149.out => tests/xfs/149.out                       |    0
 150 => tests/xfs/150                               |    0
 150.out => tests/xfs/150.out                       |    0
 151 => tests/xfs/151                               |    0
 151.out => tests/xfs/151.out                       |    0
 152 => tests/xfs/152                               |    0
 152.out => tests/xfs/152.out                       |    0
 153 => tests/xfs/153                               |    0
 153.out => tests/xfs/153.out                       |    0
 154 => tests/xfs/154                               |    0
 154.out => tests/xfs/154.out                       |    0
 155 => tests/xfs/155                               |    0
 155.out => tests/xfs/155.out                       |    0
 156 => tests/xfs/156                               |    0
 156.out => tests/xfs/156.out                       |    0
 157 => tests/xfs/157                               |    0
 157.out => tests/xfs/157.out                       |    0
 158 => tests/xfs/158                               |    0
 158.out => tests/xfs/158.out                       |    0
 159 => tests/xfs/159                               |    0
 159.out => tests/xfs/159.out                       |    0
 160 => tests/xfs/160                               |    0
 160.out => tests/xfs/160.out                       |    0
 161 => tests/xfs/161                               |    0
 161.out => tests/xfs/161.out                       |    0
 162 => tests/xfs/162                               |    0
 162.out => tests/xfs/162.out                       |    0
 163 => tests/xfs/163                               |    0
 163.out => tests/xfs/163.out                       |    0
 164 => tests/xfs/164                               |    0
 164.out => tests/xfs/164.out                       |    0
 165 => tests/xfs/165                               |    0
 165.out => tests/xfs/165.out                       |    0
 166 => tests/xfs/166                               |    0
 166.out => tests/xfs/166.out                       |    0
 167 => tests/xfs/167                               |    0
 167.out => tests/xfs/167.out                       |    0
 168 => tests/xfs/168                               |    0
 168.out => tests/xfs/168.out                       |    0
 170 => tests/xfs/170                               |    0
 170.out => tests/xfs/170.out                       |    0
 171 => tests/xfs/171                               |    0
 171.out => tests/xfs/171.out                       |    0
 172 => tests/xfs/172                               |    0
 172.out => tests/xfs/172.out                       |    0
 173 => tests/xfs/173                               |    0
 173.out => tests/xfs/173.out                       |    0
 174 => tests/xfs/174                               |    0
 174.out => tests/xfs/174.out                       |    0
 175 => tests/xfs/175                               |    0
 175.out => tests/xfs/175.out                       |    0
 176 => tests/xfs/176                               |    0
 176.out => tests/xfs/176.out                       |    0
 178 => tests/xfs/178                               |    0
 178.out => tests/xfs/178.out                       |    0
 179 => tests/xfs/179                               |    0
 179.out => tests/xfs/179.out                       |    0
 180 => tests/xfs/180                               |    0
 180.out => tests/xfs/180.out                       |    0
 181 => tests/xfs/181                               |    0
 181.out => tests/xfs/181.out                       |    0
 182 => tests/xfs/182                               |    0
 182.out => tests/xfs/182.out                       |    0
 183 => tests/xfs/183                               |    0
 183.out => tests/xfs/183.out                       |    0
 185 => tests/xfs/185                               |    0
 185.out => tests/xfs/185.out                       |    0
 186 => tests/xfs/186                               |    0
 186.out => tests/xfs/186.out                       |    0
 187 => tests/xfs/187                               |    0
 187.out => tests/xfs/187.out                       |    0
 188 => tests/xfs/188                               |    0
 188.out => tests/xfs/188.out                       |    0
 189 => tests/xfs/189                               |    0
 189.out => tests/xfs/189.out                       |    0
 190 => tests/xfs/190                               |    0
 190.out => tests/xfs/190.out                       |    0
 191 => tests/xfs/191                               |    0
 191.out => tests/xfs/191.out                       |    0
 194 => tests/xfs/194                               |    0
 194.out => tests/xfs/194.out                       |    0
 195 => tests/xfs/195                               |    0
 195.out => tests/xfs/195.out                       |    0
 196 => tests/xfs/196                               |    0
 196.out => tests/xfs/196.out                       |    0
 197 => tests/xfs/197                               |    0
 197.out => tests/xfs/197.out                       |    0
 199 => tests/xfs/199                               |    0
 199.out => tests/xfs/199.out                       |    0
 200 => tests/xfs/200                               |    0
 200.out => tests/xfs/200.out                       |    0
 201 => tests/xfs/201                               |    0
 201.out => tests/xfs/201.out                       |    0
 202 => tests/xfs/202                               |    0
 202.out => tests/xfs/202.out                       |    0
 203 => tests/xfs/203                               |    0
 203.out => tests/xfs/203.out                       |    0
 205 => tests/xfs/205                               |    0
 205.out => tests/xfs/205.out                       |    0
 206 => tests/xfs/206                               |    0
 206.out => tests/xfs/206.out                       |    0
 216 => tests/xfs/216                               |    0
 216.out => tests/xfs/216.out                       |    0
 217 => tests/xfs/217                               |    0
 217.out => tests/xfs/217.out                       |    0
 220 => tests/xfs/220                               |    0
 220.out => tests/xfs/220.out                       |    0
 222 => tests/xfs/222                               |    0
 222.out => tests/xfs/222.out                       |    0
 227 => tests/xfs/227                               |    0
 227.out => tests/xfs/227.out                       |    0
 229 => tests/xfs/229                               |    0
 229.out => tests/xfs/229.out                       |    0
 238 => tests/xfs/238                               |    0
 238.out => tests/xfs/238.out                       |    0
 242 => tests/xfs/242                               |    0
 242.out => tests/xfs/242.out                       |    0
 244 => tests/xfs/244                               |    0
 244.out => tests/xfs/244.out                       |    0
 250 => tests/xfs/250                               |    0
 250.out => tests/xfs/250.out                       |    0
 253 => tests/xfs/253                               |    0
 253.out => tests/xfs/253.out                       |    0
 259 => tests/xfs/259                               |    0
 259.out => tests/xfs/259.out                       |    0
 261 => tests/xfs/261                               |    0
 261.out => tests/xfs/261.out                       |    0
 262 => tests/xfs/262                               |    0
 262.out => tests/xfs/262.out                       |    0
 266 => tests/xfs/266                               |    0
 266.out => tests/xfs/266.out                       |    0
 267 => tests/xfs/267                               |    0
 267.out => tests/xfs/267.out                       |    0
 268 => tests/xfs/268                               |    0
 268.out => tests/xfs/268.out                       |    0
 278 => tests/xfs/278                               |    0
 278.out => tests/xfs/278.out                       |    0
 279 => tests/xfs/279                               |    0
 279.out => tests/xfs/279.out                       |    0
 281 => tests/xfs/281                               |    0
 281.out => tests/xfs/281.out                       |    0
 282 => tests/xfs/282                               |    0
 282.out => tests/xfs/282.out                       |    0
 283 => tests/xfs/283                               |    0
 283.out => tests/xfs/283.out                       |    0
 group => tests/xfs/group                           |  130 ---------------
 364 files changed, 2 insertions(+), 300 deletions(-)
 rename 003 => tests/xfs/003 (100%)
 rename 003.out => tests/xfs/003.out (100%)
 rename 004 => tests/xfs/004 (100%)
 rename 004.out => tests/xfs/004.out (100%)
 rename 008 => tests/xfs/008 (100%)
 rename 008.out => tests/xfs/008.out (100%)
 rename 009 => tests/xfs/009 (100%)
 rename 009.out => tests/xfs/009.out (100%)
 rename 012 => tests/xfs/012 (100%)
 rename 012.out => tests/xfs/012.out (100%)
 rename 016 => tests/xfs/016 (100%)
 rename 016.out => tests/xfs/016.out (100%)
 rename 017 => tests/xfs/017 (100%)
 rename 017.out => tests/xfs/017.out (100%)
 rename 018 => tests/xfs/018 (100%)
 rename 018.op.irix => tests/xfs/018.op.irix (100%)
 rename 018.op.linux => tests/xfs/018.op.linux (100%)
 rename 018.out => tests/xfs/018.out (100%)
 rename 018.trans_buf => tests/xfs/018.trans_buf (100%)
 rename 018.trans_inode => tests/xfs/018.trans_inode (100%)
 rename 019 => tests/xfs/019 (100%)
 rename 019.out => tests/xfs/019.out (100%)
 rename 021 => tests/xfs/021 (100%)
 rename 021.out => tests/xfs/021.out (100%)
 rename 022 => tests/xfs/022 (100%)
 rename 022.out.irix => tests/xfs/022.out.irix (100%)
 rename 022.out.linux => tests/xfs/022.out.linux (100%)
 rename 023 => tests/xfs/023 (100%)
 rename 023.out.irix => tests/xfs/023.out.irix (100%)
 rename 023.out.linux => tests/xfs/023.out.linux (100%)
 rename 024 => tests/xfs/024 (100%)
 rename 024.out => tests/xfs/024.out (100%)
 rename 025 => tests/xfs/025 (100%)
 rename 025.out => tests/xfs/025.out (100%)
 rename 026 => tests/xfs/026 (100%)
 rename 026.out => tests/xfs/026.out (100%)
 rename 027 => tests/xfs/027 (100%)
 rename 027.out => tests/xfs/027.out (100%)
 rename 028 => tests/xfs/028 (100%)
 rename 028.out => tests/xfs/028.out (100%)
 rename 029 => tests/xfs/029 (100%)
 rename 029.out => tests/xfs/029.out (100%)
 rename 030 => tests/xfs/030 (100%)
 rename 030.out.irix => tests/xfs/030.out.irix (100%)
 rename 030.out.linux => tests/xfs/030.out.linux (100%)
 rename 031 => tests/xfs/031 (100%)
 rename 031.out.irix => tests/xfs/031.out.irix (100%)
 rename 031.out.linux => tests/xfs/031.out.linux (100%)
 rename 032 => tests/xfs/032 (100%)
 rename 032.out => tests/xfs/032.out (100%)
 rename 033 => tests/xfs/033 (100%)
 rename 033.out.irix => tests/xfs/033.out.irix (100%)
 rename 033.out.linux => tests/xfs/033.out.linux (100%)
 rename 034 => tests/xfs/034 (100%)
 rename 034.out => tests/xfs/034.out (100%)
 rename 035 => tests/xfs/035 (100%)
 rename 035.out.irix => tests/xfs/035.out.irix (100%)
 rename 035.out.linux => tests/xfs/035.out.linux (100%)
 rename 036 => tests/xfs/036 (100%)
 rename 036.out.irix => tests/xfs/036.out.irix (100%)
 rename 036.out.linux => tests/xfs/036.out.linux (100%)
 rename 037 => tests/xfs/037 (100%)
 rename 037.out => tests/xfs/037.out (100%)
 rename 038 => tests/xfs/038 (100%)
 rename 038.out => tests/xfs/038.out (100%)
 rename 039 => tests/xfs/039 (100%)
 rename 039.out.irix => tests/xfs/039.out.irix (100%)
 rename 039.out.linux => tests/xfs/039.out.linux (100%)
 rename 041 => tests/xfs/041 (100%)
 rename 041.out => tests/xfs/041.out (100%)
 rename 042 => tests/xfs/042 (100%)
 rename 042.out => tests/xfs/042.out (100%)
 rename 043 => tests/xfs/043 (100%)
 rename 043.out.irix => tests/xfs/043.out.irix (100%)
 rename 043.out.linux => tests/xfs/043.out.linux (100%)
 rename 044 => tests/xfs/044 (100%)
 rename 044.out => tests/xfs/044.out (100%)
 rename 045 => tests/xfs/045 (100%)
 rename 045.out => tests/xfs/045.out (100%)
 rename 046 => tests/xfs/046 (100%)
 rename 046.out => tests/xfs/046.out (100%)
 rename 047 => tests/xfs/047 (100%)
 rename 047.out => tests/xfs/047.out (100%)
 rename 048 => tests/xfs/048 (100%)
 rename 048.out => tests/xfs/048.out (100%)
 rename 049 => tests/xfs/049 (100%)
 rename 049.out => tests/xfs/049.out (100%)
 rename 050 => tests/xfs/050 (100%)
 rename 050.out => tests/xfs/050.out (100%)
 rename 052 => tests/xfs/052 (100%)
 rename 052.out => tests/xfs/052.out (100%)
 rename 054 => tests/xfs/054 (100%)
 rename 054.out => tests/xfs/054.out (100%)
 rename 055 => tests/xfs/055 (100%)
 rename 055.out.irix => tests/xfs/055.out.irix (100%)
 rename 055.out.linux => tests/xfs/055.out.linux (100%)
 rename 056 => tests/xfs/056 (100%)
 rename 056.out => tests/xfs/056.out (100%)
 rename 057 => tests/xfs/057 (100%)
 rename 057.out => tests/xfs/057.out (100%)
 rename 058 => tests/xfs/058 (100%)
 rename 058.out => tests/xfs/058.out (100%)
 rename 059 => tests/xfs/059 (100%)
 rename 059.out => tests/xfs/059.out (100%)
 rename 060 => tests/xfs/060 (100%)
 rename 060.out => tests/xfs/060.out (100%)
 rename 061 => tests/xfs/061 (100%)
 rename 061.out => tests/xfs/061.out (100%)
 rename 063 => tests/xfs/063 (100%)
 rename 063.out => tests/xfs/063.out (100%)
 rename 064 => tests/xfs/064 (100%)
 rename 064.out => tests/xfs/064.out (100%)
 rename 065 => tests/xfs/065 (100%)
 rename 065.out => tests/xfs/065.out (100%)
 rename 066 => tests/xfs/066 (100%)
 rename 066.out => tests/xfs/066.out (100%)
 rename 067 => tests/xfs/067 (100%)
 rename 067.out => tests/xfs/067.out (100%)
 rename 071 => tests/xfs/071 (100%)
 rename 071.out => tests/xfs/071.out (100%)
 rename 071.out.32 => tests/xfs/071.out.32 (100%)
 rename 071.out.64 => tests/xfs/071.out.64 (100%)
 rename 072 => tests/xfs/072 (100%)
 rename 072.out => tests/xfs/072.out (100%)
 rename 073 => tests/xfs/073 (100%)
 rename 073.out => tests/xfs/073.out (100%)
 rename 078 => tests/xfs/078 (100%)
 rename 078.out => tests/xfs/078.out (100%)
 rename 080 => tests/xfs/080 (100%)
 rename 080.out => tests/xfs/080.out (100%)
 rename 081 => tests/xfs/081 (100%)
 rename 081.out => tests/xfs/081.out (100%)
 rename 081.ugquota.trans_inode => tests/xfs/081.ugquota.trans_inode (100%)
 rename 082 => tests/xfs/082 (100%)
 rename 082.op.irix => tests/xfs/082.op.irix (100%)
 rename 082.op.linux => tests/xfs/082.op.linux (100%)
 rename 082.out => tests/xfs/082.out (100%)
 rename 082.trans_buf => tests/xfs/082.trans_buf (100%)
 rename 082.trans_inode => tests/xfs/082.trans_inode (100%)
 rename 084 => tests/xfs/084 (100%)
 rename 084.out => tests/xfs/084.out (100%)
 rename 085 => tests/xfs/085 (100%)
 rename 085.out => tests/xfs/085.out (100%)
 rename 086 => tests/xfs/086 (100%)
 rename 086.out => tests/xfs/086.out (100%)
 rename 087 => tests/xfs/087 (100%)
 rename 087.out => tests/xfs/087.out (100%)
 rename 090 => tests/xfs/090 (100%)
 rename 090.out => tests/xfs/090.out (100%)
 rename 092 => tests/xfs/092 (100%)
 rename 092.out => tests/xfs/092.out (100%)
 rename 094 => tests/xfs/094 (100%)
 rename 094.out => tests/xfs/094.out (100%)
 rename 095 => tests/xfs/095 (100%)
 rename 095.out => tests/xfs/095.out (100%)
 rename 096 => tests/xfs/096 (100%)
 rename 096.external => tests/xfs/096.external (100%)
 rename 096.internal => tests/xfs/096.internal (100%)
 rename 103 => tests/xfs/103 (100%)
 rename 103.out => tests/xfs/103.out (100%)
 rename 104 => tests/xfs/104 (100%)
 rename 104.out => tests/xfs/104.out (100%)
 rename 106 => tests/xfs/106 (100%)
 rename 106.out => tests/xfs/106.out (100%)
 rename 107 => tests/xfs/107 (100%)
 rename 107.out => tests/xfs/107.out (100%)
 rename 108 => tests/xfs/108 (100%)
 rename 108.out => tests/xfs/108.out (100%)
 rename 109 => tests/xfs/109 (100%)
 rename 109.out => tests/xfs/109.out (100%)
 rename 110 => tests/xfs/110 (100%)
 rename 110.out => tests/xfs/110.out (100%)
 rename 111 => tests/xfs/111 (100%)
 rename 111.out => tests/xfs/111.out (100%)
 rename 114 => tests/xfs/114 (100%)
 rename 114.out => tests/xfs/114.out (100%)
 rename 115 => tests/xfs/115 (100%)
 rename 115.out => tests/xfs/115.out (100%)
 rename 116 => tests/xfs/116 (100%)
 rename 116.out => tests/xfs/116.out (100%)
 rename 118 => tests/xfs/118 (100%)
 rename 118.out => tests/xfs/118.out (100%)
 rename 119 => tests/xfs/119 (100%)
 rename 119.out => tests/xfs/119.out (100%)
 rename 121 => tests/xfs/121 (100%)
 rename 121.out => tests/xfs/121.out (100%)
 rename 122 => tests/xfs/122 (100%)
 rename 122.out => tests/xfs/122.out (100%)
 rename 134 => tests/xfs/134 (100%)
 rename 134.out => tests/xfs/134.out (100%)
 rename 136 => tests/xfs/136 (100%)
 rename 136.out => tests/xfs/136.out (100%)
 rename 137 => tests/xfs/137 (100%)
 rename 137.out => tests/xfs/137.out (100%)
 rename 138 => tests/xfs/138 (100%)
 rename 138.out => tests/xfs/138.out (100%)
 rename 139 => tests/xfs/139 (100%)
 rename 139.out => tests/xfs/139.out (100%)
 rename 140 => tests/xfs/140 (100%)
 rename 140.out => tests/xfs/140.out (100%)
 rename 142 => tests/xfs/142 (100%)
 rename 142.out => tests/xfs/142.out (100%)
 rename 143 => tests/xfs/143 (100%)
 rename 143.out => tests/xfs/143.out (100%)
 rename 144 => tests/xfs/144 (100%)
 rename 144.out => tests/xfs/144.out (100%)
 rename 145 => tests/xfs/145 (100%)
 rename 145.out => tests/xfs/145.out (100%)
 rename 146 => tests/xfs/146 (100%)
 rename 146.out.irix => tests/xfs/146.out.irix (100%)
 rename 146.out.linux => tests/xfs/146.out.linux (100%)
 rename 147 => tests/xfs/147 (100%)
 rename 147.out => tests/xfs/147.out (100%)
 rename 148 => tests/xfs/148 (100%)
 rename 148.out => tests/xfs/148.out (100%)
 rename 149 => tests/xfs/149 (100%)
 rename 149.out => tests/xfs/149.out (100%)
 rename 150 => tests/xfs/150 (100%)
 rename 150.out => tests/xfs/150.out (100%)
 rename 151 => tests/xfs/151 (100%)
 rename 151.out => tests/xfs/151.out (100%)
 rename 152 => tests/xfs/152 (100%)
 rename 152.out => tests/xfs/152.out (100%)
 rename 153 => tests/xfs/153 (100%)
 rename 153.out => tests/xfs/153.out (100%)
 rename 154 => tests/xfs/154 (100%)
 rename 154.out => tests/xfs/154.out (100%)
 rename 155 => tests/xfs/155 (100%)
 rename 155.out => tests/xfs/155.out (100%)
 rename 156 => tests/xfs/156 (100%)
 rename 156.out => tests/xfs/156.out (100%)
 rename 157 => tests/xfs/157 (100%)
 rename 157.out => tests/xfs/157.out (100%)
 rename 158 => tests/xfs/158 (100%)
 rename 158.out => tests/xfs/158.out (100%)
 rename 159 => tests/xfs/159 (100%)
 rename 159.out => tests/xfs/159.out (100%)
 rename 160 => tests/xfs/160 (100%)
 rename 160.out => tests/xfs/160.out (100%)
 rename 161 => tests/xfs/161 (100%)
 rename 161.out => tests/xfs/161.out (100%)
 rename 162 => tests/xfs/162 (100%)
 rename 162.out => tests/xfs/162.out (100%)
 rename 163 => tests/xfs/163 (100%)
 rename 163.out => tests/xfs/163.out (100%)
 rename 164 => tests/xfs/164 (100%)
 rename 164.out => tests/xfs/164.out (100%)
 rename 165 => tests/xfs/165 (100%)
 rename 165.out => tests/xfs/165.out (100%)
 rename 166 => tests/xfs/166 (100%)
 rename 166.out => tests/xfs/166.out (100%)
 rename 167 => tests/xfs/167 (100%)
 rename 167.out => tests/xfs/167.out (100%)
 rename 168 => tests/xfs/168 (100%)
 rename 168.out => tests/xfs/168.out (100%)
 rename 170 => tests/xfs/170 (100%)
 rename 170.out => tests/xfs/170.out (100%)
 rename 171 => tests/xfs/171 (100%)
 rename 171.out => tests/xfs/171.out (100%)
 rename 172 => tests/xfs/172 (100%)
 rename 172.out => tests/xfs/172.out (100%)
 rename 173 => tests/xfs/173 (100%)
 rename 173.out => tests/xfs/173.out (100%)
 rename 174 => tests/xfs/174 (100%)
 rename 174.out => tests/xfs/174.out (100%)
 rename 175 => tests/xfs/175 (100%)
 rename 175.out => tests/xfs/175.out (100%)
 rename 176 => tests/xfs/176 (100%)
 rename 176.out => tests/xfs/176.out (100%)
 rename 178 => tests/xfs/178 (100%)
 rename 178.out => tests/xfs/178.out (100%)
 rename 179 => tests/xfs/179 (100%)
 rename 179.out => tests/xfs/179.out (100%)
 rename 180 => tests/xfs/180 (100%)
 rename 180.out => tests/xfs/180.out (100%)
 rename 181 => tests/xfs/181 (100%)
 rename 181.out => tests/xfs/181.out (100%)
 rename 182 => tests/xfs/182 (100%)
 rename 182.out => tests/xfs/182.out (100%)
 rename 183 => tests/xfs/183 (100%)
 rename 183.out => tests/xfs/183.out (100%)
 rename 185 => tests/xfs/185 (100%)
 rename 185.out => tests/xfs/185.out (100%)
 rename 186 => tests/xfs/186 (100%)
 rename 186.out => tests/xfs/186.out (100%)
 rename 187 => tests/xfs/187 (100%)
 rename 187.out => tests/xfs/187.out (100%)
 rename 188 => tests/xfs/188 (100%)
 rename 188.out => tests/xfs/188.out (100%)
 rename 189 => tests/xfs/189 (100%)
 rename 189.out => tests/xfs/189.out (100%)
 rename 190 => tests/xfs/190 (100%)
 rename 190.out => tests/xfs/190.out (100%)
 rename 191 => tests/xfs/191 (100%)
 rename 191.out => tests/xfs/191.out (100%)
 rename 194 => tests/xfs/194 (100%)
 rename 194.out => tests/xfs/194.out (100%)
 rename 195 => tests/xfs/195 (100%)
 rename 195.out => tests/xfs/195.out (100%)
 rename 196 => tests/xfs/196 (100%)
 rename 196.out => tests/xfs/196.out (100%)
 rename 197 => tests/xfs/197 (100%)
 rename 197.out => tests/xfs/197.out (100%)
 rename 199 => tests/xfs/199 (100%)
 rename 199.out => tests/xfs/199.out (100%)
 rename 200 => tests/xfs/200 (100%)
 rename 200.out => tests/xfs/200.out (100%)
 rename 201 => tests/xfs/201 (100%)
 rename 201.out => tests/xfs/201.out (100%)
 rename 202 => tests/xfs/202 (100%)
 rename 202.out => tests/xfs/202.out (100%)
 rename 203 => tests/xfs/203 (100%)
 rename 203.out => tests/xfs/203.out (100%)
 rename 205 => tests/xfs/205 (100%)
 rename 205.out => tests/xfs/205.out (100%)
 rename 206 => tests/xfs/206 (100%)
 rename 206.out => tests/xfs/206.out (100%)
 rename 216 => tests/xfs/216 (100%)
 rename 216.out => tests/xfs/216.out (100%)
 rename 217 => tests/xfs/217 (100%)
 rename 217.out => tests/xfs/217.out (100%)
 rename 220 => tests/xfs/220 (100%)
 rename 220.out => tests/xfs/220.out (100%)
 rename 222 => tests/xfs/222 (100%)
 rename 222.out => tests/xfs/222.out (100%)
 rename 227 => tests/xfs/227 (100%)
 rename 227.out => tests/xfs/227.out (100%)
 rename 229 => tests/xfs/229 (100%)
 rename 229.out => tests/xfs/229.out (100%)
 rename 238 => tests/xfs/238 (100%)
 rename 238.out => tests/xfs/238.out (100%)
 rename 242 => tests/xfs/242 (100%)
 rename 242.out => tests/xfs/242.out (100%)
 rename 244 => tests/xfs/244 (100%)
 rename 244.out => tests/xfs/244.out (100%)
 rename 250 => tests/xfs/250 (100%)
 rename 250.out => tests/xfs/250.out (100%)
 rename 253 => tests/xfs/253 (100%)
 rename 253.out => tests/xfs/253.out (100%)
 rename 259 => tests/xfs/259 (100%)
 rename 259.out => tests/xfs/259.out (100%)
 rename 261 => tests/xfs/261 (100%)
 rename 261.out => tests/xfs/261.out (100%)
 rename 262 => tests/xfs/262 (100%)
 rename 262.out => tests/xfs/262.out (100%)
 rename 266 => tests/xfs/266 (100%)
 rename 266.out => tests/xfs/266.out (100%)
 rename 267 => tests/xfs/267 (100%)
 rename 267.out => tests/xfs/267.out (100%)
 rename 268 => tests/xfs/268 (100%)
 rename 268.out => tests/xfs/268.out (100%)
 rename 278 => tests/xfs/278 (100%)
 rename 278.out => tests/xfs/278.out (100%)
 rename 279 => tests/xfs/279 (100%)
 rename 279.out => tests/xfs/279.out (100%)
 rename 281 => tests/xfs/281 (100%)
 rename 281.out => tests/xfs/281.out (100%)
 rename 282 => tests/xfs/282 (100%)
 rename 282.out => tests/xfs/282.out (100%)
 rename 283 => tests/xfs/283 (100%)
 rename 283.out => tests/xfs/283.out (100%)
 copy group => tests/xfs/group (70%)

diff --git a/check b/check
index bdf764a..41c1654 100755
--- a/check
+++ b/check
@@ -38,6 +38,7 @@ FSTYP=xfs
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
 TEST_GROUP_DIR="tests"
 GENERIC_GROUP_DIR="$TEST_GROUP_DIR/generic"
+XFS_GROUP_DIR="$TEST_GROUP_DIR/xfs"
 
 # generic initialization
 iam=check
@@ -80,7 +81,7 @@ _setenvironment()
 get_group_list()
 {
 	grp=$1
-	dirs=". $GENERIC_GROUP_DIR"
+	dirs=". $GENERIC_GROUP_DIR $XFS_GROUP_DIR"
 
 	for d in $dirs; do
 		l=$(sed -n < $d/group \
diff --git a/group b/group
index acde48e..5c9bb7f 100644
--- a/group
+++ b/group
@@ -116,192 +116,23 @@ deprecated
 #
 # test-group association ... one line per test
 #
-003 db auto quick
-004 db auto quick
-008 rw ioctl auto quick
-009 rw ioctl auto prealloc quick
-012 rw auto quick
-016 rw auto quick
-017 mount auto quick
-018 deprecated # log logprint v2log
-019 mkfs auto quick
-021 db attr auto quick
-022 dump ioctl tape
-023 dump ioctl tape
-024 dump ioctl tape
-025 dump ioctl tape
-026 dump ioctl auto quick
-027 dump ioctl auto quick
-028 dump ioctl auto quick
-029 mkfs logprint log auto quick
-030 repair auto quick
-031 repair mkfs auto quick
-032 mkfs auto quick
-033 repair auto quick
-034 other auto quick
-035 dump ioctl tape auto
-036 dump ioctl remote tape
-037 dump ioctl remote tape
-038 dump ioctl remote tape
-039 dump ioctl remote tape
 040 other auto
-041 growfs ioctl auto
-042 fsr ioctl auto
-043 dump ioctl tape
-044 other auto
-045 other auto quick
-046 dump ioctl auto quick
-047 dump ioctl auto
-048 other auto quick
-049 rw auto quick
-050 quota auto quick
 051 acl udf auto quick
-052 quota db auto quick
-054 quota auto quick
-055 dump ioctl remote tape
-056 dump ioctl auto quick
-057 acl auto
-058 acl auto
-059 dump ioctl auto quick
-060 dump ioctl auto quick
-061 dump ioctl auto quick
-063 dump attr auto quick
-064 dump auto
-065 dump auto
-066 dump ioctl auto quick
-067 acl attr auto quick
 068 other auto freeze dangerous
-071 rw auto
-072 rw auto prealloc quick
-073 copy auto
-078 growfs auto quick
-080 rw ioctl
-081 deprecated # log logprint quota
-082 deprecated # log logprint v2log
-084 ioctl rw auto
-085 log auto quick
-086 log v2log auto
-087 log v2log auto quota
-090 rw auto
-092 other auto quick
-094 metadata dir ioctl auto
-095 log v2log auto
-096 mkfs v2log auto quick
 098 udf auto
 101 udf
 102 udf
-103 metadata dir ioctl auto quick
-104 growfs ioctl prealloc auto
-106 quota
-107 quota
-108 quota auto quick
-109 metadata auto
-110 repair auto
-111 ioctl
-114 parent attr
-115 parent attr
-116 quota auto quick
-118 quota auto quick
-119 log v2log auto freeze dangerous
-121 log auto quick
-122 other auto quick
-134 quota auto quick
-136 attr2
-137 metadata log auto
-138 metadata log auto
-139 metadata log auto
-140 metadata log auto
-142 dmapi auto
-143 dmapi auto
-144 dmapi auto
-145 dmapi auto
-146 dmapi auto
-147 dmapi auto
-148 repair auto
-149 repair auto
-150 dmapi auto
-151 dmapi auto
-152 dmapi auto
-153 dmapi auto
-154 dmapi auto
-155 dmapi auto
-156 dmapi auto
-157 dmapi auto
-158 dmapi auto
-159 dmapi auto
-160 dmapi auto
-161 dmapi auto
-162 dmapi auto
-163 dmapi auto
-164 rw pattern auto prealloc quick
-165 rw pattern auto prealloc quick
-166 rw metadata auto quick
-167 rw metadata auto
-168 dmapi auto
-170 rw filestreams auto quick
 # the next three tests are not deterministic enough to get the
 # "right" result on all platforms/configuration, so don't run
 # them by default.
-171 rw filestreams
-172 rw filestreams
-173 rw filestreams
-174 rw filestreams auto
-175 dmapi auto
-176 dmapi auto
 177 rw other auto
-178 mkfs other auto
-179 metadata rw auto
-180 metadata rw auto
-181 log auto quick
-182 metadata rw auto
-183 rw other auto quick
-185 dmapi auto
-186 attr auto quick
-187 attr auto quick
-188 ci dir auto
-189 mount auto quick
-190 rw auto quick
-191 nfs4acl auto
-194 rw auto
-195 ioctl dump auto quick
-196 quota auto quick
-197 dir auto quick
-199 mount auto quick
-200 mount auto quick
-201 metadata auto quick
-202 repair auto quick
-203 ioctl auto
-205 metadata rw auto
-206 growfs auto quick
-216 log metadata auto quick
-217 log metadata auto
 218 auto fsr quick
-220 auto quota quick
-222 auto fsr ioctl quick
-227 auto fsr
-229 auto rw
-238 auto quick metadata ioctl
-242 auto quick prealloc
 243 auto quick prealloc
-244 auto quota quick
-250 auto quick rw prealloc metadata
 252 auto quick prealloc
-253 auto quick
 254 auto quick
-259 auto quick
-261 auto quick quota
-262 auto quick quota
 264 auto
 265 auto
-266 dump ioctl auto quick
-267 dump ioctl tape
-268 dump ioctl tape
 271 auto rw quick
 272 auto enospc rw
 276 auto rw metadata
-278 repair auto
-279 auto mkfs
-281 dump ioctl auto quick
-282 dump ioctl auto quick
-283 dump ioctl auto quick
 284 auto
diff --git a/003 b/tests/xfs/003
similarity index 100%
rename from 003
rename to tests/xfs/003
diff --git a/003.out b/tests/xfs/003.out
similarity index 100%
rename from 003.out
rename to tests/xfs/003.out
diff --git a/004 b/tests/xfs/004
similarity index 100%
rename from 004
rename to tests/xfs/004
diff --git a/004.out b/tests/xfs/004.out
similarity index 100%
rename from 004.out
rename to tests/xfs/004.out
diff --git a/008 b/tests/xfs/008
similarity index 100%
rename from 008
rename to tests/xfs/008
diff --git a/008.out b/tests/xfs/008.out
similarity index 100%
rename from 008.out
rename to tests/xfs/008.out
diff --git a/009 b/tests/xfs/009
similarity index 100%
rename from 009
rename to tests/xfs/009
diff --git a/009.out b/tests/xfs/009.out
similarity index 100%
rename from 009.out
rename to tests/xfs/009.out
diff --git a/012 b/tests/xfs/012
similarity index 100%
rename from 012
rename to tests/xfs/012
diff --git a/012.out b/tests/xfs/012.out
similarity index 100%
rename from 012.out
rename to tests/xfs/012.out
diff --git a/016 b/tests/xfs/016
similarity index 100%
rename from 016
rename to tests/xfs/016
diff --git a/016.out b/tests/xfs/016.out
similarity index 100%
rename from 016.out
rename to tests/xfs/016.out
diff --git a/017 b/tests/xfs/017
similarity index 100%
rename from 017
rename to tests/xfs/017
diff --git a/017.out b/tests/xfs/017.out
similarity index 100%
rename from 017.out
rename to tests/xfs/017.out
diff --git a/018 b/tests/xfs/018
similarity index 100%
rename from 018
rename to tests/xfs/018
diff --git a/018.op.irix b/tests/xfs/018.op.irix
similarity index 100%
rename from 018.op.irix
rename to tests/xfs/018.op.irix
diff --git a/018.op.linux b/tests/xfs/018.op.linux
similarity index 100%
rename from 018.op.linux
rename to tests/xfs/018.op.linux
diff --git a/018.out b/tests/xfs/018.out
similarity index 100%
rename from 018.out
rename to tests/xfs/018.out
diff --git a/018.trans_buf b/tests/xfs/018.trans_buf
similarity index 100%
rename from 018.trans_buf
rename to tests/xfs/018.trans_buf
diff --git a/018.trans_inode b/tests/xfs/018.trans_inode
similarity index 100%
rename from 018.trans_inode
rename to tests/xfs/018.trans_inode
diff --git a/019 b/tests/xfs/019
similarity index 100%
rename from 019
rename to tests/xfs/019
diff --git a/019.out b/tests/xfs/019.out
similarity index 100%
rename from 019.out
rename to tests/xfs/019.out
diff --git a/021 b/tests/xfs/021
similarity index 100%
rename from 021
rename to tests/xfs/021
diff --git a/021.out b/tests/xfs/021.out
similarity index 100%
rename from 021.out
rename to tests/xfs/021.out
diff --git a/022 b/tests/xfs/022
similarity index 100%
rename from 022
rename to tests/xfs/022
diff --git a/022.out.irix b/tests/xfs/022.out.irix
similarity index 100%
rename from 022.out.irix
rename to tests/xfs/022.out.irix
diff --git a/022.out.linux b/tests/xfs/022.out.linux
similarity index 100%
rename from 022.out.linux
rename to tests/xfs/022.out.linux
diff --git a/023 b/tests/xfs/023
similarity index 100%
rename from 023
rename to tests/xfs/023
diff --git a/023.out.irix b/tests/xfs/023.out.irix
similarity index 100%
rename from 023.out.irix
rename to tests/xfs/023.out.irix
diff --git a/023.out.linux b/tests/xfs/023.out.linux
similarity index 100%
rename from 023.out.linux
rename to tests/xfs/023.out.linux
diff --git a/024 b/tests/xfs/024
similarity index 100%
rename from 024
rename to tests/xfs/024
diff --git a/024.out b/tests/xfs/024.out
similarity index 100%
rename from 024.out
rename to tests/xfs/024.out
diff --git a/025 b/tests/xfs/025
similarity index 100%
rename from 025
rename to tests/xfs/025
diff --git a/025.out b/tests/xfs/025.out
similarity index 100%
rename from 025.out
rename to tests/xfs/025.out
diff --git a/026 b/tests/xfs/026
similarity index 100%
rename from 026
rename to tests/xfs/026
diff --git a/026.out b/tests/xfs/026.out
similarity index 100%
rename from 026.out
rename to tests/xfs/026.out
diff --git a/027 b/tests/xfs/027
similarity index 100%
rename from 027
rename to tests/xfs/027
diff --git a/027.out b/tests/xfs/027.out
similarity index 100%
rename from 027.out
rename to tests/xfs/027.out
diff --git a/028 b/tests/xfs/028
similarity index 100%
rename from 028
rename to tests/xfs/028
diff --git a/028.out b/tests/xfs/028.out
similarity index 100%
rename from 028.out
rename to tests/xfs/028.out
diff --git a/029 b/tests/xfs/029
similarity index 100%
rename from 029
rename to tests/xfs/029
diff --git a/029.out b/tests/xfs/029.out
similarity index 100%
rename from 029.out
rename to tests/xfs/029.out
diff --git a/030 b/tests/xfs/030
similarity index 100%
rename from 030
rename to tests/xfs/030
diff --git a/030.out.irix b/tests/xfs/030.out.irix
similarity index 100%
rename from 030.out.irix
rename to tests/xfs/030.out.irix
diff --git a/030.out.linux b/tests/xfs/030.out.linux
similarity index 100%
rename from 030.out.linux
rename to tests/xfs/030.out.linux
diff --git a/031 b/tests/xfs/031
similarity index 100%
rename from 031
rename to tests/xfs/031
diff --git a/031.out.irix b/tests/xfs/031.out.irix
similarity index 100%
rename from 031.out.irix
rename to tests/xfs/031.out.irix
diff --git a/031.out.linux b/tests/xfs/031.out.linux
similarity index 100%
rename from 031.out.linux
rename to tests/xfs/031.out.linux
diff --git a/032 b/tests/xfs/032
similarity index 100%
rename from 032
rename to tests/xfs/032
diff --git a/032.out b/tests/xfs/032.out
similarity index 100%
rename from 032.out
rename to tests/xfs/032.out
diff --git a/033 b/tests/xfs/033
similarity index 100%
rename from 033
rename to tests/xfs/033
diff --git a/033.out.irix b/tests/xfs/033.out.irix
similarity index 100%
rename from 033.out.irix
rename to tests/xfs/033.out.irix
diff --git a/033.out.linux b/tests/xfs/033.out.linux
similarity index 100%
rename from 033.out.linux
rename to tests/xfs/033.out.linux
diff --git a/034 b/tests/xfs/034
similarity index 100%
rename from 034
rename to tests/xfs/034
diff --git a/034.out b/tests/xfs/034.out
similarity index 100%
rename from 034.out
rename to tests/xfs/034.out
diff --git a/035 b/tests/xfs/035
similarity index 100%
rename from 035
rename to tests/xfs/035
diff --git a/035.out.irix b/tests/xfs/035.out.irix
similarity index 100%
rename from 035.out.irix
rename to tests/xfs/035.out.irix
diff --git a/035.out.linux b/tests/xfs/035.out.linux
similarity index 100%
rename from 035.out.linux
rename to tests/xfs/035.out.linux
diff --git a/036 b/tests/xfs/036
similarity index 100%
rename from 036
rename to tests/xfs/036
diff --git a/036.out.irix b/tests/xfs/036.out.irix
similarity index 100%
rename from 036.out.irix
rename to tests/xfs/036.out.irix
diff --git a/036.out.linux b/tests/xfs/036.out.linux
similarity index 100%
rename from 036.out.linux
rename to tests/xfs/036.out.linux
diff --git a/037 b/tests/xfs/037
similarity index 100%
rename from 037
rename to tests/xfs/037
diff --git a/037.out b/tests/xfs/037.out
similarity index 100%
rename from 037.out
rename to tests/xfs/037.out
diff --git a/038 b/tests/xfs/038
similarity index 100%
rename from 038
rename to tests/xfs/038
diff --git a/038.out b/tests/xfs/038.out
similarity index 100%
rename from 038.out
rename to tests/xfs/038.out
diff --git a/039 b/tests/xfs/039
similarity index 100%
rename from 039
rename to tests/xfs/039
diff --git a/039.out.irix b/tests/xfs/039.out.irix
similarity index 100%
rename from 039.out.irix
rename to tests/xfs/039.out.irix
diff --git a/039.out.linux b/tests/xfs/039.out.linux
similarity index 100%
rename from 039.out.linux
rename to tests/xfs/039.out.linux
diff --git a/041 b/tests/xfs/041
similarity index 100%
rename from 041
rename to tests/xfs/041
diff --git a/041.out b/tests/xfs/041.out
similarity index 100%
rename from 041.out
rename to tests/xfs/041.out
diff --git a/042 b/tests/xfs/042
similarity index 100%
rename from 042
rename to tests/xfs/042
diff --git a/042.out b/tests/xfs/042.out
similarity index 100%
rename from 042.out
rename to tests/xfs/042.out
diff --git a/043 b/tests/xfs/043
similarity index 100%
rename from 043
rename to tests/xfs/043
diff --git a/043.out.irix b/tests/xfs/043.out.irix
similarity index 100%
rename from 043.out.irix
rename to tests/xfs/043.out.irix
diff --git a/043.out.linux b/tests/xfs/043.out.linux
similarity index 100%
rename from 043.out.linux
rename to tests/xfs/043.out.linux
diff --git a/044 b/tests/xfs/044
similarity index 100%
rename from 044
rename to tests/xfs/044
diff --git a/044.out b/tests/xfs/044.out
similarity index 100%
rename from 044.out
rename to tests/xfs/044.out
diff --git a/045 b/tests/xfs/045
similarity index 100%
rename from 045
rename to tests/xfs/045
diff --git a/045.out b/tests/xfs/045.out
similarity index 100%
rename from 045.out
rename to tests/xfs/045.out
diff --git a/046 b/tests/xfs/046
similarity index 100%
rename from 046
rename to tests/xfs/046
diff --git a/046.out b/tests/xfs/046.out
similarity index 100%
rename from 046.out
rename to tests/xfs/046.out
diff --git a/047 b/tests/xfs/047
similarity index 100%
rename from 047
rename to tests/xfs/047
diff --git a/047.out b/tests/xfs/047.out
similarity index 100%
rename from 047.out
rename to tests/xfs/047.out
diff --git a/048 b/tests/xfs/048
similarity index 100%
rename from 048
rename to tests/xfs/048
diff --git a/048.out b/tests/xfs/048.out
similarity index 100%
rename from 048.out
rename to tests/xfs/048.out
diff --git a/049 b/tests/xfs/049
similarity index 100%
rename from 049
rename to tests/xfs/049
diff --git a/049.out b/tests/xfs/049.out
similarity index 100%
rename from 049.out
rename to tests/xfs/049.out
diff --git a/050 b/tests/xfs/050
similarity index 100%
rename from 050
rename to tests/xfs/050
diff --git a/050.out b/tests/xfs/050.out
similarity index 100%
rename from 050.out
rename to tests/xfs/050.out
diff --git a/052 b/tests/xfs/052
similarity index 100%
rename from 052
rename to tests/xfs/052
diff --git a/052.out b/tests/xfs/052.out
similarity index 100%
rename from 052.out
rename to tests/xfs/052.out
diff --git a/054 b/tests/xfs/054
similarity index 100%
rename from 054
rename to tests/xfs/054
diff --git a/054.out b/tests/xfs/054.out
similarity index 100%
rename from 054.out
rename to tests/xfs/054.out
diff --git a/055 b/tests/xfs/055
similarity index 100%
rename from 055
rename to tests/xfs/055
diff --git a/055.out.irix b/tests/xfs/055.out.irix
similarity index 100%
rename from 055.out.irix
rename to tests/xfs/055.out.irix
diff --git a/055.out.linux b/tests/xfs/055.out.linux
similarity index 100%
rename from 055.out.linux
rename to tests/xfs/055.out.linux
diff --git a/056 b/tests/xfs/056
similarity index 100%
rename from 056
rename to tests/xfs/056
diff --git a/056.out b/tests/xfs/056.out
similarity index 100%
rename from 056.out
rename to tests/xfs/056.out
diff --git a/057 b/tests/xfs/057
similarity index 100%
rename from 057
rename to tests/xfs/057
diff --git a/057.out b/tests/xfs/057.out
similarity index 100%
rename from 057.out
rename to tests/xfs/057.out
diff --git a/058 b/tests/xfs/058
similarity index 100%
rename from 058
rename to tests/xfs/058
diff --git a/058.out b/tests/xfs/058.out
similarity index 100%
rename from 058.out
rename to tests/xfs/058.out
diff --git a/059 b/tests/xfs/059
similarity index 100%
rename from 059
rename to tests/xfs/059
diff --git a/059.out b/tests/xfs/059.out
similarity index 100%
rename from 059.out
rename to tests/xfs/059.out
diff --git a/060 b/tests/xfs/060
similarity index 100%
rename from 060
rename to tests/xfs/060
diff --git a/060.out b/tests/xfs/060.out
similarity index 100%
rename from 060.out
rename to tests/xfs/060.out
diff --git a/061 b/tests/xfs/061
similarity index 100%
rename from 061
rename to tests/xfs/061
diff --git a/061.out b/tests/xfs/061.out
similarity index 100%
rename from 061.out
rename to tests/xfs/061.out
diff --git a/063 b/tests/xfs/063
similarity index 100%
rename from 063
rename to tests/xfs/063
diff --git a/063.out b/tests/xfs/063.out
similarity index 100%
rename from 063.out
rename to tests/xfs/063.out
diff --git a/064 b/tests/xfs/064
similarity index 100%
rename from 064
rename to tests/xfs/064
diff --git a/064.out b/tests/xfs/064.out
similarity index 100%
rename from 064.out
rename to tests/xfs/064.out
diff --git a/065 b/tests/xfs/065
similarity index 100%
rename from 065
rename to tests/xfs/065
diff --git a/065.out b/tests/xfs/065.out
similarity index 100%
rename from 065.out
rename to tests/xfs/065.out
diff --git a/066 b/tests/xfs/066
similarity index 100%
rename from 066
rename to tests/xfs/066
diff --git a/066.out b/tests/xfs/066.out
similarity index 100%
rename from 066.out
rename to tests/xfs/066.out
diff --git a/067 b/tests/xfs/067
similarity index 100%
rename from 067
rename to tests/xfs/067
diff --git a/067.out b/tests/xfs/067.out
similarity index 100%
rename from 067.out
rename to tests/xfs/067.out
diff --git a/071 b/tests/xfs/071
similarity index 100%
rename from 071
rename to tests/xfs/071
diff --git a/071.out b/tests/xfs/071.out
similarity index 100%
rename from 071.out
rename to tests/xfs/071.out
diff --git a/071.out.32 b/tests/xfs/071.out.32
similarity index 100%
rename from 071.out.32
rename to tests/xfs/071.out.32
diff --git a/071.out.64 b/tests/xfs/071.out.64
similarity index 100%
rename from 071.out.64
rename to tests/xfs/071.out.64
diff --git a/072 b/tests/xfs/072
similarity index 100%
rename from 072
rename to tests/xfs/072
diff --git a/072.out b/tests/xfs/072.out
similarity index 100%
rename from 072.out
rename to tests/xfs/072.out
diff --git a/073 b/tests/xfs/073
similarity index 100%
rename from 073
rename to tests/xfs/073
diff --git a/073.out b/tests/xfs/073.out
similarity index 100%
rename from 073.out
rename to tests/xfs/073.out
diff --git a/078 b/tests/xfs/078
similarity index 100%
rename from 078
rename to tests/xfs/078
diff --git a/078.out b/tests/xfs/078.out
similarity index 100%
rename from 078.out
rename to tests/xfs/078.out
diff --git a/080 b/tests/xfs/080
similarity index 100%
rename from 080
rename to tests/xfs/080
diff --git a/080.out b/tests/xfs/080.out
similarity index 100%
rename from 080.out
rename to tests/xfs/080.out
diff --git a/081 b/tests/xfs/081
similarity index 100%
rename from 081
rename to tests/xfs/081
diff --git a/081.out b/tests/xfs/081.out
similarity index 100%
rename from 081.out
rename to tests/xfs/081.out
diff --git a/081.ugquota.trans_inode b/tests/xfs/081.ugquota.trans_inode
similarity index 100%
rename from 081.ugquota.trans_inode
rename to tests/xfs/081.ugquota.trans_inode
diff --git a/082 b/tests/xfs/082
similarity index 100%
rename from 082
rename to tests/xfs/082
diff --git a/082.op.irix b/tests/xfs/082.op.irix
similarity index 100%
rename from 082.op.irix
rename to tests/xfs/082.op.irix
diff --git a/082.op.linux b/tests/xfs/082.op.linux
similarity index 100%
rename from 082.op.linux
rename to tests/xfs/082.op.linux
diff --git a/082.out b/tests/xfs/082.out
similarity index 100%
rename from 082.out
rename to tests/xfs/082.out
diff --git a/082.trans_buf b/tests/xfs/082.trans_buf
similarity index 100%
rename from 082.trans_buf
rename to tests/xfs/082.trans_buf
diff --git a/082.trans_inode b/tests/xfs/082.trans_inode
similarity index 100%
rename from 082.trans_inode
rename to tests/xfs/082.trans_inode
diff --git a/084 b/tests/xfs/084
similarity index 100%
rename from 084
rename to tests/xfs/084
diff --git a/084.out b/tests/xfs/084.out
similarity index 100%
rename from 084.out
rename to tests/xfs/084.out
diff --git a/085 b/tests/xfs/085
similarity index 100%
rename from 085
rename to tests/xfs/085
diff --git a/085.out b/tests/xfs/085.out
similarity index 100%
rename from 085.out
rename to tests/xfs/085.out
diff --git a/086 b/tests/xfs/086
similarity index 100%
rename from 086
rename to tests/xfs/086
diff --git a/086.out b/tests/xfs/086.out
similarity index 100%
rename from 086.out
rename to tests/xfs/086.out
diff --git a/087 b/tests/xfs/087
similarity index 100%
rename from 087
rename to tests/xfs/087
diff --git a/087.out b/tests/xfs/087.out
similarity index 100%
rename from 087.out
rename to tests/xfs/087.out
diff --git a/090 b/tests/xfs/090
similarity index 100%
rename from 090
rename to tests/xfs/090
diff --git a/090.out b/tests/xfs/090.out
similarity index 100%
rename from 090.out
rename to tests/xfs/090.out
diff --git a/092 b/tests/xfs/092
similarity index 100%
rename from 092
rename to tests/xfs/092
diff --git a/092.out b/tests/xfs/092.out
similarity index 100%
rename from 092.out
rename to tests/xfs/092.out
diff --git a/094 b/tests/xfs/094
similarity index 100%
rename from 094
rename to tests/xfs/094
diff --git a/094.out b/tests/xfs/094.out
similarity index 100%
rename from 094.out
rename to tests/xfs/094.out
diff --git a/095 b/tests/xfs/095
similarity index 100%
rename from 095
rename to tests/xfs/095
diff --git a/095.out b/tests/xfs/095.out
similarity index 100%
rename from 095.out
rename to tests/xfs/095.out
diff --git a/096 b/tests/xfs/096
similarity index 100%
rename from 096
rename to tests/xfs/096
diff --git a/096.external b/tests/xfs/096.external
similarity index 100%
rename from 096.external
rename to tests/xfs/096.external
diff --git a/096.internal b/tests/xfs/096.internal
similarity index 100%
rename from 096.internal
rename to tests/xfs/096.internal
diff --git a/103 b/tests/xfs/103
similarity index 100%
rename from 103
rename to tests/xfs/103
diff --git a/103.out b/tests/xfs/103.out
similarity index 100%
rename from 103.out
rename to tests/xfs/103.out
diff --git a/104 b/tests/xfs/104
similarity index 100%
rename from 104
rename to tests/xfs/104
diff --git a/104.out b/tests/xfs/104.out
similarity index 100%
rename from 104.out
rename to tests/xfs/104.out
diff --git a/106 b/tests/xfs/106
similarity index 100%
rename from 106
rename to tests/xfs/106
diff --git a/106.out b/tests/xfs/106.out
similarity index 100%
rename from 106.out
rename to tests/xfs/106.out
diff --git a/107 b/tests/xfs/107
similarity index 100%
rename from 107
rename to tests/xfs/107
diff --git a/107.out b/tests/xfs/107.out
similarity index 100%
rename from 107.out
rename to tests/xfs/107.out
diff --git a/108 b/tests/xfs/108
similarity index 100%
rename from 108
rename to tests/xfs/108
diff --git a/108.out b/tests/xfs/108.out
similarity index 100%
rename from 108.out
rename to tests/xfs/108.out
diff --git a/109 b/tests/xfs/109
similarity index 100%
rename from 109
rename to tests/xfs/109
diff --git a/109.out b/tests/xfs/109.out
similarity index 100%
rename from 109.out
rename to tests/xfs/109.out
diff --git a/110 b/tests/xfs/110
similarity index 100%
rename from 110
rename to tests/xfs/110
diff --git a/110.out b/tests/xfs/110.out
similarity index 100%
rename from 110.out
rename to tests/xfs/110.out
diff --git a/111 b/tests/xfs/111
similarity index 100%
rename from 111
rename to tests/xfs/111
diff --git a/111.out b/tests/xfs/111.out
similarity index 100%
rename from 111.out
rename to tests/xfs/111.out
diff --git a/114 b/tests/xfs/114
similarity index 100%
rename from 114
rename to tests/xfs/114
diff --git a/114.out b/tests/xfs/114.out
similarity index 100%
rename from 114.out
rename to tests/xfs/114.out
diff --git a/115 b/tests/xfs/115
similarity index 100%
rename from 115
rename to tests/xfs/115
diff --git a/115.out b/tests/xfs/115.out
similarity index 100%
rename from 115.out
rename to tests/xfs/115.out
diff --git a/116 b/tests/xfs/116
similarity index 100%
rename from 116
rename to tests/xfs/116
diff --git a/116.out b/tests/xfs/116.out
similarity index 100%
rename from 116.out
rename to tests/xfs/116.out
diff --git a/118 b/tests/xfs/118
similarity index 100%
rename from 118
rename to tests/xfs/118
diff --git a/118.out b/tests/xfs/118.out
similarity index 100%
rename from 118.out
rename to tests/xfs/118.out
diff --git a/119 b/tests/xfs/119
similarity index 100%
rename from 119
rename to tests/xfs/119
diff --git a/119.out b/tests/xfs/119.out
similarity index 100%
rename from 119.out
rename to tests/xfs/119.out
diff --git a/121 b/tests/xfs/121
similarity index 100%
rename from 121
rename to tests/xfs/121
diff --git a/121.out b/tests/xfs/121.out
similarity index 100%
rename from 121.out
rename to tests/xfs/121.out
diff --git a/122 b/tests/xfs/122
similarity index 100%
rename from 122
rename to tests/xfs/122
diff --git a/122.out b/tests/xfs/122.out
similarity index 100%
rename from 122.out
rename to tests/xfs/122.out
diff --git a/134 b/tests/xfs/134
similarity index 100%
rename from 134
rename to tests/xfs/134
diff --git a/134.out b/tests/xfs/134.out
similarity index 100%
rename from 134.out
rename to tests/xfs/134.out
diff --git a/136 b/tests/xfs/136
similarity index 100%
rename from 136
rename to tests/xfs/136
diff --git a/136.out b/tests/xfs/136.out
similarity index 100%
rename from 136.out
rename to tests/xfs/136.out
diff --git a/137 b/tests/xfs/137
similarity index 100%
rename from 137
rename to tests/xfs/137
diff --git a/137.out b/tests/xfs/137.out
similarity index 100%
rename from 137.out
rename to tests/xfs/137.out
diff --git a/138 b/tests/xfs/138
similarity index 100%
rename from 138
rename to tests/xfs/138
diff --git a/138.out b/tests/xfs/138.out
similarity index 100%
rename from 138.out
rename to tests/xfs/138.out
diff --git a/139 b/tests/xfs/139
similarity index 100%
rename from 139
rename to tests/xfs/139
diff --git a/139.out b/tests/xfs/139.out
similarity index 100%
rename from 139.out
rename to tests/xfs/139.out
diff --git a/140 b/tests/xfs/140
similarity index 100%
rename from 140
rename to tests/xfs/140
diff --git a/140.out b/tests/xfs/140.out
similarity index 100%
rename from 140.out
rename to tests/xfs/140.out
diff --git a/142 b/tests/xfs/142
similarity index 100%
rename from 142
rename to tests/xfs/142
diff --git a/142.out b/tests/xfs/142.out
similarity index 100%
rename from 142.out
rename to tests/xfs/142.out
diff --git a/143 b/tests/xfs/143
similarity index 100%
rename from 143
rename to tests/xfs/143
diff --git a/143.out b/tests/xfs/143.out
similarity index 100%
rename from 143.out
rename to tests/xfs/143.out
diff --git a/144 b/tests/xfs/144
similarity index 100%
rename from 144
rename to tests/xfs/144
diff --git a/144.out b/tests/xfs/144.out
similarity index 100%
rename from 144.out
rename to tests/xfs/144.out
diff --git a/145 b/tests/xfs/145
similarity index 100%
rename from 145
rename to tests/xfs/145
diff --git a/145.out b/tests/xfs/145.out
similarity index 100%
rename from 145.out
rename to tests/xfs/145.out
diff --git a/146 b/tests/xfs/146
similarity index 100%
rename from 146
rename to tests/xfs/146
diff --git a/146.out.irix b/tests/xfs/146.out.irix
similarity index 100%
rename from 146.out.irix
rename to tests/xfs/146.out.irix
diff --git a/146.out.linux b/tests/xfs/146.out.linux
similarity index 100%
rename from 146.out.linux
rename to tests/xfs/146.out.linux
diff --git a/147 b/tests/xfs/147
similarity index 100%
rename from 147
rename to tests/xfs/147
diff --git a/147.out b/tests/xfs/147.out
similarity index 100%
rename from 147.out
rename to tests/xfs/147.out
diff --git a/148 b/tests/xfs/148
similarity index 100%
rename from 148
rename to tests/xfs/148
diff --git a/148.out b/tests/xfs/148.out
similarity index 100%
rename from 148.out
rename to tests/xfs/148.out
diff --git a/149 b/tests/xfs/149
similarity index 100%
rename from 149
rename to tests/xfs/149
diff --git a/149.out b/tests/xfs/149.out
similarity index 100%
rename from 149.out
rename to tests/xfs/149.out
diff --git a/150 b/tests/xfs/150
similarity index 100%
rename from 150
rename to tests/xfs/150
diff --git a/150.out b/tests/xfs/150.out
similarity index 100%
rename from 150.out
rename to tests/xfs/150.out
diff --git a/151 b/tests/xfs/151
similarity index 100%
rename from 151
rename to tests/xfs/151
diff --git a/151.out b/tests/xfs/151.out
similarity index 100%
rename from 151.out
rename to tests/xfs/151.out
diff --git a/152 b/tests/xfs/152
similarity index 100%
rename from 152
rename to tests/xfs/152
diff --git a/152.out b/tests/xfs/152.out
similarity index 100%
rename from 152.out
rename to tests/xfs/152.out
diff --git a/153 b/tests/xfs/153
similarity index 100%
rename from 153
rename to tests/xfs/153
diff --git a/153.out b/tests/xfs/153.out
similarity index 100%
rename from 153.out
rename to tests/xfs/153.out
diff --git a/154 b/tests/xfs/154
similarity index 100%
rename from 154
rename to tests/xfs/154
diff --git a/154.out b/tests/xfs/154.out
similarity index 100%
rename from 154.out
rename to tests/xfs/154.out
diff --git a/155 b/tests/xfs/155
similarity index 100%
rename from 155
rename to tests/xfs/155
diff --git a/155.out b/tests/xfs/155.out
similarity index 100%
rename from 155.out
rename to tests/xfs/155.out
diff --git a/156 b/tests/xfs/156
similarity index 100%
rename from 156
rename to tests/xfs/156
diff --git a/156.out b/tests/xfs/156.out
similarity index 100%
rename from 156.out
rename to tests/xfs/156.out
diff --git a/157 b/tests/xfs/157
similarity index 100%
rename from 157
rename to tests/xfs/157
diff --git a/157.out b/tests/xfs/157.out
similarity index 100%
rename from 157.out
rename to tests/xfs/157.out
diff --git a/158 b/tests/xfs/158
similarity index 100%
rename from 158
rename to tests/xfs/158
diff --git a/158.out b/tests/xfs/158.out
similarity index 100%
rename from 158.out
rename to tests/xfs/158.out
diff --git a/159 b/tests/xfs/159
similarity index 100%
rename from 159
rename to tests/xfs/159
diff --git a/159.out b/tests/xfs/159.out
similarity index 100%
rename from 159.out
rename to tests/xfs/159.out
diff --git a/160 b/tests/xfs/160
similarity index 100%
rename from 160
rename to tests/xfs/160
diff --git a/160.out b/tests/xfs/160.out
similarity index 100%
rename from 160.out
rename to tests/xfs/160.out
diff --git a/161 b/tests/xfs/161
similarity index 100%
rename from 161
rename to tests/xfs/161
diff --git a/161.out b/tests/xfs/161.out
similarity index 100%
rename from 161.out
rename to tests/xfs/161.out
diff --git a/162 b/tests/xfs/162
similarity index 100%
rename from 162
rename to tests/xfs/162
diff --git a/162.out b/tests/xfs/162.out
similarity index 100%
rename from 162.out
rename to tests/xfs/162.out
diff --git a/163 b/tests/xfs/163
similarity index 100%
rename from 163
rename to tests/xfs/163
diff --git a/163.out b/tests/xfs/163.out
similarity index 100%
rename from 163.out
rename to tests/xfs/163.out
diff --git a/164 b/tests/xfs/164
similarity index 100%
rename from 164
rename to tests/xfs/164
diff --git a/164.out b/tests/xfs/164.out
similarity index 100%
rename from 164.out
rename to tests/xfs/164.out
diff --git a/165 b/tests/xfs/165
similarity index 100%
rename from 165
rename to tests/xfs/165
diff --git a/165.out b/tests/xfs/165.out
similarity index 100%
rename from 165.out
rename to tests/xfs/165.out
diff --git a/166 b/tests/xfs/166
similarity index 100%
rename from 166
rename to tests/xfs/166
diff --git a/166.out b/tests/xfs/166.out
similarity index 100%
rename from 166.out
rename to tests/xfs/166.out
diff --git a/167 b/tests/xfs/167
similarity index 100%
rename from 167
rename to tests/xfs/167
diff --git a/167.out b/tests/xfs/167.out
similarity index 100%
rename from 167.out
rename to tests/xfs/167.out
diff --git a/168 b/tests/xfs/168
similarity index 100%
rename from 168
rename to tests/xfs/168
diff --git a/168.out b/tests/xfs/168.out
similarity index 100%
rename from 168.out
rename to tests/xfs/168.out
diff --git a/170 b/tests/xfs/170
similarity index 100%
rename from 170
rename to tests/xfs/170
diff --git a/170.out b/tests/xfs/170.out
similarity index 100%
rename from 170.out
rename to tests/xfs/170.out
diff --git a/171 b/tests/xfs/171
similarity index 100%
rename from 171
rename to tests/xfs/171
diff --git a/171.out b/tests/xfs/171.out
similarity index 100%
rename from 171.out
rename to tests/xfs/171.out
diff --git a/172 b/tests/xfs/172
similarity index 100%
rename from 172
rename to tests/xfs/172
diff --git a/172.out b/tests/xfs/172.out
similarity index 100%
rename from 172.out
rename to tests/xfs/172.out
diff --git a/173 b/tests/xfs/173
similarity index 100%
rename from 173
rename to tests/xfs/173
diff --git a/173.out b/tests/xfs/173.out
similarity index 100%
rename from 173.out
rename to tests/xfs/173.out
diff --git a/174 b/tests/xfs/174
similarity index 100%
rename from 174
rename to tests/xfs/174
diff --git a/174.out b/tests/xfs/174.out
similarity index 100%
rename from 174.out
rename to tests/xfs/174.out
diff --git a/175 b/tests/xfs/175
similarity index 100%
rename from 175
rename to tests/xfs/175
diff --git a/175.out b/tests/xfs/175.out
similarity index 100%
rename from 175.out
rename to tests/xfs/175.out
diff --git a/176 b/tests/xfs/176
similarity index 100%
rename from 176
rename to tests/xfs/176
diff --git a/176.out b/tests/xfs/176.out
similarity index 100%
rename from 176.out
rename to tests/xfs/176.out
diff --git a/178 b/tests/xfs/178
similarity index 100%
rename from 178
rename to tests/xfs/178
diff --git a/178.out b/tests/xfs/178.out
similarity index 100%
rename from 178.out
rename to tests/xfs/178.out
diff --git a/179 b/tests/xfs/179
similarity index 100%
rename from 179
rename to tests/xfs/179
diff --git a/179.out b/tests/xfs/179.out
similarity index 100%
rename from 179.out
rename to tests/xfs/179.out
diff --git a/180 b/tests/xfs/180
similarity index 100%
rename from 180
rename to tests/xfs/180
diff --git a/180.out b/tests/xfs/180.out
similarity index 100%
rename from 180.out
rename to tests/xfs/180.out
diff --git a/181 b/tests/xfs/181
similarity index 100%
rename from 181
rename to tests/xfs/181
diff --git a/181.out b/tests/xfs/181.out
similarity index 100%
rename from 181.out
rename to tests/xfs/181.out
diff --git a/182 b/tests/xfs/182
similarity index 100%
rename from 182
rename to tests/xfs/182
diff --git a/182.out b/tests/xfs/182.out
similarity index 100%
rename from 182.out
rename to tests/xfs/182.out
diff --git a/183 b/tests/xfs/183
similarity index 100%
rename from 183
rename to tests/xfs/183
diff --git a/183.out b/tests/xfs/183.out
similarity index 100%
rename from 183.out
rename to tests/xfs/183.out
diff --git a/185 b/tests/xfs/185
similarity index 100%
rename from 185
rename to tests/xfs/185
diff --git a/185.out b/tests/xfs/185.out
similarity index 100%
rename from 185.out
rename to tests/xfs/185.out
diff --git a/186 b/tests/xfs/186
similarity index 100%
rename from 186
rename to tests/xfs/186
diff --git a/186.out b/tests/xfs/186.out
similarity index 100%
rename from 186.out
rename to tests/xfs/186.out
diff --git a/187 b/tests/xfs/187
similarity index 100%
rename from 187
rename to tests/xfs/187
diff --git a/187.out b/tests/xfs/187.out
similarity index 100%
rename from 187.out
rename to tests/xfs/187.out
diff --git a/188 b/tests/xfs/188
similarity index 100%
rename from 188
rename to tests/xfs/188
diff --git a/188.out b/tests/xfs/188.out
similarity index 100%
rename from 188.out
rename to tests/xfs/188.out
diff --git a/189 b/tests/xfs/189
similarity index 100%
rename from 189
rename to tests/xfs/189
diff --git a/189.out b/tests/xfs/189.out
similarity index 100%
rename from 189.out
rename to tests/xfs/189.out
diff --git a/190 b/tests/xfs/190
similarity index 100%
rename from 190
rename to tests/xfs/190
diff --git a/190.out b/tests/xfs/190.out
similarity index 100%
rename from 190.out
rename to tests/xfs/190.out
diff --git a/191 b/tests/xfs/191
similarity index 100%
rename from 191
rename to tests/xfs/191
diff --git a/191.out b/tests/xfs/191.out
similarity index 100%
rename from 191.out
rename to tests/xfs/191.out
diff --git a/194 b/tests/xfs/194
similarity index 100%
rename from 194
rename to tests/xfs/194
diff --git a/194.out b/tests/xfs/194.out
similarity index 100%
rename from 194.out
rename to tests/xfs/194.out
diff --git a/195 b/tests/xfs/195
similarity index 100%
rename from 195
rename to tests/xfs/195
diff --git a/195.out b/tests/xfs/195.out
similarity index 100%
rename from 195.out
rename to tests/xfs/195.out
diff --git a/196 b/tests/xfs/196
similarity index 100%
rename from 196
rename to tests/xfs/196
diff --git a/196.out b/tests/xfs/196.out
similarity index 100%
rename from 196.out
rename to tests/xfs/196.out
diff --git a/197 b/tests/xfs/197
similarity index 100%
rename from 197
rename to tests/xfs/197
diff --git a/197.out b/tests/xfs/197.out
similarity index 100%
rename from 197.out
rename to tests/xfs/197.out
diff --git a/199 b/tests/xfs/199
similarity index 100%
rename from 199
rename to tests/xfs/199
diff --git a/199.out b/tests/xfs/199.out
similarity index 100%
rename from 199.out
rename to tests/xfs/199.out
diff --git a/200 b/tests/xfs/200
similarity index 100%
rename from 200
rename to tests/xfs/200
diff --git a/200.out b/tests/xfs/200.out
similarity index 100%
rename from 200.out
rename to tests/xfs/200.out
diff --git a/201 b/tests/xfs/201
similarity index 100%
rename from 201
rename to tests/xfs/201
diff --git a/201.out b/tests/xfs/201.out
similarity index 100%
rename from 201.out
rename to tests/xfs/201.out
diff --git a/202 b/tests/xfs/202
similarity index 100%
rename from 202
rename to tests/xfs/202
diff --git a/202.out b/tests/xfs/202.out
similarity index 100%
rename from 202.out
rename to tests/xfs/202.out
diff --git a/203 b/tests/xfs/203
similarity index 100%
rename from 203
rename to tests/xfs/203
diff --git a/203.out b/tests/xfs/203.out
similarity index 100%
rename from 203.out
rename to tests/xfs/203.out
diff --git a/205 b/tests/xfs/205
similarity index 100%
rename from 205
rename to tests/xfs/205
diff --git a/205.out b/tests/xfs/205.out
similarity index 100%
rename from 205.out
rename to tests/xfs/205.out
diff --git a/206 b/tests/xfs/206
similarity index 100%
rename from 206
rename to tests/xfs/206
diff --git a/206.out b/tests/xfs/206.out
similarity index 100%
rename from 206.out
rename to tests/xfs/206.out
diff --git a/216 b/tests/xfs/216
similarity index 100%
rename from 216
rename to tests/xfs/216
diff --git a/216.out b/tests/xfs/216.out
similarity index 100%
rename from 216.out
rename to tests/xfs/216.out
diff --git a/217 b/tests/xfs/217
similarity index 100%
rename from 217
rename to tests/xfs/217
diff --git a/217.out b/tests/xfs/217.out
similarity index 100%
rename from 217.out
rename to tests/xfs/217.out
diff --git a/220 b/tests/xfs/220
similarity index 100%
rename from 220
rename to tests/xfs/220
diff --git a/220.out b/tests/xfs/220.out
similarity index 100%
rename from 220.out
rename to tests/xfs/220.out
diff --git a/222 b/tests/xfs/222
similarity index 100%
rename from 222
rename to tests/xfs/222
diff --git a/222.out b/tests/xfs/222.out
similarity index 100%
rename from 222.out
rename to tests/xfs/222.out
diff --git a/227 b/tests/xfs/227
similarity index 100%
rename from 227
rename to tests/xfs/227
diff --git a/227.out b/tests/xfs/227.out
similarity index 100%
rename from 227.out
rename to tests/xfs/227.out
diff --git a/229 b/tests/xfs/229
similarity index 100%
rename from 229
rename to tests/xfs/229
diff --git a/229.out b/tests/xfs/229.out
similarity index 100%
rename from 229.out
rename to tests/xfs/229.out
diff --git a/238 b/tests/xfs/238
similarity index 100%
rename from 238
rename to tests/xfs/238
diff --git a/238.out b/tests/xfs/238.out
similarity index 100%
rename from 238.out
rename to tests/xfs/238.out
diff --git a/242 b/tests/xfs/242
similarity index 100%
rename from 242
rename to tests/xfs/242
diff --git a/242.out b/tests/xfs/242.out
similarity index 100%
rename from 242.out
rename to tests/xfs/242.out
diff --git a/244 b/tests/xfs/244
similarity index 100%
rename from 244
rename to tests/xfs/244
diff --git a/244.out b/tests/xfs/244.out
similarity index 100%
rename from 244.out
rename to tests/xfs/244.out
diff --git a/250 b/tests/xfs/250
similarity index 100%
rename from 250
rename to tests/xfs/250
diff --git a/250.out b/tests/xfs/250.out
similarity index 100%
rename from 250.out
rename to tests/xfs/250.out
diff --git a/253 b/tests/xfs/253
similarity index 100%
rename from 253
rename to tests/xfs/253
diff --git a/253.out b/tests/xfs/253.out
similarity index 100%
rename from 253.out
rename to tests/xfs/253.out
diff --git a/259 b/tests/xfs/259
similarity index 100%
rename from 259
rename to tests/xfs/259
diff --git a/259.out b/tests/xfs/259.out
similarity index 100%
rename from 259.out
rename to tests/xfs/259.out
diff --git a/261 b/tests/xfs/261
similarity index 100%
rename from 261
rename to tests/xfs/261
diff --git a/261.out b/tests/xfs/261.out
similarity index 100%
rename from 261.out
rename to tests/xfs/261.out
diff --git a/262 b/tests/xfs/262
similarity index 100%
rename from 262
rename to tests/xfs/262
diff --git a/262.out b/tests/xfs/262.out
similarity index 100%
rename from 262.out
rename to tests/xfs/262.out
diff --git a/266 b/tests/xfs/266
similarity index 100%
rename from 266
rename to tests/xfs/266
diff --git a/266.out b/tests/xfs/266.out
similarity index 100%
rename from 266.out
rename to tests/xfs/266.out
diff --git a/267 b/tests/xfs/267
similarity index 100%
rename from 267
rename to tests/xfs/267
diff --git a/267.out b/tests/xfs/267.out
similarity index 100%
rename from 267.out
rename to tests/xfs/267.out
diff --git a/268 b/tests/xfs/268
similarity index 100%
rename from 268
rename to tests/xfs/268
diff --git a/268.out b/tests/xfs/268.out
similarity index 100%
rename from 268.out
rename to tests/xfs/268.out
diff --git a/278 b/tests/xfs/278
similarity index 100%
rename from 278
rename to tests/xfs/278
diff --git a/278.out b/tests/xfs/278.out
similarity index 100%
rename from 278.out
rename to tests/xfs/278.out
diff --git a/279 b/tests/xfs/279
similarity index 100%
rename from 279
rename to tests/xfs/279
diff --git a/279.out b/tests/xfs/279.out
similarity index 100%
rename from 279.out
rename to tests/xfs/279.out
diff --git a/281 b/tests/xfs/281
similarity index 100%
rename from 281
rename to tests/xfs/281
diff --git a/281.out b/tests/xfs/281.out
similarity index 100%
rename from 281.out
rename to tests/xfs/281.out
diff --git a/282 b/tests/xfs/282
similarity index 100%
rename from 282
rename to tests/xfs/282
diff --git a/282.out b/tests/xfs/282.out
similarity index 100%
rename from 282.out
rename to tests/xfs/282.out
diff --git a/283 b/tests/xfs/283
similarity index 100%
rename from 283
rename to tests/xfs/283
diff --git a/283.out b/tests/xfs/283.out
similarity index 100%
rename from 283.out
rename to tests/xfs/283.out
diff --git a/group b/tests/xfs/group
similarity index 70%
copy from group
copy to tests/xfs/group
index acde48e..6686e38 100644
--- a/group
+++ b/tests/xfs/group
@@ -3,119 +3,6 @@
 # - do not start group names with a digit
 # - comment line before each group is "new" description
 #
-
-# catch-all
-other
-
-# read/write integrity
-rw
-
-# directory operations, e.g. create/unlink
-dir
-
-# metadata and inodes in particular
-metadata
-
-# xfs_db
-db
-
-# extended attributes
-attr
-
-# xfs_logprint
-logprint
-
-# XFS log related testing
-log
-
-# XFS log related testing
-v2log
-
-# xfsdump, xfsrestore, xfsinvutil
-dump
-
-# xfsdump, xfsrestore to tapes
-tape
-
-# xfsdump, xfsrestore to remote tapes
-remote
-
-# xfs_copy
-copy
-
-# chacl, libacl
-acl
-
-# capabilities
-cap
-
-# permissions
-perms
-
-# xfs_growfs
-growfs
-
-# fsr.xfs
-fsr
-
-# mkfs.xfs
-mkfs
-
-# xfs_repair
-repair
-
-# quota tools and XFS quota kernel code (XQM)
-quota
-
-# auto - tests to be run as part of nightly qa
-auto
-
-# ioctl - tests which use ioctl commands (directly/indirectly)
-ioctl
-
-# udf filesystem
-udf
-
-# AIO operations
-aio
-
-# Pattern writing and checking
-pattern
-
-# dmapi based tests
-dmapi
-
-# filestreams based tests
-filestreams
-
-# case-insensitive based tests
-ci
-
-# test the mount/remount path
-mount
-
-# test the NFS v4 ACL code if it exists
-nfs4acl
-
-# test access time
-atime
-
-# Test preallocation calls
-prealloc
-
-# Test filesystem freeze
-freeze
-
-# Tests which may oops or hang
-dangerous
-
-# Old tests that we won't spend any effort trying to run and make work
-# on current systems
-deprecated
-
-#
-# test-group association ... one line per test
-#
 003 db auto quick
 004 db auto quick
 008 rw ioctl auto quick
@@ -144,7 +31,6 @@ deprecated
 037 dump ioctl remote tape
 038 dump ioctl remote tape
 039 dump ioctl remote tape
-040 other auto
 041 growfs ioctl auto
 042 fsr ioctl auto
 043 dump ioctl tape
@@ -155,7 +41,6 @@ deprecated
 048 other auto quick
 049 rw auto quick
 050 quota auto quick
-051 acl udf auto quick
 052 quota db auto quick
 054 quota auto quick
 055 dump ioctl remote tape
@@ -170,7 +55,6 @@ deprecated
 065 dump auto
 066 dump ioctl auto quick
 067 acl attr auto quick
-068 other auto freeze dangerous
 071 rw auto
 072 rw auto prealloc quick
 073 copy auto
@@ -187,9 +71,6 @@ deprecated
 094 metadata dir ioctl auto
 095 log v2log auto
 096 mkfs v2log auto quick
-098 udf auto
-101 udf
-102 udf
 103 metadata dir ioctl auto quick
 104 growfs ioctl prealloc auto
 106 quota
@@ -248,7 +129,6 @@ deprecated
 174 rw filestreams auto
 175 dmapi auto
 176 dmapi auto
-177 rw other auto
 178 mkfs other auto
 179 metadata rw auto
 180 metadata rw auto
@@ -275,33 +155,23 @@ deprecated
 206 growfs auto quick
 216 log metadata auto quick
 217 log metadata auto
-218 auto fsr quick
 220 auto quota quick
 222 auto fsr ioctl quick
 227 auto fsr
 229 auto rw
 238 auto quick metadata ioctl
 242 auto quick prealloc
-243 auto quick prealloc
 244 auto quota quick
 250 auto quick rw prealloc metadata
-252 auto quick prealloc
 253 auto quick
-254 auto quick
 259 auto quick
 261 auto quick quota
 262 auto quick quota
-264 auto
-265 auto
 266 dump ioctl auto quick
 267 dump ioctl tape
 268 dump ioctl tape
-271 auto rw quick
-272 auto enospc rw
-276 auto rw metadata
 278 repair auto
 279 auto mkfs
 281 dump ioctl auto quick
 282 dump ioctl auto quick
 283 dump ioctl auto quick
-284 auto
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
