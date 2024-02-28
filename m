Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9793612FC;
	Wed, 28 Feb 2024 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709134773; cv=none; b=EdSK5UwooDMEoqbuQRhVmJGDqf6s6r1zNkz7mFdDDfsfsd3eMawKDs7JX+Y/11gP/UGf1Op4rVwNG9hT+z2ymzzO1rqcodcxlFilL/6EO9jVI9erv4IZ72g+yVVCmE8VdEbiw9WL2VQiSvmBwkehT8KchnFo1fDU/2aFhWUhViw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709134773; c=relaxed/simple;
	bh=G/QBBfig6n658qCIRIUYdjBKRkyLshegXU/GT3hM7aI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCXRwgZZqyW64qoepyGMiYnMoyQjrQ4QNGowgtJXIttrBowlfu5rmeU5cOCL1nDPJQxLtXdC9RZNupOUD1yqrUzzVfQHwm3IoRqJCFwVf8wtes2SHVRgWnMUjnrZCDVlfqdFdDfHyeRHXJ9v6WBJ2ZU5ld5LCvpEY96LRT2IstQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tGCWzAop; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tGCWzAop"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5FACmNrXMsLC5ZSFfuWMjCBgOJTNUS3gd0mH93L3uS8=; b=tGCWzAopNYxYn/eVezCam2su/J
	6NoJB5aaJICO9fbIbyxStwDZ0409cQwQfRlU41Mtvf+RtYce+z/9n5IipsKp3XrDo4QFFgOchDG71
	nRDU9Dk9z9UWyYgaeoVjyqigxiTHSMzcYkCHcWbQJUJ6QpT69236jmL044Uy/Er8OiQiCRz2GGzVj
	zUaMz+canEI2f6Vq3mpMYjbjKpCexJnA2gNZTnmz82vDJmu0k//36ffaaAPMhG3R1E7leD7p/SE6i
	apQprFQm0wU6tnelIGd7WkcXf+Nq9QZOq5PVH5/i44bLfmQqSy+qP6jt9jvgHC9aPu8+Bf/6u0Dqs
	38NVNKtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfM1p-00000009vfz-3gGY;
	Wed, 28 Feb 2024 15:39:29 +0000
Date: Wed, 28 Feb 2024 07:39:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs/122: update test to pick up rtword/suminfo
 ondisk unions
Message-ID: <Zd9TsVxjRTXu8sa5@infradead.org>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
 <Zd33sVBc4GSA5y1I@infradead.org>
 <20240228012704.GU6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228012704.GU6188@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 27, 2024 at 05:27:04PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 27, 2024 at 06:54:41AM -0800, Christoph Hellwig wrote:
> > Can we please just kill the goddamn test?  Just waiting for the
> > xfsprogs 6.8 resync to submit the static_asserts for libxfs that
> > will handle this much better.
> 
> I'll be very happen when we scuttle xfs/122 finally.
> 
> However, in theory it's still be useful for QA departments to make sure
> that xfsprogs backports (HA!) don't accidentally break things.
> 
> IOWs, I advocate for _notrunning this test if xfsprogs >= 6.8 is
> detected, not removing it completely.
> 
> Unless someone wants to chime in and say that actually, nobody backports
> stuff to old xfsprogs?  (We don't really...)

Well, who is going to backport changes to the on-disk format in a way
that is complex enough to change strutures, and not also backport the
patch to actually check the sizes?  Sounds like a weird use case to
optimize for.

