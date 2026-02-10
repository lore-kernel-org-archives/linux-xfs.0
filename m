Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEB132E6BB
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 19:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770750884; cv=none; b=lxLFxc4hMTUsTkR55y4d+LFPw+ZgjbATZuWzm2j89Od4thqgAU1DJAyZaqB2T/FYBlu8ihVG/E8wVxAZuYi17gWkdP1p8arljT52KhVZqhEqQTLrm7yjMgGQni+UCKi+p5j5QZIJRYnbFVPCLV7rJ2NO7FuMXIoMqH8xNqVC5TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770750884; c=relaxed/simple;
	bh=mWaFp93K8/ZvcY/Z/ljKL0SWyHpGMPfT+pm4V9Q7NeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SeYu4Bhnx0+JdDHZPbUtcLE/eEwbncjsVmJkv3KyUtD45qsD51J+SMnzgzitSZMGeX4Tg/8hEfCAa8wt6sEJZcPN4GismL/y1Me4Ge0hahURQuiZNZaTNd2dH7/vSzPhmIX+22Whsa/tj+lRAWke957BY1XVwGorqJBMPJSou54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GjfE4EWX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GjfE4EWX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770750882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jidVcSiNZX3lY53glJyY+yFsNcC2P4TE33tkCiOaUXM=;
	b=GjfE4EWXheFAuZumVWmxO9bKUUuh+ay++76BS2MbG1VBFmKsFnPIFYrhpeSXTZFRmdG6iA
	p8DD8P/HujybhyYGtqNhhTXsH3cXbH+mrGn2APmznevJW+1tsg7xxNvat5UGZdsFsHN2JJ
	QdWYKqzwUwhW+p+uJ6cTI5OhRHOya+s=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-_fRs7qcSPlWR7acFKV7_0g-1; Tue,
 10 Feb 2026 14:14:40 -0500
X-MC-Unique: _fRs7qcSPlWR7acFKV7_0g-1
X-Mimecast-MFC-AGG-ID: _fRs7qcSPlWR7acFKV7_0g_1770750879
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90B141956094;
	Tue, 10 Feb 2026 19:14:39 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.28])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8315180066D;
	Tue, 10 Feb 2026 19:14:38 +0000 (UTC)
Date: Tue, 10 Feb 2026 14:14:36 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/5] xfs: flush eof folio before insert range size
 update
Message-ID: <aYuDnLj6pg8IF8KQ@bfoster>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-3-bfoster@redhat.com>
 <aYtZ8OSBCU2EtRQU@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtZ8OSBCU2EtRQU@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Feb 10, 2026 at 08:16:48AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 29, 2026 at 10:50:25AM -0500, Brian Foster wrote:
> > The flush in xfs_buffered_write_iomap_begin() for zero range over a
> > data fork hole fronted by COW fork prealloc is primarily designed to
> > provide correct zeroing behavior in particular pagecache conditions.
> > As it turns out, this also partially masks some odd behavior in
> > insert range (via zero range via setattr).
> > 
> > Insert range bumps i_size the length of the new range, flushes,
> > unmaps pagecache and cancels COW prealloc, and then right shifts
> > extents from the end of the file back to the target offset of the
> > insert. Since the i_size update occurs before the pagecache flush,
> > this creates a transient situation where writeback around EOF can
> > behave differently.
> 
> Eww.
> 

Yes. I'd still like to have something better here. I just don't know
what that is. I'm hoping that more eyes on this little quirk will
eventually lead to some better ideas on the insert range side.

Thanks for the review.

Brian

> > To avoid this quirk, flush the EOF folio before the i_size update
> > during insert range. The entire range will be flushed, unmapped and
> > invalidated anyways, so this should be relatively unnoticeable.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

