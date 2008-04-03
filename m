Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 18:39:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m331dNOs006463
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 18:39:28 -0700
Date: Thu, 03 Apr 2008 11:45:33 +1000
Subject: Re: [PATCH 1/7] XFS: Name operation vector for hash and compare
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062707.797672682@chook.melbourne.sgi.com> <20080403012912.GO103491721@sgi.com>
Message-ID: <op.t80ht7n33jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080403012912.GO103491721@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, 03 Apr 2008 11:29:12 +1000, David Chinner <dgc@sgi.com> wrote:

> On Wed, Apr 02, 2008 at 04:25:09PM +1000, Barry Naujok wrote:
>> Adds two pieces of functionality for the basis of case-insensitive
>> support in XFS:
>>
>> 1.  A comparison result enumerated type: xfs_dacmp_t. It represents an
>>     exact match, case-insensitive match or no match at all. This patch
>>     only implements different and exact results.
>>
>> 2.  xfs_nameops vector for specifying how to perform the hash generation
>>     of filenames and comparision methods. In this patch the hash vector
>>     points to the existing xfs_da_hashname function and the comparison
>>     method does a length compare, and if the same, does a memcmp and
>>     return the xfs_dacmp_t result.
>>
>> All filename functions that use the hash (create, lookup remove, rename,
>> etc) now use the xfs_nameops.hashname function and all directory lookup
>> functions also use the xfs_nameops.compname function.
>
> Ok, so internally I see this is not the case. I'll comment on that
> inline.

Ah yes. Remove and rename rely on an exact match. Forgot about that
when documenting this patch.

>> The lookup functions also handle case-insensitive results even though
>> the default comparison function cannot return that. And important
>> aspect of the lookup functions is that an exact match always has
>> precedence over a case-insensitive. So while a case-insensitive match
>> is found, we have to keep looking just in case there is an exact
>> match. In the meantime, the info for the first case-insensitive match
>> is retained if no exact match is found.
>>
>> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> ......
>>  }
>>
>> +xfs_dacmp_t
>> +xfs_da_compname(const uchar_t *name1, int len1, const uchar_t *name2,  
>> int len2)
>> +{
>> +	return (len1 == len2 && memcmp(name1, name2, len1) == 0) ?
>> +			XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
>> +}
>> +
>> +struct xfs_nameops xfs_default_nameops = {
>
> const.
>
>>  #ifdef __KERNEL__
>>  /*========================================================================
>> @@ -248,7 +271,12 @@ xfs_daddr_t	xfs_da_reada_buf(struct xfs_
>>  int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
>>  					  xfs_dabuf_t *dead_buf);
>>
>> +extern struct xfs_nameops xfs_default_nameops;
>
> Does this need global visibility? It's only needed in xfs_dir_mount(),
> right?

Good point, I'll fix this.

>> Index: kern_ci/fs/xfs/xfs_dir2.h
>> ===================================================================
>> --- kern_ci.orig/fs/xfs/xfs_dir2.h
>> +++ kern_ci/fs/xfs/xfs_dir2.h
>> @@ -85,6 +85,12 @@ extern int xfs_dir_canenter(struct xfs_t
>>  				char *name, int namelen);
>>  extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
>>
>> +#define xfs_dir_hashname(dp, n, l) \
>> +		((dp)->i_mount->m_dirnameops->hashname((n), (l)))
>> +
>> +#define xfs_dir_compname(dp, n1, l1, n2, l2) \
>> +		((dp)->i_mount->m_dirnameops->compname((n1), (l1), (n2), (l2)))
>> +
>
> Static inline functions, please.

Ok.

>>  /*
>>   * Utility routines for v2 directories.
>>   */
>> Index: kern_ci/fs/xfs/xfs_dir2_block.c
>> ===================================================================
>> --- kern_ci.orig/fs/xfs/xfs_dir2_block.c
>> +++ kern_ci/fs/xfs/xfs_dir2_block.c
>> @@ -643,6 +643,7 @@ xfs_dir2_block_lookup_int(
>>  	int			mid;		/* binary search current idx */
>>  	xfs_mount_t		*mp;		/* filesystem mount point */
>>  	xfs_trans_t		*tp;		/* transaction pointer */
>> +	xfs_dacmp_t		cmp;		/* comparison result */
>>
>>  	dp = args->dp;
>>  	tp = args->trans;
>> @@ -698,19 +699,33 @@ xfs_dir2_block_lookup_int(
>>  			((char *)block + xfs_dir2_dataptr_to_off(mp, addr));
>>  		/*
>>  		 * Compare, if it's right give back buffer & entry number.
>> +		 *
>> +		 * lookup case - use nameops;
>> +		 *
>> +		 * replace/remove case - as lookup has been already been
>> +		 * performed, look for an exact match using the fast method
>>  		 */
>> -		if (dep->namelen == args->namelen &&
>> -		    dep->name[0] == args->name[0] &&
>> -		    memcmp(dep->name, args->name, args->namelen) == 0) {
>> +		cmp = args->oknoent ?
>> +			xfs_dir_compname(dp, dep->name, dep->namelen,
>> +						args->name, args->namelen) :
>> +			xfs_da_compname(dep->name, dep->namelen,
>> +						args->name, args->namelen);
>
> Why add this "fast path"? All you're saving here is a few
> instructions but making the code much harder to follow.
>
> 		cmp = xfs_dir_compname(dp, dep->name, dep->namelen,
> 						args->name, args->namelen);
>
> Will do exactly the same thing and I'd much prefer readable code
> over prematurely optimised code any day of the week....

Ok, I'll change that code (might make it more CONFIG_XFS_CI capable ;) )

>> +		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
>> +			args->cmpresult = cmp;
>>  			*bpp = bp;
>>  			*entno = mid;
>> -			return 0;
>> +			if (cmp == XFS_CMP_EXACT)
>> +				return 0;
>>  		}
>> -	} while (++mid < be32_to_cpu(btp->count) &&  
>> be32_to_cpu(blp[mid].hashval) == hash);
>> +	} while (++mid < be32_to_cpu(btp->count) &&
>> +			be32_to_cpu(blp[mid].hashval) == hash);
>> +
>> +	ASSERT(args->oknoent);
>> +	if (args->cmpresult == XFS_CMP_CASE)
>> +		return 0;
>
> So if we find multiple case matches, we'll take the last we find?

No, the first as *bpp and *entno is only set for the first
case-insensitive match or overriden for an exact match.

>>  	/*
>>  	 * No match, release the buffer and return ENOENT.
>>  	 */
>> -	ASSERT(args->oknoent);
>>  	xfs_da_brelse(tp, bp);
>>  	return XFS_ERROR(ENOENT);
>
> Should we really be promoting that assert to before we return a  
> successful
> case match?

Yes as a !args->oknoent has to find an exact match. It's a big
failure otherwise (ie. remove/rename case).

>> @@ -907,9 +914,8 @@ xfs_dir2_sf_removename(
>>  	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
>>  	     i < sfp->hdr.count;
>>  	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
>> -		if (sfep->namelen == args->namelen &&
>> -		    sfep->name[0] == args->name[0] &&
>> -		    memcmp(sfep->name, args->name, args->namelen) == 0) {
>> +		if (xfs_da_compname(sfep->name, sfep->namelen,
>> +				args->name, args->namelen) == XFS_CMP_EXACT) {
>>  			ASSERT(xfs_dir2_sf_get_inumber(sfp,
>>  					xfs_dir2_sf_inumberp(sfep)) ==
>>  				args->inumber);
>
> This only checks for an exact match - what is supposed to happen
> with a XFS_CMP_CASE return?
>
>> @@ -1044,9 +1050,9 @@ xfs_dir2_sf_replace(
>>  		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
>>  		     i < sfp->hdr.count;
>>  		     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
>> -			if (sfep->namelen == args->namelen &&
>> -			    sfep->name[0] == args->name[0] &&
>> -			    memcmp(args->name, sfep->name, args->namelen) == 0) {
>> +			if (xfs_da_compname(sfep->name, sfep->namelen,
>> +					    args->name, args->namelen) ==
>> +					XFS_CMP_EXACT) {
>
> ditto.

Like I stated above, remove/rename (replace) require an exact match.
