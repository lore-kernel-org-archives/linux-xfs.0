Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A44233ADAC
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 15:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636542; cv=none; b=CgWE1IXeI/oBaxx4KF/jtMTBQhBu6747BZyZsa0v8eh3EudtNKVdPMnPJXEMvjxtF+fojGeF4wX9AeGajafgbkwjlz1hG7swdBUCne17iDGhZi/GZWQnEzg4IY+ws2dMaYwfoJAOCrQDDPgpD+SqVujHbpRJWHpt9pUou6lKXek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636542; c=relaxed/simple;
	bh=WaI8UKJ0j9C8po/mY1iOSXJjwLuwVrUlbtnhd5X2Bnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dREBVhNVFklFN3KNxTcTnbrWRkOIMCgWF6GZOuN8QsFAk2ZO3LWTc6GsGNf0n3VBpPnIMKPVKHUSUTUI3sIhRhn6Wzq4eRGXKU+EtTBdH12/kEIYzYZ+3cxu60Sek4S6X0ftHQ2+NHrEDihWE8xWQOEhrMI7Aiy6F4KgesRlaw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DFIGqYTE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DFIGqYTE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772636540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V2W3TQM9sfdNNIZ1kR1STSGmEHhZlmDUNxbeChmefSY=;
	b=DFIGqYTEzrrjAWGknBvrOEeVwIGmrl8s5vcjpHF8H1PTGiv7Mdz+lS8M3YqQapsxyeK5WA
	HJEoMQZ5x6TUg4rq6gmIR41vJTMG+JyRHY3RUhoh6HTQP2M5H0NhHKdfL2TFrmEuo3hnVZ
	GiJCSkZG/exqK/haMfENGTkyv3YXTtQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-248-uN1hCZBPOZyJKfcNeTCrXQ-1; Wed,
 04 Mar 2026 10:02:17 -0500
X-MC-Unique: uN1hCZBPOZyJKfcNeTCrXQ-1
X-Mimecast-MFC-AGG-ID: uN1hCZBPOZyJKfcNeTCrXQ_1772636535
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B3EF195605E;
	Wed,  4 Mar 2026 15:02:15 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7223218002A6;
	Wed,  4 Mar 2026 15:02:14 +0000 (UTC)
Date: Wed, 4 Mar 2026 10:02:09 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] iomap, xfs: lift zero range hole mapping flush
 into xfs
Message-ID: <aahJcVkrkLRtsJO9@bfoster>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-2-bfoster@redhat.com>
 <aY6_eqkIrMkOr039@infradead.org>
 <aY9hY7TwgMXJNzkI@bfoster>
 <aaXesgEmu46X7OwD@bfoster>
 <aabyFY0l7GTEHnoQ@infradead.org>
 <aacv39AZ5P9ubOZ5@bfoster>
 <aagv8y96vGHvbOdX@infradead.org>
 <aag-_c8G_L5MQ42m@bfoster>
 <aahEk4yNqd15BIt7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aahEk4yNqd15BIt7@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Mar 04, 2026 at 06:41:23AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 04, 2026 at 09:17:33AM -0500, Brian Foster wrote:
> > I tested the change below but it ended up failing xfs/131. Some fast and
> > loose (i.e. LLM assisted) trace analysis suggests the issue is that this
> > particular situation is racy. I.e., we write to a sparse file range and
> > add COW fork dellaloc, writeback kicks in and drops the delalloc
> > mapping, then zeroing occurs over said range and finds holes in both
> > forks, then zone I/O completion occurs and maps blocks into the data
> > fork.
> 
> Yes, that can happen.  But the folio will be locked or have the
> writeback bit set over that whole period, so I can't see how writeback
> can actually race with that?
> 

I think that's why the flush (i.e. current behavior) works..

The change in my last mail attempts to replace the flush with improved
reporting to only report a hole if one exists in both COW/data forks at
the same time. So basically if the data fork is currently a hole and
writeback kicks in, xfs_zoned_map_blocks() deletes the COW fork mapping
and carries on with zoned writeback handling. At that point if zeroing
occurs, it would see holes in both the COW (just removed) and data fork
(not yet mapped in) and think there's nothing to do.

The idea is that if say we instead did something like transfer delalloc
into the data fork at writeback time, if the data fork had a hole, then
we could always tell from the iomap mapping whether we need to zero or
not without flushing or consulting pagecache at all.

Brian

