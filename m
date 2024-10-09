Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63DB18E75F
	for <linux-xfs@vger.kernel.org>; Wed,  9 Oct 2024 12:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728477414; cv=none; b=mv+evqqASLAwpB8KItUGcdQnK6CB/Mrqme+7K4Y6044e0DLvNxK//oBHhVCCY1WNYgzWGPhmLztbjMlfH+q3C3CwoN1MmM7KNVK4QbgmEpJK7vVAsHOl0B+hp7rbdYmiB3rx/4Jlakx75P05xDMOZpcn41q+PEn/r1unWTpxIn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728477414; c=relaxed/simple;
	bh=RxmqlUpfHWEXqrYcqOR1U5ZhwtyGRuVWqk9IWml3Ino=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=up+v7uXN3wniYKlCrojshoNhgQ7j689Tkrkagca6/C6ROJfQshlDNg/qPel/KLfVcScKqY0iObn06zbm3Wn/jPB1Afo+9A4AHfvi2Yy6BTdtrhHkLS3JI3qBZD0HCDItqxc3Cg0xam8Xju1oDHddL6+O0L+6kCdj3XdXt+mMjKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eddq7qlz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eddq7qlz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728477411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dR52kLv/zTwryH/Q7obL/2ABaEACy0peM84CmtqHyE8=;
	b=Eddq7qlzJbxwbeeSLA1QjDoYmPP6UExoz6ejy7yqFidiQLi/2qKI8S153SY6nkvPSg1paS
	Myqql6gI2nDVNef8OsMC60MRSlVhApozHSzLMcT40gUhxpdqTU796xeQqBOz6bhZWeRfSJ
	L+HdOIKI1njaGd6AmnasoDsRVRHjrm0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214-MVJSS7y2NFiAExHmu2K9IQ-1; Wed,
 09 Oct 2024 08:36:47 -0400
X-MC-Unique: MVJSS7y2NFiAExHmu2K9IQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACE951955EE7;
	Wed,  9 Oct 2024 12:36:45 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89FAA300018D;
	Wed,  9 Oct 2024 12:36:44 +0000 (UTC)
Date: Wed, 9 Oct 2024 08:38:00 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, sandeen@sandeen.net
Subject: Re: [RFC 2/4] xfs: transaction support for sb_agblocks updates
Message-ID: <ZwZ5KGHKyrmBJxkj@bfoster>
References: <20241008131348.81013-1-bfoster@redhat.com>
 <20241008131348.81013-3-bfoster@redhat.com>
 <ZwY5TGnmqq91xsSJ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwY5TGnmqq91xsSJ@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Oct 09, 2024 at 01:05:32AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 08, 2024 at 09:13:46AM -0400, Brian Foster wrote:
> > Support transactional changes to superblock agblocks and related
> > fields.
> 
> The growfs log recovery fix requires moving all the growfs sb updates
> out of the transaction deltas.  (It also despertely needs a review or
> two)
> 

Ok, got a link to that fix? Is this the same as for that growfs related
fstest?

Anyways, this patch is really just doing updates as updates are done. It
can change if needed, but that's an implementation detail depending on
the high level direction this whole thing goes, if anywhere..

Brian

