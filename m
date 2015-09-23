Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 663237F37
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 04:15:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B7EB304032
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 02:15:36 -0700 (PDT)
Received: from mail.nomovok.com (mail.nomovok.com [83.150.122.238]) by
	cuda.sgi.com with ESMTP id 6zbiPlPSAxTJe5Lq (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2015 02:15:32 -0700 (PDT)
Received: from [192.168.0.111]
	(host46-236-dynamic.8-87-r.retail.telecomitalia.it [87.8.236.46])
	by mail.nomovok.com (Postfix) with ESMTPSA id 65287AE0A7
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 12:15:29 +0300 (EEST)
Message-ID: <56026DB0.8070104@nomovok.com>
Date: Wed, 23 Sep 2015 11:15:28 +0200
From: Angelo Dureghello <angelo.dureghello@nomovok.com>
MIME-Version: 1.0
Subject: Re: xfstests, bad generic tests 009 and 308
References: <55FC3E0E.9060506@nomovok.com>
	<20150918224412.GE26895@dastard>	<55FFE665.7040004@nomovok.com>
	<20150921225244.GD19114@dastard>	<56014C62.1070403@nomovok.com>
	<20150922212740.GJ19114@dastard>
In-Reply-To: <20150922212740.GJ19114@dastard>
Content-Type: multipart/mixed; boundary="------------060003040901080706060303"
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
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------060003040901080706060303
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

many thanks.

On 22/09/2015 23:27, Dave Chinner wrote:
> Urk, the command should be "fsync", not "sync". Regardless, the
> last bmap/fiemap pair shows something interesting:
>
> bmap-vp:
>
>> /media/p6/testfile:
>>   EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>>     0: [0..127]:        96..223           0 (96..223)          128 00000
>>     1: [128..2047]:     hole                                  1920
>>     2: [2048..2559]:    2144..2655        0 (2144..2655)       512 10000
> fiemap -v:
>
>> /media/p6/testfile:
>>   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>>     0: [0..127]:        96..223            128   0x0
>>     1: [128..2047]:     hole              1920
>>     2: [2048..2175]:    2144..2271         128 0x800
>>     3: [2176..2303]:    2272..2399         128   0x0
>>     4: [2304..2559]:    2400..2655         256 0x801
> Note that they are different - the former shows an unwritten extent
> of 256k @ offset 1MB, the later shows that extent split by 64k of
> data @ 1088k.
>
> The bmap -vp output is incorrect - it is supposed to sync data first
> and so should look the same as the fiemap output. Can you run this
> test again, this time with s/sync/fsync so the files are clean when
> bmap/fiemap are run? Can you run it a second time (umount/mkfs
> again) but with fiemap run first? i.e '-c "fiemap -v" -c "bmap -vp" \'
> instead of the original order?
>
> Next, can you compile your kernel with CONFIG_XFS_DEBUG=y and rerun
> the tests? Does anything interesting appear in dmesg during the test
> run?

Done, see mkfs_output_2.txt attached

> Not actually useful - I need to know what is happening inside the
> unlinkat() call.  I'm going to need a trace-cmd event dump of that
> xfs_io command and the subsequent rm (at least for the first couple
> of seconds of the rm). Please put the output file from the trace-cmd
> record command on a tmpfs filesystem so it doesn't pollute the xfs
> event trace ;)
>
I set some traces inside fs/namei.c  do_unlinkat()

root[243] vpc24 (master) /home/angelo/xfstests
# ./start_xfs_test.sh
QA output created by 308
[  144.822616] XFS (mmcblk0p5): Mounting V4 Filesystem
[  145.074537] XFS (mmcblk0p5): Starting recovery (logdev: internal)
[  145.107298] XFS (mmcblk0p5): Ending recovery (logdev: internal)
Silence is golden
[  145.413606] do_unlinkat(): entering
[  145.417124] do_unlinkat(): retry
[  145.421156] do_unlinkat(): retry_delegate
[  145.425920] do_unlinkat(): vfs_unlink returns 0
[  145.430950] do_unlinkat(): exit2

At least that function "seems" to complete, but, as from my previous 
message
looks like strace was not showing nothig over it.

I captured about 10 seconds of events after the "hang" on 308. Hope they 
are
enough.

File is quite long, so you can read it from here:
http://sysam.it/~angelo/events.txt

bye,

-- 
Best regards,
Angelo Dureghello


--------------060003040901080706060303
Content-Type: text/plain; charset=UTF-8;
 name="mkfs_output_2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mkfs_output_2.txt"

# # xfs_io -f -c "pwrite 0 64k" -c fsync \
	    -c "bmap -vp" -c "fiemap -v" \
	    -c "falloc 1024k 256k" -c fsync \
	    -c "pwrite 1088k 64k" -c fsync \
	    -c "bmap -vp" -c "fiemap -v" \
	    /media/p6/testfile


# xfs_io -f -c "pwrite 0 64k" -c fsync \
>     -c "bmap -vp" -c "fiemap -v" \
>     -c "falloc 1024k 256k" -c fsync \
>     -c "pwrite 1088k 64k" -c fsync \
>     -c "bmap -vp" -c "fiemap -v" \
>     /media/p6/testfile
wrote 65536/65536 bytes at offset 0
64 KiB, 16 ops; 0.0000 sec (10.271 MiB/sec and 2629.4166 ops/sec)
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..127]:        96..223           0 (96..223)          128 00000
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        96..223            128   0x1
wrote 65536/65536 bytes at offset 1114112
64 KiB, 16 ops; 0.0000 sec (11.857 MiB/sec and 3035.4771 ops/sec)
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..127]:        96..223           0 (96..223)          128 00000
   1: [128..2047]:     hole                                  1920
   2: [2048..2175]:    2144..2271        0 (2144..2271)       128 10000
   3: [2176..2303]:    2272..2399        0 (2272..2399)       128 00000
   4: [2304..2559]:    2400..2655        0 (2400..2655)       256 10000
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        96..223            128   0x0
   1: [128..2047]:     hole              1920
   2: [2048..2175]:    2144..2271         128 0x800
   3: [2176..2303]:    2272..2399         128   0x0
   4: [2304..2559]:    2400..2655         256 0x801


root[251] host ~
# mkfs.xfs -f /dev/mmcblk0p6 
meta-data=/dev/mmcblk0p6         isize=256    agcount=4, agsize=551008 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=2204032, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
root[252] host ~
# mount /dev/mmcblk0p6 /media/p6
[ 1000.531021] XFS (mmcblk0p6): Mounting V4 Filesystem
[ 1000.813339] XFS (mmcblk0p6): Ending clean mount
root[253] host ~
# xfs_io -f -c "pwrite 0 64k" -c fsync \
>      -c "bmap -vp" -c "fiemap -v" \
>      -c "falloc 1024k 256k" -c fsync \
>      -c "pwrite 1088k 64k" -c fsync \
>      -c "fiemap -v" -c "bmap -vp" \
>      /media/p6/testfile
wrote 65536/65536 bytes at offset 0
64 KiB, 16 ops; 0.0000 sec (10.126 MiB/sec and 2592.3526 ops/sec)
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..127]:        96..223           0 (96..223)          128 00000
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        96..223            128   0x1
wrote 65536/65536 bytes at offset 1114112
64 KiB, 16 ops; 0.0000 sec (11.519 MiB/sec and 2948.7652 ops/sec)
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        96..223            128   0x0
   1: [128..2047]:     hole              1920
   2: [2048..2175]:    2144..2271         128 0x800
   3: [2176..2303]:    2272..2399         128   0x0
   4: [2304..2559]:    2400..2655         256 0x801
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..127]:        96..223           0 (96..223)          128 00000
   1: [128..2047]:     hole                                  1920
   2: [2048..2175]:    2144..2271        0 (2144..2271)       128 10000
   3: [2176..2303]:    2272..2399        0 (2272..2399)       128 00000
   4: [2304..2559]:    2400..2655        0 (2400..2655)       256 10000
root[254] host ~


--------------060003040901080706060303
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------060003040901080706060303--
