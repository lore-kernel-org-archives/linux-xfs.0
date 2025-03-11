Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14F719E975
	for <linux-xfs@vger.kernel.org>; Tue, 11 Mar 2025 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741716824; cv=none; b=mDFsnx+4xXf82gw+lkjCJHbZi2s3xSSPpDsyWAj7Arw5EotSh4m9O0m+Qkp+kYXm7pUCOXTtRKgop+vET0B36TVBD86BP8/baCJjI/fWNo2cQGEhfqvXvjaDk6ffTk/KiiO+wT4/HvVqEUdki6fkyZvWyStuNeUWkANE7pvRDQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741716824; c=relaxed/simple;
	bh=xpVSaVjm99oJvI4/bVpRFGni8u1uxdvIroB3L0jiYdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NKRjBtRftLR3lXr2LHpontnvh7+GTPE8U8AzFldfepceGAf1Kkj2azRYX10lmYx7/b9GSJ8lD9zZshJzyQq2uAG1ayV3SNozZiXC8+ejzMRAB1TcCznY3A/tXUwejnpXKbFJriqyFbuskMHAy6nEvFjCUYqBSsjJyflyEmhUXAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sIZlARgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sIZlARgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405E0C4CEE9;
	Tue, 11 Mar 2025 18:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741716824;
	bh=xpVSaVjm99oJvI4/bVpRFGni8u1uxdvIroB3L0jiYdk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sIZlARgDnbF9SQLjYet5kIGKGH+3IFyKzoj6k4LtC0K1rrfNZd7uBEMGRLjGdZPgr
	 0Lk253wmMpl6dihOB7bdOE2B8/spOAXoFKkwh8lhpSOeZjxWFh8Fpq9cJm6hw4bYT4
	 TLsNxSKjbh5XO2KiYsKzH7Aw2g+2vB+jJUCXwBSHd9z3cnHbbY09eVHRQH3IjxzEIo
	 hHjcQWLJe0aBZJXy3/fLuBrhq+XtDc7KNMSUC52E7Eep6pUHGGnXQHY0l9kPgWM6yR
	 FKl3JN/Smup49ybttqh2YD5n/mRDayUG8MO1nUz5LpUrOFWe1rJrhN/w4neVFuaOmO
	 e0Cxej2CyOyAQ==
Date: Tue, 11 Mar 2025 11:13:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: Is xfs data inline feature merged into linux upstream?
Message-ID: <20250311181343.GC89034@frogsfrogsfrogs>
References: <20250309191708.EFCF.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250309191708.EFCF.409509F4@e16-tech.com>

On Sun, Mar 09, 2025 at 07:17:09PM +0800, Wang Yugui wrote:
> Hi,
> 
> Is xfs data inline feature merged into linux upstream?
> https://lwn.net/Articles/759183/

No.

--D

> 
> There is yet no inline feature in mkfs.xfs.
> 
> and shan.hai@oracle.com can not be sent to now.
> 
> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2025/03/09
> 
> 
