Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 65E0F7F3F
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2014 10:28:29 -0500 (CDT)
Message-ID: <53232019.8060701@sgi.com>
Date: Fri, 14 Mar 2014 10:28:25 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE] xfsprogs for-3.1.12 branch has been updated to 40c65a7
References: <201401201822.48520.arekm@maven.pl> <52E6A9A2.1010905@sgi.com>
	<53050391.7020701@sgi.com> <20140219215025.GF4916@dastard>
In-Reply-To: <20140219215025.GF4916@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/19/2014 03:50 PM, Dave Chinner wrote:
...
>
> Can you outline the testing you have done?
Sorry it took so long to get back.

I used Kernel version 3.14.0-rc4+
Compared the results against TOT xfsprogs and for-3.1.12

Most of the bugs were log and repair specific so I ran a bunch of tests 
to exercise those.

I ran xfstests several times on ia64, x86_64 and i386 with the following 
command:
./check -g auto -x dmapi -x freeze -x tape

generic/306     - output mismatch (see 
/usr/src/3.1.12/xfstests/results//generic/306.out.bad)
     --- tests/generic/306.out    2014-03-11 09:42:47.000000000 -0500
     +++ /usr/src/3.1.12/xfstests/results//generic/306.out.bad 
2014-03-11 11:34:01.000000000 -0500
     @@ -2,11 +2,9 @@
      == try to create new file
      touch: cannot touch 'SCRATCH_MNT/this_should_fail': Read-only file 
system
      == pwrite to null device
     -wrote 512/512 bytes at offset 0
     -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)xfs/001 
     [not run] mkfs.xfs doesn't have crc feature
xfs/002     [not run] mkfs.xfs doesn't have crc feature
xfs/005     [not run] mkfs.xfs doesn't have crc feature
xfs/299     [not run] mkfs.xfs doesn't have crc feature
xfs/304     [not run] mkfs.xfs doesn't have crc feature
xfs/305     [not run] mkfs.xfs doesn't have crc feature
     +XFS_IOC_FSGEOMETRY: Inappropriate ioctl for device
      == pread from zero device
     ...
     (Run 'diff -u tests/generic/306.out 
/usr/src/3.1.12/xfstests/results//generic/306.out.bad'  to see the 
entire diff)


xfs/016     - output mismatch (see 
/usr/src/3.1.12/xfstests/resuxfs/lts//xfs/016.out.bad)
     --- tests/xfs/016.out    2014-03-11 09:42:47.000000000 -0500
     +++ /usr/src/3.1.12/xfstests/results//xfs/016.out.bad    2014-03-11 
11:34:15.000000000 -0500
     @@ -11,25 +11,30 @@
         *** mount
         *** fiddle
         *** unmount
     +XFS: Invalid block length (0x2000) given for buffer
      *** generate log traffic
         *** mount
         *** fiddle
     ...
     (Run 'diff -u tests/xfs/016.out 
/usr/src/3.1.12/xfstests/results//xfs/016.out.bad'  to see the entire diff)

xfs/122     - output mismatch (see 
/usr/src/3.1.12/xfstests/results//xfs/122.out.bad)
     --- tests/xfs/122.out    2014-03-11 09:42:47.000000000 -0500
     +++ /usr/src/3.1.12/xfstests/results//xfs/122.out.bad    2014-03-11 
11:34:17.000000000 -0500
     @@ -49,39 +49,70 @@
      sizeof( xfs_agfl_t ) = 4
      sizeof( xfs_agi_t ) = 296
      sizeof( xfs_alloc_rec_incore_t ) = 8
     +sizeof( xfs_alloc_rec_incore_t ) = 8
     +sizeof( xfs_alloc_rec_t ) = 8
      sizeof( xfs_alloc_rec_t ) = 8
      sizeof( xfs_attr_inactive_list_t ) = 8
     ...
     (Run 'diff -u tests/xfs/122.out 
/usr/src/3.1.12/xfstests/results//xfs/122.out.bad'  to see the entire diff)

      - output mismatch (see
/usr/src/3.1.12/xfstests/results//xfs/178.out.bad)
      --- tests/xfs/178.out    2014-03-11 09:42:47.000000000 -0500
      +++ /usr/src/3.1.12/xfstests/results//xfs/178.out.bad    2014-03-11
12:09:55.000000000 -0500
      @@ -10,6 +10,9 @@

       attempting to find secondary superblock...
       found candidate secondary superblock...
      +error reading superblock 1 -- seek to offset 1099511623680 failed
      +unable to verify superblock, continuing...
      +found candidate secondary superblock...
       verified secondary superblock...

Ran: generic/001 generic/002 generic/003 generic/005 generic/006 
generic/007 generic/010 generic/011 generic/013 generic/014 generic/015 
generic/020 generic/053 generic/062 generic/069 generic/070 generic/074 
generic/075 generic/076 generic/077 generic/079 generic/083 generic/088 
generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 
generic/117 generic/120 generic/123 generic/124 generic/125 generic/126 
generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 
generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 
generic/193 generic/198 generic/204 generic/207 generic/208 generic/209 
generic/210 generic/211 generic/212 generic/213 generic/214 generic/215 
generic/219 generic/221 generic/223 generic/224 generic/225 generic/226 
generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 
generic/235 generic/236 generic/237 generic/239 generic/240 generic/245 
generic/246 generic/247 generic/248 generic/249 generic/255 generic/256 
generic/257 generic/258 generic/263 generic/269 generic/270 generic/273 
generic/274 generic/275 generic/277 generic/285 generic/286 generic/294 
generic/299 generic/300 generic/306 generic/307 generic/308 generic/309 
generic/310 generic/312 generic/313 generic/314 generic/315 generic/316 
generic/317 generic/318 generic/319 generic/320 shared/032 shared/051 
shared/218 shared/243 shared/298 xfs/003 xfs/004 xfs/008 xfs/009 xfs/012 
xfs/016 xfs/017 xfs/019 xfs/021 xfs/026 xfs/027 xfs/028 xfs/029 xfs/030 
xfs/031 xfs/033 xfs/034 xfs/041 xfs/042 xfs/045 xfs/046 xfs/047 xfs/048 
xfs/049 xfs/050 xfs/052 xfs/054 xfs/056 xfs/059 xfs/060 xfs/061 xfs/063 
xfs/064 xfs/065 xfs/066 xfs/067 xfs/071 xfs/072 xfs/073 xfs/078 xfs/084 
xfs/085 xfs/086 xfs/087 xfs/092 xfs/096 xfs/103 xfs/104 xfs/108 xfs/109 
xfs/110 xfs/116 xfs/118 xfs/121 xfs/122 xfs/134 xfs/137 xfs/138 xfs/139 
xfs/140 xfs/164 xfs/165 xfs/166 xfs/167 xfs/170 xfs/174 xfs/178 xfs/179 
xfs/180 xfs/181 xfs/182 xfs/183 xfs/186 xfs/187 xfs/188 xfs/189 xfs/190 
xfs/194 xfs/195 xfs/196 xfs/199 xfs/200 xfs/201 xfs/202 xfs/203 xfs/205 
xfs/206 xfs/216 xfs/217 xfs/220 xfs/222 xfs/227 xfs/229 xfs/238 xfs/242 
xfs/244 xfs/250 xfs/252 xfs/253 xfs/259 xfs/261 xfs/262 xfs/266 xfs/278 
xfs/281 xfs/282 xfs/283 xfs/287 xfs/290 xfs/291 xfs/292 xfs/293 xfs/295 
xfs/296 xfs/298 xfs/301 xfs/302 xfs/303 xfs/306
Not run: generic/093 generic/097 generic/099 generic/241 generic/260 
generic/288 generic/311 generic/321 generic/322 shared/001 shared/002 
shared/003 shared/004 shared/005 shared/272 shared/289 xfs/001 xfs/002 
xfs/005 xfs/040 xfs/044 xfs/057 xfs/058 xfs/090 xfs/094 xfs/095 xfs/148 
xfs/149 xfs/177 xfs/191 xfs/197 xfs/279 xfs/299 xfs/300 xfs/304 xfs/305
Failures: generic/306 xfs/016 xfs/122 xfs/178
Failed 4 of 235 tests

There were some tests that did not run that were crc specific
xfs/001     [not run] mkfs.xfs doesn't have crc feature
xfs/002     [not run] mkfs.xfs doesn't have crc feature
xfs/005     [not run] mkfs.xfs doesn't have crc feature
xfs/299     [not run] mkfs.xfs doesn't have crc feature
xfs/304     [not run] mkfs.xfs doesn't have crc feature
xfs/305     [not run] mkfs.xfs doesn't have crc feature

generic/306
There is on patch that could be cherry-picked to fix it. (I re-ran tests 
with it applied.

commit fcd6fa7f6a29188a756ff8b071a152bc9d62baf4
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Oct 8 15:17:50 2013 +0000

     xfsprogs: restrict platform_test_xfs_fd to regular files

xfs/016 passes
If I revert bb4074a31 xfstests: use minimum log size in xfs/016
http://oss.sgi.com/archives/xfs/2013-10/msg00559.html

xfs/122 also fails on both and most people don't install INDENT so they 
would never see it.

xfs/178
This test blows away the main sb, then does repair. It should have found 
sb1 but failed, it did find sb2. strange but not an error. I got the 
same error using TOT xfsprogs.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
