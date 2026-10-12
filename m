Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B628249A3B0;
	Mon, 12 Oct 2026 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818115; cv=none; b=s0uDcjWpQpuMtQ6LaMIxnGMLwJZK0QPCWizowJVtyPJHHL8Mn4dwP+efrT3Aojs+3vwihxZQTplhcd0HJzipFIPEGV7phPKYjJqnOqn1T6C8iWe3lXqWmlbh+zObn5HsrXRInPj8KPHG+NkJjNBRtseCOr6zlHR5xaRItMVmFkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818115; c=relaxed/simple;
	bh=quXu5g3xwX/9R7BPe1EkspmVxdG3riwyJxYedQPwfTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QqV9ctKyNz0OdzWY+gMIkqPtGg3E0b9cRPbyPI+rwDNxj4SXNob05Oxzk/3yxJCHFFTBIpupPqvTNXyJMY+Jt/aBN9N7F5aKU5tDMwKFKhwd3ObSeNQ0/2p3zQjyFYt1dYoi33gF53Ncn4xFIKkpD/++3wsmzecMdReYN+Xg8UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hYIqwudw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hYIqwudw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C7CEB1F0089B;
	Mon, 12 Oct 2026 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818113;
	bh=quXu5g3xwX/9R7BPe1EkspmVxdG3riwyJxYedQPwfTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hYIqwudwhfJL97Gx98x+Y7QtAVQZ+yCTC8JDe8j7vDf9rbmMU3PrbQ+zVzh7xY7FD
	 VCLXj9VPvLp8wYpsaAevp7O3M37T6tRWz0mF1vD76heuQGOrLbkITmTcweGh0mNpCT
	 0xqq3Y9azducCXrdXR3ZaCvbLfWQLF6X+fuyGZEwHuMR9VN9misWhwUZoN88yxElbv
	 9Fjr9p5hIA3IvXYp9EqRmE6dLUPpy6jUweJh3vHRlUGOzYEMdIGO7/h5zw3RixwvdB
	 /AXpJTpzpgjNX4eMfFxWSDacGSLlYQE57VAbdhAXjM5U4LwK492aLkKkWHVc2Xh83F
	 qEoivrZ9iy7ag==
Date: Mon, 12 Oct 2026 08:15:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: reattach dquots after changing inode ids
Message-ID: <20261012151513.GX2705364@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
 <179151614707.3163896.4351468047280563575.stgit@frogsfrogsfrogs>
 <aszWFcgPtr5cFKdT@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszWFcgPtr5cFKdT@infradead.org>

On Mon, Oct 12, 2026 at 05:44:05AM -0700, Christoph Hellwig wrote:
> Sashiko still feels unhappy about this one, and the complaints look
> kinda legit.

Yeah, I fixed the complaints but then forgot to resend part 21 last
night because yeah. :(

--D
