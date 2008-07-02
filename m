Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 16:39:58 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m62NdS4a013490
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 16:39:28 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH] Introduce xfs_trans_bmap_add_attrfork.
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
	<1214196150-5427-2-git-send-email-xaiki@sgi.com>
	<1214196150-5427-3-git-send-email-xaiki@sgi.com>
	<1214196150-5427-4-git-send-email-xaiki@sgi.com>
	<20080626092856.GA27069@infradead.org> <nccy74r1oba.fsf@sgi.com>
	<486B3B76.8020303@sgi.com>
Date: Thu, 03 Jul 2008 09:39:52 +1000
In-Reply-To: <486B3B76.8020303@sgi.com> (Timothy Shimmin's message of "Wed, 02
	Jul 2008 18:25:26 +1000")
Message-ID: <nccwsk34zzr.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Timothy Shimmin <tes@sgi.com> writes:
[...]
>> +	if (error)
>> +		goto error1;
>> +
>> +	if (XFS_IFORK_Q(ip))
>> +		goto error1;
>> +
>> +	ASSERT(ip->i_d.di_anextents == 0);
>> +	VN_HOLD(XFS_ITOV(ip));
>> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>> +
>> +	error = xfs_trans_bmap_add_attrfork(NULL, ip, size, rsvd);
>> +	if (error)
>> +		return error;
>> +	return xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);
>
> I was kind of expecting the transaction, &tp, to be passed into
> xfs_trans_bmap_add_attrfork().
> (And then xfs_trans_bmap_add_attrfork() which calls
> xfs_bmap_finish() which calls xfs_trans_dup() and so from that
> point on we would then have to update tp if we were to use it.)
>
> So how come we pass in NULL?
> I'm tired so I'm probably missing something obvious.

No you're right, it took me a while to remember you're working out of
git. I haven't really re-read it properly yet but thanks for this one.

Cheers,
-- 
Niv Sardi
