Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB8F8WY8007967
	for <linux-xfs@oss.sgi.com>; Mon, 8 Dec 2008 09:08:32 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1631D16E0E67
	for <linux-xfs@oss.sgi.com>; Mon,  8 Dec 2008 07:08:30 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id chUhC9Z0rHaqL1Et for
	<linux-xfs@oss.sgi.com>; Mon, 08 Dec 2008 07:08:30 -0800 (PST)
Date: Mon, 8 Dec 2008 10:08:29 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: XFS benchmarks on 3ware 9650SE-16ML Controller: RAID 6
Message-ID: <alpine.DEB.1.10.0812080831140.24867@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: linux-xfs@oss.sgi.com
Cc: linux-raid@vger.kernel.org

Just one question, using -d agcount=2 seems to speedup XFS but by only a 
slight margin (on a 10-disk raid6 of raptor150s), the default it chooses 
is -d agcount=4 and when you increase the agcount, the performance 
decreases quite a bit.  Are there any downsides to using -d agcount=2 (the 
smallest number allowed)?

Overall question, see the benchmarks below, is it worth tweaking XFS to 
obtain a 3-4 second improvement on various benchmarks? Or is it best to 
just leave them alone?

I have chosen to go with the default mkfs.xfs options as they are optimal 
within a few seconds of further optimizations shown below.  These are more 
or less the raw benchmarks, I did not pretty them up in any way.

================================================================================
benchmarks.txt
================================================================================
1. Run a single and fast bonnie++ per each test, ALL for raid6.
2. Need to first test:
    a. XFS filesystem creation with the different parameters.
    b. sunit=128, swidth=512
    c. sunit=128, swidth=576
3. Then, after XFS:
    a. blockdev --setra 16384,32768,65536
4. Test other various 'tweaks' recommended by 3ware:
    a. scheduler changes (cfq,noop,deadline,as)
    b. echo "64" > /sys/block/sdb/queue/max_sectors_kb
    c. echo "512" > /sys/block/sdb/queue/nr_requests

notes from websites
a. Changing /sys/block/sde/queue/nr_requests from 128 to 512 does a moderate
improvement. Going to higher numbers, such as 1024 does not make it better
any more.
b. Must apply read-ahead settings AFTER applying changes to max_sectors_kb etc.
http://www.3ware.com/kb/article.aspx?id=11050

-----------------------------------------------------------------------------
benchmark:
/usr/bin/time /usr/sbin/bonnie++ -d /t/test -s 16384 -m p34 -n 16:100000:16:64 > $HOME/test"$i".txt 2>&1
-----------------------------------------------------------------------------

cd / && umount /t && mkfs.xfs -f /dev/sdb1 && mount /dev/sdb1 /t
chown jpiszcz:users -R /t

defaults:

p34:/# cat /sys/block/sdb/queue/max_sectors_kb
128
p34:/# cat /sys/block/sdb/queue/nr_requests
128
p34:/# cat /sys/block/sda/device/queue_depth (already the best/highest)
254

echo noop > /sys/block/sdb/queue/scheduler
echo anticipatory > /sys/block/sdb/queue/scheduler
echo deadline > /sys/block/sdb/queue/scheduler
echo cfq > /sys/block/sdb/queue/scheduler

# key
test1:               defaults: 27:22.89 elapsed (CFQ was used)
test2: defaults,su=64k,sw=512: 27:34.46 elapsed (CFQ was used)**slower
test3:          defaults,noop: 24:26.36 elapsed (noop)*** test more
test4:            defaults,as: 24:22.01 elapsed (anticipatory)*** test more
test5:      defaults,deadline: 24:43.54 elapsed (deadline)
test6:           defaults,cfq: 27:23.53 elapsed (cfq)
test7: defaults,noop,3run,avg:  1:13:45 elapsed (noop) (60+13.45)/3 = 24.48/avg
test8:   defaults,as,3run,avg:  1:14:21 elapsed (as)
# future tests use noop
test9:      max_sectors_kb=64: 24:48.15 elapsed 
test10:    max_sectors_kb=128: 24:26.36 elapsed (same as test3)
test11:       nr_requests=128: 24:26.36 elapsed (same as test3)
test12:       nr_requests=512: 24:22.50 elapsed (512, slight improvement)
test13:      nr_requests=1024: 24:22.68 elapsed (no improvement past 512)
# re-test deadline once again w/optimized settings above (can deadline win?)
test14:      deadline+req=512: 24:21.29 elapsed (wins) [deadline=recommended]
# future tests use deadline [can get it under 24.21?]
# 16384 has the best re-write speed so that is what I will be using
test15:    same_14,setra=4096: 12:40.55 elapsed (deadline+others+setra=4096)
test16:   same_14,setra=16384: 11:42.24 elapsed (readahead=16384)*too_close
test17:   same_14,setra=32768: 11:40.70 elapsed (readahead=32768)*too_close
test18:   same_14,setra=65536: 11:47.66 elapsed (readahead=65536)*too_close?
# all tests to use 14+readahead=16384 (recommended by 3ware)
# does sunit,swidth/su,sw matter on a 3ware card? it appears not
# below is for 10 disks in a RAID6 using a 64KiB stripe
# same as test 16 above except use these parameters for making the filesystem
test19:  defaults,su=64k,sw=8: 12:06.68 elapsed (again, slower, dont bother)
# same as test 16
test20:    defaults,agcount=2: 11:28.02 elapsed (wow, anomaly?)
test21:    defaults,agcount=4: 11:42.24 elapsed (same as 16)
test22:    defaults,agcount=8: 12:08.67 elapsed
test23:   defaults,agcount=16: 11:49.64 elapsed (fewer=better in general)
# redo 16,17,18 3 runs and take avg.
test24:              test16x3: 35:28.64 elapsed (avg=12:16.00)*3ware rec'd
test25:              test17x3: 35:10.75 elapsed (avg=12:10.00)
test26:              test18x3: 35:01.74 elapsed (avg=12:07.00) (re-write=worse)
# now using results from test16+20 for all future benchmarks.
test27:    mount -o nobarrier: 11:45.95 elapsed (should be close to test20?)
                                                 (do not specify barrier)
test28:      re-run of test20: 11:42.93 elapsed (agcount=2/4 no difference?)
# need to run 3 tests and take average for agcount=2, agcount=4
test29:        agcount=2 (x3): 34:28.51elapsed => 11.42/avg **(best)
test30:        agcount=4 (x3): 35:22.15elapsed => 12.14/avg
# all tests use agcount=2 now
# test below is with the log options shown below
test31:      xfs_mount_opts_1: 34:18.96 elapsed => 11.39/avg *(slightly better)
              these options will not be used regularly as they are mount opts,
              the filesystem creation options are more interesting to me, once
              you make them, that's typicall it, they're set with the exception
              of some that can be modified at mount time.
# last changeable parameters: inode size & sectorsize (256,512 by default)
#                             and naming size (4096 bytes by default)
# sector sizes
test32:  test29+'-s size=512': 34:28.51 elapsed => 11.42/avg (same/29)
test33: test29+'-s size=1024': 34:48.47 elapsed (slower)
test34: test29+'-s size=2048': 34:18.40 elapsed (slightly faster)
test35: test29+'-s size=4096': 34:11.92 elapsed => 11.37/avg (fastest)
# and inode size
test36:  test29+'-i size=256': 34:28.51 elapsed => 11.42/avg (same/29)
test37:  test29+'-i size=512': 35:08.45 elapsed => (worse)
test38: test29+'-i size=1024': 35:02.99 elapsed => 12.07/avg (worse)
test39: test29+'-i size=2048': 34:41.93 elapsed => 11.47/avg (worse)
# block size tests, default is 4096, is a smaller blocksize any better?
test40:  test29+'-b size=512': 37:47.06 elapsed => 12.47/avg
- test42: test29+'-b size=1024': will not bother
- test43: test29+'-b size=2048': will not bother
test41: test29+'-b size=4096': 34:28.51elapsed => 11.42/avg (same as 29)

# naming size tests (mainly directory tests, did not test these as it is
   set to 4096 and the defaults for inode,sector,block sizes seem to be
   optimal for the most part)

xfs_mount_opts_1:
defaults,noatime,logbufs=8,logbsize=262144

# results
test1,16G,73586,99,505013,61,27452,6,38169,51,55322,5,629.8,0,16:100000:16/64,7246,61,+++++,+++,16773,95,7751,70,+++++,+++,10815,81
test2,16G,72826,99,493247,59,27232,6,39367,51,56890,5,610.6,0,16:100000:16/64,1857,14,+++++,+++,1220,7,1983,17,+++++,+++,13976,82
test3,16G,70669,99,519085,61,42716,7,36064,48,54080,4,626.0,0,16:100000:16/64,81663,+++++,+++,19710,89,7268,58,21372,50,8407,68
test4,16G,73554,99,514691,61,42878,7,36338,50,54848,5,365.7,0,16:100000:16/64,63851,+++++,+++,19942,94,8479,72,+++++,+++,2400,19
test5,16G,69311,98,519464,60,42081,6,35590,49,54188,4,622.2,0,16:100000:16/64,7941,64,+++++,+++,16050,91,7340,66,+++++,+++,5660,42
test6,16G,71880,98,501459,60,27424,6,38524,52,55889,5,594.6,0,16:100000:16/64,7226,54,+++++,+++,7941,36,8823,66,+++++,+++,11536,72
test7,16G,72018.0,98.3,518441.3,60.3,41961.0,6.0,35626.3,48.7,54213.7,4.3,619.7,0.0,16:100000:16/64,7996.3,61.3,0.0,0.0,15897.7,72.0,7687.3,61.7,6653.7,16.0,7408.3,58.3
test8,16G,71409.0,99.0,517795.0,60.0,42724.0,6.0,35215.3,48.7,53733.3,4.0,373.0,0.0,16:100000:16/64,7918.7,64.7,0.0,0.0,10267.7,58.0,7383.3,67.3,0.0,0.0,10234.0,77.0
test9,16G,73394,99,497319,56,41768,6,35832,49,52654,4,607.6,0,16:100000:16/64,6318,53,+++++,+++,5414,31,6988,64,+++++,+++,2064,16
test10,16G,70669,99,519085,61,42716,7,36064,48,54080,4,626.0,0,16:100000:16/64,81663,+++++,+++,19710,89,7268,58,21372,50,8407,68
test11,16G,70669,99,519085,61,42716,7,36064,48,54080,4,626.0,0,16:100000:16/64,81663,+++++,+++,19710,89,7268,58,21372,50,8407,68
test12,16G,72165,99,522318,71,42710,6,36269,49,54723,4,608.5,0,16:100000:16/64,74061,+++++,+++,16233,93,7605,66,+++++,+++,1795,15
test13,16G,73729,99,529523,73,42792,6,35624,49,54835,4,614.4,0,16:100000:16/64,74757,+++++,+++,8084,49,7803,68,+++++,+++,2367,17
test14,16G,73047,99,538036,72,42695,6,36004,49,53519,4,618.8,0,16:100000:16/64,80762,+++++,+++,20157,91,7060,59,+++++,+++,9729,73
test15,16G,73431,99,537298,72,109922,15,76890,99,179542,14,609.4,0,16:100000:16/64 8287,67,+++++,+++,8688,51,7853,66,+++++,+++,1795,13
test16,16G,73353,99,539162,72,144432,19,77645,99,218854,17,613.0,0,16:100000:16/64 8046,61,16890,41,12677,62,8257,62,+++++,+++,2602,18
test17,16G,73370,99,541903,71,152908,20,77661,99,205225,16,595.5,0,16:100000:16/64 7241,57,17943,41,19245,93,8454,69,+++++,+++,2603,20
test18,16G,73172,99,543663,71,151835,23,76110,99,212243,16,608.5,0,16:100000:16/64 7867,64,+++++,+++,16582,94,7597,67,+++++,+++,1516,12
test19,16G,73711,99,538586,72,143378,19,77618,99,220458,17,600.5,0,16:100000:16/64 1277,10,6665,15,5048,27,2321,19,+++++,+++,1378,10
test20,16G,72996,99,575247,76,159371,21,77828,99,218462,17,809.0,1,16:100000:16/64 8430,65,+++++,+++,5916,31,7909,68,+++++,+++,2491,21
test21,16G,73353,99,539162,72,144432,19,77645,99,218854,17,613.0,0,16:100000:16/64 8046,61,16890,41,12677,62,8257,62,+++++,+++,2602,18
test22,16G,68813,99,514195,68,142659,19,76527,99,212022,16,570.3,0,16:100000:16/64,7919,63,+++++,+++,6513,36,7621,66,+++++,+++,2284,16
test23,16G,71620,99,509930,68,144200,19,77249,98,212428,16,610.5,0,16:100000:16/64 6144,50,+++++,+++,17671,97,6843,57,+++++,+++,6810,33
test24,16G,70914.7,99.0,541021.7,72.7,144413.7,19.7,76949.3,99.0,219469.7,16.7,605.9,0.0,16:100000:16/64,8459.7,65.7,0.0,0.0,20287.0,92.0,8131.7,63.7,6973.3,16.3,5203.3,39.7
test25,16G,72205.0,99.0,542056.0,72.7,152582.3,20.7,77241.3,99.0,210399.3,16.7,608.8,0.0,16:100000:16/64,7440.0,60.7,6687.7,18.3,8244.3,47.3,7610.7,66.7,0.0,0.0,4485.0,31.7
test26,16G,72696.3,99.0,538011.7,71.7,150574.7,22.3,77091.0,99.0,215220.3,16.7,608.3,0.0,16:100000:16/64,8458.7,66.0,0.0,0.0,19090.7,93.0,7921.7,63.7,6303.3,15.3,4422.0,33.0
test27,16G,72231,99,573898,77,159439,21,69398,99,230125,17,834.9,0,16:100000:16/64,8561,69,+++++,+++,17847,96,8152,69,20708,49,10811,93
test28,16G,69455,99,574361,77,159450,21,76103,99,218771,16,822.9,0,16:100000:16/64 7961,68,+++++,+++,7422,49,7408,69,+++++,+++,3077,26
test29,16G,72030.3,98.7,575339.7,77.7,159421.7,21.7,76765.7,98.7,229605.3,17.0,821.2,0.7,16:100000:16/64,8238.0,68.7,0.0,0.0,9759.7,61.0,7820.3,70.0,0.0,0.0,4351.7,36.0
test30,16G,71785.7,99.0,514180.7,68.3,143635.7,19.0,76987.3,99.0,215108.0,16.0,606.1,0.0,16:100000:16/64,8346.3,66.7,0.0,0.0,16396.7,87.3,7928.0,67.3,0.0,0.0,10893.0,76.0
test31,16G,71116.0,99.0,576581.3,77.0,160511.7,21.0,76481.3,99.0,230528.7,17.0,836.2,1.0,16:100000:16/64,9056.3,69.3,0.0,0.0,19033.0,85.7,9337.0,72.7,0.0,0.0,11281.3,68.3
test32,16G,72030.3,98.7,575339.7,77.7,159421.7,21.7,76765.7,98.7,229605.3,17.0,821.2,0.7,16:100000:16/64,8238.0,68.7,0.0,0.0,9759.7,61.0,7820.3,70.0,0.0,0.0,4351.7,36.0
test33,16G,71408.3,99.0,573249.3,76.0,157130.0,21.0,75766.3,99.0,228602.3,17.3,816.1,0.7,16:100000:16/64,7892.7,67.0,8322.3,21.7,11643.7,75.0,7336.7,69.3,0.0,0.0,4493.0,37.0
test34,16G,71926.0,99.0,567184.7,75.3,159568.0,21.0,76963.7,99.0,229259.0,17.3,830.0,1.0,16:100000:16/64,8045.7,68.3,0.0,0.0,13918.0,84.3,6960.0,65.7,0.0,0.0,6410.0,54.3
test35,16G,72578.3,99.0,575499.3,76.7,158285.0,21.7,76653.3,99.0,231374.7,17.7,825.5,0.7,16:100000:16/64,8045.0,67.7,0.0,0.0,11675.7,72.7,7319.7,64.7,0.0,0.0,7244.0,59.0
test36,16G,72030.3,98.7,575339.7,77.7,159421.7,21.7,76765.7,98.7,229605.3,17.0,821.2,0.7,16:100000:16/64,8238.0,68.7,0.0,0.0,9759.7,61.0,7820.3,70.0,0.0,0.0,4351.7,36.0
test37,16G,70425.3,99.0,537817.7,72.3,152487.7,20.0,76437.7,99.0,227308.7,17.0,813.5,1.0,16:100000:16/64,7142.0,57.7,0.0,0.0,7702.7,42.3,7125.3,59.0,0.0,0.0,4676.0,35.3
test38,16G,70280.0,99.0,539463.3,73.0,152248.0,20.0,76865.7,98.7,225277.3,16.3,816.5,0.7,16:100000:16/64,7730.7,61.7,5636.3,14.7,12740.7,69.3,6141.7,53.0,10464.7,25.0,5829.0,52.3
test39,16G,71871.7,99.0,537393.0,72.3,152217.7,20.0,77026.7,99.0,228184.3,16.7,809.0,0.7,16:100000:16/64,8115.7,64.7,0.0,0.0,12403.0,68.0,6717.3,56.7,0.0,0.0,6662.7,48.7
test40,16G,61452.7,96.3,319687.3,86.3,158370.7,36.0,77324.3,98.7,228657.7,18.0,808.9,0.7,16:100000:16/64,4947.3,82.7,0.0,0.0,11052.7,83.3,5085.7,87.7,10442.7,26.0,4714.3,46.0
test41,16G,72030.3,98.7,575339.7,77.7,159421.7,21.7,76765.7,98.7,229605.3,17.0,821.2,0.7,16:100000:16/64,8238.0,68.7,0.0,0.0,9759.7,61.0,7820.3,70.0,0.0,0.0,4351.7,36.0

An untar-like test with the optimizations shown below except the mount
options.

real world tests: 0:40.10 elapsed 91%CPU (default mkfs.xfs)
real world tests: 0:39.86 elapsed 92%CPU (mkfs.xfs -d agcount=2)
real world tests: 0:41.89 elapsed 87%CPU (w/noatime,etc)

Final optimizations:
echo 128 > /sys/block/sdb/queue/max_sectors_kb   # 128 is default
echo 512 > /sys/block/sdb/queue/nr_requests      # 128 is default
echo 254 > /sys/block/sda/device/queue_depth     # 254 is default
echo deadline > /sys/block/sdb/queue/scheduler   # distribution dependent
blockdev --setra 16384 /dev/sdb                  # set readahead
defaults,noatime,logbufs=8,logbsize=262144       # add to /etc/fstab

Kept the defaults for mkfs.xfs:
p34:~# mkfs.xfs -f /dev/sdb1
meta-data=/dev/sdb1              isize=256    agcount=4, agsize=73236819 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=292947275, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096 
log      =internal log           bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
p34:~#

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
