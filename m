Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 18:15:33 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L2FOqV028227
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 18:15:29 -0800
Subject: Re: [REVIEW 2/2] Case insensitive support for XFS - user-space
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t43zfeiz3jf8g2@pc-bnaujok.melbourne.sgi.com> <479118CF.1020302@sandeen.net> <47919214.9000807@sandeen.net> <op.t49b6jkr3jf8g2@pc-bnaujok.melbourne.sgi.com>
Date: Mon, 21 Jan 2008 13:16:17 +1100
Message-ID: <op.t49clfbc3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t49b6jkr3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Mon, 21 Jan 2008 13:07:21 +1100, Barry Naujok <bnaujok@sgi.com> wrote:

> On Sat, 19 Jan 2008 17:00:52 +1100, Eric Sandeen <sandeen@sandeen.net>  
> wrote:
>
>> Eric Sandeen wrote:
>>
>>> Also, if I specify -nutf8=default on a 500m fs:
>>>
>>> # mkfs.xfs -dfile,name=fsfile,size=500m -nutf8=default
>>> meta-data=fsfile                 isize=256    agcount=4, agsize=32000  
>>> blks
>>>          =                       sectsz=512   attr=2
>>> data     =                       bsize=4096   blocks=128000, imaxpct=25
>>>          =                       sunit=0      swidth=0 blks
>>> naming   =version 2              bsize=4096   utf8=default
>>> log      =internal log           bsize=4096   blocks=1200, version=2
>>>          =                       sectsz=512   sunit=0 blks,  
>>> lazy-count=0
>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>> mkfs.xfs: cannot reserve space: No space left on device
>>
>>         /*
>>          * allocate the inode
>>          */
>>         tp = libxfs_trans_alloc(mp, 0);
>>         error =  libxfs_trans_reserve(tp, XFS_CREATE_LOG_RES(mp), 0, 0,
>> 0, 0);
>
> Can you try this instead?
>
> 	error =  libxfs_trans_reserve(tp, XFS_IALLOC_BLOCKS(mp) +
> 			(XFS_IN_MAXLEVELS(mp) - 1), 0, 0, 0, 0);

BTW. this fix works for me :)

>>         if (error) {
>>                 fprintf(stderr, _("%s: 1: cannot reserve space: %s  
>> (%d)\n"),
>>                         progname, strerror(error),  
>> XFS_CREATE_LOG_RES(mp));
>>                 exit(1);
>>         }
>>
>>
>> I think there are some wrong arguments to that trans_reserve... at least
>> XFS_CREATE_LOG_RES should be 3rd arg, no?
>>
>> -Eric
>
>
>
>
