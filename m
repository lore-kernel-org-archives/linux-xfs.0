Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC97015382F;
	Wed, 19 Jun 2024 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718816327; cv=none; b=OGQuNPLvLeyGSp57YYgmpnsFapAHKdwdkCiiKuS5guDvsjT1WemfgO/2TGeQjf4W5XHodp5yhXuOjes8suXKnx0I4ggEBbOmsrOLt6wx8VPAaCuwyhur8/XXoJ0PC2wG2Uf8j39XHGoaXmUu5tlZ3E+eGR+4pOW8pG9Ji8+Dd3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718816327; c=relaxed/simple;
	bh=5BBlgMTWoWykLFsvtBksvtfZh7GmoKMb6X8ly7x9vEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpRaMxuo1RwRD7VL3fQSt3Q1GghZOU4TYKLNFfYP5bSsbpwxLXJ1jewzchejhLFpZBr/cRM5Et4jVvWWpx0bWlih2xxiQIugCZ1fb4OITsMwopGc/zXm4+8chvENLpUuWT8xXRGYulPEpcdvelQInRVtnCg4qSWodNSidA624UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JlX2oYlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JlX2oYlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51475C2BBFC;
	Wed, 19 Jun 2024 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718816326;
	bh=5BBlgMTWoWykLFsvtBksvtfZh7GmoKMb6X8ly7x9vEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JlX2oYlQuBYlC9OjvV8L2yKc333PRm+Fgr3eMQBTo+SnoFJQaMW7MMGdW+G7sPFtH
	 wH0v6aXkKBGMH4BQdQQU2SefGFUIgwKhIeCTI7n9hm4nemjc0BJb7m1wlqi9It2VNS
	 /8hKh/FESgGJoTTU4NGIIgk+J8K3bCxoScV82dCO9ab1x//m3iHoyvMc0RvpbEfQVe
	 xJv2+To8E8ZxMZvoyAbqr3793LPPyux5NFeJOOIzr/p57rhpVzFOnMB+IquhntGK1P
	 Yl0XE8KNkJxCQ8i2TKF/MfNZ79BD0HJ9TUSN4RZfcUjn/ZoCOpcz+9/TEKb87sBvEC
	 19/ikSPEAC+uQ==
Date: Wed, 19 Jun 2024 09:58:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] swapext: make sure that we don't swap unwritten
 extents unless they're part of a rt extent(??)
Message-ID: <20240619165845.GO103034@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145451.793463.2794238931520323458.stgit@frogsfrogsfrogs>
 <ZnJ2jieRl4-B70Ux@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnJ2jieRl4-B70Ux@infradead.org>

On Tue, Jun 18, 2024 at 11:11:26PM -0700, Christoph Hellwig wrote:
> On Mon, Jun 17, 2024 at 05:49:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Can you add a commit message explaining what this test does and why
> you wrote it?

Whoops, another one escaped:

exchangerange: make sure that we don't swap unwritten extents unless they're part of a rt extent

By default, the FILE1_WRITTEN flag for the EXCHANGERANGE ioctl isn't
supposed to touch anything except for written extents.  In other words,
it shouldn't exchange delalloc reservations, unwritten preallocations,
or holes.  The XFS implementation flushes dirty pagecache to disk so
there should never be delalloc reservations running through the
exchangerange machinery, but there can be unwritten extents.

Hence, write a test to make sure that unwritten extents don't get moved
around.  This test opts itself out for realtime filesystems where the
allocation unit is larger than 1 fsblock because xfs has to move full
allocation units, and that requires exchanging of partially written rt
extents.

--D
