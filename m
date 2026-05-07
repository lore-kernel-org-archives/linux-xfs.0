Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801A1175A85;
	Thu,  7 May 2026 20:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778185265; cv=none; b=jf0bd8HhjKxJS27n+k7SXUkPexm2Ag1T010v5BoWqHz0tlHQg2z1dKjN9cL6Zwi8EsoXa5rQRqUKS/+DLLi+A8fhE8fWqJ9qZfMGuBckFY5ZaoEK7NQAU2knD+u3EFC7lK5NJfRSLpt+V9kYlzKKx02n2mmIJ4kPzPDiRdzdk90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778185265; c=relaxed/simple;
	bh=tD8py6U0e7L6UhPQPJi5qYuBjRmS263KJiaioSan1ks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IP9n4CYmMATeP7+KZftI6To7xLvcAc4hha+fzgez+cIGTRsFqYOXf+aP/sKn8aWX8w2IqcyjhcpQfWGzgo5EjTA/jFHRWhX0YkO9Tdd41gJw0q8gUday2hVNsIpBBvsRCURYLiqKTDZTi01JUTB9/DcjV++KyVqycw8kw3STbkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpMDx/Pg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpMDx/Pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6557FC2BCB2;
	Thu,  7 May 2026 20:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185265;
	bh=tD8py6U0e7L6UhPQPJi5qYuBjRmS263KJiaioSan1ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dpMDx/Pg4TmbJr9ZvqT7t7ldaFhuiW081o5nuciCK9xQ7dymxSwvb8z8wqwyAFig2
	 ah9M+A7BrMaMAc8ifD6XVmWvEqZSJl6qu3Vi4Zaubm0kqdvhwvAX9iWVkEQGWWsybr
	 Y+r8K24L5K4Bel7pOLLRW9yf6AwpP5Y5H62D2EWGO6rVLdkSAcsVmJUW3cSwuO+SEv
	 oy2sqcduu2boXuTT0ZqzUOlLX8oTTS1nMhF1pZw9jt8J/Eb2P4Vwis0lJm49SoTdNU
	 ovNEF9GhIo9Af3/qQ77T2D8Ul9PM3inRTZkzBzI8quZPppPfvkEL46eQIwEIWoJJ3z
	 kO4/eHHQzubxA==
Date: Fri, 8 May 2026 04:20:54 +0800
From: Zorro Lang <zlang@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: fstests@vger.kernel.org, xfs-list <linux-xfs@vger.kernel.org>, 
	ext4-list <linux-ext4@vger.kernel.org>, btrfs-list <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] check: add new option "--loop <n>" which runs each
 test multiple times
Message-ID: <afzyQgqrhZEtMcc0@zlang-mailbox>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, fstests@vger.kernel.org, 
	xfs-list <linux-xfs@vger.kernel.org>, ext4-list <linux-ext4@vger.kernel.org>, 
	btrfs-list <linux-btrfs@vger.kernel.org>
References: <20260415213248.1795275-1-tytso@mit.edu>
 <20260505133409.GA49070@macsyma.local>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505133409.GA49070@macsyma.local>

On Tue, May 05, 2026 at 03:34:09PM +0200, Theodore Tso wrote:
> On Wed, Apr 15, 2026 at 05:32:48PM -0400, Theodore Ts'o wrote:
> > Teach the check script a new option --loop, which re-run each test
> > multiple times.  This works very similarly to to -L, which will retry
> > a particular test after it first fails, except that the test is rerun
> > unconditionally.
> 
> Ping?  Does anyone have a preference between adding a new option,
> --loop, or changing the heaviour of the -i option?

Hi Ted,

Personally, I feel that once we have --loop, the existing -i starts to lose
its value. --loop is far more effective at catching specific, flaky bugs due
to its stashing logic.

Furthermore, if we eventually add something like --loop-while-successful, then
-I also becomes redundant. It might be worth considering a more unified naming
convention in the long run, perhaps renaming -L to --loop-on-fail and keeping
everything under the --loop-* family. This would be much clearer for other users
than the current mix of single-letter flags.

Welcome any further feedback. Also, feel free to weigh in if you have concerns
about the potential impact of renaming these option names.

Thanks,
Zorro

> 
> > This differs from the "-i <n>" option, which iterates each set of
> > tests <n> times instead of each test.  The -i option is problematic in
> > two ways.  First, it doesn't save the test artifacts from each test run.
> > This is unfortunate because when the developer is trying to debug a
> > flaky test failure, running "check -i 100" will run a test 100 times,
> > but if only the 42nd test fails, the NNN.out.bad file for that failing
> > test run is not preserved.  The second difference between --loop and
> > -i is the result.xml file is rewritten after each test set, so we do
> > not have the cumulative statistics of the 100 test runs in the junit
> > XML file.
> 
> 						- Ted
> 
