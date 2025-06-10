Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A626A290BC2
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 12:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749558200; cv=none; b=iwWAMo+D/9x3Mg8Foe92PHXO6fd1J/6e4109/5uU6MGhYfQO6XGudW2ijTNjzE5zKf7z7BhftozZFPgN6AjdCVweErTADN6t2ZZ+upgYrl8fzVHeTa6NAvVZel8eubH2R0TGJ2CuNnzFAPq7lQINvlI+rcL0NdxnmlU1R9iUaoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749558200; c=relaxed/simple;
	bh=Mx+m0Kvr3P5//+kfdE27LV2gIzvBClZH1GCPHM85MaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fcPiQyhWiykpd4YjdG+8M5nuOQGfFkvwVkaHphnBvMZMOnktELLvxhNjrObKMysZB0hTMUaBSJmfnfGg2NgAla6T9//Q/g/JkuPfSC81C4Sh02FtW/cKd3qJa0HDm2uvITpPMFn1oiiI7Lwgv6b4IZN4jv1mr3vuISdgcVF0KRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Flf0yUsV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Flf0yUsV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749558197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GiWXWdJikqoIX0QaIbtyGeuDqgzC7gx2eetCW8Ce0Fw=;
	b=Flf0yUsViEIGnEmtaubJrVtYyAn900MoJX38DEYbe831caF0sZ24cpiMXarYP2tFmzEOYX
	CztQ7u+OvVV3+n0ybUxC2uNg/3cbfnUNKPPBT7gJuJi+yQQ6pMLyfBgNnsTM8BBwFQgHqH
	n7rZRfzrJwwHX8vrOkhUEEsBXmzemGQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-146-ypkTm2-fP4-Suj9YEK5lUg-1; Tue,
 10 Jun 2025 08:23:12 -0400
X-MC-Unique: ypkTm2-fP4-Suj9YEK5lUg-1
X-Mimecast-MFC-AGG-ID: ypkTm2-fP4-Suj9YEK5lUg_1749558191
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2242D195608E;
	Tue, 10 Jun 2025 12:23:11 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.100])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59A1E19560A3;
	Tue, 10 Jun 2025 12:23:10 +0000 (UTC)
Date: Tue, 10 Jun 2025 08:26:45 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC 7/7] xfs: error tag to force zeroing on debug kernels
Message-ID: <aEgkhYne8EenhJfI@bfoster>
References: <20250605173357.579720-1-bfoster@redhat.com>
 <20250605173357.579720-8-bfoster@redhat.com>
 <aEe1oR3qRXz-QB67@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEe1oR3qRXz-QB67@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Jun 09, 2025 at 09:33:37PM -0700, Christoph Hellwig wrote:
> On Thu, Jun 05, 2025 at 01:33:57PM -0400, Brian Foster wrote:
> > iomap_zero_range() has to cover various corner cases that are
> > difficult to test on production kernels because it is used in fairly
> > limited use cases. For example, it is currently only used by XFS and
> > mostly only in partial block zeroing cases.
> > 
> > While it's possible to test most of these functional cases, we can
> > provide more robust test coverage by co-opting fallocate zero range
> > to invoke zeroing of the entire range instead of the more efficient
> > block punch/allocate sequence. Add an errortag to occasionally
> > invoke forced zeroing.
> 
> I like this, having an easy way to improve code coverage using the
> existing fallocate and errtag interfaces is always a good thing.
> 
> Can I assume you plan to add a testcase using the errtag to xfstests?
> 

Well that is kind of the question.. ;) My preference was to either add
something to fstests to enable select errortags by default on every
mount (or do the same in-kernel via XFS_DEBUG[_ERRTAGS] or some such)
over just creating a one-off test that runs fsx or whatever with this
error tag turned on. [1].

That said, I wouldn't be opposed to just doing both if folks prefer
that. It just bugs me to add yet another test that only runs a specific
fsx test when we get much more coverage by running the full suite of
tests. IOW, whenever somebody is testing a kernel that would actually
run a custom test (XFS_DEBUG plus specific errortag support), we could
in theory be running the whole suite with the same errortag turned on
(albeit perhaps at a lesser frequency than a custom test would use). So
from that perspective I'm not sure it makes a whole lot of sense to do
both.

So any thoughts from anyone on a custom test vs. enabling errortag
defaults (via fstests or kernel) vs. some combination of both?

Brian

[1] Eric also raised the idea of branching off "test tag" variants of
errortags that might help distinguish injection points that control
behavior vs. those that truly create errors. That could reduce confusion
for testers and whatnot.

I haven't dug into viability, but in theory that could also define a set
of events that don't spew event trigger noise into dmesg if certain
events were to be enabled by default (again, on debug kernels only).

