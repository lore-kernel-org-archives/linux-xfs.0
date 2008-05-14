Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 23:08:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4E68Svk015019
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 23:08:30 -0700
Date: Wed, 14 May 2008 16:12:50 +1000
Subject: Re: [PATCH 2/4] XFS: add op_flags field and helpers to xfs_da_args
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.598022276@chook.melbourne.sgi.com> <20080513083458.GB21919@infradead.org>
Message-ID: <op.ua4rjop53jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080513083458.GB21919@infradead.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Tue, 13 May 2008 18:34:58 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Tue, May 13, 2008 at 05:57:51PM +1000, Barry Naujok wrote:
>> The end of the xfs_da_args structure has 4 unsigned char fields for
>> true/false information on directory and attr operations using the
>> xfs_da_args structure.
>>
>> The following converts these 4 into a op_flags field that uses the
>> first 4 bits for these fields and allows expansion for future
>> operation information (eg. case-insensitive lookup request).
>>
>> There is also a bit of EOL whitespace cleanup too.
>
> Looks generally good to me.  A few stylistic comments:
>
>  - I don't think the xfs_da_is*_op wrappers help readability, we'd
>    be better off without those.

I have taken the wrappers out.

>  - op_flags seems like a rather odd name to me, what about
>    lookup_flags instead?

Because these flags are used for all sorts of dir and attr operations.

> And the hinks below are an awfull lot of random reformatting that don't
> belong into this patch.  As they're sensible what about just commiting
> the beforehand?

Yanked the whitespace cleanups from the follow up patches.

>>  	dsize = dp->i_df.if_bytes;
>> -	
>> +
>>  	switch (dp->i_d.di_format) {
>>  	case XFS_DINODE_FMT_EXTENTS:
>> -		/*
>> -		 * If there is no attr fork and the data fork is extents,
>> -		 * determine if creating the default attr fork will result
>> -		 * in the extents form migrating to btree. If so, the
>> -		 * minimum offset only needs to be the space required for
>> +		/*
>> +		 * If there is no attr fork and the data fork is extents,
>> +		 * determine if creating the default attr fork will result
>> +		 * in the extents form migrating to btree. If so, the
>> +		 * minimum offset only needs to be the space required for
>>  		 * the btree root.
>> -		 */
>> +		 */
>>  		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes > mp->m_attroffset)
>>  			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
>>  		break;
>> -		
>> +
>>  	case XFS_DINODE_FMT_BTREE:
>>  		/*
>>  		 * If have data btree then keep forkoff if we have one,
>> -		 * otherwise we are adding a new attr, so then we set
>> -		 * minforkoff to where the btree root can finish so we have
>> +		 * otherwise we are adding a new attr, so then we set
>> +		 * minforkoff to where the btree root can finish so we have
>>  		 * plenty of room for attrs
>>  		 */
>>  		if (dp->i_d.di_forkoff) {
>> -			if (offset < dp->i_d.di_forkoff)
>> +			if (offset < dp->i_d.di_forkoff)
>>  				return 0;
>> -			else
>> +			else
>>  				return dp->i_d.di_forkoff;
>>  		} else
>>  			dsize = XFS_BMAP_BROOT_SPACE(dp->i_df.if_broot);
>>  		break;
>>  	}
>> -	
>> -	/*
>> -	 * A data fork btree root must have space for at least
>> +
>> +	/*
>> +	 * A data fork btree root must have space for at least
>>  	 * MINDBTPTRS key/ptr pairs if the data fork is small or empty.
>>  	 */
>>  	minforkoff = MAX(dsize, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
>
>
