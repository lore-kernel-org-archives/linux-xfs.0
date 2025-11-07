Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9D61F790F
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 12:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762518620; cv=none; b=oIOxDB3KHvk/C9ognf61x0A4r1mwagwBhfoVySmJNNeQD770IW/c8IhSkfb/YcWgFyxdsrcF40MgWujAfbfjtCEplDB/6vQ90AVt6OfB48TyVBhno/49cIvI7oquLIsKz2DkrRWXGcTOFhbQa0ng+19bsbmHKM8VmvVX3GjaqcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762518620; c=relaxed/simple;
	bh=MWsTwzm03+/oCpwtY0vTYoOk0lyjLomqe3yB39/8lD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ALbzCsJ2C028CMLR7f/3XDWnp1tv0WoK3BsYRnYlgfQGTmgsc1sxqZwwKGEmD4KTfV9nLTBtbDJIvmzOzzCiEyYg56pAx4LtiJAycd/OLrweOZLfBBd4SQF6OJbly8qAAQS7qGc0SNZYbmrx7ZKnBgpKzqyLQA7wz2xldKIQHjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HrQyHYAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HrQyHYAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D91C116B1;
	Fri,  7 Nov 2025 12:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762518620;
	bh=MWsTwzm03+/oCpwtY0vTYoOk0lyjLomqe3yB39/8lD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HrQyHYAx6DPim0HR49PRF0RLuH6uvjrEfyEUw8WA90cCedTtfsjBtQiMJTWaajUGI
	 aHS48Yn2KRYmPJMsh82Fb1gY9HxF16y7qpmmo+Dy+Jlie3rOMBnon2pLW42kQ2iUwC
	 VbpnaNCLhb5HPTPAgqwKD+5ox54LBWBNYADd7xCzpixOK//V5uwtIt2fbXqZWJPQ5c
	 JseA1CoTKnVFeUweV7okf9ql+qKCLC/kHpK/ucDpO3+o0TcGK2R1ysWuv/ImbWNSCr
	 ccCpeZR46+g1MhCJWfynHUnzZhhz0LjDMGZDh1zGTLrbEbNXN8P7sXyMSgilxzXcw8
	 /iT97eSPrUgGQ==
Date: Fri, 7 Nov 2025 13:30:16 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: generic/648 metadata corruption
Message-ID: <nd4auwcopw3bjekjt3vwvo7qtu5lk5v6rhicu5m6ecs7hnkfjb@ay3p5t2niwef>
References: <gjureda6lp7phaaum3ffwmcumu5q2zisatei73o6u2mgvohkkk@n2i2bwltxjqu>
 <crUm-8CoX1u2T7Sd22l_4aXhHfQ1QTe19dEtHfNmvmeLL2e67ovBaOz46gkyOr4XYbcMg3YObr-1imbbaltPFA==@protonmail.internalid>
 <aQ3ehsu2NNNsjVQh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQ3ehsu2NNNsjVQh@infradead.org>

On Fri, Nov 07, 2025 at 03:56:54AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 07, 2025 at 10:42:21AM +0100, Carlos Maiolino wrote:
> > Hello, has anybody has found any issues with generic/648 recently?
> 
> I haven't seen anything like this so far.  I've also not tested 2k
> block size any time recently, though.
> 

Thanks. I've been running g/648 for a couple hours already with a big
time factor, but couldn't hit it again. I just restarted a full xfstests
run, will see how it goes.

I didn't hit anything like this during the 6.18 cycle, but yet I
couldn't reproduce it again so far.

Let's see with a new, complete xfstests run
