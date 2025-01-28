Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD072199FAB
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 13:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738072281; cv=none; b=p3+P6M9PDnmpK8kQZ09AZZfgpZZQhtqX4TrnoRK/qZfeN/7h06Ibgo3ynGG4WMD6nauUg+q/pKbgLuSDm81md5cwjEhtTTkURHr/+SZqBIk90RIqiqZd+EA3SnJwgetPHCD71vF/lnJFYgFE524e1RkAB8Ss8MFTQ7RIPjJx4T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738072281; c=relaxed/simple;
	bh=vw828RggbuYhwBbU6+9jsIiVYeyisFWDpJcDtu/jafA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RPKA2sWxFY848hgiU/4eWdjTCjx34tp9FFOxAlfvVDFtc4orp6w1zVqKfD39lSSSu295Xzp9VzZWFk6ScS+WsYd6ddza1B60wIsR3VfRV08YGl5IfjHUKIIk3Vp/YUFOmM2Sf6wvvZ390k4BoeT1NmIg2kmP4HdSgN85AquQbXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RxZqxBVM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RxZqxBVM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738072278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZF4Y/avTtyZDef7prmha6ZoVMCHtxOCxkR/7Ls/Ows=;
	b=RxZqxBVMB0WFr9gA5NP1t5BbZSP6Xq2jrd1HIrj0wwRoiqwKa3H0k/EOTofmvqrVVIjATk
	OTdtJmM1SijFKya0eXFsfK6dQs2piC+oky3IY9OP9YhjXnPxTErCvDFe2ZZ4la1tPfb3me
	9MmZB5yOf4dtf9IF9X2t+tw1bPPgq3o=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-552KfdE-MoKbHIA7VsIpJQ-1; Tue,
 28 Jan 2025 08:51:17 -0500
X-MC-Unique: 552KfdE-MoKbHIA7VsIpJQ-1
X-Mimecast-MFC-AGG-ID: 552KfdE-MoKbHIA7VsIpJQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 210921801F1E;
	Tue, 28 Jan 2025 13:51:16 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.118])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C024195608E;
	Tue, 28 Jan 2025 13:51:15 +0000 (UTC)
Date: Tue, 28 Jan 2025 08:53:27 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/7] iomap: factor out iomap length helper
Message-ID: <Z5jhV7kuuCvNr9lN@bfoster>
References: <20250122133434.535192-1-bfoster@redhat.com>
 <20250122133434.535192-3-bfoster@redhat.com>
 <Z5hqd31L6Ww6TT_a@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5hqd31L6Ww6TT_a@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Jan 27, 2025 at 09:26:15PM -0800, Christoph Hellwig wrote:
> > +static inline u64 iomap_length_trim(const struct iomap_iter *iter, loff_t pos,
> > +		u64 len)
> > +{
> > +	u64 end = iter->iomap.offset + iter->iomap.length;
> > +
> > +	if (iter->srcmap.type != IOMAP_HOLE)
> > +		end = min(end, iter->srcmap.offset + iter->srcmap.length);
> > +	return min(len, end - pos);
> 
> Does this helper warrant a kerneldoc comment similar to iomap_length?
> 

Can't hurt I suppose. I'll add one.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks.

Brian

