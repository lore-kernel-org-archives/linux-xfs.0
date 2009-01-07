Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n075rZXE007456 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 23:53:38 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92BB369754
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 21:53:33 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id VWmprNRMHRm1mkow for
	<xfs@oss.sgi.com>; Tue, 06 Jan 2009 21:53:33 -0800 (PST)
Message-ID: <4964435C.802@sandeen.net>
Date: Tue, 06 Jan 2009 23:53:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix corruption case for block size < page size
References: <49435F35.40109@sandeen.net>	<4943FCD7.2010509@sandeen.net>	<494735D9.8020809@sgi.com>	<49473F5C.3070308@sandeen.net>	<49474530.2080809@sgi.com>	<4947466D.7000705@sandeen.net>
	<494748FA.20404@sandeen.net> <49474FE4.2030500@sandeen.net>
	<49643C5A.30608@sgi.com>
In-Reply-To: <49643C5A.30608@sgi.com>
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
To: lachlan@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>
>>> Gah; or not.  what is going on here...  Doing just steps 1, 2, 3, 4
>>> (ending on the extending truncate):
>>>
>>> # xfs_io -c "pwrite -S 0x11 -b 4096 0 4096" -c "mmap -r 0 512" -c "mread
>>> 0 512" -c "munmap" -c "truncate 256" -c "truncate 514" -t -d -f
>>> /mnt/scratch/testfile
>>>
>>> # xfs_bmap -v /mnt/scratch/testfile
>>> /mnt/scratch/testfile:
>>>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>>>    0: [0..0]:          63..63            0 (63..63)             1
>>>    1: [1..1]:          hole                                     1
>>>
>>> It looks like what I expect, at this point.  But then:
>>>
>>> # sync
>>> # xfs_bmap -v /mnt/scratch/testfile
>>> /mnt/scratch/testfile:
>>>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>>>    0: [0..1]:          63..64            0 (63..64)             2
>>>
>>> Um, why'd that last block get mapped in?  mmap vs. direct IO I'm
>>> guessing... w/o the mmap read this does not happen.
>> Replying to myself twice?  I really need to go to bed.
>>
>> So this all does seem to come back to page_state_convert.
>>
>> Both the extending write in the original case and the sync above find
>> their way there; but esp. in the sync test above, why do we have *any*
>> work to do?
> Eric, did you find out why sync was allocating that second block?

I'm afraid this has been on the back burner (or maybe further back) for
a while... so... either "no" or "I don't remember" :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
