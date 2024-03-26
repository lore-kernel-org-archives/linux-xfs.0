Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E9E5788E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421688; cv=none; b=C2OctvHPXDVMyWsTQadzTbQ3q/e0+sZFFBgCYD5O2WHz5VXFQIWYhqQeg7d2AfknXAsBDQCtiPTCzTm1dl2muBdOzxEZMVyGWDp4EmJcabio1wZZ9F5yv0X223nc+V1pEL0ZEv9IRVF3ef6lOOHc5VuZFqds1OU/TJhsM31c/5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421688; c=relaxed/simple;
	bh=ziodtBO2eGTlMLo9BPN4StM3FbaW8CkZVm94cZIx860=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIlHLkHqXwxqj3RB3uAXYgm91V5D1zLGxCt0XDpFeJbN7W72tmvJHKAy4OlC1Lxwq8k1DvmNtwa6sC+tzcKfKyJUU+rtXrxfwhQhUtJOh9ZrNM+PD3jG2ZKUtKotDmuQP9KOcWReavbdfMYj26/YPjrh8aH0USb4qptOXOcr944=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ON8kppbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ON8kppbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90435C433C7;
	Tue, 26 Mar 2024 02:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421688;
	bh=ziodtBO2eGTlMLo9BPN4StM3FbaW8CkZVm94cZIx860=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ON8kppbr93pjVf9+MPlBgsBvKAQj23WQGbgKok1FeQxBZUUs30j0zBm7R9nNLL+a8
	 kWwtrLE6/OYm9yGYdEsTjOmWQHh7ZsKx3+68fvlipAgjSwuoMoDvrTkpjbPfVkD9f6
	 8quliWVwKmv7JPc6cYg97tFbv6UsP+szIfAXx9oDEyC6UPdEL0vEMUbVHBQxGidkZd
	 g9znUdRY5aLjCk+/Si5/H8F9+EbKZMQvY/BeSWVkb41kc+3MymK7KrT62WpLXlEQK0
	 oSs8vClxQvtwi7bym5xhJ68gGHadm0f/DncCT0QGbwE3itDxE0oNFqQbEZ692T66H5
	 u5IUg3L16h+lA==
Date: Mon, 25 Mar 2024 19:54:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCHBOMB v2] xfsprogs: everything headed towards 6.9
Message-ID: <20240326025448.GF6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>

On Mon, Mar 25, 2024 at 07:45:49PM -0700, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Now that 6.9-rc1 is out, here's v2 of my earlier patchbomb to help us
> get xfsprogs caught up to 6.8.  There are four new bugfixes for a 6.8
> release, and I've added my libxfs-6.9-sync branch + all the 6.9 changes
> that I've queued up so far.
> 
> Sorry about the giant patchset tho. :(

Unreviewed patches:

[PATCHSET 04/18] xfsprogs: bug fixes for 6.8:
	patches 2-5

[PATCHSET 11/18] libxfs: sync with 6.9:
	patches 88-90, 92

[PATCHSET v29.4 12/18] xfsprogs: bmap log intent cleanups
[PATCHSET v29.4 13/18] xfsprogs: widen BUI formats to support
[PATCHSET v29.4 14/18] xfs_spaceman: updates for 6.9
[PATCHSET v29.4 15/18] xfs_scrub: updates for 6.9
[PATCHSET v29.4 16/18] xfs_repair: use in-memory rmap btrees
[PATCHSET v29.4 17/18] xfs_repair: reduce refcount repair memory
[PATCHSET v29.4 18/18] mkfs: cleanups for 6.9
	all patches in these series

--D
