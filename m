Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EB738E8BB;
	Thu, 15 Oct 2026 14:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075661; cv=none; b=BAxrfol/em/x8FF7aTodOUibFeCIcxVA9u2Mh1F/XXKK4BXC9ul/FKyhyK8+nCx3PRKD3I/KyrGlysSnwHvmtX7c9FGLPqrNNd77WlFyZnIn4DWdj/ajqYERIXM4LIT/+oD5O9P10Lqlh4lGgXwT0mCj5fKA622QJOn8lrf5qsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075661; c=relaxed/simple;
	bh=uabN2nTNMwW2/AtmjI3NGMYalD1m4KkQ7Y20wTd+WbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4Kd6rWFHQAbr3j70IwJ0dFOFepGpHj8H75q3AwCAyW0s6iNkrkluISzsEZf608dY2KhVk6dXW5xhXyV7t44zWTJge+3Z8p4THbR8p3v6MCLLEZq9pcxOc9zNMXP5CXP38F77sn8PkqBSPzVXUEYINTEtXABiBRdbGd+lof4rrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+jkkhe8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+jkkhe8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B4D651F000C4;
	Thu, 15 Oct 2026 14:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075659;
	bh=bSjP+UwpqI+NS6EYzoasfsRbPYfhtVuF7WeVV1iya8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R+jkkhe8mJx2PWYeZQ1Tzvb8YXN2x89CcDuzircDoSFMLNhL7YtL6YqI/I0t0V4Ni
	 BGsFqf8tO5ks7k+Q6MJ63Tw2Mst6mALgR5URfdxcbAmierwAqGYUfkAXyi2Vkndjc7
	 mUkFjAwFTX9cWailBV4rh8Ttf+MBmtnQRCZrpSqLlFyJ1FE4M3q5ZoHLLVyrkY8vBP
	 G0ItIYq52eAum97tTlvbs+zNXoKeqEJLEHIjDJ6J/Kyu8EvDpMfZuVQvEvbGc+7vvI
	 vXuZU1ffevSYrq0CThwHiMU3rh3Db5ny2dIrKejUwyfj56U5wX4gWeYmyzE+sB8/BK
	 rBTPoyULdMYYw==
Date: Thu, 15 Oct 2026 07:47:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"sashal@kernel.org" <sashal@kernel.org>,
	Mark Tinguely <mark.tinguely@oracle.com>,
	"dchinner@redhat.com" <dchinner@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 5.10 v2 00/19] Backport of XFS umount hang fixes
Message-ID: <20261015144739.GR2705364@frogsfrogsfrogs>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
 <f6316f9f2422d54cacd75e20a79503638b689e72.camel@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6316f9f2422d54cacd75e20a79503638b689e72.camel@oracle.com>

On Thu, Oct 15, 2026 at 12:54:37PM +0000, Siddh Raman Pant wrote:
> 5.10 xfstests_xfs:
> 	Generic:
> 		Ran: 001 to 771 (661 tests; gaps)
> 		Excluded: 738
> 
> 		Failures before changes:
> 			Number: 19
> 			IDs: 083, 091, 112, 127, 263, 269, 270, 363,
> 			     365, 373, 374, 681, 682, 700, 733, 749,
> 			     753, 754, 762
> 
> 		Failures after changes:
> 			Number: 19
> 			IDs: 083, 091, 112, 127, 263, 269, 270, 363,
> 			     365, 373, 374, 681, 682, 700, 733, 749,
> 			     753, 754, 762
> 
> 		No new success or failure after changes.
> 
> 	XFS:
> 		Ran: 001 to 789 (281 tests; gaps)
> 
> 		Failures before changes:
> 			Number: 15
> 			IDs: 019, 082, 104, 144, 179, 270, 300, 348,
> 			     442, 514, 515, 533, 597, 598, 609
> 
> 		Failures after changes:
> 			Number: 15
> 			IDs: 019, 082, 104, 144, 179, 270, 300, 348,
> 			     442, 514, 515, 533, 597, 598, 609
> 
> 		No new success or failure after changes.

Looks good to me,
Acked-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> Thanks,
> Siddh


