Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 20:53:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3M3rGCN030006
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 20:53:19 -0700
Date: Tue, 22 Apr 2008 13:54:28 +1000
Subject: Re: [PATCH 2/4] XFS: Return case-insensitive match for dentry cache
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080421083103.433280025@chook.melbourne.sgi.com> <20080421083644.809426871@chook.melbourne.sgi.com> <20080421085947.GA10399@infradead.org> <20080421094641.GA5191@infradead.org>
Message-ID: <op.t9zug2dn3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080421094641.GA5191@infradead.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Mon, 21 Apr 2008 19:46:41 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

>> > +kmem_zone_t	*xfs_name_zone;
>>
>> What about just using kmalloc here?  We know the length of the name
>> anyway, so there is no point of allocating the maximum possible size.
>>
>> >  	error = xfs_iget(dp->i_mount, NULL, inum, 0, 0, ipp, 0);
>> > -	if (error)
>> > +	if (error) {
>> > +		if (ci_match && *ci_match)
>> > +			xfs_name_free(name->name);
>> >  		goto out;
>> > +	}
>>
>> All the allocation and freeing for ci_match looks odd and error prone
>> to me.  I think the low-level directory code should never allocate
>> args->value unless it's explicitly asked for a CI match.  That way
>> there's only one place in xfs_ci_lookup to free it either.
>
> Also the low-level name duplication code could be factored out a little
> more ala:
>
> /*
>  * If a case-insensitive match, allocate a buffer and copy the actual
>  * name into the buffer. Return it via args->value.
>  */
> void xfs_copy_ci_name(struct xfs_da_args *args, const char *name, int  
> namelen)
> {
> 	if (args->return_ci_name && args->cmpresult == XFS_CMP_CASE) {
> 		args->valuelen = namelen;
> 		args->value = kmemdup(name, namelen, GFP_NOFS);
> 		/* error handled in higher layers */
> 	}
> }
>
> Instead of adding args->return_ci_name it might make sense to just
> replace the last four chars there with an unsigned short lookup_flags
> and just set bits in it.

There's already a "flags" field in xfs_da_args and only the low 16 bits
are currently used for attr operations.

We could use 5 of the high bits for these flags, or just add another
flags field (which are used for things other than lookup).
