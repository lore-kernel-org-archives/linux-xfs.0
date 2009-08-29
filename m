Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7T68ewK203299 for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 01:08:55 -0500
Received: from mx2.empa.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5416640C005
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 23:09:00 -0700 (PDT)
Received: from mx2.empa.ch (mx2.empa.ch [152.88.7.32]) by cuda.sgi.com with
	ESMTP id EKnG6fxvPU7Cg9fV for <xfs@oss.sgi.com>;
	Fri, 28 Aug 2009 23:09:00 -0700 (PDT)
From: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Date: Sat, 29 Aug 2009 08:08:38 +0200
Subject: RE: xfs data loss
Message-ID: <B9A7B002C7FAFC469D4229539E909760308DA653FA@DU-EXC-MAIL.empa.emp-eaw.ch>
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A975A35.3060809@sandeen.net>
	<B9A7B002C7FAFC469D4229539E909760308DA65345@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A981133.6060009@sandeen.net>
In-Reply-To: <4A981133.6060009@sandeen.net>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Dear Eric, all
During the night also the "twin" partition of the previously affected one

(/dev/md5) got problems, 
this time with a clear hardware problem: 

one of the 20 disks was going on failure (2 devices missing).
After that, and also after a reboot I cannot mount the partition:
can't read superblock.
I would like to recover my data, so I try xfs_repair but...

ipazia-sun:~ # xfs_repair -v /dev/md5
Phase 1 - find and verify superblock...
superblock read failed, offset 0, size 524288, ag 0, rval 0

fatal error -- Invalid argument

What should I do now?
Thanks, Daniele

Here the logs:


Aug 29 04:52:31 ipazia-sun kernel: sdo: Current [descriptor]: sense key: Medium Error
Aug 29 04:52:31 ipazia-sun kernel:     Additional sense: Unrecovered read error - auto reallocate failed
Aug 29 04:52:31 ipazia-sun kernel: Descriptor sense data with sense descriptors (in hex):
Aug 29 04:52:31 ipazia-sun kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
Aug 29 04:52:31 ipazia-sun kernel:         08 6c c5 7e 
Aug 29 04:52:31 ipazia-sun kernel: end_request: I/O error, dev sdo, sector 141346174
Aug 29 04:52:31 ipazia-sun kernel: raid5: read error not correctable.
Aug 29 04:52:31 ipazia-sun kernel: raid5: Disk failure on sdo1, disabling device. Operation continuing on 18 devices
Aug 29 04:52:31 ipazia-sun kernel: raid5: read error not correctable.
Aug 29 04:52:32 ipazia-sun kernel: raid5: read error not correctable.
Aug 29 04:52:32 ipazia-sun kernel: I/O error in filesystem ("md5") meta-data dev md5 block 0x229195c48       ("xlog_iodone") error 5 buf count 20480
Aug 29 04:52:32 ipazia-sun kernel: xfs_force_shutdown(md5,0x2) called from line 958 of file fs/xfs/xfs_log.c.  Return address = 0xffffffff8829801c
Aug 29 04:52:32 ipazia-sun kernel: Filesystem "md5": Log I/O Error Detected.  Shutting down filesystem: md5
Aug 29 04:52:32 ipazia-sun kernel: Please umount the filesystem, and rectify the problem(s)
Aug 29 04:52:32 ipazia-sun kernel: RAID5 conf printout:
Aug 29 04:52:32 ipazia-sun kernel:  --- rd:20 wd:18 fd:2


>-----Original Message-----
>From: Eric Sandeen [mailto:sandeen@sandeen.net]
>Sent: Friday, August 28, 2009 7:18 PM
>To: Passerone, Daniele
>Cc: xfs@oss.sgi.com
>Subject: Re: xfs data loss
>
>Passerone, Daniele wrote:
>>>> Due to a power shock, suddenly and without log messages about one
>half
>>> (5 TB) of the user
>>>> directories on /dev/md4 have disappeared.
>>> I presume you mean after a reboot?
>>
>>
>>
>> No! No reboot at all.
>
>Ok then perhaps I don't know what you mean by "power shock"
>
>> The directories were mounted via nfs to all our cluster,
>> and are of the type
>>
>> /pool/user
>>
>> all directories from
>>
>> /pool/g*
>>
>> to
>>
>> /pool/z*
>>
>> have disappeared.
>
>On the server as well?  Or just clients?  -really- no server-side errors
>in the logs?
>
>Are you sure the storage hardware & the md volume is in ok shape?
>
>> Of course NO COMMAND of the kind rm /pool/[g-z]* was issued.
>>
>>> Were the lost directories recently created?  I've never heard of
>>> untouched, existing directories disappearing after a power loss...
>>>
>>
>> Not at all.
>> Here I am.
>>> Not much to go on here I'm afraid.  SLES10 is an old kernel, but it's
>>> supported by SuSE at least.
>>>
>>
>> Can you use my metadata, or is it useless?
>
>Not yet, still wondering what really happened.
>
>-eric
>
>> Thank you!
>>
>> Daniele
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
