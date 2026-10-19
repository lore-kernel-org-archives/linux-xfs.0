Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B4549550F
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 08:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792397629; cv=none; b=uDr2kYM2ou/h6CVWyOnc6GoxT5btXLCNX+fjp4k392ME7Y0yBgvjTdRyes3bB6tUd/b0sayGIEAmnobZ0fruiRys6S37c1eBGAV5DXJ4wLKsJIkLQo6JNCXemJRk55YKeEj7T7cbDNTOHrozhj2hm2y95XgkjpFQyaIIgyItd5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792397629; c=relaxed/simple;
	bh=MOGuM4gPLrcfwqg0nusHoXWXMyeYfUI1JHNioXK/vac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LBNUrq1gOEE/M6g/VbGKyOxpg7Zo0Kv9fw9oXBgPemwVgIAp6f9CXlB/gerhboaLeGWTXMT8fBS3S9oIRlKItnviO3PUMoStBkGcFpwDFDL2JssWHyEHZDLETf2jE/caZGfVGjSdbaE+V+nVE3RK6Cu4ATWgvFLNLGC0TSCBgx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIqKefjw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIqKefjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6064C1F000C4;
	Mon, 19 Oct 2026 08:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792397628;
	bh=3Ur/SQwVlq+AXn15lcxZzWUR9lN/jHi24pahqIgRvKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jIqKefjwAo0BxBC6G6408iAr4s7Z9CfYwXlOV+qOfC5zdc2RHCvQQ9qUXwMGUhQkQ
	 pn9rCyntGsP+uCDJtfdllxVs0M+Id4CrIdQ4k95dqna9Da9M2SMKQpbND9xQvR/fIp
	 toa4iwvXG/eV77uYWwuyx09qoAOTdvI5OMvwOmyv22dcBDMc71Vk6uE/+3Rs/caWy7
	 6x5od+wQhCo/WcRgL7YaPTcA3/gvAPIcAZzp/0vqpleatF/Xszav5HAO4cDGm5yBc6
	 uTYcnjhzJFnwxe+KwpS0MlfC4i4LcffBS97ZkOYQzdEd0NUB7ucFa7tBkn0ReONtYN
	 JnEQA7wKx5Wrw==
Date: Mon, 19 Oct 2026 10:13:45 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] mkfs: enable metadata directory trees by default
Message-ID: <atXRKjYpWlLdCt9T@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <179158948269.3720929.14224184767079938461.stgit@frogsfrogsfrogs>
 <179158948337.3720929.9620901680652749422.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179158948337.3720929.9620901680652749422.stgit@frogsfrogsfrogs>

On 2026-10-09 16:53:42, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Metadata directory trees were added to XFS in Linux 6.13 at the end of
> 2024.  It's now been two years and we haven't found any significant
> problems, so enable it by default.  Sysadmins will now be able to have
> persistent quota options instead of having to encode that in fstab.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
