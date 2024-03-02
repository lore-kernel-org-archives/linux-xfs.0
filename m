Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDF13E46D;
	Sat,  2 Mar 2024 19:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709409111; cv=none; b=pLnxk9RyrsDvy+jgLZLV1aYzxz7A1otwUziOVuBkH10d0kn8iKd1nxtEMLjx+LJI3AyzuG4cDXWawmr1HRQHxx54w+QTNPuN0tkoYEDcBFcRwiyenbKweIa6RXYVXMlX8L0WZkYgK/QpB2gmdFWnwwsRFrRhdRMaNHaRBngPtJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709409111; c=relaxed/simple;
	bh=IPzPH3l6hYEFKcyM8LrHXierWjIrEvvh4J4tKJfl1hY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXEODFwKg7PNhDx0i4IBd0TvOTgOnE+FJkTkUCDKbrlXwR/e785ZFR7t1jkp6KDj9I3UlXsjD018YD8aLS3LleEHRiCwt3N2stSl0rT0eBKIIU/WcY0U6L9BiIbL6At+IvabBtlXv8eXCl6INLmL/yY5kVGLY5EqY2kMWV021D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZAcXkgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZAcXkgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5CEC433C7;
	Sat,  2 Mar 2024 19:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709409110;
	bh=IPzPH3l6hYEFKcyM8LrHXierWjIrEvvh4J4tKJfl1hY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MZAcXkgn/Qm+UxjqmPvDZtkDX0VaO1yGeNfpsA/ghKZKQ0GIVIbtnpNR9xTjldwRt
	 FP579Cr3LJ4NX8hyxW8k5aXWwteUoywK5sWVzg3n5jZty4zyQtHmuVXzI+8+Y433fx
	 Erfj6gaiO3YZS30kB6aZmuUqDOKuRFDgoodA/o2G2dXpmAETM3O5IizZHYTu1ehnFd
	 erXJXp+CVH3UkgRATNJiYbuHTu+LBA5E5YlGBPSyuROPbw6mc9RVKrvxcmZ91l0hw2
	 tTjzaEuEtEaHCz3o2s0+enAnjjwGnE+i+ufjnvZr0v2S7+a7ZA+AOAGcqW6tNJeDhK
	 7evWBtsK5pALQ==
Date: Sat, 2 Mar 2024 11:51:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] shared/298: run xfs_db against the loop device instead
 of the image file
Message-ID: <20240302195150.GV6226@frogsfrogsfrogs>
References: <20240301152820.1149483-1-hch@lst.de>
 <20240301174756.GG1927156@frogsfrogsfrogs>
 <20240302140141.GA1170@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240302140141.GA1170@lst.de>

On Sat, Mar 02, 2024 at 03:01:41PM +0100, Christoph Hellwig wrote:
> On Fri, Mar 01, 2024 at 09:47:56AM -0800, Darrick J. Wong wrote:
> > Might want to leave a comment here about why xfs uses $loop_dev unlike
> > the other clauses that use $img_file
> 
> Well, as I tried to explain in my commit message running it against
> the file always seemed weird.  The loop device is the canonical place
> to run fs tools against.  I can throw in a cleanup patch to also do
> this for the other file systems.

That would also work.

--D
