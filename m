Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DAA284B20
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422284; cv=none; b=a4Ls4EycK1jp1XgjaXqcMxl1YJW+VrCM5AVWB7QhTpoOqyeQZTrVos25/0pu9HS7OkPQ/SY5vgltwUag+K+c/qsY0TJJ7mHuaX2brMvANkFdoVfxrq5eKghkjRewfn9TjaMoSd8RqVXW42pbq4dbkMcddYjAl6TbqkUbBnD5JEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422284; c=relaxed/simple;
	bh=AlQKNVWBdQVa+yp2isWGNjAg0OBA996MZQApNs4Ig5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZ9Mc3H5PVXpEArk3woGNHakX12qGNb/6+Mfy7SH+5wrGz5+w3LLIu5zkvM/Eq+H1JrLNievQbHLolq9D0rTFC/BFJozfh9Zp3HiPFdKjlZ1qdZp1D6sAg17gHqtn1MEIdv7ge6woZceiAMZus2PY/smWq6Udga7ByzKQhVUg/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJiluoXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJiluoXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD42C4CEE2;
	Wed, 23 Apr 2025 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745422284;
	bh=AlQKNVWBdQVa+yp2isWGNjAg0OBA996MZQApNs4Ig5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oJiluoXRAFM8SeJRBAbIjkWw2lEwyadgKewOXcVrhUhlZLbZx69dJGct1dPqkQrwQ
	 a7EWjiICdGTgxzOqNBALLpopgpmcnt+DtL8RuWyis108CA12LESOqapXNL+j+plzn0
	 Y0ODtrlx4d18jO4H8CAvVb5eGzUU6UT32M3PNwVI0lkYM8GxGFBCzyB2Rqkl3kFVf2
	 nUeP+Uysvb8jWqSq5tqjtzLilSGmpZvhhOj8qSiv7X17xE1nxYSuReS6hHEYWEBA0c
	 6+JbJliKRa5T4DXo4Jlx+LmQRAD8IvzszPT5FlT4IGQbMLM4Lxf4q2u4Tk2sgkblJY
	 9QD+v2ueAAQig==
Date: Wed, 23 Apr 2025 08:31:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs_io: catch statx fields up to 6.15
Message-ID: <20250423153123.GE25675@frogsfrogsfrogs>
References: <20250416052134.GB25675@frogsfrogsfrogs>
 <aAcz6NiFfxJHAHQ5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAcz6NiFfxJHAHQ5@infradead.org>

On Mon, Apr 21, 2025 at 11:15:04PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 15, 2025 at 10:21:34PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add all the new statx fields that have accumulated for the past couple
> > of years.
> 
> I only see a single new field, although I can spot a few flags and
> missing printing of a few fields.
> 
> Maybe update the commit log a little?

"Add all the new statx fields and flags that have accumulated for the
past couple of years so they all print now." ?

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
