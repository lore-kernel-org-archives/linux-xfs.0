Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7281F2382
	for <linux-xfs@vger.kernel.org>; Thu,  1 May 2025 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112011; cv=none; b=fHQG7JQnniFyh0grNbuWNHoj0PXswHUXU7NxnvG6FXxxFKNH0HDiEpfvd2cSGYxL7VYX/8XplwNKm9/rUah9QoisVunOFD8tpMQVTgTVFuzNp34ZxqeX9oHfeeFSjl7UB5Ynb9FyLh+AZP+X8UqtMWTxzdzCCXfkYAQ2FWhaq2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112011; c=relaxed/simple;
	bh=XDQEmFdUEVct3cJmSrcErxMtkWsXOu45B22zqc9dE1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SjVpQGEVN0Slybk9XloVxhz9lCzVJOVW64n3xJWTrcLQcKa/YqYdAdO0mKcqPyhBslIkWgmBVZ9zihDPz2RVpWq0/gM/ymgVxJw2trWvW7xNRuwa4A/Ll/KwL28vEDEki8vHfapAziaFhUeTaX9uPDaMVn7BwH8+4adEGtPbU+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KL+y9ECb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KL+y9ECb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746112008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7oCFhBg5wCUn4DcJ7pKowDKEDikjSr5ZPvOKEOzXu9M=;
	b=KL+y9ECbU24Rsm0tvjwJDMNSZ9JiXctBY9LbQWLgST0+/19XsWmzRvuxeZEzx42YvnQ9c5
	k88sHHMLVgSZsbqYY5Q23uYVAmg8gHojgUE7UuC2epN93w3pl8muHpuVgXqSBWhY2Y6Al4
	LAMrfEf5IpNqWb96k4gK4dgLfPZh1LM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-cjSpB5yfMEywpGhQIPw7SA-1; Thu, 01 May 2025 11:06:47 -0400
X-MC-Unique: cjSpB5yfMEywpGhQIPw7SA-1
X-Mimecast-MFC-AGG-ID: cjSpB5yfMEywpGhQIPw7SA_1746112007
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c7c30d8986so380481985a.2
        for <linux-xfs@vger.kernel.org>; Thu, 01 May 2025 08:06:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112006; x=1746716806;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7oCFhBg5wCUn4DcJ7pKowDKEDikjSr5ZPvOKEOzXu9M=;
        b=tUkKyohHlJ3YtHUSHq1E0HnV0zeS3kF8AwnwPMr2il35eLxxGfcLXyY3NtFBgUP0zi
         Qur+ssARoovpzWKg0pZuomzfOFiDYvAdwpBggskiKIlX5tTpNiN/WdbClWQNDiWXcEKa
         xXcgBNmaw+Gatc0X8lEf64zJA4dGl3Y8nG61zw2E/LWjE6bO5YEhFudwlB09E+EvfIK4
         9aqy88Sr+uSzxDVeLD5nT6DjVT1e3dIm5xnTAmLuFk7nt5T8xgjHFXlYUBlcLoDYR7OD
         9dR4qk17fLn46OkcDdh5WKVuXPRhWPzHSneFesfcun0gjJlnpX+Nug/zYUmO4QyYB8kX
         C6rw==
X-Gm-Message-State: AOJu0YyInrRyecGLSxZt4HcYDTis+S3HYZ1GbjxpM96EQ48zHuKkIxew
	z+6VsqMR3pbZ2T/2HjN39RtiSdFwtqzN3jeoB1RrcqxNTUMjKztDJONmi8SdlYl0+oU7y57T8KI
	ZkolEwKSsGy1Fu+W/QbW+ZquLHi+wB3FfxtqK0dgTuhanzQQmLbIXwf/RS1wtcgwj1w==
X-Gm-Gg: ASbGncsRC3okfV6yqmX2VS70Ho+GrO0lczbo9/0EM9DoI/WJOlBsK5D2hRTdQUvlVAA
	vWscsejGqqVcsHGT0koBPBvDW+SQHmSK686RSyOL0qpwUDU6aZMq0xAv2aa5xTMKPC59quTNNp1
	vueXliFZpALi/bLxJkXEP/GGsHSF8Z24i44TaA+ATKnAiGWifk6k3AETr7Y4d5s9DJfMT4Uu/8L
	mO8ClcWRd4ZY+CFGpVy71Uk6hc7cOCXRAmIJEk3e9EgN1IbmMgpW6R3D8ANVUy23eeZLStxsLmv
	MivK2cJ4PirBoyZPBAra+mL3xKD6vYLYyxHE2U8U7fWb
X-Received: by 2002:a05:620a:d81:b0:7c5:dfd6:dc7b with SMTP id af79cd13be357-7cacd750321mr462984785a.22.1746112006065;
        Thu, 01 May 2025 08:06:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXHWVsZx8eKZyQcp0yUJBiXFWzOcthbLNEjBlki/2RhPMQAbsLPK0+gCs/qdmrFEcAMXVOIw==
X-Received: by 2002:a05:620a:d81:b0:7c5:dfd6:dc7b with SMTP id af79cd13be357-7cacd750321mr462981785a.22.1746112005748;
        Thu, 01 May 2025 08:06:45 -0700 (PDT)
Received: from redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cad243f32esm52196585a.92.2025.05.01.08.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 08:06:45 -0700 (PDT)
Date: Thu, 1 May 2025 10:06:43 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't assume perags are initialised when trimming
 AGs
Message-ID: <aBOOA4LMddhl27pw@redhat.com>
References: <20250430232724.475092-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430232724.475092-1-david@fromorbit.com>

On Thu, May 01, 2025 at 09:27:24AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When running fstrim immediately after mounting a V4 filesystem,
> the fstrim fails to trim all the free space in the filesystem. It
> only trims the first extent in the by-size free space tree in each
> AG and then returns. If a second fstrim is then run, it runs
> correctly and the entire free space in the filesystem is iterated
> and discarded correctly.
> 
> The problem lies in the setup of the trim cursor - it assumes that
> pag->pagf_longest is valid without either reading the AGF first or
> checking if xfs_perag_initialised_agf(pag) is true or not.
> 
> As a result, when a filesystem is mounted without reading the AGF
> (e.g. a clean mount on a v4 filesystem) and the first operation is a
> fstrim call, pag->pagf_longest is zero and so the free extent search
> starts at the wrong end of the by-size btree and exits after
> discarding the first record in the tree.
> 
> Fix this by deferring the initialisation of tcur->count to after
> we have locked the AGF and guaranteed that the perag is properly
> initialised. We trigger this on tcur->count == 0 after locking the
> AGF, as this will only occur on the first call to
> xfs_trim_gather_extents() for each AG. If we need to iterate,
> tcur->count will be set to the length of the record we need to
> restart at, so we can use this to ensure we only sample a valid
> pag->pagf_longest value for the iteration.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
Needs a "fixes" note in the description. Otherwise, lgtm.
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>


>  fs/xfs/xfs_discard.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index c1a306268ae4..94d0873bcd62 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -167,6 +167,14 @@ xfs_discard_extents(
>  	return error;
>  }
>  
> +/*
> + * Care must be taken setting up the trim cursor as the perags may not have been
> + * initialised when the cursor is initialised. e.g. a clean mount which hasn't
> + * read in AGFs and the first operation run on the mounted fs is a trim. This
> + * can result in perag fields that aren't initialised until
> + * xfs_trim_gather_extents() calls xfs_alloc_read_agf() to lock down the AG for
> + * the free space search.
> + */
>  struct xfs_trim_cur {
>  	xfs_agblock_t	start;
>  	xfs_extlen_t	count;
> @@ -204,6 +212,14 @@ xfs_trim_gather_extents(
>  	if (error)
>  		goto out_trans_cancel;
>  
> +	/*
> +	 * First time through tcur->count will not have been initialised as
> +	 * pag->pagf_longest is not guaranteed to be valid before we read
> +	 * the AGF buffer above.
> +	 */
> +	if (!tcur->count)
> +		tcur->count = pag->pagf_longest;
> +
>  	if (tcur->by_bno) {
>  		/* sub-AG discard request always starts at tcur->start */
>  		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
> @@ -350,7 +366,6 @@ xfs_trim_perag_extents(
>  {
>  	struct xfs_trim_cur	tcur = {
>  		.start		= start,
> -		.count		= pag->pagf_longest,
>  		.end		= end,
>  		.minlen		= minlen,
>  	};
> -- 
> 2.45.2
> 
> 

