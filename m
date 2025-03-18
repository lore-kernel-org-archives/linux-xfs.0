Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB03DC2C8
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 02:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742263397; cv=none; b=cRvmlWNbTsu5godpRoZXVo6DXSrDd5vTCm8fPWvZlRLBucj8euNht8qf3Yi6MM0agV8sxxVQh00DrJ7/vOdBViiHJ+8jIxwlv7ctXUdSX7WiLoXmFmhnwt2CeuYkheFzRIwQt+/DDcUJ7YUXxtP8UrnObjYJTIfeO8E4qt8xxEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742263397; c=relaxed/simple;
	bh=wzJJtj31SQ287mOGF1G3+igWHUhTC87Wgi/UesRj2IY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I16xrKfF3HGSFUQXpx18H7Hrb4/MmKCnNWZXirIAdYwCj0n/oFCuAzAXVdjisI07izB26hyA2RMca0nVq9OJeOj/QpO5l2NLi/SQoUAK7CEN3s0+WoZaFCnQsA9knVhmMrzlGSpCMO5BA6w5yA4/gXR7YWRc4319/yALhfVAvHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/u+f9iQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/u+f9iQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD1CC4CEE3;
	Tue, 18 Mar 2025 02:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742263397;
	bh=wzJJtj31SQ287mOGF1G3+igWHUhTC87Wgi/UesRj2IY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c/u+f9iQgfdoCZZp++VCl20gkBeG3TzYd8iirTVsulhHcywJhTP22kFhCoMOKYGCG
	 Y2UKPkneZmRMa5yRTplVo099LkLvlcdCzPnLIFu/uQoggz43kxjGoeqIZm4W1YcQYC
	 sCSUe0N7HC+GyCB6FzbHL3P4YGCBKnhxKJO8Fn75Jtajvoa8Zrl0ACUsGvi2Uw5/ji
	 sOqtrkgSvW6/ZKOs37OA0da+q57NrgSfbswAfPeFYXNGYCxWRa6Zw95Fa6PGunhO8z
	 6hH2R34BXk+R6+o779LBQLpS44/kutC3/jnmNtNdVTgs2Wjq4WBWq2mikvXohMme5v
	 72ycvuoQU4Jfg==
Date: Tue, 18 Mar 2025 10:03:10 +0800
From: Gao Xiang <xiang@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Zorro Lang <zlang@redhat.com>
Subject: Re: [report] Unixbench shell1 performance regression
Message-ID: <Z9jUXkfmDYc0Vlni@debian>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Zorro Lang <zlang@redhat.com>
References: <0849fc77-1a6e-46f8-a18d-15699f99158e@linux.alibaba.com>
 <Z9dB4nT2a2k0d5vH@dread.disaster.area>
 <fddda0be-3679-46ae-836c-26580a8d55f4@linux.alibaba.com>
 <Z9iJgWf_RL0vlolN@dread.disaster.area>
 <b9871ab8-19c1-4708-99f7-3f91f629aeda@linux.alibaba.com>
 <Z9jFTdELyfwsfeKz@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z9jFTdELyfwsfeKz@dread.disaster.area>

On Tue, Mar 18, 2025 at 11:58:53AM +1100, Dave Chinner wrote:
> On Tue, Mar 18, 2025 at 08:29:46AM +0800, Gao Xiang wrote:
> > On 2025/3/18 04:43, Dave Chinner wrote:
> > > On Mon, Mar 17, 2025 at 08:25:16AM +0800, Gao Xiang wrote:
> > > > If they think the results are not good, they might ask us to move away
> > > > of XFS filesystem.  It's not what I could do anything, you know.
> > > 
> > > If they think there is a filesystem better suited to their
> > > requirements than XFS, then they are free to make that decision
> > > themselves. We can point out that their selection metrics are
> > > irrelevant to their actual workload, but in my experience this just
> > > makes the people running the selection trial more convinced they are
> > > right and they still make a poor decision....
> > 
> > The problem is not simple like this, what we'd like is to provide
> > a unique cloud image for users to use.  It's impossible for us to
> > provide two images for two filesystems.  But Unixbench is still
> > important for many users, so either we still to XFS or switch back
> > to EXT4.
> 
> Well, that means your company has the motivation to try to improve
> the XFS code, doesn't it? If they won't put up the resources to
> address issues that affect their customers, then why should anyone
> else do that work for them for free?

Disclose: I don't speak for my company. So the following is just
my own thoughts.

It may be true in 2023, however, the only resource now is me (I
suspect there will be more resource), but I still have other work
to do on my hand which impacts my own performance review more.
For this issue, I spent much time (up to the mid-night) last week
to find out, which greatly impact my own physical health.  Yes,
I will speed more on this, but:

There is no clear evidence that a cloud image could directly benefit
to our AI infra.  So from POV of a company, the worst case is that
they may revisit the overall benefits among all possible choices and
find out the best one.

Anyway, I've got the community view of Unixbench.  I will arrange my
own TODO list.

Thanks,
Gao Xiang

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
