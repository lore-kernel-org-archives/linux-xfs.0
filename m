Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 18:54:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2Q1s6s4025217
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 18:54:08 -0700
Message-ID: <47E9AC67.8070809@sgi.com>
Date: Wed, 26 Mar 2008 12:52:39 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: REVIEW: Write primary superblock info to ALL secondaries during
 mkfs
References: <op.t8j4nch93jf8g2@pc-bnaujok.melbourne.sgi.com> <47E8F5BD.7000601@sandeen.net>
In-Reply-To: <47E8F5BD.7000601@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>



Eric Sandeen wrote:
> Barry Naujok wrote:
>> Secondaries should contain redundant information from the primary
>> superblock. It does this for the filesystem geometry information,
>> but not inode values (rootino, rt inos, quota inos).
>>
>> This patch updates all the secondaries from the primary just before
>> it marks the filesystem as good to go.
>>
>> Unfortunately, this also affects the output of xfs_repair during
>> QA 030 and 178 which restores the primary superblock from the
>> secondaries.
>>
>> Now that the secondaries have valid inode values, xfs_repair
>> does not have to restore them to the correct values after copying
>> the secondary into the primary.
>>
>> Attached is the mkfs.xfs patch and also the updated golden
>> outputs for QA 030 and 178.
>>
>> The next step after this is to enhance xfs_repair to be more
>> thorough in checking the secondaries during Phase 1.
> 
> One related thing I'd always wondered about was stamping a secondary at
> the very end of the device (and therefore shrinking the fs by just a
> bit) - repair could then do a quick check at the end of the device
> before resorting to scanning for the 2nd backup... would this make any
> sense?

I guess it might, Barry what do you think? Probably makes grow a bit
more complicated. What would repair do if it doesn't find the backup
SB at the end of the device? We'd need a new SB flag to indicate it's
supposed to be there, which seems a bit chicken-and-egg'ish ...

Cheers

> 
> -Eric
> 
> 

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
