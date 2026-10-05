Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D776B44F563;
	Mon,  5 Oct 2026 10:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791195831; cv=none; b=k5e0mzp8y5S/nH1JpnXXA3QdQsulrCyeVt9ZuUmLrjzAg0+4wuE0P72Vwh27JFXFHO5dKM02bYxfk9EedkLhdjutcRynWAcumUjb7VFxsMNYyYkG4cqfrF3A/eA3s56KRyOsFhXTLhwZdf12DLfAokjMjlZDwlAwVnNLZHHVz+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791195831; c=relaxed/simple;
	bh=wWuZBQ6qtT2DXHC72wp9taQfK8641jTkSxPhQ70MMJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7rdpxvycR+s679IjFkv2jOx3y0fWO4ImfKkDkZmW+AcRQjmGDHZsYymvjiHase998vqlXvGSqjNgL3hSs8jtV42mIN+zqr0wO+6ANq9VQ3eEMblt50R0ZfDFQL8iGvkSqFq2CGEbZHZh33o7hzctAnA8RTbZZW1quuNRnY6FAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obdMAmQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obdMAmQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D27D1F000FF;
	Mon,  5 Oct 2026 10:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791195830;
	bh=dq6yaDqLRNjhJJ6qmZRm7vO0/CBkMwmhcXQHVBEQaXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=obdMAmQraLlk/FFfKvCwFp+Werj5eq5SANLo0BYdMhBDLjsI86zBGKtEykBzotnlD
	 BjNWU0+EtBiS2mTOeG3/2AXxMmq+s/6BerkbWJ3EGnSiYGRoEZqSolHXNrmHup9CuD
	 uYAbM5JUKeIbIhePCXr/W44SJh/ZFLgNl7nS2bbp6aLASDHEaRJTZjRg8vtDqeyaMS
	 Dh3TMiOR6qYQ2uXkzy0qd737bWJUWxyVoeW6LeQDxYGCTNoI0wbO+nTDobJ8mJGdKH
	 UUg45bWUfyKdbkvZAzmwgNV1gEeitKURoe0YbLCDQLhEQ6gW5Rd0VFXsOOE93Msf1y
	 eVjwGk5imADXg==
Date: Mon, 5 Oct 2026 12:23:46 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Eric Peterson <linuxinstalled@gmail.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dgc@kernel.org>, 
	Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, eric.peterson@hpe.com
Subject: Re: [PATCH v2] xfs: add per-mount read/write I/O completion counters
Message-ID: <asN6bTMKQvBAVOtj@nidhogg.toxiclabs.cc>
References: <20260828033429.4070267-1-linuxinstalled@gmail.com>
 <20260902042539.4073566-1-linuxinstalled@gmail.com>
 <20260930224032.1413-1-linuxinstalled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930224032.1413-1-linuxinstalled@gmail.com>

On Wed, Sep 30, 2026 at 04:40:32PM -0600, Eric Peterson wrote:
> Hi Carlos,
> 
> I wanted to check in since it has been a few weeks since any response
> has been posted.
> Is there anything else that you'd like to explore before the changes are
> considered for approval or denial?

Sorry, I (well, we all) have been busy with some higher priority things,
conferences, etc during the past few weeks. I haven't had time to look
into this yet, it's still on my todo list but didn't get there yet.

> 
> Thanks,
> Eric
> 
