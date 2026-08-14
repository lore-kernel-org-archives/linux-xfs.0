Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8229429CD9
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 16:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786724690; cv=none; b=uFRYT2xe9zpkcL2PUlU0Ip4MtVHB+Xu71EcVmXYmVMK6dVfZZMGoPRDtjHRL4qGibLEnH6MSAxf/snoOocZ7c6qbnHOowyIlxgljPw1nTd+IX9fL8UDfH/V9n/tcmcshw5ftM7+HS88uW6KW4fPSFZRJzRJQSPUrTKcuU6QoCd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786724690; c=relaxed/simple;
	bh=L5ZXyAL0kM2WSGSZqr3DmJnneu3OvrPNEwjMOnW+s1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZCx9EWVmKO1kDCfZha/Khbjcp30D1Z9j6uGPZ8+7aWEX2lwMn9mYbwEovNxej1V0zNFGsmpCzrOIiD1YoEtKREyJCDDM4uhO3h7gj9q5Qqjr9cRIeob8+vrl70k3TxJUqHFnS/xQ1zGeWeuWvYM8+Woge8QhbpdezfDACX+avyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i3bBN5Bd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i3bBN5Bd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786724687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sexfnBjzjj3x1a03EZ3fHbhFVaM0/npYxTfnurRvK8w=;
	b=i3bBN5BdIrJn9e7a272XzMPQzPvbtEhrMrl9ef6YcYDg7HAl3AZAhx2vYG3Tnm8twJzKPW
	pmGRNN3jXs/nxqbX0GvIMyfQI5hZGCTc+gmgS92ea0lli2nR34xOCEh6YaUHGtKETUQIkq
	A35dEX+V+xmMWwr2D/iAVNW90ZWZAko=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-Mi23SX_vOtijZQX8VqAIYw-1; Fri,
 14 Aug 2026 12:24:44 -0400
X-MC-Unique: Mi23SX_vOtijZQX8VqAIYw-1
X-Mimecast-MFC-AGG-ID: Mi23SX_vOtijZQX8VqAIYw_1786724683
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E40BF195606C;
	Fri, 14 Aug 2026 16:24:42 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.105])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F20D18005AC;
	Fri, 14 Aug 2026 16:24:42 +0000 (UTC)
Date: Fri, 14 Aug 2026 12:24:40 -0400
From: Brian Foster <bfoster@redhat.com>
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [External] : Re: [PATCH v2 3/3] xfs: incorporate increased AGFL
 min requirement for minleft allocs
Message-ID: <an9BSI7I0WX3ua4g@bfoster>
References: <20260814132239.271492-1-bfoster@redhat.com>
 <20260814132239.271492-4-bfoster@redhat.com>
 <an8e1YgRDysYtlgM@bfoster>
 <8e58b1e1-c15a-41df-898a-3725d920b486@oracle.com>
 <an8qkZXtwQwYDycO@bfoster>
 <c493b668-9b13-4802-ad05-f54cc62db168@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c493b668-9b13-4802-ad05-f54cc62db168@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Fri, Aug 14, 2026 at 10:18:15AM -0500, Mark Tinguely wrote:
> On 8/14/26 9:47 AM, Brian Foster wrote:
> > On Fri, Aug 14, 2026 at 09: 15: 15AM -0500, Mark Tinguely wrote: > On 8/14/26 8: 57 AM, Brian Foster wrote: > > On Fri, Aug 14, 2026 at 09: 22: 39AM -0400, Brian Foster wrote: > > > Matt Fleming reports a filesystem shutdown due
> > 
> > 
> > On Fri, Aug 14, 2026 at 09:15:15AM -0500, Mark Tinguely wrote:
> > > On 8/14/26 8:57 AM, Brian Foster wrote:
> > > > On Fri, Aug 14, 2026 at 09:22:39AM -0400, Brian Foster wrote:
> > > > > Matt Fleming reports a filesystem shutdown due to inobt block
> > > > > allocation failure during sparse chunk allocation. Inode creation
> 
> 
> (deleted text)
> 
> > > 
> > > 
> > > thank you for the comment clarification.
> > > I was confused by that change.
> > > 
> > > Could you CC stable. We saw a version of this problem in Linux 5.15
> > > 
> > 
> > Sure, though I'm not sure how far back this will apply cleanly.
> > 
> > Curious.. was the instance you saw also an inobt alloc failure leading
> > to dirty trans cancel and shutdown, or something different but similar?
> > 
> > Brian
> > 
> 
> yes the v5.15 problem was a similar sparse inode chunk / inode btree insert failure.
> I admit that I did not have the numbers to realize why the inode btree insert failed.
> 

Ok.

> although this is a fundamental allocation flaw, the sparse inode chunk allocation
> seems to be the just right/wrong conditions to trigger it.
> 

I think that's probably right, but I had the Fixes: tag on v1 and
dropped it here just because I think it's kind of a tenuous connection
now. Re: the discussion on v1, presumably we could have the same thing
happen with bmap allocs and just not see the shutdown because those
allocs are usually more flexible and can fall back to different AGs.

Regardless, wrt stable I think it would be reasonable to target back to
the release that enabled sparse inodes (v4.2) since that's how this is
reproduced in practice, so it probably doesn't make much difference
either way.

Brian

> Fixes: 5419040fc0f3a xfs: introduce inode record hole mask for sparse inode chunks ??
> 
> thanks for the fix
> 
> Mark Tinguely
> 
> 
> 

