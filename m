Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63C44B488C
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 17:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791824576; cv=none; b=rpaXhVuOXoDFAyTdhuIKqT18T7bOYSYv7cOqD8ukGNFGu/Njr/NUIx9LBUuGyRatLb3HCFQwiSn2fcKrBgALwaPjg/wHqiQTnpq87l+XwGxvmV8sCpuzunybOuO3qFa1qbdZIcQhkAF6169k/TMcXN04gbDy43RxhaTxRE1MwTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791824576; c=relaxed/simple;
	bh=Z+KN34fF0wrk/SSkvNTwqU3wjE6KR3Eo+fwi0J34LCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VuSME1UghMjK0Y2vgvEGGHuSYUuvwMWJQ8uhAbqCc/pOxJh5ciS1ZEMQksxEMz28GTSjrqh1jN/EfxL7Apcvqs9+Vm4cUYlikCsgMUx3B/8Gl2Y+q7/Mt9wrmuuFjr8z9gRLuDGuMJjRNHYxp+YbCL4g77f/0n8JX4QzhhmTdNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FssJXB2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FssJXB2N"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6F9601F0089C;
	Mon, 12 Oct 2026 17:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791824574;
	bh=XF37NvpjjCW+QGlmBm4c88+gmML4lMjMWEw1y2YKxlA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FssJXB2NpVHeO8ZhLOkTBy7g+ghOhFSQzNQOyvaF7c39xKaSmlm8mvJBkFEzK3vR5
	 YQXOBdSOhZW3ohg5Www3zRndmpykyCS4rtxjBShFL32JZorIMgMTVLPdkUwBxryDYs
	 Q1EN8/OrprOwMyVDKh4kzlXA67cL00MrLyfFQCe0Z1+Bh5G2AJ2mA/NRfxJa7spEeV
	 4kaT3hTytiicgcxJwP4PD33ZZp6vi80Hd1djy96ER6sxtjDXhpmaPy6jDh4Kox7Kdz
	 MhEIg2/uBssE3Vu9kOnOHSbZ82zJ5skqa5WXmLLJ5blS6cCSouraOrB1NxQ9+GB7Fz
	 umDNkjB5kpN9g==
Date: Mon, 12 Oct 2026 10:02:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: bugzilla-daemon@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Bug 222081] xfs stops if link count is to high
Message-ID: <20261012170253.GE2705364@frogsfrogsfrogs>
References: <bug-222081-201763@https.bugzilla.kernel.org/>
 <bug-222081-201763-BHNfDsTdYa@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-222081-201763-BHNfDsTdYa@https.bugzilla.kernel.org/>

On Mon, Oct 12, 2026 at 08:01:01AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=222081
> 
> --- Comment #9 from sachse@gmx.net ---
> I found option -o, but I think you need the extended attributes.

Yes, omitting -o will obfuscate names if that's critical for being able
to share a filesystem metadata image.  It will also pick up (and
obfuscate) the xattrs, even for parent pointers.

--D

> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
