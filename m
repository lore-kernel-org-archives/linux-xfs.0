Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25DD30675F
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 20:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791232995; cv=none; b=ajHlVUBO9SdqsT2DDstVkahhhID1A66gYIZz50UTWDLKQfBU4brI2F8mWHe1/OwX5QMfY6kM0Teu9LXfmmHBqhk5czVoo7vDyXTNbqGIY6SbEMxqZX9cIzi/2M2i7BZa5vdSFz71CEAr1imuTXy6HEZ66Xe5ii5Zx+jLQYIgFyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791232995; c=relaxed/simple;
	bh=67x8l3sW0OijzjkxlRscMby7wKK2YEnUlqKvOefpjHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ncIKtkA8WUth07jEde34/tfB3LjOHjq3qHr7q+pij+G3c0HI/pqChN5cdOMZ3sa7cRv7hSNSSLPJuSazbbT0Eo5u/flEgcJv0qfKRjg/wmeuLJ/59KwDA1u202OjoSM7fJ5ipbBxLZI1IFciVRR+OAHuSPIBYJe7+YVDTYr0ShY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NIQZ1Krd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qEAyxl5G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NIQZ1Krd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qEAyxl5G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791232992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2UY8dxRhSNOYqR68C79lQZZrx8YVQ1i5ZKLUpW1zkZA=;
	b=NIQZ1Krdwi7tTW5y/iTfRXHupbc7mq3V8DHyxsrFWMeVqxjefNjxL5FJF60fyhGrZi7eHy
	PcJQzPQYl32KGo0qvTtIQJsmhr5Q7qHtbcrXrlkjtp4WirSUn2k85eehQAWtvUeG3xWGRv
	7wyvnNgR/xKPs+eF0h0WDRNnKyx/nzQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280--RbZ_wRbMsCn5gkiOIljjA-1; Mon, 05 Oct 2026 16:43:10 -0400
X-MC-Unique: -RbZ_wRbMsCn5gkiOIljjA-1
X-Mimecast-MFC-AGG-ID: -RbZ_wRbMsCn5gkiOIljjA_1791232990
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91785bd637bso50752976d6.1
        for <linux-xfs@vger.kernel.org>; Mon, 05 Oct 2026 13:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791232990; x=1791837790; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2UY8dxRhSNOYqR68C79lQZZrx8YVQ1i5ZKLUpW1zkZA=;
        b=qEAyxl5Ge9OlfZQv/T+NNTM9PS6GvWKH1JosqwNor01OimXNqjmG0DqjQTfSo0KE53
         sxpaWBA+us/iVpVsW7Qank3sughphp9lYqU0ia07TRpTYTeovFWYv0Dtciwqxp4dkWYp
         4v81onfq0L3QFCSOaoZ8VGxkl+/Dd0lszqZo6BBqyge0T8wLY+3zZF4UcF0KQbgwNfXP
         gwa3cyChnjwmT3P390wYRIw58W1kptVAh76dPnZwX/8GS2lYmc4NVG56vgf7ZcHCEEFp
         k3TNki4xvnaAv0CM14Di+OJ8TXODqgPETVN0HuE14c8YyVvPGKERIE6sGLk5epfubwch
         JISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791232990; x=1791837790;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2UY8dxRhSNOYqR68C79lQZZrx8YVQ1i5ZKLUpW1zkZA=;
        b=oHL7aS8ZUx5UYjJp885fDsfxSpn9652xjVAVQsNm98kx6J4uP5DI+RdtxpE8Ivd5CN
         562CIQUnPrSn8K81f0m1bpqPPH6j5/EZI3ZsGYSZTOWZnQyi1TjTfAca682WpQ0uTuf8
         poJviVwlvTRnMw3RZsBGVGqt+qfEY8xwD2WDXjN3RbEqmPiN6k5/g8KFaHU2NdlifsLV
         BexPWp6Y8CJVnj09OHYzhMYhBwkaiVhI2I1CArclAMw/OsI3UjJZRrkKaK4VOIZqmX0b
         UJmjZXdY/t2/dkycc3iGGfWqkRjE7YgttxklIIlIJXNxz6C6JTE2jamxILsi6OihNbzr
         tSbQ==
X-Gm-Message-State: AFuF++mgyGPzyrHi3VfH8/wSygkRS0Rq3IW3ijIJx3tE9KKnSsptVYJF
	DRmV1n399ooBSPbf2gPumysnew3hSLX+jned/xBK2zC1Ms1w3EzlKgBHEHuZW5a/RZQrmqnWOEI
	Vu+9bzbF+cVzaA/jTfHgA17s2Jq5QcaSxnJxucq933/aHZp0liVGg22ew/2NjoQqcLgNwld1t
X-Gm-Gg: AYBFou1j2tDgLXQwV+pNKdAtZllZqEZXQFYwTJvWEmuxICA7/ZI7K4IsvgcqPIS/7P7
	X4YnOUup0J41dX2jbhmSW9Nj9r86GI01ZnpaPKMa7QsFz6ssFdJNzdUKWRIWdUugerFcg3qoVaA
	qr5yT4T+l1OVPk9ao4tog3cI3kA+xJen+oEWWv7FNV3VOYgtTEY5HvKt65s9QVT2vTOOHAyOb75
	MZ3UGiWXkhK3J8WL+z1WXZx0lQHlHFNFoucN573szvdvWqbYayMvv8fS0Un1yL8Si2kbvH9QLIT
	S3AMfxbF024mnEHb7bBq5Nd4KHobbK4jXrKJRs4drSz+H5a0awkFDQevC+Xs74b/est/7ZVIH+j
	W90CW4/w+0IsGzqjNVJM+Y40lOSSF8rxzzV+NLsy0BxgjlA==
X-Received: by 2002:a05:620a:27ce:b0:93e:646c:9133 with SMTP id af79cd13be357-93e646c9df1mr909903685a.64.1791232990112;
        Mon, 05 Oct 2026 13:43:10 -0700 (PDT)
X-Received: by 2002:a05:620a:27ce:b0:93e:646c:9133 with SMTP id af79cd13be357-93e646c9df1mr909900985a.64.1791232989624;
        Mon, 05 Oct 2026 13:43:09 -0700 (PDT)
Received: from [10.0.0.209] (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93cca29e2f5sm962263885a.38.2026.10.05.13.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 13:43:09 -0700 (PDT)
Message-ID: <d68afc86-6510-45c4-a225-784e7f629a33@redhat.com>
Date: Mon, 5 Oct 2026 15:43:08 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/3] xfs: factor out xrep_reset_fork_to_extents helper
 for scrub/repair
To: "Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-3-sandeen@redhat.com>
 <5a8c7689-492f-4119-a75f-5d5bb442786d@sandeen.net>
 <20261005202059.GD2705364@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20261005202059.GD2705364@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/5/26 3:20 PM, Darrick J. Wong wrote:
> On Mon, Oct 05, 2026 at 02:11:37PM -0500, Eric Sandeen wrote:
>> The open-coded ~10 line series of steps to reset a fork to empty extents
>> format is repeated 3 times; factor this out into a helper to eliminate
>> cut and paste.

...

>> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
>> index c2a437416227..8385308c852f 100644
>> --- a/fs/xfs/scrub/repair.c
>> +++ b/fs/xfs/scrub/repair.c
>> @@ -882,6 +882,32 @@ xrep_ino_ensure_extent_count(
>>  	return 0;
>>  }
>>  
>> +/* Discard the contents of this fork and initialize as empty extent-format. */
>> +void
>> +xrep_reset_fork_to_extents(
>> +	struct xfs_scrub	*sc,
>> +	int			whichfork)
>> +{
>> +	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
>> +	uint			ilog_flags = XFS_ILOG_CORE;
>> +
>> +	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
>> +
>> +	if (whichfork == XFS_DATA_FORK)
>> +		ilog_flags |= XFS_ILOG_DDATA;
>> +	else
>> +		ilog_flags |= XFS_ILOG_ADATA;
> 
> Nit pick:

I thought about a case switch but it seemed excessive for 2 choices.
My ASSERT does make sure we have one or the other valid value... *shrug*

> 	switch (whichfork) {
> 	case XFS_DATA_FORK:
> 		ilog_flags |= XFS_ILOG_DDATA;
> 		break;
> 	case XFS_ATTR_FORK:
> 		ilog_flags |= XFS_ILOG_ADATA;
> 		break;
> 	default:
> 		ASSERT(0);
> 		return;

I guess this has the advantage of kinda handling an unknown whichfork or
XFS_COW_FORK, though who knows what happens to callers that get a do-nothing
return at that point?
> 	}
> 
> Either way this looks like a good hoist to me, so
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
>> +
>> +	xfs_idestroy_fork(ifp);
>> +	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
>> +	ifp->if_nextents = 0;
>> +	ifp->if_bytes = 0;
>> +	ifp->if_data = NULL;
>> +	ifp->if_height = 0;
>> +
>> +	xfs_trans_log_inode(sc->tp, sc->ip, ilog_flags);
>> +}
>> +
>>  /*
>>   * Initialize all the btree cursors for an AG repair except for the btree that
>>   * we're rebuilding.
>> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
>> index 2bb125c4f9bf..c1ba462e4426 100644
>> --- a/fs/xfs/scrub/repair.h
>> +++ b/fs/xfs/scrub/repair.h
>> @@ -81,6 +81,7 @@ int xrep_setup_xfbtree(struct xfs_scrub *sc, const char *descr);
>>  int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
>>  		xfs_extnum_t nextents);
>>  int xrep_reset_perag_resv(struct xfs_scrub *sc);
>> +void xrep_reset_fork_to_extents(struct xfs_scrub *sc, int whichfork);
>>  int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
>>  int xrep_metadata_inode_forks(struct xfs_scrub *sc);
>>  int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
>> diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
>> index 181961364233..9f6901905bfd 100644
>> --- a/fs/xfs/scrub/symlink_repair.c
>> +++ b/fs/xfs/scrub/symlink_repair.c
>> @@ -303,20 +303,8 @@ xrep_symlink_swap_prep(
>>  	 * to an empty extent list in preparation for the atomic mapping
>>  	 * exchange.
>>  	 */
>> -	if (ip_local) {
>> -		struct xfs_ifork	*ifp;
>> -
>> -		ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
>> -		xfs_idestroy_fork(ifp);
>> -		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
>> -		ifp->if_nextents = 0;
>> -		ifp->if_bytes = 0;
>> -		ifp->if_data = NULL;
>> -		ifp->if_height = 0;
>> -
>> -		xfs_trans_log_inode(sc->tp, sc->ip,
>> -				XFS_ILOG_CORE | XFS_ILOG_DDATA);
>> -	}
>> +	if (ip_local)
>> +		xrep_reset_fork_to_extents(sc, XFS_DATA_FORK);
>>  
>>  	return 0;
>>  }
>> -- 
>> 2.55.0
>>
>>
> 

