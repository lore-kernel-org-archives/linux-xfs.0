Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213C11DE4EC;
	Wed,  5 Feb 2025 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738777140; cv=none; b=OC1PbbOQUvL/egpcL7jnTOpBXnrxl8u4Ac1dLmYwFuH2XrfRfOD9eZWUzyDR5LWFtuWHIEXOZVHNQc5WzhiaWs6M6KqhsNuXhD26WL9StgZuqCevQ7qaeJbXGxLNgZmvSX1xfzlawDLhd47DlMu2Mwri+Wd8kHInH99YHwfnup8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738777140; c=relaxed/simple;
	bh=O/dihc7wN+JM8EfRVU2CCO3hIF5ZepWHDBEY6ecgqAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZIyFJtu/45tAw1bGNd3F88gNYL9WWjwfcMu8JbOJneTFpit1xtCo0QUhlXCweyugPBuw7nGq2fjoGHzFcAJvwfck5luLoVa4QkGdC1CijHM46W1xHAxTslTo97oXmVegKemvJERVlp+RyEVSbIRjZbpFyAfpFCio01q23sbe+2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ap0lRPcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ap0lRPcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDB0C4CED1;
	Wed,  5 Feb 2025 17:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738777139;
	bh=O/dihc7wN+JM8EfRVU2CCO3hIF5ZepWHDBEY6ecgqAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ap0lRPcQyu7BWeeePba1rS3PzyQWv7UEsV1s2RO4vRBqhYXfnEywqKgV4lrcDm0Qa
	 PqvvhLV9B0zhNGWjqRLPtqOMvhRwJ/PZq+cmNS0ohAD68/NG18uK5zAb5FTUrCyh+w
	 WiL/hxFr8cTnfBTAwQ/dlncLernzrSCEZZSJQGtk72Fi+ddM78UVNRrndgxszPwPBw
	 WI8N/1ohI1IEmTIwsiefEQiV2cn8mclr7dfkuTg4z0XqGI+/atPK4UZkkBoYT/3dv/
	 BEkgKH8IeaqojF7muTO48PzVPzrH1VBt1yMLAb6IcBNXP//Flf20aZryzD7/Xibzqd
	 tlk06JeAjPUQA==
Date: Wed, 5 Feb 2025 09:38:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/34] fuzzy: kill subprocesses with SIGPIPE, not SIGINT
Message-ID: <20250205173859.GF21799@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406291.546134.15020436171673463354.stgit@frogsfrogsfrogs>
 <Z6Kt0Khj0hF9HX15@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6Kt0Khj0hF9HX15@dread.disaster.area>

On Wed, Feb 05, 2025 at 11:16:16AM +1100, Dave Chinner wrote:
> On Tue, Feb 04, 2025 at 01:25:26PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The next patch in this series fixes various issues with the recently
> > added fstests process isolation scheme by running each new process in a
> > separate process group session.  Unfortunately, the processes in the
> > session are created with SIGINT ignored by default because they are not
> > attached to the controlling terminal.  Therefore, switch the kill signal
> > to SIGPIPE because that is usually fatal and not masked by default.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  common/fuzzy |   13 ++++++-------
> >  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> Change looks fine, but _pkill is not yet defined. It is introduced
> in the next patch "common/rc: hoist pkill to a helper function"
> so this needs to be reordered.

Fixed.

> With that done, however:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks for spotting that, and for the review!

--D

> -- 
> Dave Chinner
> david@fromorbit.com
> 
