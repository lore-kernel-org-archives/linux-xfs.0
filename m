Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E1112FB18
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 08:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709023615; cv=none; b=lCL7BJRAXnTV5E2CC3gK0///HyWEwVMtES64Mc1Yr+1yd1PAoYwr3T5YNRW/NDRlxQQy8hegxGoyXdkNM4V+fydAyKHo3FySFZH+r3sNWaznyFdSyIvD7bG2F9ZfvsELduEEVpLv9yXLJeSsmAvyNHpvgiMwu3+HHCj6DLx0m6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709023615; c=relaxed/simple;
	bh=ueICFioNlW/vmsb1NBszXYP9xMaMQc7iK3bKdzMObvw=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=O+mW4bxDNo/WRnJPH8ZVQT35qWpQQY0gfpeHjw0Yp5GszDNrYuErWvLVVNj13NCMa4YnSURHp1OSlX7H/Wu4Y4RZ9NDKdiuTpKixjJmzoozIOYyDyO1TohISXgnyhm/e5czSz4gzY40qObMvddFpyiIijSuNttUQPfrI8OxGvso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EThIMngm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EThIMngm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEA5C43399;
	Tue, 27 Feb 2024 08:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709023615;
	bh=ueICFioNlW/vmsb1NBszXYP9xMaMQc7iK3bKdzMObvw=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=EThIMngmRdHs05R9jG7k9DNtmDUSHoKxY/hyDj/jdvQUrz6x3cp4mhSIzgRXZGj6X
	 K0lq/nl+EoK7HDQulz4Rs0oQNSrOWMIhoWsk8SUdOECCIZnPfa3cQzici1FmL76QRp
	 mrjUkagplqxGcLjmSVyTx1ntS00NbTAcZI7xHS3wzyo/RnurjfQ8IlDTLDU0KAXxtL
	 m5O4qm66d/NIXqJuffJgGBO9R964nMCneeRyHY0B6WYM1s/Fe0Ix/Ok9gqfJF19k0O
	 8aewLcp8SEy1GPX/EogHShvurJi0Y680YRn1wrpQ8dEg5yQW+eGmBuoQuHYeM6VdNy
	 ja1RD5Pi9j9tQ==
References: <20240227001135.718165-1-david@fromorbit.com>
 <20240227001135.718165-3-david@fromorbit.com>
 <20240227004621.GN616564@frogsfrogsfrogs>
 <Zd1QhmIB/SzPDoDf@dread.disaster.area>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: use kvfree() in xlog_cil_free_logvec()
Date: Tue, 27 Feb 2024 14:15:03 +0530
In-reply-to: <Zd1QhmIB/SzPDoDf@dread.disaster.area>
Message-ID: <874jdul2f8.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Feb 27, 2024 at 02:01:26 PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> The xfs_log_vec items are allocated by xlog_kvmalloc(), and so need
> to be freed with kvfree. This was missed when coverting from the
> kmem_free() API.
>
> Reported-by: Chandan Babu R <chandanbabu@kernel.org>

I have changed the Reported-by tag value to Darrick (since he reported it
first) when applying the patches to my local Git tree.

-- 
Chandan
