Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA2535F180
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 22:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772748052; cv=none; b=CrsJCBhIdp5ctbdpitwWLcNzCFa9M8neAVfZsztU8uR4IHiXf/vxKwBwyqItsfWFwA2MwUJcW6XxZLdA2RHyhhSTV6xfSSxqy3Wm6SSrtj3TBzICSzzD0aqalkuu9M+WyfQOkljtTp1QmNDXiz5B6gHUEtZRAMfAe7NacgxHE5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772748052; c=relaxed/simple;
	bh=fEXeooMXXx873akaI9eEsdD+sCwFDMoBfqq4mVPwtdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AoA6BOcB95Lbm8/lzv2qAeVjbUG53tXb8yCM5ZVKKsDvYzwlB0bVtiw2t8itn2t4VHyRfXylDsWOBJu5svpDn6gSQPjq3YavtszelTBN7EPjbNtnqCjk3hJpykAvPUwhh4O71Euh1khQa/4noqoZupVDTaevU+D4yvec1dT8T4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKbocx3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKbocx3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7575CC116C6;
	Thu,  5 Mar 2026 22:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772748052;
	bh=fEXeooMXXx873akaI9eEsdD+sCwFDMoBfqq4mVPwtdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OKbocx3z72djAEAFdpIjnda1KfLd2uRkXvkAVBFZh3Ad5G5kt+2fqbLK+vXHcP26d
	 b/tNo7zbsBgGtbsFsmnO0upxWz+bwb5JNvyI2kU0ou5a7AYHWC8WTgTYDhvb7QCsqw
	 Rt/L2+wiUm4f1FeHiGZUsaMYiTjQBLHLpcKK2MlaEEbyhMJkGSocSSYaghZh3Lp5cj
	 GBxagUECWXgepazu1ku/vPvy6+PlhSdrJKs6wh4cGp7PJeudUzu5TTnXNjSdIAQkPC
	 UuviRjl0z1NevtCoSN4+b0T0MM1j7qOAkENGUHYKXkmCyCnP6Ztrk20sjTEYikP3uC
	 WhR9KlB3XxJ+g==
Date: Thu, 5 Mar 2026 14:00:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs_io: print systemd service names
Message-ID: <20260305220051.GG57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
 <aacE3gW9j6pKrspy@infradead.org>
 <20260303172916.GR57948@frogsfrogsfrogs>
 <aagt0pZTkqysyjQJ@infradead.org>
 <20260304163502.GV57948@frogsfrogsfrogs>
 <aamLP5UnWiPhvKqh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aamLP5UnWiPhvKqh@infradead.org>

On Thu, Mar 05, 2026 at 05:55:11AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 04, 2026 at 08:35:02AM -0800, Darrick J. Wong wrote:
> > On Wed, Mar 04, 2026 at 05:04:18AM -0800, Christoph Hellwig wrote:
> > > On Tue, Mar 03, 2026 at 09:29:16AM -0800, Darrick J. Wong wrote:
> > > > (That was a long way of saying "can't we just keep using xfs_io as a
> > > > dumping ground for QA-related xfs stuff?" ;))
> > > 
> > > I really hate messing it up with things that are no I/O at all,
> > > and not related to issuing I/O or related syscalls.  Maybe just add
> > > a new little binary for it?
> > 
> > How about xfs_db, since normal users shouldn't need to compute the
> > service unit names?
> 
> Still seems totally out of place for something not touching the
> on-disk structures.  What's the problem with adding a new trivial
> binary for it?  Or even just publishing the name in a file in
> /usr/share?

Eh I'll just put it in xfs_{scrub,healer} as a --svcname argument.

$ xfs_scrub --svcname /home
xfs_scrub@home.service
$ xfs_scrub --svcname -x /home
xfs_scrub_media@home.service
$ xfs_healer --svcname /home
xfs_healer@home.service

--D
