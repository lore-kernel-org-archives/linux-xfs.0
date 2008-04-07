Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 14:34:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m37LXv2l029990
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 14:33:58 -0700
Received: from smtp.getmail.no (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 158C275B34A
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2008 14:34:34 -0700 (PDT)
Received: from smtp.getmail.no (smtp.getmail.no [84.208.20.33]) by cuda.sgi.com with ESMTP id ZQ36SgdNjHZnd1eq for <xfs@oss.sgi.com>; Mon, 07 Apr 2008 14:34:34 -0700 (PDT)
Received: from pmxchannel-daemon.no-osl-m323-srv-009-z2.isp.get.no by
 no-osl-m323-srv-009-z2.isp.get.no
 (Sun Java System Messaging Server 6.2-7.05 (built Sep  5 2006))
 id <0JYZ0010V2GPOX00@no-osl-m323-srv-009-z2.isp.get.no> for xfs@oss.sgi.com;
 Mon, 07 Apr 2008 22:34:01 +0200 (CEST)
Received: from smtp.getmail.no ([10.5.16.1])
 by no-osl-m323-srv-009-z2.isp.get.no
 (Sun Java System Messaging Server 6.2-7.05 (built Sep  5 2006))
 with ESMTP id <0JYZ007U92FJRSD0@no-osl-m323-srv-009-z2.isp.get.no> for
 xfs@oss.sgi.com; Mon, 07 Apr 2008 22:33:19 +0200 (CEST)
Received: from localhost ([84.215.109.218])
 by no-osl-m323-srv-009-z1.isp.get.no
 (Sun Java System Messaging Server 6.2-7.05 (built Sep  5 2006))
 with ESMTP id <0JYZ00GXM2FJP6A0@no-osl-m323-srv-009-z1.isp.get.no> for
 xfs@oss.sgi.com; Mon, 07 Apr 2008 22:33:19 +0200 (CEST)
Date: Mon, 07 Apr 2008 22:33:19 +0200
From: Thor Kristoffersen <thorkr@gmail.com>
Subject: Re: Does XFS prevent disk spindown?
In-reply-to: <47F9735E.8020900@sgi.com>
Message-id: <m2wsn9qub4.fsf@getmail.no>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <m2tzimbvif.fsf@getmail.no> <20080401003005.GJ103491721@sgi.com>
 <47F1CF6D.2040103@sandeen.net> <m2d4p9o2sc.fsf@getmail.no>
 <m2y77smmdj.fsf@getmail.no> <47F9735E.8020900@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

Timothy Shimmin <tes@sgi.com> writes:
> Thor Kristoffersen wrote:
>>> Use blktrace, or echo 1 > /proc/sys/vm/block_dump to see what block and
>>> who's writing it...  it's probably the superblock?  what kernel?
>>
>> This is kernel version 2.6.24.  More specifically it's a Debian kernel from
>> package linux-image-2.6.24-1-686 (2.6.24-4).
>>
>> I put the system in runlevel 1 and executed the test as you suggested.  On
>> /dev/sda3 I have mounted (with noatime) an XFS filesystem that contains
>> data that is not supposed to be accessed by any process.  In the output
>> below I have filtered out all accesses to other partitions.  (BTW, this is
>> not actually the disk that I wanted to spin down, but I think the log
>> proves my point.)
>>
>>
> I'm wondering if that is writing to the xfs ondisk log/journal in those cases.
> What does 'xfs_logprint -t' show in these "idle" states
> after these writes?

xfs_logprint produces output like the one shown below, so it does indeed
look like it's writing to the journal.  But why should it need to keep
writing to the journal when there have been no updates to any files on that
partition recently?


Thor

----------------------------------------------------------------

xfs_logprint:
    data device: 0x803
    log device: 0x803 daddr: 682818768 length: 262144

    log tail: 157103 head: 157107 state: <DIRTY>


LOG REC AT LSN cycle 1 block 157103 (0x1, 0x265af)
============================================================================
TRANS: tid:0xf2fcd6e0  type:SB_COUNT  #items:1  trans:0x0  q:0x80b4c08
BUF: cnt:2 total:2 a:0x8099140 len:24 a:0x80ac748 len:128 
	BUF:  #regs:2   start blkno:0x0   len:1   bmap size:1   flags:0x0
	SUPER Block Buffer:

LOG REC AT LSN cycle 1 block 157105 (0x1, 0x265b1)
============================================================================
TRANS: tid:0xf2fcd790  type:SB_COUNT  #items:1  trans:0x0  q:0x80b4c08
BUF: cnt:2 total:2 a:0x8099140 len:24 a:0x80ac748 len:128 
	BUF:  #regs:2   start blkno:0x0   len:1   bmap size:1   flags:0x0
	SUPER Block Buffer:
