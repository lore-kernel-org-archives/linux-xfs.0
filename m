Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 21:01:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3940moI009676
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 21:00:50 -0700
Subject: Re: [REVIEW #2] cleanup - remove bhv_vname_t
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t897ipuu3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080408085153.GA19699@infradead.org>
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Apr 2008 14:01:45 +1000
Message-ID: <op.t9br47yz3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080408085153.GA19699@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, 08 Apr 2008 18:51:53 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

>> --- kern_ci.orig/fs/xfs/xfs_dir2.h
>> +++ kern_ci/fs/xfs/xfs_dir2.h
>> @@ -60,6 +60,16 @@ typedef	__uint32_t	xfs_dir2_db_t;
>>  typedef	xfs_off_t	xfs_dir2_off_t;
>>
>>  /*
>> + * Counted string for file names.
>> + */
>> +struct xfs_name {
>> +	const char	*name;
>> +	int		len;
>> +};
>> +
>> +extern struct xfs_name	xfs_name_dotdot;
>
> I think these should be in a different header as they are used a lot
> outside the low-level directory code.

xfs_types.h ?
