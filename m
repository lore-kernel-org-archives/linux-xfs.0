Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDFC3264FE
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 11:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776857726; cv=none; b=Okw3jtusw+ZvIGeIB0+e5x1g9qKl1BcVzD+ArRvtkJ86/iucDFxDHyP+XA0YjoCdoqFdYaZ/emGVCaTWjqmaCi+wmUn22EKqMCmGTYP2i6QaBjAUMFTFC1X33b2793xwgOvUhk4QWVJ98C5V8Mx9dzDvUdHQNyXhFFYnhgR3ECo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776857726; c=relaxed/simple;
	bh=vnuUY07BollKRPzRF9Uh8RGQgr/B1tBrzItheCza5hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dufj1YnC7geFwDAgeTIZHpol1w5ThLrpzAbVXD0SWIagHB56Lw6xpxX0AaXpzaGpmKx18Se286+HiU0Giz1ygVZpWCmRMb0ajrDJCLD9Cr6yJHLNlIcMVY984my3Z4cL/FQ151ZguilkZd+Fu9qKJV+G8Mn/snJCUcDeDeRmnRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bq7Ep9fd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bq7Ep9fd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776857724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZluGsPymL9vQFLMyqSy4ACZH2UNPcwgTDGVZkfllTBg=;
	b=Bq7Ep9fdN5QclrMeBJbshjK0v3sJ9rqFhPqkkrvThFQ0XTGznoRu/G2CYGvGiSHbRwjbe0
	fLG/rfGEn2mTx3M2cm1tg/T/57fPtCGCAJsTg8CuXzhzOSVwqoeYkXM7uAKMAUGoQEnM+z
	qxv6X9TZPBbpCX2xlS/kJ0p/bEs/lII=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-VpoPH-hcP22H-qX7Usqf5Q-1; Wed,
 22 Apr 2026 07:35:21 -0400
X-MC-Unique: VpoPH-hcP22H-qX7Usqf5Q-1
X-Mimecast-MFC-AGG-ID: VpoPH-hcP22H-qX7Usqf5Q_1776857720
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 372021800454;
	Wed, 22 Apr 2026 11:35:20 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.73])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8DD6B19560B7;
	Wed, 22 Apr 2026 11:35:19 +0000 (UTC)
Date: Wed, 22 Apr 2026 07:35:17 -0400
From: Brian Foster <bfoster@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Fengnan Chang <fengnanchang@gmail.com>
Subject: Re: Should we hook up sashiko.dev?
Message-ID: <aeiydeH-zDYw3yCK@bfoster>
References: <87c6dc3d-ed23-4ae9-8309-0782ffd9b191@sandeen.net>
 <83e6b930-2705-4719-80cc-71987092f1b7@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83e6b930-2705-4719-80cc-71987092f1b7@sandeen.net>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Apr 21, 2026 at 06:47:01PM -0500, Eric Sandeen wrote:
> On 4/15/26 11:49 AM, Eric Sandeen wrote:
> > Hi all - 
> > 
> > "Sashiko is an agentic Linux kernel code review system. It monitors public mailing lists to thoroughly evaluate proposed Linux kernel changes. The system acts like a team of specialized reviewers covering domains from high-level architecture verification and security audits to low-level resource management and concurrency analysis."
> > 
> > This is something built by Chris Mason and others, with Google providing the LLM and tokens.
> > 
> > The website sashiko.dev shows these review results for mailing lists it is subscribed to, so you can browse around and see how it works. I've heard reasonably positive feedback from some who've used it already.
> > 
> > We could send a PR to request adding linux-xfs, and I think we should try it.
> 
> Ok, we're connected: https://sashiko.dev/#/?list=org.kernel.vger.linux-xfs
> 
> for now it is not sending any emails; it's web-only. Depending on the
> usefulness and accuracy of the reviews, we could consider more than web-only.
> 
> I'd like to set up some xfs-specific review prompts, but apparently we need
> to be somewhat sparse on that due to token usage for a large set of prompts.
> 
> LMK what you think of the review quality!
> 

I just took a quick look at this one and it seems like it's accurate:

https://sashiko.dev/#/patchset/20260420061630.62077-1-changfengnan%40bytedance.com

The flaw isn't actually with the patch, but rather the surrounding code
it touches. It also feels a little weird to me to have a tool that tries
to communicate like a person, but maybe that's just something to get
used to I guess. ;)

Fengnan,

Any chance you want to try to fix that up in your patch, since it's
outstanding and you've created the helper to facilitate it? ;) If not
nbd we can fix it up separately. I don't think it's a pressing issue.

Brian

