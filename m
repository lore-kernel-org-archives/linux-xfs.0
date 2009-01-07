Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n076U07Y012002 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 00:30:01 -0600
Message-ID: <49644C69.1000801@sgi.com>
Date: Wed, 07 Jan 2009 17:32:09 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix corruption case for block size < page size
References: <49435F35.40109@sandeen.net>	<4943FCD7.2010509@sandeen.net>	<494735D9.8020809@sgi.com>	<49473F5C.3070308@sandeen.net>	<49474530.2080809@sgi.com>	<4947466D.7000705@sandeen.net>
	<494748FA.20404@sandeen.net> <49474FE4.2030500@sandeen.net>
	<49643C5A.30608@sgi.com> <4964435C.802@sandeen.net>
In-Reply-To: <4964435C.802@sandeen.net>
Reply-To: lachlan@sgi.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>> Eric Sandeen wrote:
>>> Eric Sandeen wrote:
>>>
>>>> Gah; or not.  what is going on here...  Doing just steps 1, 2, 3, 4
>>>> (ending on the extending truncate):
>>>>
>>>> # xfs_io -c "pwrite -S 0x11 -b 4096 0 4096" -c "mmap -r 0 512" -c "mread
>>>> 0 512" -c "munmap" -c "truncate 256" -c "truncate 514" -t -d -f
>>>> /mnt/scratch/testfile
>>>>
>>>> # xfs_bmap -v /mnt/scratch/testfile
>>>> /mnt/scratch/testfile:
>>>>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>>>>    0: [0..0]:          63..63            0 (63..63)             1
>>>>    1: [1..1]:          hole                                     1
>>>>
>>>> It looks like what I expect, at this point.  But then:
>>>>
>>>> # sync
>>>> # xfs_bmap -v /mnt/scratch/testfile
>>>> /mnt/scratch/testfile:
>>>>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>>>>    0: [0..1]:          63..64            0 (63..64)             2
>>>>
>>>> Um, why'd that last block get mapped in?  mmap vs. direct IO I'm
>>>> guessing... w/o the mmap read this does not happen.
>>> Replying to myself twice?  I really need to go to bed.
>>>
>>> So this all does seem to come back to page_state_convert.
>>>
>>> Both the extending write in the original case and the sync above find
>>> their way there; but esp. in the sync test above, why do we have *any*
>>> work to do?
>> Eric, did you find out why sync was allocating that second block?
> 
> I'm afraid this has been on the back burner (or maybe further back) for
> a while... so... either "no" or "I don't remember" :)

Just trying your test case.  It's not related to direct I/O or mmap I/O
since I can reproduce it without those.

# xfs_io -f -c "pwrite -S 0x11 -b 513 0 513" -c "truncate 1" -c "truncate 513" file
wrote 513/513 bytes at offset 0
513.000000 bytes, 1 ops; 0.0000 sec (8.895 MiB/sec and 18181.8182 ops/sec)
# xfs_bmap -vvp file; sync; xfs_bmap -vvp file
file:
  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
    0: [0..0]:          48..48            0 (48..48)             1 00000
    1: [1..1]:          hole                                     1
  FLAG Values:
     010000 Unwritten preallocated extent
     001000 Doesn't begin on stripe unit
     000100 Doesn't end   on stripe unit
     000010 Doesn't begin on stripe width
     000001 Doesn't end   on stripe width
file:
  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
    0: [0..1]:          48..49            0 (48..49)             2 00000
  FLAG Values:
     010000 Unwritten preallocated extent
     001000 Doesn't begin on stripe unit
     000100 Doesn't end   on stripe unit
     000010 Doesn't begin on stripe width
     000001 Doesn't end   on stripe width

xfs_bmap will cause the file to be flushed so there should be no dirty
data to be flushed during the sync.  Strange.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
