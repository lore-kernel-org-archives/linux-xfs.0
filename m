Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9ShLM006918 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:43 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VNrjCALfCHRplhuy for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:38 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKN1-0001B1-Ay
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:35 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMr-0005Vi-7i
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/18] xfstests: move generic tests out of top level dir
Date: Thu, 26 Jul 2012 19:28:05 +1000
Message-Id: <1343294892-20991-12-git-send-email-david@fromorbit.com>
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

And into tests/generic.  Tests were found simply by grepping for the
__supported_fs field in the tests.

Output starts to look like:

$ sudo ./check -g quick -r
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test-1 3.5.0-rc5-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

./242    1s
./183    2s
generic/236      1s
generic/014      1s
generic/258      0s
./096    1s
generic/245      0s
^C
Ran: ./242 ./183 generic/236 generic/014 generic/258 ./096 generic/245
Passed all 7 tests

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 group                                        |   98 --------------------------
 001 => tests/generic/001                     |    0
 001.out => tests/generic/001.out             |    0
 002 => tests/generic/002                     |    0
 002.out => tests/generic/002.out             |    0
 005 => tests/generic/005                     |    0
 005.out => tests/generic/005.out             |    0
 006 => tests/generic/006                     |    0
 006.out => tests/generic/006.out             |    0
 007 => tests/generic/007                     |    0
 007.out => tests/generic/007.out             |    0
 010 => tests/generic/010                     |    0
 010.out => tests/generic/010.out             |    0
 011 => tests/generic/011                     |    0
 011.out => tests/generic/011.out             |    0
 013 => tests/generic/013                     |    0
 013.out => tests/generic/013.out             |    0
 014 => tests/generic/014                     |    0
 014.out => tests/generic/014.out             |    0
 015 => tests/generic/015                     |    0
 015.out => tests/generic/015.out             |    0
 020 => tests/generic/020                     |    0
 020.out => tests/generic/020.out             |    0
 053 => tests/generic/053                     |    0
 053.out => tests/generic/053.out             |    0
 062 => tests/generic/062                     |    0
 062.out => tests/generic/062.out             |    0
 069 => tests/generic/069                     |    0
 069.out => tests/generic/069.out             |    0
 070 => tests/generic/070                     |    0
 070.out => tests/generic/070.out             |    0
 074 => tests/generic/074                     |    0
 074.out => tests/generic/074.out             |    0
 075 => tests/generic/075                     |    0
 075.out => tests/generic/075.out             |    0
 076 => tests/generic/076                     |    0
 076.out => tests/generic/076.out             |    0
 077 => tests/generic/077                     |    0
 077.out => tests/generic/077.out             |    0
 079 => tests/generic/079                     |    0
 079.out => tests/generic/079.out             |    0
 083 => tests/generic/083                     |    0
 083.out => tests/generic/083.out             |    0
 088 => tests/generic/088                     |    0
 088.out.irix => tests/generic/088.out.irix   |    0
 088.out.linux => tests/generic/088.out.linux |    0
 089 => tests/generic/089                     |    0
 089.out => tests/generic/089.out             |    0
 091 => tests/generic/091                     |    0
 091.out => tests/generic/091.out             |    0
 093 => tests/generic/093                     |    0
 093.out => tests/generic/093.out             |  Bin 917 -> 917 bytes
 097 => tests/generic/097                     |    0
 097.out.udf => tests/generic/097.out.udf     |    0
 097.out.xfs => tests/generic/097.out.xfs     |    0
 099 => tests/generic/099                     |    0
 099.out => tests/generic/099.out             |    0
 100 => tests/generic/100                     |    0
 100.out => tests/generic/100.out             |    0
 105 => tests/generic/105                     |    0
 105.out => tests/generic/105.out             |    0
 112 => tests/generic/112                     |    0
 112.out => tests/generic/112.out             |    0
 113 => tests/generic/113                     |    0
 113.out => tests/generic/113.out             |    0
 117 => tests/generic/117                     |    0
 117.out => tests/generic/117.out             |    0
 120 => tests/generic/120                     |    0
 120.out => tests/generic/120.out             |    0
 123 => tests/generic/123                     |    0
 123.out => tests/generic/123.out             |    0
 124 => tests/generic/124                     |    0
 124.out => tests/generic/124.out             |    0
 125 => tests/generic/125                     |    0
 125.out => tests/generic/125.out             |    0
 126 => tests/generic/126                     |    0
 126.out => tests/generic/126.out             |    0
 127 => tests/generic/127                     |    0
 127.out => tests/generic/127.out             |    0
 128 => tests/generic/128                     |    0
 128.out => tests/generic/128.out             |    0
 129 => tests/generic/129                     |    0
 129.out => tests/generic/129.out             |    0
 130 => tests/generic/130                     |    0
 130.out => tests/generic/130.out             |    0
 131 => tests/generic/131                     |    0
 131.out => tests/generic/131.out             |    0
 132 => tests/generic/132                     |    0
 132.out => tests/generic/132.out             |    0
 133 => tests/generic/133                     |    0
 133.out => tests/generic/133.out             |    0
 135 => tests/generic/135                     |    0
 135.out => tests/generic/135.out             |    0
 141 => tests/generic/141                     |    0
 141.out => tests/generic/141.out             |    0
 169 => tests/generic/169                     |    0
 169.out => tests/generic/169.out             |    0
 184 => tests/generic/184                     |    0
 184.out => tests/generic/184.out             |    0
 192 => tests/generic/192                     |    0
 192.out => tests/generic/192.out             |    0
 193 => tests/generic/193                     |    0
 193.out => tests/generic/193.out             |    0
 198 => tests/generic/198                     |    0
 198.out => tests/generic/198.out             |    0
 204 => tests/generic/204                     |    0
 204.out => tests/generic/204.out             |    0
 207 => tests/generic/207                     |    0
 207.out => tests/generic/207.out             |    0
 208 => tests/generic/208                     |    0
 208.out => tests/generic/208.out             |    0
 209 => tests/generic/209                     |    0
 209.out => tests/generic/209.out             |    0
 210 => tests/generic/210                     |    0
 210.out => tests/generic/210.out             |    0
 211 => tests/generic/211                     |    0
 211.out => tests/generic/211.out             |    0
 212 => tests/generic/212                     |    0
 212.out => tests/generic/212.out             |    0
 213 => tests/generic/213                     |    0
 213.out => tests/generic/213.out             |    0
 214 => tests/generic/214                     |    0
 214.out => tests/generic/214.out             |    0
 215 => tests/generic/215                     |    0
 215.out => tests/generic/215.out             |    0
 219 => tests/generic/219                     |    0
 219.out => tests/generic/219.out             |    0
 221 => tests/generic/221                     |    0
 221.out => tests/generic/221.out             |    0
 223 => tests/generic/223                     |    0
 223.out => tests/generic/223.out             |    0
 224 => tests/generic/224                     |    0
 224.out => tests/generic/224.out             |    0
 225 => tests/generic/225                     |    0
 225.out => tests/generic/225.out             |    0
 226 => tests/generic/226                     |    0
 226.out => tests/generic/226.out             |    0
 228 => tests/generic/228                     |    0
 228.out => tests/generic/228.out             |    0
 230 => tests/generic/230                     |    0
 230.out => tests/generic/230.out             |    0
 231 => tests/generic/231                     |    0
 231.out => tests/generic/231.out             |    0
 232 => tests/generic/232                     |    0
 232.out => tests/generic/232.out             |    0
 233 => tests/generic/233                     |    0
 233.out => tests/generic/233.out             |    0
 234 => tests/generic/234                     |    0
 234.out => tests/generic/234.out             |    0
 235 => tests/generic/235                     |    0
 235.out => tests/generic/235.out             |    0
 236 => tests/generic/236                     |    0
 236.out => tests/generic/236.out             |    0
 237 => tests/generic/237                     |    0
 237.out => tests/generic/237.out             |    0
 239 => tests/generic/239                     |    0
 239.out => tests/generic/239.out             |    0
 240 => tests/generic/240                     |    0
 240.out => tests/generic/240.out             |    0
 241 => tests/generic/241                     |    0
 241.out => tests/generic/241.out             |    0
 245 => tests/generic/245                     |    0
 245.out => tests/generic/245.out             |    0
 246 => tests/generic/246                     |    0
 246.out => tests/generic/246.out             |    0
 247 => tests/generic/247                     |    0
 247.out => tests/generic/247.out             |    0
 248 => tests/generic/248                     |    0
 248.out => tests/generic/248.out             |    0
 249 => tests/generic/249                     |    0
 249.out => tests/generic/249.out             |    0
 251 => tests/generic/251                     |    0
 251.out => tests/generic/251.out             |    0
 255 => tests/generic/255                     |    0
 255.out => tests/generic/255.out             |    0
 256 => tests/generic/256                     |    0
 256.out => tests/generic/256.out             |    0
 257 => tests/generic/257                     |    0
 257.out => tests/generic/257.out             |    0
 258 => tests/generic/258                     |    0
 258.out => tests/generic/258.out             |    0
 260 => tests/generic/260                     |    0
 260.out => tests/generic/260.out             |    0
 263 => tests/generic/263                     |    0
 263.out => tests/generic/263.out             |    0
 269 => tests/generic/269                     |    0
 269.out => tests/generic/269.out             |    0
 270 => tests/generic/270                     |    0
 270.out => tests/generic/270.out             |    0
 273 => tests/generic/273                     |    0
 273.out => tests/generic/273.out             |    0
 274 => tests/generic/274                     |    0
 274.out => tests/generic/274.out             |    0
 275 => tests/generic/275                     |    0
 275.out => tests/generic/275.out             |    0
 277 => tests/generic/277                     |    0
 277.out => tests/generic/277.out             |    0
 280 => tests/generic/280                     |    0
 280.out => tests/generic/280.out             |    0
 tests/generic/group                          |   98 ++++++++++++++++++++++++++
 200 files changed, 98 insertions(+), 98 deletions(-)
 rename 001 => tests/generic/001 (100%)
 rename 001.out => tests/generic/001.out (100%)
 rename 002 => tests/generic/002 (100%)
 rename 002.out => tests/generic/002.out (100%)
 rename 005 => tests/generic/005 (100%)
 rename 005.out => tests/generic/005.out (100%)
 rename 006 => tests/generic/006 (100%)
 rename 006.out => tests/generic/006.out (100%)
 rename 007 => tests/generic/007 (100%)
 rename 007.out => tests/generic/007.out (100%)
 rename 010 => tests/generic/010 (100%)
 rename 010.out => tests/generic/010.out (100%)
 rename 011 => tests/generic/011 (100%)
 rename 011.out => tests/generic/011.out (100%)
 rename 013 => tests/generic/013 (100%)
 rename 013.out => tests/generic/013.out (100%)
 rename 014 => tests/generic/014 (100%)
 rename 014.out => tests/generic/014.out (100%)
 rename 015 => tests/generic/015 (100%)
 rename 015.out => tests/generic/015.out (100%)
 rename 020 => tests/generic/020 (100%)
 rename 020.out => tests/generic/020.out (100%)
 rename 053 => tests/generic/053 (100%)
 rename 053.out => tests/generic/053.out (100%)
 rename 062 => tests/generic/062 (100%)
 rename 062.out => tests/generic/062.out (100%)
 rename 069 => tests/generic/069 (100%)
 rename 069.out => tests/generic/069.out (100%)
 rename 070 => tests/generic/070 (100%)
 rename 070.out => tests/generic/070.out (100%)
 rename 074 => tests/generic/074 (100%)
 rename 074.out => tests/generic/074.out (100%)
 rename 075 => tests/generic/075 (100%)
 rename 075.out => tests/generic/075.out (100%)
 rename 076 => tests/generic/076 (100%)
 rename 076.out => tests/generic/076.out (100%)
 rename 077 => tests/generic/077 (100%)
 rename 077.out => tests/generic/077.out (100%)
 rename 079 => tests/generic/079 (100%)
 rename 079.out => tests/generic/079.out (100%)
 rename 083 => tests/generic/083 (100%)
 rename 083.out => tests/generic/083.out (100%)
 rename 088 => tests/generic/088 (100%)
 rename 088.out.irix => tests/generic/088.out.irix (100%)
 rename 088.out.linux => tests/generic/088.out.linux (100%)
 rename 089 => tests/generic/089 (100%)
 rename 089.out => tests/generic/089.out (100%)
 rename 091 => tests/generic/091 (100%)
 rename 091.out => tests/generic/091.out (100%)
 rename 093 => tests/generic/093 (100%)
 rename 093.out => tests/generic/093.out (100%)
 rename 097 => tests/generic/097 (100%)
 rename 097.out.udf => tests/generic/097.out.udf (100%)
 rename 097.out.xfs => tests/generic/097.out.xfs (100%)
 rename 099 => tests/generic/099 (100%)
 rename 099.out => tests/generic/099.out (100%)
 rename 100 => tests/generic/100 (100%)
 rename 100.out => tests/generic/100.out (100%)
 rename 105 => tests/generic/105 (100%)
 rename 105.out => tests/generic/105.out (100%)
 rename 112 => tests/generic/112 (100%)
 rename 112.out => tests/generic/112.out (100%)
 rename 113 => tests/generic/113 (100%)
 rename 113.out => tests/generic/113.out (100%)
 rename 117 => tests/generic/117 (100%)
 rename 117.out => tests/generic/117.out (100%)
 rename 120 => tests/generic/120 (100%)
 rename 120.out => tests/generic/120.out (100%)
 rename 123 => tests/generic/123 (100%)
 rename 123.out => tests/generic/123.out (100%)
 rename 124 => tests/generic/124 (100%)
 rename 124.out => tests/generic/124.out (100%)
 rename 125 => tests/generic/125 (100%)
 rename 125.out => tests/generic/125.out (100%)
 rename 126 => tests/generic/126 (100%)
 rename 126.out => tests/generic/126.out (100%)
 rename 127 => tests/generic/127 (100%)
 rename 127.out => tests/generic/127.out (100%)
 rename 128 => tests/generic/128 (100%)
 rename 128.out => tests/generic/128.out (100%)
 rename 129 => tests/generic/129 (100%)
 rename 129.out => tests/generic/129.out (100%)
 rename 130 => tests/generic/130 (100%)
 rename 130.out => tests/generic/130.out (100%)
 rename 131 => tests/generic/131 (100%)
 rename 131.out => tests/generic/131.out (100%)
 rename 132 => tests/generic/132 (100%)
 rename 132.out => tests/generic/132.out (100%)
 rename 133 => tests/generic/133 (100%)
 rename 133.out => tests/generic/133.out (100%)
 rename 135 => tests/generic/135 (100%)
 rename 135.out => tests/generic/135.out (100%)
 rename 141 => tests/generic/141 (100%)
 rename 141.out => tests/generic/141.out (100%)
 rename 169 => tests/generic/169 (100%)
 rename 169.out => tests/generic/169.out (100%)
 rename 184 => tests/generic/184 (100%)
 rename 184.out => tests/generic/184.out (100%)
 rename 192 => tests/generic/192 (100%)
 rename 192.out => tests/generic/192.out (100%)
 rename 193 => tests/generic/193 (100%)
 rename 193.out => tests/generic/193.out (100%)
 rename 198 => tests/generic/198 (100%)
 rename 198.out => tests/generic/198.out (100%)
 rename 204 => tests/generic/204 (100%)
 rename 204.out => tests/generic/204.out (100%)
 rename 207 => tests/generic/207 (100%)
 rename 207.out => tests/generic/207.out (100%)
 rename 208 => tests/generic/208 (100%)
 rename 208.out => tests/generic/208.out (100%)
 rename 209 => tests/generic/209 (100%)
 rename 209.out => tests/generic/209.out (100%)
 rename 210 => tests/generic/210 (100%)
 rename 210.out => tests/generic/210.out (100%)
 rename 211 => tests/generic/211 (100%)
 rename 211.out => tests/generic/211.out (100%)
 rename 212 => tests/generic/212 (100%)
 rename 212.out => tests/generic/212.out (100%)
 rename 213 => tests/generic/213 (100%)
 rename 213.out => tests/generic/213.out (100%)
 rename 214 => tests/generic/214 (100%)
 rename 214.out => tests/generic/214.out (100%)
 rename 215 => tests/generic/215 (100%)
 rename 215.out => tests/generic/215.out (100%)
 rename 219 => tests/generic/219 (100%)
 rename 219.out => tests/generic/219.out (100%)
 rename 221 => tests/generic/221 (100%)
 rename 221.out => tests/generic/221.out (100%)
 rename 223 => tests/generic/223 (100%)
 rename 223.out => tests/generic/223.out (100%)
 rename 224 => tests/generic/224 (100%)
 rename 224.out => tests/generic/224.out (100%)
 rename 225 => tests/generic/225 (100%)
 rename 225.out => tests/generic/225.out (100%)
 rename 226 => tests/generic/226 (100%)
 rename 226.out => tests/generic/226.out (100%)
 rename 228 => tests/generic/228 (100%)
 rename 228.out => tests/generic/228.out (100%)
 rename 230 => tests/generic/230 (100%)
 rename 230.out => tests/generic/230.out (100%)
 rename 231 => tests/generic/231 (100%)
 rename 231.out => tests/generic/231.out (100%)
 rename 232 => tests/generic/232 (100%)
 rename 232.out => tests/generic/232.out (100%)
 rename 233 => tests/generic/233 (100%)
 rename 233.out => tests/generic/233.out (100%)
 rename 234 => tests/generic/234 (100%)
 rename 234.out => tests/generic/234.out (100%)
 rename 235 => tests/generic/235 (100%)
 rename 235.out => tests/generic/235.out (100%)
 rename 236 => tests/generic/236 (100%)
 rename 236.out => tests/generic/236.out (100%)
 rename 237 => tests/generic/237 (100%)
 rename 237.out => tests/generic/237.out (100%)
 rename 239 => tests/generic/239 (100%)
 rename 239.out => tests/generic/239.out (100%)
 rename 240 => tests/generic/240 (100%)
 rename 240.out => tests/generic/240.out (100%)
 rename 241 => tests/generic/241 (100%)
 rename 241.out => tests/generic/241.out (100%)
 rename 245 => tests/generic/245 (100%)
 rename 245.out => tests/generic/245.out (100%)
 rename 246 => tests/generic/246 (100%)
 rename 246.out => tests/generic/246.out (100%)
 rename 247 => tests/generic/247 (100%)
 rename 247.out => tests/generic/247.out (100%)
 rename 248 => tests/generic/248 (100%)
 rename 248.out => tests/generic/248.out (100%)
 rename 249 => tests/generic/249 (100%)
 rename 249.out => tests/generic/249.out (100%)
 rename 251 => tests/generic/251 (100%)
 rename 251.out => tests/generic/251.out (100%)
 rename 255 => tests/generic/255 (100%)
 rename 255.out => tests/generic/255.out (100%)
 rename 256 => tests/generic/256 (100%)
 rename 256.out => tests/generic/256.out (100%)
 rename 257 => tests/generic/257 (100%)
 rename 257.out => tests/generic/257.out (100%)
 rename 258 => tests/generic/258 (100%)
 rename 258.out => tests/generic/258.out (100%)
 rename 260 => tests/generic/260 (100%)
 rename 260.out => tests/generic/260.out (100%)
 rename 263 => tests/generic/263 (100%)
 rename 263.out => tests/generic/263.out (100%)
 rename 269 => tests/generic/269 (100%)
 rename 269.out => tests/generic/269.out (100%)
 rename 270 => tests/generic/270 (100%)
 rename 270.out => tests/generic/270.out (100%)
 rename 273 => tests/generic/273 (100%)
 rename 273.out => tests/generic/273.out (100%)
 rename 274 => tests/generic/274 (100%)
 rename 274.out => tests/generic/274.out (100%)
 rename 275 => tests/generic/275 (100%)
 rename 275.out => tests/generic/275.out (100%)
 rename 277 => tests/generic/277 (100%)
 rename 277.out => tests/generic/277.out (100%)
 rename 280 => tests/generic/280 (100%)
 rename 280.out => tests/generic/280.out (100%)

diff --git a/group b/group
index 538e10d..acde48e 100644
--- a/group
+++ b/group
@@ -116,26 +116,15 @@ deprecated
 #
 # test-group association ... one line per test
 #
-001 rw dir udf auto quick
-002 metadata udf auto quick
 003 db auto quick
 004 db auto quick
-005 dir udf auto quick
-006 dir udf auto quick
-007 dir udf auto quick
 008 rw ioctl auto quick
 009 rw ioctl auto prealloc quick
-010 other udf auto
-011 dir udf auto quick
 012 rw auto quick
-013 other ioctl udf auto quick
-014 rw udf auto quick
-015 other auto quick
 016 rw auto quick
 017 mount auto quick
 018 deprecated # log logprint v2log
 019 mkfs auto quick
-020 metadata attr udf auto quick
 021 db attr auto quick
 022 dump ioctl tape
 023 dump ioctl tape
@@ -168,7 +157,6 @@ deprecated
 050 quota auto quick
 051 acl udf auto quick
 052 quota db auto quick
-053 acl repair auto quick
 054 quota auto quick
 055 dump ioctl remote tape
 056 dump ioctl auto quick
@@ -177,86 +165,52 @@ deprecated
 059 dump ioctl auto quick
 060 dump ioctl auto quick
 061 dump ioctl auto quick
-062 attr udf auto quick
 063 dump attr auto quick
 064 dump auto
 065 dump auto
 066 dump ioctl auto quick
 067 acl attr auto quick
 068 other auto freeze dangerous
-069 rw udf auto quick
-070 attr udf auto quick
 071 rw auto
 072 rw auto prealloc quick
 073 copy auto
-074 rw udf auto
-075 rw udf auto quick
-076 metadata rw udf auto quick
-077 acl attr auto enospc
 078 growfs auto quick
-079 acl attr ioctl metadata auto quick
 080 rw ioctl
 081 deprecated # log logprint quota
 082 deprecated # log logprint v2log
-083 rw auto
 084 ioctl rw auto
 085 log auto quick
 086 log v2log auto
 087 log v2log auto quota
-088 perms auto quick
-089 metadata auto
 090 rw auto
-091 rw auto quick
 092 other auto quick
-093 attr cap udf auto
 094 metadata dir ioctl auto
 095 log v2log auto
 096 mkfs v2log auto quick
-097 udf auto
 098 udf auto
-099 udf auto
-100 udf auto
 101 udf
 102 udf
 103 metadata dir ioctl auto quick
 104 growfs ioctl prealloc auto
-105 acl auto quick
 106 quota
 107 quota
 108 quota auto quick
 109 metadata auto
 110 repair auto
 111 ioctl
-112 rw aio auto quick
-113 rw aio auto quick
 114 parent attr
 115 parent attr
 116 quota auto quick
-117 attr auto quick
 118 quota auto quick
 119 log v2log auto freeze dangerous
-120 other auto quick
 121 log auto quick
 122 other auto quick
-123 perms auto quick
-124 pattern auto quick
-125 other auto
-126 perms auto quick
-127 rw auto
-128 perms auto quick
-129 rw auto quick
-130 pattern auto quick
-131 perms auto quick
-132 pattern auto
-133 rw auto
 134 quota auto quick
-135 metadata auto quick
 136 attr2
 137 metadata log auto
 138 metadata log auto
 139 metadata log auto
 140 metadata log auto
-141 rw auto quick
 142 dmapi auto
 143 dmapi auto
 144 dmapi auto
@@ -284,7 +238,6 @@ deprecated
 166 rw metadata auto quick
 167 rw metadata auto
 168 dmapi auto
-169 rw metadata auto quick
 170 rw filestreams auto quick
 # the next three tests are not deterministic enough to get the
 # "right" result on all platforms/configuration, so don't run
@@ -302,7 +255,6 @@ deprecated
 181 log auto quick
 182 metadata rw auto
 183 rw other auto quick
-184 metadata auto quick
 185 dmapi auto
 186 attr auto quick
 187 attr auto quick
@@ -310,95 +262,45 @@ deprecated
 189 mount auto quick
 190 rw auto quick
 191 nfs4acl auto
-192 atime auto
-193 metadata auto quick
 194 rw auto
 195 ioctl dump auto quick
 196 quota auto quick
 197 dir auto quick
-198 auto aio quick
 199 mount auto quick
 200 mount auto quick
 201 metadata auto quick
 202 repair auto quick
 203 ioctl auto
-204 metadata rw auto
 205 metadata rw auto
 206 growfs auto quick
-207 auto aio quick
-208 auto aio
-209 auto aio
-210 auto aio quick
-211 auto aio quick
-212 auto aio quick
-213 rw auto prealloc quick enospc
-214 rw auto prealloc quick
-215 auto metadata quick
 216 log metadata auto quick
 217 log metadata auto
 218 auto fsr quick
-219 auto quota quick
 220 auto quota quick
-221 auto metadata quick
 222 auto fsr ioctl quick
-223 auto quick
-224 auto
-225 auto quick
-226 auto enospc
 227 auto fsr
-228 rw auto prealloc quick
 229 auto rw
-230 auto quota quick
-231 auto quota
-232 auto quota
-233 auto quota
-234 auto quota
-235 auto quota quick
-236 auto quick metadata
-237 auto quick acl
 238 auto quick metadata ioctl
-239 auto aio rw
-240 auto aio quick rw
-241 auto
 242 auto quick prealloc
 243 auto quick prealloc
 244 auto quota quick
-245 auto quick dir
-246 auto quick rw
-247 auto quick rw
-248 auto quick rw
-249 auto quick rw 
 250 auto quick rw prealloc metadata
-251 ioctl trim
 252 auto quick prealloc
 253 auto quick
 254 auto quick
-255 auto quick prealloc
-256 auto quick
-257 dir auto quick
-258 auto quick
 259 auto quick
-260 auto quick trim
 261 auto quick quota
 262 auto quick quota
-263 rw auto quick
 264 auto
 265 auto
 266 dump ioctl auto quick
 267 dump ioctl tape
 268 dump ioctl tape
-269 auto rw prealloc ioctl enospc
-270 auto quota rw prealloc ioctl enospc
 271 auto rw quick
 272 auto enospc rw
-273 auto rw
-274 auto rw
-275 auto rw
 276 auto rw metadata
-277 auto ioctl quick metadata
 278 repair auto
 279 auto mkfs
-280 auto quota freeze dangerous
 281 dump ioctl auto quick
 282 dump ioctl auto quick
 283 dump ioctl auto quick
diff --git a/001 b/tests/generic/001
similarity index 100%
rename from 001
rename to tests/generic/001
diff --git a/001.out b/tests/generic/001.out
similarity index 100%
rename from 001.out
rename to tests/generic/001.out
diff --git a/002 b/tests/generic/002
similarity index 100%
rename from 002
rename to tests/generic/002
diff --git a/002.out b/tests/generic/002.out
similarity index 100%
rename from 002.out
rename to tests/generic/002.out
diff --git a/005 b/tests/generic/005
similarity index 100%
rename from 005
rename to tests/generic/005
diff --git a/005.out b/tests/generic/005.out
similarity index 100%
rename from 005.out
rename to tests/generic/005.out
diff --git a/006 b/tests/generic/006
similarity index 100%
rename from 006
rename to tests/generic/006
diff --git a/006.out b/tests/generic/006.out
similarity index 100%
rename from 006.out
rename to tests/generic/006.out
diff --git a/007 b/tests/generic/007
similarity index 100%
rename from 007
rename to tests/generic/007
diff --git a/007.out b/tests/generic/007.out
similarity index 100%
rename from 007.out
rename to tests/generic/007.out
diff --git a/010 b/tests/generic/010
similarity index 100%
rename from 010
rename to tests/generic/010
diff --git a/010.out b/tests/generic/010.out
similarity index 100%
rename from 010.out
rename to tests/generic/010.out
diff --git a/011 b/tests/generic/011
similarity index 100%
rename from 011
rename to tests/generic/011
diff --git a/011.out b/tests/generic/011.out
similarity index 100%
rename from 011.out
rename to tests/generic/011.out
diff --git a/013 b/tests/generic/013
similarity index 100%
rename from 013
rename to tests/generic/013
diff --git a/013.out b/tests/generic/013.out
similarity index 100%
rename from 013.out
rename to tests/generic/013.out
diff --git a/014 b/tests/generic/014
similarity index 100%
rename from 014
rename to tests/generic/014
diff --git a/014.out b/tests/generic/014.out
similarity index 100%
rename from 014.out
rename to tests/generic/014.out
diff --git a/015 b/tests/generic/015
similarity index 100%
rename from 015
rename to tests/generic/015
diff --git a/015.out b/tests/generic/015.out
similarity index 100%
rename from 015.out
rename to tests/generic/015.out
diff --git a/020 b/tests/generic/020
similarity index 100%
rename from 020
rename to tests/generic/020
diff --git a/020.out b/tests/generic/020.out
similarity index 100%
rename from 020.out
rename to tests/generic/020.out
diff --git a/053 b/tests/generic/053
similarity index 100%
rename from 053
rename to tests/generic/053
diff --git a/053.out b/tests/generic/053.out
similarity index 100%
rename from 053.out
rename to tests/generic/053.out
diff --git a/062 b/tests/generic/062
similarity index 100%
rename from 062
rename to tests/generic/062
diff --git a/062.out b/tests/generic/062.out
similarity index 100%
rename from 062.out
rename to tests/generic/062.out
diff --git a/069 b/tests/generic/069
similarity index 100%
rename from 069
rename to tests/generic/069
diff --git a/069.out b/tests/generic/069.out
similarity index 100%
rename from 069.out
rename to tests/generic/069.out
diff --git a/070 b/tests/generic/070
similarity index 100%
rename from 070
rename to tests/generic/070
diff --git a/070.out b/tests/generic/070.out
similarity index 100%
rename from 070.out
rename to tests/generic/070.out
diff --git a/074 b/tests/generic/074
similarity index 100%
rename from 074
rename to tests/generic/074
diff --git a/074.out b/tests/generic/074.out
similarity index 100%
rename from 074.out
rename to tests/generic/074.out
diff --git a/075 b/tests/generic/075
similarity index 100%
rename from 075
rename to tests/generic/075
diff --git a/075.out b/tests/generic/075.out
similarity index 100%
rename from 075.out
rename to tests/generic/075.out
diff --git a/076 b/tests/generic/076
similarity index 100%
rename from 076
rename to tests/generic/076
diff --git a/076.out b/tests/generic/076.out
similarity index 100%
rename from 076.out
rename to tests/generic/076.out
diff --git a/077 b/tests/generic/077
similarity index 100%
rename from 077
rename to tests/generic/077
diff --git a/077.out b/tests/generic/077.out
similarity index 100%
rename from 077.out
rename to tests/generic/077.out
diff --git a/079 b/tests/generic/079
similarity index 100%
rename from 079
rename to tests/generic/079
diff --git a/079.out b/tests/generic/079.out
similarity index 100%
rename from 079.out
rename to tests/generic/079.out
diff --git a/083 b/tests/generic/083
similarity index 100%
rename from 083
rename to tests/generic/083
diff --git a/083.out b/tests/generic/083.out
similarity index 100%
rename from 083.out
rename to tests/generic/083.out
diff --git a/088 b/tests/generic/088
similarity index 100%
rename from 088
rename to tests/generic/088
diff --git a/088.out.irix b/tests/generic/088.out.irix
similarity index 100%
rename from 088.out.irix
rename to tests/generic/088.out.irix
diff --git a/088.out.linux b/tests/generic/088.out.linux
similarity index 100%
rename from 088.out.linux
rename to tests/generic/088.out.linux
diff --git a/089 b/tests/generic/089
similarity index 100%
rename from 089
rename to tests/generic/089
diff --git a/089.out b/tests/generic/089.out
similarity index 100%
rename from 089.out
rename to tests/generic/089.out
diff --git a/091 b/tests/generic/091
similarity index 100%
rename from 091
rename to tests/generic/091
diff --git a/091.out b/tests/generic/091.out
similarity index 100%
rename from 091.out
rename to tests/generic/091.out
diff --git a/093 b/tests/generic/093
similarity index 100%
rename from 093
rename to tests/generic/093
diff --git a/093.out b/tests/generic/093.out
similarity index 100%
rename from 093.out
rename to tests/generic/093.out
diff --git a/097 b/tests/generic/097
similarity index 100%
rename from 097
rename to tests/generic/097
diff --git a/097.out.udf b/tests/generic/097.out.udf
similarity index 100%
rename from 097.out.udf
rename to tests/generic/097.out.udf
diff --git a/097.out.xfs b/tests/generic/097.out.xfs
similarity index 100%
rename from 097.out.xfs
rename to tests/generic/097.out.xfs
diff --git a/099 b/tests/generic/099
similarity index 100%
rename from 099
rename to tests/generic/099
diff --git a/099.out b/tests/generic/099.out
similarity index 100%
rename from 099.out
rename to tests/generic/099.out
diff --git a/100 b/tests/generic/100
similarity index 100%
rename from 100
rename to tests/generic/100
diff --git a/100.out b/tests/generic/100.out
similarity index 100%
rename from 100.out
rename to tests/generic/100.out
diff --git a/105 b/tests/generic/105
similarity index 100%
rename from 105
rename to tests/generic/105
diff --git a/105.out b/tests/generic/105.out
similarity index 100%
rename from 105.out
rename to tests/generic/105.out
diff --git a/112 b/tests/generic/112
similarity index 100%
rename from 112
rename to tests/generic/112
diff --git a/112.out b/tests/generic/112.out
similarity index 100%
rename from 112.out
rename to tests/generic/112.out
diff --git a/113 b/tests/generic/113
similarity index 100%
rename from 113
rename to tests/generic/113
diff --git a/113.out b/tests/generic/113.out
similarity index 100%
rename from 113.out
rename to tests/generic/113.out
diff --git a/117 b/tests/generic/117
similarity index 100%
rename from 117
rename to tests/generic/117
diff --git a/117.out b/tests/generic/117.out
similarity index 100%
rename from 117.out
rename to tests/generic/117.out
diff --git a/120 b/tests/generic/120
similarity index 100%
rename from 120
rename to tests/generic/120
diff --git a/120.out b/tests/generic/120.out
similarity index 100%
rename from 120.out
rename to tests/generic/120.out
diff --git a/123 b/tests/generic/123
similarity index 100%
rename from 123
rename to tests/generic/123
diff --git a/123.out b/tests/generic/123.out
similarity index 100%
rename from 123.out
rename to tests/generic/123.out
diff --git a/124 b/tests/generic/124
similarity index 100%
rename from 124
rename to tests/generic/124
diff --git a/124.out b/tests/generic/124.out
similarity index 100%
rename from 124.out
rename to tests/generic/124.out
diff --git a/125 b/tests/generic/125
similarity index 100%
rename from 125
rename to tests/generic/125
diff --git a/125.out b/tests/generic/125.out
similarity index 100%
rename from 125.out
rename to tests/generic/125.out
diff --git a/126 b/tests/generic/126
similarity index 100%
rename from 126
rename to tests/generic/126
diff --git a/126.out b/tests/generic/126.out
similarity index 100%
rename from 126.out
rename to tests/generic/126.out
diff --git a/127 b/tests/generic/127
similarity index 100%
rename from 127
rename to tests/generic/127
diff --git a/127.out b/tests/generic/127.out
similarity index 100%
rename from 127.out
rename to tests/generic/127.out
diff --git a/128 b/tests/generic/128
similarity index 100%
rename from 128
rename to tests/generic/128
diff --git a/128.out b/tests/generic/128.out
similarity index 100%
rename from 128.out
rename to tests/generic/128.out
diff --git a/129 b/tests/generic/129
similarity index 100%
rename from 129
rename to tests/generic/129
diff --git a/129.out b/tests/generic/129.out
similarity index 100%
rename from 129.out
rename to tests/generic/129.out
diff --git a/130 b/tests/generic/130
similarity index 100%
rename from 130
rename to tests/generic/130
diff --git a/130.out b/tests/generic/130.out
similarity index 100%
rename from 130.out
rename to tests/generic/130.out
diff --git a/131 b/tests/generic/131
similarity index 100%
rename from 131
rename to tests/generic/131
diff --git a/131.out b/tests/generic/131.out
similarity index 100%
rename from 131.out
rename to tests/generic/131.out
diff --git a/132 b/tests/generic/132
similarity index 100%
rename from 132
rename to tests/generic/132
diff --git a/132.out b/tests/generic/132.out
similarity index 100%
rename from 132.out
rename to tests/generic/132.out
diff --git a/133 b/tests/generic/133
similarity index 100%
rename from 133
rename to tests/generic/133
diff --git a/133.out b/tests/generic/133.out
similarity index 100%
rename from 133.out
rename to tests/generic/133.out
diff --git a/135 b/tests/generic/135
similarity index 100%
rename from 135
rename to tests/generic/135
diff --git a/135.out b/tests/generic/135.out
similarity index 100%
rename from 135.out
rename to tests/generic/135.out
diff --git a/141 b/tests/generic/141
similarity index 100%
rename from 141
rename to tests/generic/141
diff --git a/141.out b/tests/generic/141.out
similarity index 100%
rename from 141.out
rename to tests/generic/141.out
diff --git a/169 b/tests/generic/169
similarity index 100%
rename from 169
rename to tests/generic/169
diff --git a/169.out b/tests/generic/169.out
similarity index 100%
rename from 169.out
rename to tests/generic/169.out
diff --git a/184 b/tests/generic/184
similarity index 100%
rename from 184
rename to tests/generic/184
diff --git a/184.out b/tests/generic/184.out
similarity index 100%
rename from 184.out
rename to tests/generic/184.out
diff --git a/192 b/tests/generic/192
similarity index 100%
rename from 192
rename to tests/generic/192
diff --git a/192.out b/tests/generic/192.out
similarity index 100%
rename from 192.out
rename to tests/generic/192.out
diff --git a/193 b/tests/generic/193
similarity index 100%
rename from 193
rename to tests/generic/193
diff --git a/193.out b/tests/generic/193.out
similarity index 100%
rename from 193.out
rename to tests/generic/193.out
diff --git a/198 b/tests/generic/198
similarity index 100%
rename from 198
rename to tests/generic/198
diff --git a/198.out b/tests/generic/198.out
similarity index 100%
rename from 198.out
rename to tests/generic/198.out
diff --git a/204 b/tests/generic/204
similarity index 100%
rename from 204
rename to tests/generic/204
diff --git a/204.out b/tests/generic/204.out
similarity index 100%
rename from 204.out
rename to tests/generic/204.out
diff --git a/207 b/tests/generic/207
similarity index 100%
rename from 207
rename to tests/generic/207
diff --git a/207.out b/tests/generic/207.out
similarity index 100%
rename from 207.out
rename to tests/generic/207.out
diff --git a/208 b/tests/generic/208
similarity index 100%
rename from 208
rename to tests/generic/208
diff --git a/208.out b/tests/generic/208.out
similarity index 100%
rename from 208.out
rename to tests/generic/208.out
diff --git a/209 b/tests/generic/209
similarity index 100%
rename from 209
rename to tests/generic/209
diff --git a/209.out b/tests/generic/209.out
similarity index 100%
rename from 209.out
rename to tests/generic/209.out
diff --git a/210 b/tests/generic/210
similarity index 100%
rename from 210
rename to tests/generic/210
diff --git a/210.out b/tests/generic/210.out
similarity index 100%
rename from 210.out
rename to tests/generic/210.out
diff --git a/211 b/tests/generic/211
similarity index 100%
rename from 211
rename to tests/generic/211
diff --git a/211.out b/tests/generic/211.out
similarity index 100%
rename from 211.out
rename to tests/generic/211.out
diff --git a/212 b/tests/generic/212
similarity index 100%
rename from 212
rename to tests/generic/212
diff --git a/212.out b/tests/generic/212.out
similarity index 100%
rename from 212.out
rename to tests/generic/212.out
diff --git a/213 b/tests/generic/213
similarity index 100%
rename from 213
rename to tests/generic/213
diff --git a/213.out b/tests/generic/213.out
similarity index 100%
rename from 213.out
rename to tests/generic/213.out
diff --git a/214 b/tests/generic/214
similarity index 100%
rename from 214
rename to tests/generic/214
diff --git a/214.out b/tests/generic/214.out
similarity index 100%
rename from 214.out
rename to tests/generic/214.out
diff --git a/215 b/tests/generic/215
similarity index 100%
rename from 215
rename to tests/generic/215
diff --git a/215.out b/tests/generic/215.out
similarity index 100%
rename from 215.out
rename to tests/generic/215.out
diff --git a/219 b/tests/generic/219
similarity index 100%
rename from 219
rename to tests/generic/219
diff --git a/219.out b/tests/generic/219.out
similarity index 100%
rename from 219.out
rename to tests/generic/219.out
diff --git a/221 b/tests/generic/221
similarity index 100%
rename from 221
rename to tests/generic/221
diff --git a/221.out b/tests/generic/221.out
similarity index 100%
rename from 221.out
rename to tests/generic/221.out
diff --git a/223 b/tests/generic/223
similarity index 100%
rename from 223
rename to tests/generic/223
diff --git a/223.out b/tests/generic/223.out
similarity index 100%
rename from 223.out
rename to tests/generic/223.out
diff --git a/224 b/tests/generic/224
similarity index 100%
rename from 224
rename to tests/generic/224
diff --git a/224.out b/tests/generic/224.out
similarity index 100%
rename from 224.out
rename to tests/generic/224.out
diff --git a/225 b/tests/generic/225
similarity index 100%
rename from 225
rename to tests/generic/225
diff --git a/225.out b/tests/generic/225.out
similarity index 100%
rename from 225.out
rename to tests/generic/225.out
diff --git a/226 b/tests/generic/226
similarity index 100%
rename from 226
rename to tests/generic/226
diff --git a/226.out b/tests/generic/226.out
similarity index 100%
rename from 226.out
rename to tests/generic/226.out
diff --git a/228 b/tests/generic/228
similarity index 100%
rename from 228
rename to tests/generic/228
diff --git a/228.out b/tests/generic/228.out
similarity index 100%
rename from 228.out
rename to tests/generic/228.out
diff --git a/230 b/tests/generic/230
similarity index 100%
rename from 230
rename to tests/generic/230
diff --git a/230.out b/tests/generic/230.out
similarity index 100%
rename from 230.out
rename to tests/generic/230.out
diff --git a/231 b/tests/generic/231
similarity index 100%
rename from 231
rename to tests/generic/231
diff --git a/231.out b/tests/generic/231.out
similarity index 100%
rename from 231.out
rename to tests/generic/231.out
diff --git a/232 b/tests/generic/232
similarity index 100%
rename from 232
rename to tests/generic/232
diff --git a/232.out b/tests/generic/232.out
similarity index 100%
rename from 232.out
rename to tests/generic/232.out
diff --git a/233 b/tests/generic/233
similarity index 100%
rename from 233
rename to tests/generic/233
diff --git a/233.out b/tests/generic/233.out
similarity index 100%
rename from 233.out
rename to tests/generic/233.out
diff --git a/234 b/tests/generic/234
similarity index 100%
rename from 234
rename to tests/generic/234
diff --git a/234.out b/tests/generic/234.out
similarity index 100%
rename from 234.out
rename to tests/generic/234.out
diff --git a/235 b/tests/generic/235
similarity index 100%
rename from 235
rename to tests/generic/235
diff --git a/235.out b/tests/generic/235.out
similarity index 100%
rename from 235.out
rename to tests/generic/235.out
diff --git a/236 b/tests/generic/236
similarity index 100%
rename from 236
rename to tests/generic/236
diff --git a/236.out b/tests/generic/236.out
similarity index 100%
rename from 236.out
rename to tests/generic/236.out
diff --git a/237 b/tests/generic/237
similarity index 100%
rename from 237
rename to tests/generic/237
diff --git a/237.out b/tests/generic/237.out
similarity index 100%
rename from 237.out
rename to tests/generic/237.out
diff --git a/239 b/tests/generic/239
similarity index 100%
rename from 239
rename to tests/generic/239
diff --git a/239.out b/tests/generic/239.out
similarity index 100%
rename from 239.out
rename to tests/generic/239.out
diff --git a/240 b/tests/generic/240
similarity index 100%
rename from 240
rename to tests/generic/240
diff --git a/240.out b/tests/generic/240.out
similarity index 100%
rename from 240.out
rename to tests/generic/240.out
diff --git a/241 b/tests/generic/241
similarity index 100%
rename from 241
rename to tests/generic/241
diff --git a/241.out b/tests/generic/241.out
similarity index 100%
rename from 241.out
rename to tests/generic/241.out
diff --git a/245 b/tests/generic/245
similarity index 100%
rename from 245
rename to tests/generic/245
diff --git a/245.out b/tests/generic/245.out
similarity index 100%
rename from 245.out
rename to tests/generic/245.out
diff --git a/246 b/tests/generic/246
similarity index 100%
rename from 246
rename to tests/generic/246
diff --git a/246.out b/tests/generic/246.out
similarity index 100%
rename from 246.out
rename to tests/generic/246.out
diff --git a/247 b/tests/generic/247
similarity index 100%
rename from 247
rename to tests/generic/247
diff --git a/247.out b/tests/generic/247.out
similarity index 100%
rename from 247.out
rename to tests/generic/247.out
diff --git a/248 b/tests/generic/248
similarity index 100%
rename from 248
rename to tests/generic/248
diff --git a/248.out b/tests/generic/248.out
similarity index 100%
rename from 248.out
rename to tests/generic/248.out
diff --git a/249 b/tests/generic/249
similarity index 100%
rename from 249
rename to tests/generic/249
diff --git a/249.out b/tests/generic/249.out
similarity index 100%
rename from 249.out
rename to tests/generic/249.out
diff --git a/251 b/tests/generic/251
similarity index 100%
rename from 251
rename to tests/generic/251
diff --git a/251.out b/tests/generic/251.out
similarity index 100%
rename from 251.out
rename to tests/generic/251.out
diff --git a/255 b/tests/generic/255
similarity index 100%
rename from 255
rename to tests/generic/255
diff --git a/255.out b/tests/generic/255.out
similarity index 100%
rename from 255.out
rename to tests/generic/255.out
diff --git a/256 b/tests/generic/256
similarity index 100%
rename from 256
rename to tests/generic/256
diff --git a/256.out b/tests/generic/256.out
similarity index 100%
rename from 256.out
rename to tests/generic/256.out
diff --git a/257 b/tests/generic/257
similarity index 100%
rename from 257
rename to tests/generic/257
diff --git a/257.out b/tests/generic/257.out
similarity index 100%
rename from 257.out
rename to tests/generic/257.out
diff --git a/258 b/tests/generic/258
similarity index 100%
rename from 258
rename to tests/generic/258
diff --git a/258.out b/tests/generic/258.out
similarity index 100%
rename from 258.out
rename to tests/generic/258.out
diff --git a/260 b/tests/generic/260
similarity index 100%
rename from 260
rename to tests/generic/260
diff --git a/260.out b/tests/generic/260.out
similarity index 100%
rename from 260.out
rename to tests/generic/260.out
diff --git a/263 b/tests/generic/263
similarity index 100%
rename from 263
rename to tests/generic/263
diff --git a/263.out b/tests/generic/263.out
similarity index 100%
rename from 263.out
rename to tests/generic/263.out
diff --git a/269 b/tests/generic/269
similarity index 100%
rename from 269
rename to tests/generic/269
diff --git a/269.out b/tests/generic/269.out
similarity index 100%
rename from 269.out
rename to tests/generic/269.out
diff --git a/270 b/tests/generic/270
similarity index 100%
rename from 270
rename to tests/generic/270
diff --git a/270.out b/tests/generic/270.out
similarity index 100%
rename from 270.out
rename to tests/generic/270.out
diff --git a/273 b/tests/generic/273
similarity index 100%
rename from 273
rename to tests/generic/273
diff --git a/273.out b/tests/generic/273.out
similarity index 100%
rename from 273.out
rename to tests/generic/273.out
diff --git a/274 b/tests/generic/274
similarity index 100%
rename from 274
rename to tests/generic/274
diff --git a/274.out b/tests/generic/274.out
similarity index 100%
rename from 274.out
rename to tests/generic/274.out
diff --git a/275 b/tests/generic/275
similarity index 100%
rename from 275
rename to tests/generic/275
diff --git a/275.out b/tests/generic/275.out
similarity index 100%
rename from 275.out
rename to tests/generic/275.out
diff --git a/277 b/tests/generic/277
similarity index 100%
rename from 277
rename to tests/generic/277
diff --git a/277.out b/tests/generic/277.out
similarity index 100%
rename from 277.out
rename to tests/generic/277.out
diff --git a/280 b/tests/generic/280
similarity index 100%
rename from 280
rename to tests/generic/280
diff --git a/280.out b/tests/generic/280.out
similarity index 100%
rename from 280.out
rename to tests/generic/280.out
diff --git a/tests/generic/group b/tests/generic/group
index 4e01f0c..828f135 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -3,3 +3,101 @@
 # - do not start group names with a digit
 # - comment line before each group is "new" description
 #
+001 rw dir udf auto quick
+002 metadata udf auto quick
+005 dir udf auto quick
+006 dir udf auto quick
+007 dir udf auto quick
+010 other udf auto
+011 dir udf auto quick
+013 other ioctl udf auto quick
+014 rw udf auto quick
+015 other auto quick
+020 metadata attr udf auto quick
+053 acl repair auto quick
+062 attr udf auto quick
+069 rw udf auto quick
+070 attr udf auto quick
+074 rw udf auto
+075 rw udf auto quick
+076 metadata rw udf auto quick
+077 acl attr auto enospc
+079 acl attr ioctl metadata auto quick
+083 rw auto
+088 perms auto quick
+089 metadata auto
+091 rw auto quick
+093 attr cap udf auto
+097 udf auto
+099 udf auto
+100 udf auto
+105 acl auto quick
+112 rw aio auto quick
+113 rw aio auto quick
+117 attr auto quick
+120 other auto quick
+123 perms auto quick
+124 pattern auto quick
+125 other auto
+126 perms auto quick
+127 rw auto
+128 perms auto quick
+129 rw auto quick
+130 pattern auto quick
+131 perms auto quick
+132 pattern auto
+133 rw auto
+135 metadata auto quick
+141 rw auto quick
+169 rw metadata auto quick
+184 metadata auto quick
+192 atime auto
+193 metadata auto quick
+198 auto aio quick
+204 metadata rw auto
+207 auto aio quick
+208 auto aio
+209 auto aio
+210 auto aio quick
+211 auto aio quick
+212 auto aio quick
+213 rw auto prealloc quick enospc
+214 rw auto prealloc quick
+215 auto metadata quick
+219 auto quota quick
+221 auto metadata quick
+223 auto quick
+224 auto
+225 auto quick
+226 auto enospc
+228 rw auto prealloc quick
+230 auto quota quick
+231 auto quota
+232 auto quota
+233 auto quota
+234 auto quota
+235 auto quota quick
+236 auto quick metadata
+237 auto quick acl
+239 auto aio rw
+240 auto aio quick rw
+241 auto
+245 auto quick dir
+246 auto quick rw
+247 auto quick rw
+248 auto quick rw
+249 auto quick rw 
+251 ioctl trim
+255 auto quick prealloc
+256 auto quick
+257 dir auto quick
+258 auto quick
+260 auto quick trim
+263 rw auto quick
+269 auto rw prealloc ioctl enospc
+270 auto quota rw prealloc ioctl enospc
+273 auto rw
+274 auto rw
+275 auto rw
+277 auto ioctl quick metadata
+280 auto quota freeze dangerous
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
