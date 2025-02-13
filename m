Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B474145A03
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 15:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460336; cv=none; b=WaSeCfhuozhNTfpG6dPloXmqodyG8wGGVLXl5NY6xNo2Dlm535aoEoPPmAeERWp1FuMKgFzMouqdhrI5f6/ZDhtRSCkxIG+G5WpLUTXKcWEzEKE3BYuBwcx3wagIEKMuXnUIzo95aHFun0nxhdUVpOGcTCagM4vWK7SEBV2sm1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460336; c=relaxed/simple;
	bh=zk1OSRdKIwz2dt8AtiPc/57OeJQvHna0rCg2CNI7luQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cJ42nzQBwc31Su4Qk0cvz5SyjY3VnMLdq6i0mGX0a7PPKawVl+Qet0Aj+t5A8OrhlYAC79RpbuHTRhHJLyyTCxBc7WehY/Izn3moDkHmX2B48HZ+o9uaJsOdmc6z4A/TKQWCxy7W+JGRWFJRP6srGTFng6I169BWlsQHTbvnM4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i89ztY+n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i89ztY+n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739460334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tPCVkxUdnWQsj8W2o6ba0A8R3JaO4Lg9gQu1gKaeLto=;
	b=i89ztY+nCXcVXfxqZHHKkEkwdXgyYsHGPRH5pnDSuG1RGdq60SWBHkhXPHzSVezKCtnNip
	db8HP3+mLvuZKaU9KjDT+oM0WK4F3aBGB26dFRu1zb4lFRn05ejPcHJZkOdelORi+9+eqP
	/x4WHQa4xMfanXK0lQxMqN9AsiMCEzU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-138-WjBLI-SoMWSQxF7cU2DZmQ-1; Thu,
 13 Feb 2025 10:25:32 -0500
X-MC-Unique: WjBLI-SoMWSQxF7cU2DZmQ-1
X-Mimecast-MFC-AGG-ID: WjBLI-SoMWSQxF7cU2DZmQ_1739460327
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 598F71955F28;
	Thu, 13 Feb 2025 15:25:27 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.88])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C0D819373C4;
	Thu, 13 Feb 2025 15:25:26 +0000 (UTC)
Date: Thu, 13 Feb 2025 10:27:52 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 09/10] iomap: remove unnecessary advance from iomap_iter()
Message-ID: <Z64PeMFlUtKoSRYQ@bfoster>
References: <20250212135712.506987-1-bfoster@redhat.com>
 <20250212135712.506987-10-bfoster@redhat.com>
 <Z62YYEKE8n8qIsMc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z62YYEKE8n8qIsMc@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Feb 12, 2025 at 10:59:44PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 12, 2025 at 08:57:11AM -0500, Brian Foster wrote:
> > +	ret = (iter->len > 0) ? 1 : 0;
> > +	if (iter->processed < 0)
> > +		ret = iter->processed;
> > +	else if (!advanced && !stale)
> >  		ret = 0;
> 
> Maybe reshuffle this a bit as:
> 
> 	if (iter->processed < 0)
> 		ret = iter->processed;
> 	else if (iter->len == 0 || (!advanced && !stale))
> 		ret = 0;
> 	else
> 		ret = 1;
> 
> Otherwise this looks great!
> 

Ack, I like that better. Thanks for the feedback.

Brian

