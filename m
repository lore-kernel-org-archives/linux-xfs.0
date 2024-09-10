Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2FB2AEF1
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725984753; cv=none; b=E+RtFAY3nXur3cd3/fuEM6hmetgJI8V427kPO0B40cm1f3VmxIl4vIyHgubyFxVwbzqYx8NIfm5+eSQVkRYer/IsjeoKpdbaVwNfE8t+JmJOPdNb0mgRnORC1owtbCicQPgfUbQ4/rW2MTFc6QGAVJxgyBD3eyck1NMImk6vuDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725984753; c=relaxed/simple;
	bh=XOyzOGhRVa8POUMC89T+vTtKBJqWPIY41iQUE89n0ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0PqMoUjOoUZrXAYJzQrNKTLm/4MfWoGrAUW2DivI7IdGt3LkcQ9ivs4c/ZWirTuygqWBF86ZghQu92e5MhyEavZ+5rCcAZrYcVVbWamTHKAd10afakTNijA5O2+yRpx/blreut5hrTZHp3zI8GLfTlcyuSQ8/A1d7wVK4aGcn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h41yjfEV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h41yjfEV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725984750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UnrHpgCi6k7zNrHt/uKQL5qvcm/koUg/CD8NHy1iLno=;
	b=h41yjfEV8HSX5Px7H08x/J+GKIHsTOK/4kMgdCUUwyDQcpTdszHBMrtxGm5jU6WEawjnAq
	4BXq8WZXb8Z8yJc1Q2ynmvW4t8ocQulnxv6mJsxq48Ur3kalf6h7MYq9zpJG2CYPXWIiNI
	+42nz5YBvFyEFzybvtXxoNFS5faVH8Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-kZQAjgUANK2U_ULPulpgNA-1; Tue,
 10 Sep 2024 12:12:29 -0400
X-MC-Unique: kZQAjgUANK2U_ULPulpgNA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C681195604F;
	Tue, 10 Sep 2024 16:12:28 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.69])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2FDAE1956086;
	Tue, 10 Sep 2024 16:12:27 +0000 (UTC)
Date: Tue, 10 Sep 2024 12:13:29 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, djwong@kernel.org, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test log recovery for extent frees right after
 growfs
Message-ID: <ZuBwKQBMsuV-dp18@bfoster>
References: <20240910043127.3480554-1-hch@lst.de>
 <ZuBVhszqs-fKmc9X@bfoster>
 <20240910151053.GA22643@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910151053.GA22643@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, Sep 10, 2024 at 05:10:53PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 10, 2024 at 10:19:50AM -0400, Brian Foster wrote:
> > No real issue with the test, but I wonder if we could do something more
> > generic. Various XFS shutdown and log recovery issues went undetected
> > for a while until we started adding more of the generic stress tests
> > currently categorized in the recoveryloop group.
> > 
> > So for example, I'm wondering if you took something like generic/388 or
> > 475 and modified it to start with a smallish fs, grew it in 1GB or
> > whatever increments on each loop iteration, and then ran the same
> > generic stress/timeout/shutdown/recovery sequence, would that eventually
> > reproduce the issue you've fixed? I don't think reproducibility would
> > need to be 100% for the test to be useful, fwiw.
> > 
> > Note that I'm assuming we don't have something like that already. I see
> > growfs and shutdown tests in tests/xfs/group.list, but nothing in both
> > groups and I haven't looked through the individual tests. Just a
> > thought.
> 
> It turns out reproducing this bug was surprisingly complicated.
> After a growfs we can now dip into reserves that made the test1
> file start filling up the existing AGs first for a while, and thus
> the error injection would hit on that and never even reach a new
> AG.
> 
> So while agree with your sentiment and like the highlevel idea, I
> suspect it will need a fair amount of work to actually be useful.
> Right now I'm too busy with various projects to look into it
> unfortunately.
> 

Fair enough, maybe I'll play with it a bit when I have some more time.

Brian

