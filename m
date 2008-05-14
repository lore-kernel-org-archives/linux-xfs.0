Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 23:10:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4E6ActN015222
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 23:10:41 -0700
Date: Wed, 14 May 2008 16:15:01 +1000
Subject: Re: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.911303131@chook.melbourne.sgi.com> <20080513085724.GC21919@infradead.org>
Message-ID: <op.ua4rnbqb3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080513085724.GC21919@infradead.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Tue, 13 May 2008 18:57:24 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Tue, May 13, 2008 at 05:57:52PM +1000, Barry Naujok wrote:
>
>> +	if (ci_sfep)
>> +		return XFS_ERROR(xfs_dir_cilookup_result(args,
>> +					ci_sfep->name, ci_sfep->namelen));
>
> Putting a function call inside XFS_ERROR is quite unreadable.  Should be
> easy to fix as there's already an error variable in scope.

Done (even though there was no "error" variable in this function).

>> @@ -1646,15 +1653,18 @@ xfs_lookup(
>>  		return XFS_ERROR(EIO);
>>
>>  	lock_mode = xfs_ilock_map_shared(dp);
>> -	error = xfs_dir_lookup(NULL, dp, name, &inum);
>> +	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_match);
>>  	xfs_iunlock_map_shared(dp, lock_mode);
>>
>>  	if (error)
>>  		goto out;
>>
>>  	error = xfs_iget(dp->i_mount, NULL, inum, 0, 0, ipp, 0);
>> -	if (error)
>> +	if (error) {
>> +		if (ci_match && *ci_match)
>> +			kmem_free(name->name, name->len);
>>  		goto out;
>
> normal style would be to add a out_free_name label for this one to move
> the error handling code into one place at the end of the function.

Done.

I've also changed "int *ci_match" to "struct xfs_name *ci_name" to make
it's use clearer and not overload the use of the "name" parameter.

Barry.
