Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB282F25F5;
	Wed,  1 Apr 2026 06:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775025176; cv=none; b=gQC0xKOeH4vP5W1+sWO7X1Z8VYvo2wyRZ9qjvFhloWTni6u4l0qwO9jYJymhLXD4kqxrf21eKwfckzpH0uVZqEvBNrZk66n21ZnU8bCG9eoplBnKqLV4weWx1wDXqdj83McY4KaftH8P6qoplnYpfs/KZsTDeiubrS8HBik6Ylc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775025176; c=relaxed/simple;
	bh=aLxUhpyTKn43VG3vTemWcbaUEIA3iAko1d3EU97hycg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQ2fiFOnJDlYE3O4xZc3LnQeuU/9rkpLDHWHFps7np1JtxJqx+cildjcl0zfIbYVN9/9uWGaMTyQMs3rQfejzWnYfCjjp1YnoTfqsnNPy9141FGxMi2VsFwsnuXiIkNCxNJCvB3u8OxJIKBqWsCpeIpBnOT4FrYNB59eWlgr8D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9B7FA68AFE; Wed,  1 Apr 2026 08:32:52 +0200 (CEST)
Date: Wed, 1 Apr 2026 08:32:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>, ebiggers@kernel.org
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v6 00/22] fs-verity support for XFS with post EOF
 merkle tree
Message-ID: <20260401063252.GF24459@lst.de>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Eric,

can we get you to chime in on the core fsverity changes, especially
the hole handling?

