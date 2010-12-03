Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB3E6kdo090363 for <xfs@oss.sgi.com>; Fri, 3 Dec 2010 08:06:46 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A59B1C90452
	for <xfs@oss.sgi.com>; Fri,  3 Dec 2010 06:08:29 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id emKIeuHBESkn19E5 for
	<xfs@oss.sgi.com>; Fri, 03 Dec 2010 06:08:29 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUZL2FI08GLS7MS1@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Fri, 03 Dec 2010 15:07:57 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUZL2E915SLS7X2C@mx.isti.cnr.it> for xfs@oss.sgi.com; Fri,
	03 Dec 2010 15:07:54 +0100 (MET)
Date: Fri, 03 Dec 2010 15:07:58 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
In-reply-to: <20101202230743.GZ16922@dastard>
Message-id: <4CF8F9BE.6000604@shiftmail.org>
MIME-version: 1.0
References: <4CF7A539.1050206@shiftmail.org> <4CF7A9CF.2020904@shiftmail.org>
	<20101202230743.GZ16922@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-lvm@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 12/03/2010 12:07 AM, Dave Chinner wrote:
> This is a classic ENOSPC vs NFS client writeback overcommit caching
> issue.  Have a look at the block map output - I bet theres holes in
> the file and it's only consuming 1.5GB of disk space. use xfs_bmap
> to check this. du should tell you the same thing.
>
>    

Yes you are right!

root@server:/mnt/ram# ll -h
total 1.5G
drwxr-xr-x 2 root root   21 2010-12-02 12:54 ./
drwxr-xr-x 3 root root 4.0K 2010-11-29 23:51 ../
-rw-r--r-- 1 root root 1.9G 2010-12-02 15:04 zerofile

root@server:/mnt/ram# ls -lsh
total 1.5G
1.5G -rw-r--r-- 1 root root 1.9G 2010-12-02 15:04 zerofile
(it's a sparse file)

root@server:/mnt/ram# xfs_bmap zerofile
zerofile:
         0: [0..786367]: 786496..1572863
         1: [786368..1572735]: 2359360..3145727
         2: [1572736..2232319]: 1593408..2252991
         3: [2232320..2529279]: 285184..582143
         4: [2529280..2531327]: hole
         5: [2531328..2816407]: 96..285175
         6: [2816408..2971511]: 582144..737247
         7: [2971512..2971647]: hole
         8: [2971648..2975183]: 761904..765439
         9: [2975184..2975743]: hole
         10: [2975744..2975751]: 765440..765447
         11: [2975752..2977791]: hole
         12: [2977792..2977799]: 765480..765487
         13: [2977800..2979839]: hole
         14: [2979840..2979847]: 765448..765455
         15: [2979848..2981887]: hole
         16: [2981888..2981895]: 765472..765479
         17: [2981896..2983935]: hole
         18: [2983936..2983943]: 765456..765463
         19: [2983944..2985983]: hole
         20: [2985984..2985991]: 765464..765471
         21: [2985992..3202903]: hole
         22: [3202904..3215231]: 737248..749575
         23: [3215232..3239767]: hole
         24: [3239768..3252095]: 774104..786431
         25: [3252096..3293015]: hole
         26: [3293016..3305343]: 749576..761903
         27: [3305344..3370839]: hole
         28: [3370840..3383167]: 2252992..2265319
         29: [3383168..3473239]: hole
         30: [3473240..3485567]: 2265328..2277655
         31: [3485568..3632983]: hole
         32: [3632984..3645311]: 2277656..2289983
         33: [3645312..3866455]: hole
         34: [3866456..3878783]: 2289984..2302311

(many delayed allocation extents cannot be filled because space on 
device is finished)

However ...


> Basically, the NFS client overcommits the server filesystem space by
> doing local writeback caching. Hence it caches 1.9GB of data before
> it gets the first ENOSPC error back from the server at around 1.5GB
> of written data. At that point, the data that gets ENOSPC errors is
> tossed by the NFS client, and a ENOSPC error is placed on the
> address space to be reported to the next write/sync call. That gets
> to the dd process when it's 1.9GB into the write.
>    

I'm no great expert but isn't this a design flaw in NFS?

Ok in this case we were lucky it was all zeroes so XFS made a sparse 
file and could fit a 1.9GB into 1.5GB device size.

In general with nonzero data it seems to me you will get data corruption 
because the NFS client thinks it has written the data while the NFS 
server really can't write more data than the device size.

It's nice that the NFS server does local writeback caching but it should 
also cache the filesystem's free space (and check it periodically, since 
nfs-server is presumably not the only process writing in that 
filesystem) so that it doesn't accept more data than it can really 
write. Alternatively, when free space drops below 1GB (or a reasonable 
size based on network speed), nfs-server should turn off filesystem 
writeback caching.

I can't repeat the test with urandom because it's too slow (8MB/sec !?). 
How come Linux hasn't got an "uurandom" device capable of e.g. 400MB/sec 
with only very weak randomness?

But I have repeated the test over ethernet with a bunch of symlinks to a 
100MB file created from urandom:

At client side:

# time cat randfile{001..020} | pv -b > /mnt/nfsram/randfile
1.95GB

real    0m22.978s
user    0m0.310s
sys     0m5.360s


At server side:

# ls -lsh ram
total 1.5G
1.5G -rw-r--r-- 1 root root 1.7G 2010-12-03 14:43 randfile
# xfs_bmap ram/randfile
ram/randfile:
         0: [0..786367]: 786496..1572863
         1: [786368..790527]: 96..4255
         2: [790528..1130495]: hole
         3: [1130496..1916863]: 2359360..3145727
         4: [1916864..2682751]: 1593408..2359295
         5: [2682752..3183999]: 285184..786431
         6: [3184000..3387207]: 4256..207463
         7: [3387208..3387391]: hole
         8: [3387392..3391567]: 207648..211823
         9: [3391568..3393535]: hole
         10: [3393536..3393543]: 211824..211831
         11: [3393544..3395583]: hole
         12: [3395584..3395591]: 211832..211839
         13: [3395592..3397631]: hole
         14: [3397632..3397639]: 211856..211863
         15: [3397640..3399679]: hole
         16: [3399680..3399687]: 211848..211855
         17: [3399688..3401727]: hole
         18: [3401728..3409623]: 221984..229879
# dd if=/mnt/ram/randfile | wc -c
3409624+0 records in
3409624+0 records out
1745727488
1745727488 bytes (1.7 GB) copied, 5.72443 s, 305 MB/s

The file is still sparse, and this time it certainly has data corruption 
(holes will be read as zeroes).
I understand that the client receives Input/output error when this 
condition is hit, but the file written at server side has apparent size 
1.8GB but the valid data in it is not 1.8GB. Is it good semantics? 
Wouldn't it be better for nfs-server to turn off writeback caching when 
it approaches a disk-full situation?


And then I see another problem:
As you see, xfs_fsr shows lots of holes, even with randomfile (this is 
taken from urandom so you can be sure it hasn't got many zeroes) already 
from offset 790528 sectors which is far from the disk full situation...

First I checked that this does not happen by pushing less than 1.5GB of 
data. Ok it does not.
Then I tried with exactly 15*100MB (files are 100MB, are symliks to a 
file which was created with dd if=/dev/urandom of=randfile.rnd bs=1M 
count=100)
and this happened:

client side:

# time cat randfile{001..015} | pv -b > /mnt/nfsram/randfile
1.46GB

real    0m18.265s
user    0m0.260s
sys     0m4.460s

(please note: no I/O error at client side! blockdev --getsize64 
/dev/ram0 == 1610612736)


server side:

# ls -ls ram
total 1529676
1529676 -rw-r--r-- 1 root root 1571819520 2010-12-03 14:51 randfile

# dd if=/mnt/ram/randfile | wc -c
3069960+0 records in
3069960+0 records out
1571819520
1571819520 bytes (1.6 GB) copied, 5.30442 s, 296 MB/s

# xfs_bmap ram/randfile
ram/randfile:
         0: [0..112639]: 96..112735
         1: [112640..208895]: 114784..211039
         2: [208896..399359]: 285184..475647
         3: [399360..401407]: 112736..114783
         4: [401408..573439]: 475648..647679
         5: [573440..937983]: 786496..1151039
         6: [937984..1724351]: 2359360..3145727
         7: [1724352..2383871]: 1593408..2252927
         8: [2383872..2805695]: 1151040..1572863
         9: [2805696..2944447]: 647680..786431
         10: [2944448..2949119]: 211040..215711
         11: [2949120..3055487]: 2252928..2359295
         12: [3055488..3058871]: 215712..219095
         13: [3058872..3059711]: hole
         14: [3059712..3060143]: 219936..220367
         15: [3060144..3061759]: hole
         16: [3061760..3061767]: 220368..220375
         17: [3061768..3063807]: hole
         18: [3063808..3063815]: 220376..220383
         19: [3063816..3065855]: hole
         20: [3065856..3065863]: 220384..220391
         21: [3065864..3067903]: hole
         22: [3067904..3067911]: 220392..220399
         23: [3067912..3069951]: hole
         24: [3069952..3069959]: 220400..220407

Holes in a random file!
This is data corruption, and nobody is notified of this data corruption: 
no error at client side or server side!
Is it good semantics? How could client get notified of this? Some kind 
of fsync maybe?

Thank you

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
