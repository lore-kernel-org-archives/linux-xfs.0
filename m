Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0588C15E5C8
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 19:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706902848; cv=none; b=E4MRDgxyM9zJh3m/CREiP4qHStPBJyAyMGkXq3KApZkGR5gY/xv+lcEwbN4szd4GZBEhiACcPP0cWLNTzcfYdAx4lx4CIqlhLxfyfv4v40OrsAobkPfXHN5tn7rdoD6uxKMUxmJAEeyxM9W25Pu32qI6RH19JE1xONUN1/NNaX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706902848; c=relaxed/simple;
	bh=0Y1sAOZ5BgKhPD2lfxcbxu/RFcAgDyJG3EKn7GfOdyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KSe+eWUu/IyjxWdnvpz1d9CyyF818GEuaDDWMQiplyeP8FwOUMsS9B2K9hYbuqEe6w0lN7kVNaptPFH6I9xx2hc+Ess468H/V0V1FbsMQ9Jqkm4Jsfr2Eu/7R9PUIvVokc+2V0BT3D50cXkMRAutxzyTsj6DpcTV3jvOEbr4ocs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hdn4qW1+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hdn4qW1+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706902845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pZuDIwK8o8CGVtj1URAZgeRSO/U/NTnVnuQ48aFru2c=;
	b=hdn4qW1+BOJcv0lhFNk78W4ioG3PKil3NLZGopw0dOaKX/sHmi0O4trMQF7BAyc6lVUBrf
	Ol3iezmWsRntgqIlhL0lzt1SbXEa6QqPTU0qSReM4yah/t0sP00MpmUbM/9fxdcC3Ee8tP
	KvjhKAjIl6GQWHpzMpBChLWbXj1xKd8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-r8YfSmWENeW6pHNtTv6HLw-1; Fri, 02 Feb 2024 14:40:42 -0500
X-MC-Unique: r8YfSmWENeW6pHNtTv6HLw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AB0D85A589;
	Fri,  2 Feb 2024 19:40:42 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4894D492BE2;
	Fri,  2 Feb 2024 19:40:42 +0000 (UTC)
Date: Fri, 2 Feb 2024 14:41:56 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <Zb1FhDn09pwFvE7O@bfoster>
References: <20240119193645.354214-1-bfoster@redhat.com>
 <Za3fwLKtjC+B8aZa@dread.disaster.area>
 <ZbJYP63PgykS1CwU@bfoster>
 <ZbLyxHSkE5eCCRRZ@dread.disaster.area>
 <Zbe9+EY5bLjhPPJn@bfoster>
 <Zbrw07Co5vhrDUfd@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zbrw07Co5vhrDUfd@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Thu, Feb 01, 2024 at 12:16:03PM +1100, Dave Chinner wrote:
> On Mon, Jan 29, 2024 at 10:02:16AM -0500, Brian Foster wrote:
> > On Fri, Jan 26, 2024 at 10:46:12AM +1100, Dave Chinner wrote:
> > > On Thu, Jan 25, 2024 at 07:46:55AM -0500, Brian Foster wrote:
> > > > On Mon, Jan 22, 2024 at 02:23:44PM +1100, Dave Chinner wrote:
> > > > > On Fri, Jan 19, 2024 at 02:36:45PM -0500, Brian Foster wrote:
...
> Here's the fixes for the iget vs inactive vs freeze problems in the
> upstream kernel:
> 
> https://lore.kernel.org/linux-xfs/20240201005217.1011010-1-david@fromorbit.com/T/#t
> 
> With that sorted, are there any other issues we know about that
> running a blockgc scan during freeze might work around?
> 

The primary motivation for the scan patch was the downstream/stable
deadlock issue. The reason I posted it upstream is because when I
considered the overall behavior change, I thought it uniformly
beneficial to both contexts based on the (minor) benefits of the side
effects of the scan. You don't need me to enumerate them, and none of
them are uniquely important or worth overanalyzing.

The only real question that matters here is do you agree with the
general reasoning for a blockgc scan during freeze, or shall I drop the
patch?

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

