Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629254C62B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 17:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710352091; cv=none; b=q4DHc0zD0jcVjjq3fP9tNKT4jZMY56R0+mP/7Djl9yBruPgkcOGN2rIbKrKf3yA3PoT6hXCuMLKC3CQa8tskmWC7Bo7c8mAsq4mdF29Hm9X8d0GkZrc4LGBfLUdTlQ2lQRAtpha8sLtmxJP66U7AKO7yVo4XDP6oZ2dOI5G5V9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710352091; c=relaxed/simple;
	bh=X+Ow7V/cFiSxP8gqDozyn/TUi6aExr/yci2NmtkjUxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ix9ZEctzoz/b4s5QLlGviHZ1ltoFWXX5zA/SVEJyXghRU3JvHextAeSDzUPYJHvQbgqqa02dZNK4XmJMKuzIGzM/IROYnICbwHxNy6GNwc+qQgX0FwrNwWakTfSJvfkAzRpHFsD8syokGHIj9K1z3ANChZcS3BGnuIUEmLJJj5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K7dvlWWb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K7dvlWWb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710352088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V9HWd48QSA0OQFoMBGmQjh2t7zpw9CpqaFilEhyW/pY=;
	b=K7dvlWWby1kdbTGi5e5tt4oeRafFSz7wL/k2xYKSMA2eHbje9/kIwO2JFRzCtaLUFDCTS2
	xWkh7tQkLM1hitg/Sa1sZb1PQDq2otZndgGwWkYNeIxpDzDoV5hBwp5ExWoUPoFkVe6T8d
	tekNwK8gmQKI6KVRlihzMSLPHAg9aSs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-h_j5_QCANx6dfVfTzlWcBg-1; Wed, 13 Mar 2024 13:48:04 -0400
X-MC-Unique: h_j5_QCANx6dfVfTzlWcBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8722800267;
	Wed, 13 Mar 2024 17:48:03 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.77])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2932EC15771;
	Wed, 13 Mar 2024 17:48:03 +0000 (UTC)
Date: Wed, 13 Mar 2024 12:48:01 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: adjust btree bulkloading slack
 computations to match online repair
Message-ID: <ZfHm0V0oTnXxDyk4@redhat.com>
References: <171029432500.2063452.8809888062166577820.stgit@frogsfrogsfrogs>
 <171029432516.2063452.11265636611489161443.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029432516.2063452.11265636611489161443.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Tue, Mar 12, 2024 at 07:10:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Adjust the lowspace threshold in the new btree block slack computation
> code to match online repair, which uses a straight 10% instead of magic
> shifting to approximate that without division.  Repairs aren't that
> frequent in the kernel; and userspace can always do u64 division.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  repair/bulkload.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/repair/bulkload.c b/repair/bulkload.c
> index 8dd0a0c3908b..0117f69416cf 100644
> --- a/repair/bulkload.c
> +++ b/repair/bulkload.c
> @@ -106,9 +106,10 @@ bulkload_claim_block(
>   * exceptions to this rule:
>   *
>   * (1) If someone turned one of the debug knobs.
> - * (2) The AG has less than ~9% space free.
> + * (2) The AG has less than ~10% space free.
>   *
> - * Note that we actually use 3/32 for the comparison to avoid division.
> + * In the latter case, format the new btree blocks almost completely full to
> + * minimize space usage.
>   */
>  void
>  bulkload_estimate_ag_slack(
> @@ -124,8 +125,8 @@ bulkload_estimate_ag_slack(
>  	bload->leaf_slack = bload_leaf_slack;
>  	bload->node_slack = bload_node_slack;
>  
> -	/* No further changes if there's more than 3/32ths space left. */
> -	if (free >= ((sc->mp->m_sb.sb_agblocks * 3) >> 5))
> +	/* No further changes if there's more than 10% space left. */
> +	if (free >= sc->mp->m_sb.sb_agblocks / 10)
>  		return;
>  
>  	/*
> 
> 

