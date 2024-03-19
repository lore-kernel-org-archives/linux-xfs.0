Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2F53EA77
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 21:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884360; cv=none; b=KKaaoDzKHRLxURHC3qLGIszjQHMNw982McWbRNMnzhg9I8gb6db9rGZEuuKYi+6hbyCcWFiCffyJQCVINcqVEsOeO/M5qaCoN33ZEt+pkB2py88l/tl+X8Nv7ZU/kDBR+RstkvggUqDZKM7auFbtmBajZZQVROJBVIozdl5kms4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884360; c=relaxed/simple;
	bh=LWARep5lTFHk1cuUvUeZ/HTYZJvpK2WDvGQbAc9gfFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bIe0kdqFRPCm5azva4SROxzulDJjD2DAA12BwzMESl0pT4W/fMWNl0clvjS7vx018YznO3ot230nkXSLLnzdsktgnrA5pAkwDfA7pNSYIqy0hnVYdUnpZvv4YJivQ1AMvnhWbNNWb8351SIyBNsj+PdbTtpP4Ut8LBqI0rySa2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHMdo9XL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHMdo9XL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CE4C43390;
	Tue, 19 Mar 2024 21:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710884360;
	bh=LWARep5lTFHk1cuUvUeZ/HTYZJvpK2WDvGQbAc9gfFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kHMdo9XLJmnQOtBoy+HiE5UDJsWdV+JoWJmqYo1Bgq4fispXoC5SxaSubhuwzIM/v
	 4gNnVqSuFuMrG0T6mXfV7wDXvEp4X2X0YH9xJeKUA0GOV50HVRNk1zfJnOX0R4d0zV
	 5XXVW87/uVBvkiKDIOizh9xs/ARo8NT6Qt5VrI3EbzxL2QTpDx8A75JcU0SQgkNAcr
	 gjUIo3y/A37U+pV2w+2Bq0YbOSapLus3B3GKUidIMOFPomCH0TUVDj8pD0H1PKVCGt
	 LgZyNWg4B+oY7WObkaTr6mr9bhJvhusU48v40tiWffgdU+NgB3ith1FO3LDC/gJyfO
	 mta3IDNvubU3g==
Date: Tue, 19 Mar 2024 14:39:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: map buffers in xfs_buf_alloc_folios
Message-ID: <20240319213919.GR1927156@frogsfrogsfrogs>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-7-david@fromorbit.com>
 <20240319173413.GS1927156@frogsfrogsfrogs>
 <ZfoEgJ7U7A6BxwIl@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfoEgJ7U7A6BxwIl@infradead.org>

On Tue, Mar 19, 2024 at 02:32:48PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 19, 2024 at 10:34:13AM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 19, 2024 at 09:45:57AM +1100, Dave Chinner wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > > 
> > > With the concept of unmapped buffer gone, there is no reason to not
> > > vmap the buffer pages directly in xfs_buf_alloc_folios.
> > 
> > "..no reason to not map the buffer pages..."?
> 
> or maybe 
> 
> "..no good reason to not map the buffer pages..."

We might as well fix the split infinitive as well:

"...no good reason not to map the buffer pages..."

--D
