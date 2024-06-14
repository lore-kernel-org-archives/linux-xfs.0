Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2B03D64
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 03:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718336990; cv=none; b=cFVimvbt0Zuc6Ct4zpXcPsUJWoaw2edbfSQi/KBvAxn9xCEVfFHmVuxAiV7QV5N2FkH+p9bcH07skBAy/ZsOaPLscXV4rpP2XOCdKhWtky9WVbvAA0VHrW111M9bzZ9uv068YPOWVy2LLUSyACnCU/qyZ8GyV0ewYL+jJ8mKT9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718336990; c=relaxed/simple;
	bh=O7yBUUOI1/uVj8Bi3jncac59QY8cesswVD8A1hrqLC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alqWc4GHP1aBGvqUrw1sqk79yCU07eO76iSaeceREAhnFZ6Vl5TMJ1AolM1DSUu81fzVKj3AmCbmWmqQdb5OHuOO1C7f3UJFRIwJuoJTVgfhqNfYOv7BSNd9RLSw9TJVnaIL9jtzjn5UueQFn65XNBinqO5zGKe2GthQ3vWiu98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m2GCfWm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m2GCfWm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B67C3277B;
	Fri, 14 Jun 2024 03:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718336990;
	bh=O7yBUUOI1/uVj8Bi3jncac59QY8cesswVD8A1hrqLC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m2GCfWm0ET3yP4TQtSxr9N0C2MNdZiJGoLOMR1OFtvWX2ZkBcaLMUMOdGEwNUzc2y
	 YCn7uZOVkiLT9qb/3zP0/TcqXtDachMPezciGeXGxmyz526UiLB6tYmoTrp/uvvgRG
	 icFm31SjYY57+AKWasM6EOoNB4Sd0Ld53dTpwVJRvir2mnBxoJ2W/KN5Wfwr4Ig8cq
	 OcCg6ShLl0fojLEmS5ZKNddxNT+CucRPeU3u0uFBXNHpD/XpdDqOYwkmzGEoeC1EIX
	 fyc4pH37ol5TxiZGMJ9UxS/2FFa+YzfRHztNsBD3b2YqOKSXoSaTO9iM6B+/ZUWRuK
	 3lWwabEPPSRfQ==
Date: Thu, 13 Jun 2024 20:49:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: verify buffer, inode, and dquot items every tx
 commit
Message-ID: <20240614034949.GA6125@frogsfrogsfrogs>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
 <171821431846.3202459.15525351478656391595.stgit@frogsfrogsfrogs>
 <ZmqaDwbXOahCAK1v@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmqaDwbXOahCAK1v@dread.disaster.area>

On Thu, Jun 13, 2024 at 05:04:47PM +1000, Dave Chinner wrote:
> On Wed, Jun 12, 2024 at 10:47:50AM -0700, Darrick J. Wong wrote:
> > The actual defect here was an overzealous inode verifier, which was
> > fixed in a separate patch.  This patch adds some transaction precommit
> > functions for CONFIG_XFS_DEBUG=y mode so that we can detect these kinds
> > of transient errors at transaction commit time, where it's much easier
> > to find the root cause.
> 
> Ok, I can see the value in this for very strict integrity checking,
> but I don't think that XONFIG_XFS_DEBUG context is right
> for this level of checking. 
> 
> Think of the difference using xfs_assert_ilocked() with
> CONFIG_XFS_DEBUG vs iusing CONFIG_PROVE_LOCKING to enable lockdep.
> Lockdep checks a lot more about lock usage than our debug build
> asserts and so may find deep, subtle issues that our asserts won't
> find. However, that extra capability comes at a huge cost for
> relatively little extra gain, and so most of the time people work
> without CONFIG_PROVE_LOCKING enabled. A test run here or there, and
> then when the code developement is done, but it's not used all the
> time on every little change that is developed and tested.
> 
> In comparison, I can't remember the last time I did any testing with
> CONFIG_XFS_DEBUG disabled. Even all my performance regression
> testing is run with CONFIG_XFS_DEBUG=y, and a change like this one
> would make any sort of load testing on debug kernels far to costly
> and so all that testing would get done with debugging turned off.
> That's a significant loss, IMO, because we'd lose more validation
> from people turning CONFIG_XFS_DEBUG off than we'd gain from the
> rare occasions this new commit verifier infrastructure would catch
> a real bug.
> 
> Hence I think this should be pushed into a separate debug config
> sub-option. Make it something we can easily turn on with
> KASAN and lockdep when we our periodic costly extensive validation
> test runs.

Do you want a CONFIG_XFS_DEBUG_EXPENSIVE=y guard, then?  Some of the
bmbt scanning debug things might qualify for that too.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
