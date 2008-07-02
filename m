Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 01:25:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m628OZef001976
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 01:24:37 -0700
Message-ID: <486B3B76.8020303@sgi.com>
Date: Wed, 02 Jul 2008 18:25:26 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Introduce xfs_trans_bmap_add_attrfork.
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>	<1214196150-5427-2-git-send-email-xaiki@sgi.com>	<1214196150-5427-3-git-send-email-xaiki@sgi.com>	<1214196150-5427-4-git-send-email-xaiki@sgi.com>	<20080626092856.GA27069@infradead.org> <nccy74r1oba.fsf@sgi.com>
In-Reply-To: <nccy74r1oba.fsf@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Niv Sardi wrote:
> Updated patch attached,
> Moved case where there is no transaction back into
> xfs_bmap_add_attrfork() and rely on caller to call xfs_trans_roll(),
> 
> Christoph Hellwig <hch@infradead.org> writes:
>>> +xfs_bmap_add_attrfork(
> [...]
>> Care to add this below xfs_trans_bmap_add_attrfork?  Also please
>> us struct xfs_inode instead of the typedef.
> 
> Done,
> 
>>> +	if (tpp) {
>>> +		ASSERT(*tpp);
>>> +		tp = *tpp;
>>> +	} else {
> [...]
>> I think it would be much cleaner if all the transaction setup, joining
>> etc was done in xfs_bmap_add_attrfork, and xfs_trans_bmap_add_attrfork
>> just gets an always non-NULL xfs_trans pointer.  That would mean
>> the common code would become just a helper, and
>> xfs_trans_bmap_add_attrfork would be a small wrapper including the 
>> xfs_trans_roll.  Alternatively the caller could always do the roll.
> 
> I think I got it right, but error handeling is a bit weird this way,
> looks logically identical.
> 
> 
> 
> ------------------------------------------------------------------------
> 
> 
> Thanks for this extensive review =)
>
> +	if (error)
> +		goto error1;
> +
> +	if (XFS_IFORK_Q(ip))
> +		goto error1;
> +
> +	ASSERT(ip->i_d.di_anextents == 0);
> +	VN_HOLD(XFS_ITOV(ip));
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	error = xfs_trans_bmap_add_attrfork(NULL, ip, size, rsvd);
> +	if (error)
> +		return error;
> +	return xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);

I was kind of expecting the transaction, &tp, to be passed into
xfs_trans_bmap_add_attrfork().
(And then xfs_trans_bmap_add_attrfork() which calls
xfs_bmap_finish() which calls xfs_trans_dup() and so from that
point on we would then have to update tp if we were to use it.)

So how come we pass in NULL?
I'm tired so I'm probably missing something obvious.

--Tim
