Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C356515444A;
	Wed, 10 Apr 2024 15:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712762161; cv=none; b=FbyjovreCzyp423UWuUYuj/eWDnZS8BVK4f6OJeOOwmAB03sOPxlAeuY+bgt7lNV5f+1S1pUPtCj6QfAqZjKmZn7m4nCVdNsCN8JHvq2bcocuDnWFtd5nWpF+/K/Da5JNhdxdJ+YF8cWzcB6VzAwcYATmf9E7ABZB0lK23utO+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712762161; c=relaxed/simple;
	bh=o/ajN8fd9Y9XQ2N2GNLupffRWiyq9HCNocgVwRN5H5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZC4+YTMZUVoZYsR8POVWn7H/V0x4m7elwqzamggXSh7sKXeaUb9kvBdJd9eZjp9Iw3yNo7kiPEy7fs+MJTcW9mnxRt3HywfLePLEBRpfMebQ6gEL5cZ6u5icMoH9iyEHY92SDCd54BCLIDt0rSZbD+40aHW1q0muqp+h+TIVarA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPt1dese; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPt1dese"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4325EC433C7;
	Wed, 10 Apr 2024 15:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712762161;
	bh=o/ajN8fd9Y9XQ2N2GNLupffRWiyq9HCNocgVwRN5H5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YPt1deseP8F3/bfy4Wn33h8vd+eUgzxYd7LJzIl9B/OcskMzASt4+/WduwPH9YdNr
	 IeVW4vvI1eTOt9wrFroHIy670XOXXOGzMizCLWYhpiaW9HV2/gYIqbde8ErucjRGTQ
	 YCWn7IHZRalzKkUUMYJNJnPR+Lxc6PuJgMOI2g49GXkDwGdPYZOQlc56gew5MwS7zE
	 eq4RAU/TO1n2RghUnP2lD+MHcEULj+9fiEeBVPf0uTLFt9ofR7SBshOH8zCWvw1/y0
	 A08LO2hltFgknHFmLJSNode+ApODj8+4CxScQ8Zwpe8Ii8K/nffhhjrwpZ/0V72em/
	 Er0uUYGWzbhxQ==
Date: Wed, 10 Apr 2024 08:16:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: fix kernels without v5 support
Message-ID: <20240410151600.GV6390@frogsfrogsfrogs>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408145554.ezvbgolzjppua4in@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240408145939.GA26949@lst.de>
 <20240408190043.oib4lmiri7ssw3ez@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240410144254.iiqrxlm64xc6mqa6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240410145140.GA8219@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410145140.GA8219@lst.de>

On Wed, Apr 10, 2024 at 04:51:40PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 10, 2024 at 10:42:54PM +0800, Zorro Lang wrote:
> > But as the review points from XFS list, looks like the patch 4/6 is better
> > to not be merged, and the patch 6/6 need further changes? So I'll look forward
> > the V2, to take more actions.
> 
> Maybe you can take 1-3 and 5 for now and I'll rework the others?

I second that.  I'll deal with xfs/158, 160, and 526, but the other
patches that were ok could go in.

--D
