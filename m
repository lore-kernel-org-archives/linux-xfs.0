Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5313BED79;
	Fri, 16 Oct 2026 22:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792188609; cv=none; b=D6J1u01iEKUdJKe2c2r89j6EUtpPk6FUKduYNOIAb+jedEI8+V2Vxn9otYGgVeGMk+vsAGTNr9qVQGtA1uv06rpMMg3HKPFZMnbs5bbvQgwpSHCyoeXWupqwAD99bA1V9MsMh4f8RHTAFgdGCOoYJlp8Lmwwv5Wvr2iOKV+MUy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792188609; c=relaxed/simple;
	bh=PUD8UwWjmwJmZshSz4XnJZgT2rzoExreslpkDDppG4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oNJKE8FhwSyyAQx4ZHHhsXo6RmWBa6pix6vdGaVifqH9T/t1IYan/QSvupYtO0Yq0cLYCtrpA+KO7T3RJ9Qp5G/vuV4pziw1iJtbFZMtoz2SiTMrns4IsfsVp7Uz0uAaXFpyYXyD5m4j+03/7Y9y5XmSGRI1ri+VRU5KD/8oZ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fsE2sKyq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fsE2sKyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858691F000C4;
	Fri, 16 Oct 2026 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792188607;
	bh=8jHBBYtzI0Crwku3PKmVHLaE27//EeDFKhbudVmugYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fsE2sKyqg/wu9JGJCqGi6qsF0sQV2yRg0doOwR1ShIS1OwCCuNsCzp43zAH4ri2CL
	 U1iAJ7JVtZ8uq/cS3hLS59vpPSrz0bl1acmxBhECPMRY3fOPGeyDGQdklJio6Yh6IE
	 T20DiHMrVFsL1JcrG3iOpjXuTaSC5sQLT0pcbDk86gjcVBH49x2tA6iFBYLgwslRaI
	 Oatr69Oznn+pmv8weX2iAYra5lPCM695zw9XPYItfbbxiL32Cwnc4z1zjYIHrypDHH
	 sMKl7KBJIZjoSurLLQBY49G+PdeX+wy9rRVIaTJYbNsDNvEBpld/kka3HkpNgSzlOz
	 XF2zJNgLdC2jQ==
Date: Sat, 17 Oct 2026 06:10:02 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	fuse-devel <fuse-devel@lists.linux.dev>, fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
Message-ID: <atKgUbdG3Z4Vuj5c@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, fuse-devel <fuse-devel@lists.linux.dev>, 
	fstests <fstests@vger.kernel.org>
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
> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.
> 
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!

Hi Darrick,

Really sorry to hear the news. I truly hope that after a well-deserved
extended break, we'll get to see you back around here again.

Of course, if you decide instead to embrace a quiet, pastoral life and leave
all this noise behind for good, I'll have nothing but pure envy, haha ;)

Best of luck with everything, friend!

Thanks,
Zorro

> 
> --Darrick
> 
