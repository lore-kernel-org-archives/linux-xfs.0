Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 738A17F54
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 16:54:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5251A30406B
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 14:54:42 -0700 (PDT)
Received: from mail-ob0-f182.google.com (mail-ob0-f182.google.com
	[209.85.214.182]) by cuda.sgi.com with ESMTP id
	Vb87we9p7t8eEhaz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 14:54:38 -0700 (PDT)
Received: by mail-ob0-f182.google.com with SMTP id eh20so933103obb.13
	for <xfs@oss.sgi.com>; Thu, 02 May 2013 14:54:37 -0700 (PDT)
Message-ID: <5182E09B.7070109@gmail.com>
Date: Thu, 02 May 2013 17:54:35 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix internal _xfs_check to handle logdev etc
References: <51827DDF.4050708@redhat.com>
	<1367509132.4098.86.camel@chandra-dt.ibm.com>
	<51828F84.3040508@sandeen.net>
	<1367516658.4098.87.camel@chandra-dt.ibm.com>
	<5182B0FE.4030301@sandeen.net> <5182CE0D.8030502@gmail.com>
	<5182D123.80005@redhat.com>
In-Reply-To: <5182D123.80005@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, sekharan@us.ibm.com, xfs-oss <xfs@oss.sgi.com>

On 05/02/2013 04:48 PM, Eric Sandeen wrote:
>> =====================================================================
>> This is how things went after using Eric's patch:
>>
>> root@plbearer:/var/lib/xfstests# ./check generic/001
>> mount: wrong fs type, bad option, bad superblock on /dev/mapper/tData,
>>         missing codepage or helper program, or other error
>>         In some cases useful info is found in syslog - try
>>         dmesg | tail  or so
>
> Yeah this seems . . . suboptimal, I haven't looked into it.
>
> If TEST_LOGDEV is set it seems like that should be the *first* thing
> to try.  I don't recall if it did this before the reorganization.
>
> FWIW, I've seen problems in the past when using devicemapper devices.
> One never knows what's a symlink ;)
>
> If you specify /dev/dm-X instead of the pretty name, does it go any
> better for you?
>
> (I don't remember if that helped; I remember chasing dm issues before.
> I just don't use dm in my testing anymore, TBH) :)
>
> -Eric

Ugh, that was a rather sobering experience.  Lesson learned.  To use 
/dev/dm-X goes much worse.  The /dev/dm-0 for logdev goes untranslated, 
but the /dev/dm-1 seems to get auto-translated back to /dev/mapper/tData 
(more commentary after this):

======================================================================
root@plbearer:~# export TEST_DEV=/dev/dm-1
root@plbearer:~# export TEST_LOGDEV=/dev/dm-0
root@plbearer:~# export USE_EXTERNAL="yes"
root@plbearer:~# cd /var/lib/xfstests/

root@plbearer:/var/lib/xfstests# mount | grep mapper
/dev/mapper/tData on /mnt/testdir type xfs (rw,logdev=/dev/mapper/tLog)

root@plbearer:/var/lib/xfstests# ./check generic/001 generic/002
mount: /dev/mapper/tData already mounted or /mnt/testdir busy
mount: according to mtab, /dev/mapper/tData is already mounted on 
/mnt/testdir
common/rc: retrying test device mount with external set
mount: /dev/mapper/tData already mounted or /mnt/testdir busy
mount: according to mtab, /dev/mapper/tData is already mounted on 
/mnt/testdir
common/rc: could not mount /dev/dm-1 on /mnt/testdir

root@plbearer:/var/lib/xfstests# ./check generic/001 generic/002
mount: /dev/mapper/tData already mounted or /mnt/testdir busy
mount: according to mtab, /dev/mapper/tData is already mounted on 
/mnt/testdir
common/rc: retrying test device mount with external set
mount: /dev/mapper/tData already mounted or /mnt/testdir busy
mount: according to mtab, /dev/mapper/tData is already mounted on 
/mnt/testdir
common/rc: could not mount /dev/dm-1 on /mnt/testdir

root@plbearer:/var/lib/xfstests# umount $TEST_DEV

root@plbearer:/var/lib/xfstests# ./check generic/001 generic/002
common/rc: Error: $TEST_DEV (/dev/dm-1) is not a MOUNTED xfs filesystem
Filesystem     Type 1K-blocks  Used Available Use% Mounted on
-              -       385460     0    385460   0% /dev

root@plbearer:/var/lib/xfstests# ./check generic/001 generic/002
mount: /dev/mapper/tData already mounted or /mnt/testdir busy
mount: according to mtab, /dev/mapper/tData is already mounted on 
/mnt/testdir
common/rc: retrying test device mount with external set
mount: /dev/mapper/tData already mounted or /mnt/testdir busy
mount: according to mtab, /dev/mapper/tData is already mounted on 
/mnt/testdir
common/rc: could not mount /dev/dm-1 on /mnt/testdir

root@plbearer:/var/lib/xfstests# umount $TEST_DEV

root@plbearer:/var/lib/xfstests# mount -t xfs -o logdev=$TEST_LOGDEV 
$TEST_DEV $TEST_DIR

root@plbearer:/var/lib/xfstests# mount | grep mapper
/dev/mapper/tData on /mnt/testdir type xfs (rw,logdev=/dev/dm-0)

root@plbearer:/var/lib/xfstests# echo $TEST_DEV
/dev/dm-1

======================================================================

So I got rid of the linear objects, went to cfdisk, brewed up some 
good-old-fashioned MBR logical partitions, and then...

======================================================================

root@plbearer:~# mkfs.xfs -l logdev=/dev/sda5 /dev/sda6
meta-data=/dev/sda6              isize=256    agcount=4, agsize=69774 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=279095, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =/dev/sda5              bsize=4096   blocks=16057, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

root@plbearer:~# export TEST_DEV=/dev/sda6
root@plbearer:~# export TEST_LOGDEV=/dev/sda5
root@plbearer:~# export TEST_DIR=/mnt/testdir
root@plbearer:~# export USE_EXTERNAL="yes"
root@plbearer:~# cd /var/lib/xfstests/

root@plbearer:/var/lib/xfstests# ./check generic/001 generic/002
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 plbearer 3.8.11

generic/001      7s
generic/002      1s
Ran: generic/001 generic/002
Passed all 2 tests
root@plbearer:/var/lib/xfstests# ./check generic/001 generic/002
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 plbearer 3.8.11

generic/001      6s
generic/002      1s
Ran: generic/001 generic/002
Passed all 2 tests
root@plbearer:/var/lib/xfstests# ./check generic/001 generic/002
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 plbearer 3.8.11

generic/001      7s
generic/002      1s
Ran: generic/001 generic/002
Passed all 2 tests

======================================================================

And here's how it runs on bare partitions after reversing the patch and 
reinstalling xfstests, as a sort of check figure...

======================================================================

root@plbearer:/var/lib/xfstests# ./check generic/001 generic/002
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 plbearer 3.8.11

_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (c) (see 
.full)
Passed all 0 tests
root@plbearer:/var/lib/xfstests# ./check generic/001 generic/002
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 plbearer 3.8.11

_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (c) (see 
.full)
Passed all 0 tests

======================================================================

So I'll consider this problem solved as well as another trial-by-fire 
lesson in using the device-mapper objects.  Thanks again!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
