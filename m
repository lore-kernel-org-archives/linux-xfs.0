Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793226937;
	b=Foa7EVnyqrsgkKgbWNF1VCLOhO6q7/f67ZdnzILZzJuOr8Z5i/66WPz/uk3M9JwoFA2F
	 5g/RQbq+yL+TCxTKLJ9ZRRoOzJunbUeAh9uchopLUDr/nddg7g05ZvdRA0SOaSLHj9Sul
	 0cZQ7PFhTXXKinQdkr3gemiceDldEvlT1O0G+nr1bw3OXA7D2mkgAukP62yv7tsUdatCy
	 VgADAzMOcEwK6TdfhshaYZVldpgPLkw8TQpyOuaCVGz5MGGueoiKcHFKvcH027EKxYpxp
	 wGJU629zLs/01IfWsL/okhE3YinhjlO0Bmyw8ny3Df/mRm3HJTyy1Rp4RulKCSwHXng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793226937;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=dlNoJu8vO1/V+ZdxkmmmDTDWplEGcT3ZIrju8mrf3Cg=;
	b=gX9SX6dmH5IQ+1QNIbezAUCavIL7IW3M9XbpzyBZTc7k084LdovPavwb6cSF4XZzBf1u
	 n9dwqEFYi6N3TC0rRDMaffVA9ghOvWJMJvspKC0c7nnQlwoMA8TP0hZU7Lj+SxIZNVIW3
	 bZe9HJJMYX1rrbfRzCDGJ52CE+Cfhe46fE2pbrcwtKkG60/2BEHwWGbfDtan6KTasJpli
	 DhIRMzoAEPZTON04XefsiD0c0Q9v0yhlORR148qVCsOAHRSNSA6kzFgbq48JkXFN7T0QX
	 Yqf4xj3Ub+y9u0tdT8p/BiAliuBqotZ+/PjYcW7MvAe8zqm/bH07kgPw4YE07tjVH1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=a0L4l4fz;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=KNuwjbMJ;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2003A606A31C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 22:35:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2003A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=a0L4l4fz;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=KNuwjbMJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793226935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dlNoJu8vO1/V+ZdxkmmmDTDWplEGcT3ZIrju8mrf3Cg=;
	b=a0L4l4fz7rRKZlbQUma431LneQ8r3hOJyP7f1ahCm+B281SRIuLL8VysM3Fr0yoh/ggadw
	iNNXJzXiAXKzn6GqnmXVIb9B7+FcwJNcB4Oy9u2oOJ+UG6Y1g5kQnl/XAr1I6+ZULMg/SU
	fhuoD8ScJtLHIMEi+VC39z6LKEuJRQU=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-eHZnxWG_Ppy0yf4HUG0k6w-1; Wed, 28 Oct 2026 18:35:33 -0400
X-MC-Unique: eHZnxWG_Ppy0yf4HUG0k6w-1
X-Mimecast-MFC-AGG-ID: eHZnxWG_Ppy0yf4HUG0k6w_1793226933
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-85c1135c289so436036a34.3
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793226933; x=1793831733; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dlNoJu8vO1/V+ZdxkmmmDTDWplEGcT3ZIrju8mrf3Cg=;
        b=KNuwjbMJBClr8OfQWsIEN7bPtnhqZ+lHrFI1cmFlp5xWvPhHHHYuc/BnTL0vOlDmUV
         XOP2kn6xFfQjCfHVmzN4J59P269nynrmfDfNC+WLqFuPpg3jW5e+VX0dsfJ52OrIHn3l
         yAEmDEFO9Mxy2Q9XbUMU554kaCNkbvVkYiM2+WehsMoutieq3THWwQzBecCV/aSLIz5x
         0ZH/jzPm/vaIzVtepISr183t3D4n+Dxk2srh4AzkXY0MRMNIebIv9FL16fTe3U1gVOWE
         NOTx2jxOaT6KngLCkQnF3t84BZqK5GOX3k+DsMAmy52A0hSPBatevfPOTokRUwtpsVz9
         L3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793226933; x=1793831733;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dlNoJu8vO1/V+ZdxkmmmDTDWplEGcT3ZIrju8mrf3Cg=;
        b=g5ajZ6wqBRxzOSwfqLBGpurAg2ylIK+yYPbJ/SFheY/zH3gVaqUoRUn/jydNHW4zIk
         m+sRTifuyBBvhItccpA0YaLX9n46aFgKvI+CpvDLyZERokNQBSdG7ahl4ozoMDbKDO9f
         NCRouXWtct2PqnQBSRIsPBejYmm06tDwXtfofKNkP0HPo3ruiydxE2z6UlknvttMdfg4
         x4GXYFmK9Nw1cNxiCXSSxWzJI1d5EdiXRtw5REynZZD0AjF9PQJS2LQZHHrUaMdA3fmV
         UcE3PKNbFGK1MFxdoYdtjq75vPOyIsomEeKdDC9DjFY9GYdnU2nE1t5Yku0xoID5uJcO
         B+6A==
X-Gm-Message-State: AFq9FYJQ8zRiKRg4/KPdr1ro158GU5WvkaEpFr5ONLPkXo3aV5N5Icct
	PYJLISRBG919QXiGGDzNnk00dmWnSttCaMse9spkHBl6WGxHXqoZHF0NLm2RlTBDod5EMrknevw
	7QaoQMlJ5iYzRiyePodL/ZpaJ4WQG2BUAkfuGqugd6vwtwB64q+mTLZ7HHvPKuA==
X-Gm-Gg: AYBFou2Pk1Uf/VLjP/HB5LovGkn7aOQTGJgv+wp8N5h54hwrz5IG/Oo8OyGXqIREii5
	1x0/uQx2JGG+Gv2NnyQbko3xfY8u3Cx3tMAubTRnAGkESF/H1OEuYum1GQIscO6Exl7H8uzDkSA
	HSxaf3RuAIwoVFXtKfu4iVRunv1etpLKTAGdirvxLeo3DvlxH/BucFsyegnFZRF3Kx1KLQ2Qcz7
	OEbZPq8WNU3m5gso64PS8YroZTl+CDHljB/KFPMlp3D4SWOjMD//P0TVVDtho5FldWMJxXlnIHo
	clVaiJ/enOSOYqsqtOmR14OoVXsOgZmkueTwvEc1+wavpbn5V8DyH4Wp+5V7VAPh09AqkSG3xoT
	9IcP+AbAuvSnngnWoIqywS9YNprz0ObudCroh9OOVyqJShKWbA9YW7k09CmTHWCmqIbI+wNKFuq
	ISy/LPGw045uJU7LyT6gs=
X-Received: by 2002:a05:6808:6808:b0:53a:8c5:d7d7 with SMTP id 5614622812f47-56383e9d3a6mr2925140b6e.58.1793226932966;
        Wed, 28 Oct 2026 15:35:32 -0700 (PDT)
X-Received: by 2002:a05:6808:6808:b0:53a:8c5:d7d7 with SMTP id 5614622812f47-56383e9d3a6mr2925132b6e.58.1793226932562;
        Wed, 28 Oct 2026 15:35:32 -0700 (PDT)
Received: from [10.0.0.209] (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-563c6d4699dsm2250345b6e.17.2026.10.28.15.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 15:35:31 -0700 (PDT)
Message-ID: <ce477fd2-2445-4bae-a3ec-3001ef152808@redhat.com>
Date: Wed, 28 Oct 2026 17:35:29 -0500
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] xfs: remove status parameter from several btree
 insert functions
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de, dgc@kernel.org
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-6-sandeen@redhat.com>
 <auIZx_UH5UYvYzqU@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <auIZx_UH5UYvYzqU@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/28/26 10:50 AM, Christoph Hellwig wrote:
> On Fri, Oct 16, 2026 at 02:29:05PM -0500, Eric Sandeen wrote:
>> xfs_btree_insert and its callers now have no need for the status
>> parameter; either they return error = 0 / status = 1, or nonzero error
>> and status 0. No caller evaluates the status variable, so remove that
>> parameter from these functions.
>>
>> As requested, convert all of the compound tests/assignments to discrete
>> lines.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Although I agree with Darrick that spelling out the parameters would
> be helpful.
> 

thanks, agree but I dunno, seems like a dedicated patch to change /so many/
of them would be good instead of hitting this one just because ...

/*
 * Common btree core entry points.
 */
int xfs_btree_increment(struct xfs_btree_cur *, int, int *);
int xfs_btree_decrement(struct xfs_btree_cur *, int, int *);
int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
int xfs_btree_insert(struct xfs_btree_cur *, int *);
int xfs_btree_delete(struct xfs_btree_cur *, int *);
int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
int xfs_btree_change_owner(struct xfs_btree_cur *cur, uint64_t new_owner,
                           struct list_head *buffer_list);

/*
 * btree block CRC helpers
 */
void xfs_btree_fsblock_calc_crc(struct xfs_buf *);
bool xfs_btree_fsblock_verify_crc(struct xfs_buf *);
void xfs_btree_agblock_calc_crc(struct xfs_buf *);
bool xfs_btree_agblock_verify_crc(struct xfs_buf *);

/*
 * Internal btree helpers also used by xfs_bmap.c.
 */
void xfs_btree_log_block(struct xfs_btree_cur *, struct xfs_buf *, uint32_t);
void xfs_btree_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int, int);

