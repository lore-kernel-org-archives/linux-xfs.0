Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B885296152
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 14:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749565022; cv=none; b=iIUzb4LKkoaHw1S6Z4qJcJEXrMlEk7WJ347Gb4qs6XinvZDWA3615gJa8kFB6L16r03zKgZWtUQLe9qQ8Tfl0EV5JF10O5snhnsiZFFrSADf90OPmDZrVZVJjEO3hOMdePZ4fWJJ06ZMWYiFOuzQSOGXAaLoFHyDYPRpYYYZz+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749565022; c=relaxed/simple;
	bh=bpFA7MThQ1vU59YHa+kKutc+WSnaudERBmP9SilvaRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2No8A0tlNTfiMxrBmMybnjctzXd39l+VprNMNhUrFjtctI+hT8yLkzQr5SU34hqI6OzBYVZXHSknrL3JivuBlth/m77rf10yD1X7+X1gCOPP++GU9yW3D3PpRrwvHowWmmC5DkmHl9mryBytIw+qOwThrCC23btJb9MZC0Ss0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CQ5DpKy/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQ5DpKy/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749565020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XUcZUslNDuQ2HQKyQbnOe3UdhZ+iJ00hJ31vDYu2byM=;
	b=CQ5DpKy/NyX6ugYQn5FRf4FJvrEmd0Z8VU+rq0S843NkclGu7Q6vH1Slx/3SSLJkO6qu9G
	itstoAEWS2UG52wrYq6wjieLdQZJaitsXPBY0pF8nKVfZIvaw2P543oDAkXN2Hv7srAkfj
	xejrKwyCDA4izTj4gKnBEKdQ4QEufps=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-9EMWWKLMMBm0_TWs51s5_Q-1; Tue,
 10 Jun 2025 10:16:56 -0400
X-MC-Unique: 9EMWWKLMMBm0_TWs51s5_Q-1
X-Mimecast-MFC-AGG-ID: 9EMWWKLMMBm0_TWs51s5_Q_1749565014
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CC2518002E4;
	Tue, 10 Jun 2025 14:16:54 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.100])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B15B19560B0;
	Tue, 10 Jun 2025 14:16:53 +0000 (UTC)
Date: Tue, 10 Jun 2025 10:20:28 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC 7/7] xfs: error tag to force zeroing on debug kernels
Message-ID: <aEg_LH2BelAnY7It@bfoster>
References: <20250605173357.579720-1-bfoster@redhat.com>
 <20250605173357.579720-8-bfoster@redhat.com>
 <aEe1oR3qRXz-QB67@infradead.org>
 <aEgkhYne8EenhJfI@bfoster>
 <aEgzdZKtL2Sp5RRa@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEgzdZKtL2Sp5RRa@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Jun 10, 2025 at 06:30:29AM -0700, Christoph Hellwig wrote:
> On Tue, Jun 10, 2025 at 08:26:45AM -0400, Brian Foster wrote:
> > Well that is kind of the question.. ;) My preference was to either add
> > something to fstests to enable select errortags by default on every
> > mount (or do the same in-kernel via XFS_DEBUG[_ERRTAGS] or some such)
> > over just creating a one-off test that runs fsx or whatever with this
> > error tag turned on. [1].
> > 
> > That said, I wouldn't be opposed to just doing both if folks prefer
> > that. It just bugs me to add yet another test that only runs a specific
> > fsx test when we get much more coverage by running the full suite of
> > tests. IOW, whenever somebody is testing a kernel that would actually
> > run a custom test (XFS_DEBUG plus specific errortag support), we could
> > in theory be running the whole suite with the same errortag turned on
> > (albeit perhaps at a lesser frequency than a custom test would use). So
> > from that perspective I'm not sure it makes a whole lot of sense to do
> > both.
> > 
> > So any thoughts from anyone on a custom test vs. enabling errortag
> > defaults (via fstests or kernel) vs. some combination of both?
> 
> I definitively like a targeted test to exercise it.  If you want
> additional knows to turn on error tags that's probably fine if it
> works out.  I'm worried about adding more flags to xfstests because
> it makes it really hard to figure out what runs are need for good
> test coverage.
> 
> 

Yeah, an fstests variable would add yet another configuration to test,
which maybe defeats the point. But we could still turn on certain tags
by default in the kernel. For example, see the couple of open coded
get_random_u32_below() callsites in XFS where we already effectively do
this for XFS_DEBUG, they just aren't implemented as proper errortags.

I think the main thing that would need to change is to not xfs_warn() on
those knobs when they are enabled by default. I think there are a few
different ways that could possibly be done, ideally so we go back to
default/warn behavior when userspace makes an explicit errortag change,
but I'd have to play around with it a little bit. Hm?

Anyways, given the fstests config matrix concern I'm inclined to at
least give something like that a try first and then fall back to a
custom test if that fails or is objectionable for some other reason..

Brian

