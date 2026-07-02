Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F3D47D933;
	Thu,  2 Jul 2026 12:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782995096; cv=none; b=VZtsDL/L7xOVKyz3Z/eziAM4no2kpyzh5ktlbsRkyd5BM6sLq+8PpAdJ1tO+Ku/JGTh+eLm3E2u/NUyneB1P8CoZHS7KN9fZek61kGlLAOUZq7o5r0yArK9JxLG8glElDjb2a8k2ji9lwUeBL0m4gf76Dk+GatkvvWlvbr4ehiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782995096; c=relaxed/simple;
	bh=ICx0y48EgCqwfUHNaqvLcqUK7PvEoDZZYH1/W6//A4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMX49pDfGZ8jDm1j9sV47aBowRebvFuWmNRjUMomO6mZWNvuhMXARrvUjmEqWGJiC5gFweQ6AYTHiVA7B+x8K4p3uMwyzDgj1XnLCBQILag3CFt0tTg2LoiDZrBpYwTsr0ucsoo+yDjS9gLOiW22B06I60zD57ztimeMgFv1kFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MOD8Nzut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MOD8Nzut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC061F000E9;
	Thu,  2 Jul 2026 12:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782995095;
	bh=1F/DnNRQhNjVTQ0PSQv/Zbt1GQU1sT+mz5mYcSd9Uq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MOD8NzutSbE5DdqnftFDp1RWydj64FDIYocU3xGvqy3WYNHeymhmGboz+b/ecsyxd
	 ne49teMDeOFKjgmQZP4/5oeW6D0TPIDziY6fVP4Fp52WUWrXb3RLMtdxTjMpwxlK/7
	 g+/t1XWQS+54f64n16MAi3wR9XTrLWC/NmPChijwUcAgyk0VmPTtaHaSue0Q9fJ9JF
	 RwzEvjqP0p7pG0v39qsOrSDFSeIocbFvAx2lLzKIWyLdFit15ymPHiLASQUksJCBRf
	 Q6ZZMAjJNZzNsN210yoMirZ3kSjEWFnKmVUbnawBolmWRfLYPz+/ZMn2SKYQBJ+M3R
	 alYo2AO7HtjIg==
Date: Thu, 2 Jul 2026 14:24:50 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	"Serge E. Hallyn" <serge@hallyn.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: Re: [PATCH v3 1/5] xfs: fix capability check in xfs
Message-ID: <akZYU2T4BkIuTcE3@nidhogg.toxiclabs.cc>
References: <20260702093324.127450-1-cem@kernel.org>
 <20260702093324.127450-3-cem@kernel.org>
 <20260702103052.GA6670@lst.de>
 <akZITB_FDP1nl2_S@nidhogg.toxiclabs.cc>
 <20260702112438.GA10565@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702112438.GA10565@lst.de>

> > +                               ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
> > +                               &tp);
> 
> This still adds an extra tab.  Like much (but not all) of the kernel
> we use two-tabs by default, which is also in the other two hinks.  This
> now adds a third.  Just keep it as it was:
> 
> 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> 			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
> 
> 

FWIW, I also fixed these in the patch 4 which I had screwed up too :)
