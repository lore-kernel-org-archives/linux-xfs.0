Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974374E4C2D
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 11:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792410138; cv=none; b=aP/aK5onyjJxYvw0LvobJX6JryojNgyyOHZ1HW31s8xigi1Pyl+0RybWpTMxZy70HNPJ/W3SxQ4qBI8qiqOu0wAaGxMd29AEQf3lTW3ZuKQ91t8WUlFHXcE1zk/74QV2MsH+1KfoGCGl7/RFdXZi1bhPQvKFTOggp9SSfkoaWtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792410138; c=relaxed/simple;
	bh=KFm12keBM4ZiHGUH54ySLgTMy9yf6j2gcebjLhj1UTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PmCsEaJZROXjEGQ6aXt38fMCAIBYfTaIaHk6W8Y5m8jxWmp5yC77Yh5sNi3bYwEbIcNRffBRgxqE8IFOjbxJqCDOWOfhZHIztQqRFQ/rRfebZ6Hgev5iub903/Hws2ZhvSoDcJuIPFTZm2jbjTcNvKGR8ClWSSem+vS9BHEWUrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qf4pVrq9; arc=none smtp.client-ip=95.215.58.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qf4pVrq9"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KFm12keBM4ZiHGUH54ySLgTMy9yf6j2gcebjLhj1UTM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792410133; v=1; x=1793014933;
 b=Qf4pVrq9oLYsiXzrSWYNSU7jTkRLEGk0PfenWKINWyugkYkJ/kJwZ+2r47B/unkSlfMTWGa/
 oiKh8ru500lcjvjKv5qaihvOSSXoyXVYF/kTZ19hxZn7gWbZenTlJMQng+NH4P6TkK14d9G/0P4
 xAEm9v8nRP51DNInS3GO2jBo=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6a4e5febb37f0903;
	Mon, 19 Oct 2026 11:42:13 +0000
X-Mizu-Trace-ID: 6a4e5febb37f0903
X-Migadu-Flow: FLOW_OUT
Date: Mon, 19 Oct 2026 13:42:00 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	fuse-devel <fuse-devel@lists.linux.dev>, fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
Message-ID: <atYAnu6wfblHw4LG@quentin>
References: <20261016160037.GA107919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>

On Fri, Oct 16, 2026 at 09:00:37AM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.
> 

Thank you for what you have done in the kernel.

I hope the break gives you the energy to come back stronger.

> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.
> 
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!

We will miss your practical decision mindset and of course, your witty
comments.

You will be missed, Darrick. All the best with whatever you do in the
future.

-- 
Pankaj
