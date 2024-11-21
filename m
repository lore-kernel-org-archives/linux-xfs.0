Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ADA142633;
	Thu, 21 Nov 2024 16:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732206836; cv=none; b=hy6/sk4z4R05TThorbq/YmcbVDWq1FrBT214pD5bWbgHjmOUDXnJkH1yAh3Sk9Tj1PaNt0e9DH6FrsqpwxlW8TNXRvKWX7bfDmx2zler/MTuY+Zv0Ztn3DL8a+6rqx+sGw8FXl3JYWfS1NmTO07xFnJpwYgQ6xEF7cfq9by4y2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732206836; c=relaxed/simple;
	bh=T2b1n3OQO60Ha7D4HWQ+KBdabDPlMLzq3ylXCqcUHk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FUcdn5HkCkLrGIbBpDu0pSmCNDxJcF61c7D81oW7IHrI/T5BkwU3PaW/vMWMXFQCdLHkqPrbUivMhKx+afTlPDy2Y/aLdk59YmEEH0JMPjUevXZQsG6RKGtoPkkY5fV01AsaFDVY50eiMRB3nO0CCKhFCsJS7PXKEwuj9nWNjLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eJw6Ez6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eJw6Ez6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF721C4CECC;
	Thu, 21 Nov 2024 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732206835;
	bh=T2b1n3OQO60Ha7D4HWQ+KBdabDPlMLzq3ylXCqcUHk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eJw6Ez6QoXBn9nwiUJzliJJhyei6lobsBmATjreOWT1dxHS4QnZMboOX2YRBnYo0U
	 CfH1XTOtcs2fhRnvsjmrLsxOpt5FaqVGLa0VBwxQFPy59PxBNSQ2kI3MiMM8BjBQrr
	 NBMxk0uwi7lqF42wVBYhAWJNplDcEKUV9hifd3NVE+JMirZ1R3F0LIdLC/2NNAm3F5
	 Yd7ZegQo8ssVRqtn9khxTRPxbxe0zLFege3iDie/2ZlEdzx78AOjxqTfTwZePxpdOF
	 +9RSwxzIxsDx7i/EMNITdNta00GPgaWxoTGerJX1uLp1HDpv888O6YNSQQ4GImaXFZ
	 DFBOb4dDVTjsg==
Date: Thu, 21 Nov 2024 08:33:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241121163355.GU9425@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>
 <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241121100555.GA4176@lst.de>
 <20241121101325.GA5608@lst.de>
 <20241121105248.GA10449@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121105248.GA10449@lst.de>

On Thu, Nov 21, 2024 at 11:52:48AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 21, 2024 at 11:13:25AM +0100, Christoph Hellwig wrote:
> > proper zeroout ioctl, which fixes my generic/757 issues, and should
> 
> It turns out then when I extrapolate my shortened 10 iteration run
> to the 100 currently in the test it would take ~ 30 minutes.  I'm
> not sure that's really a reasonable run time for a single test in
> the auto group.

Yeah, perhaps I should adjust this one to use TIME_FACTOR too?

while _soak_loop_running $((10 * TIME_FACTOR)); do
	# timeconsuming stuff
done

(and then you can SOAK_DURATION=10s to limit the runtime)

--D
