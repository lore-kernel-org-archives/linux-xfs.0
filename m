Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BCC28EC
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 14:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745592603; cv=none; b=J/n24ISGNNpqpX+0guBmiSzzXCf7R3eajfeS1yHECbAECPlHzIioy4ugBuM7zeAfmarQoMTyLENsl4ppbtA9eB1Xs2TL+54sdK/scU/BKOnBVnK+FIVvtKv5HDn1Q7qH10GWD/8b1gAgvw4v3CRXLkpYVDLNUZ+xgKGhBWWItdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745592603; c=relaxed/simple;
	bh=Cue6B3T8kVjLIWu1cPNAzhwQTn9cuguYyJL81wJiwqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DgTNnlKnd71vnA3mKU+5yoOrj27rk1yi28v+Fm2zP4/lhruuZAX/mS9hrE+JpjznxeESbbgqo6Ny4fEkGVs6Kj4w4iRxFthXaUiivODj1lF5PbtE5Biwb5i9aQl1KcsYRV/0Sa6qdOKIrLSPDfSjE4pXND5FH3bqI/cfeBoKFs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9nFp+nN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9nFp+nN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB68C4CEE4;
	Fri, 25 Apr 2025 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745592602;
	bh=Cue6B3T8kVjLIWu1cPNAzhwQTn9cuguYyJL81wJiwqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E9nFp+nNivB8tJtKfNGxmlDyf1ImvKZnvjVrb8gbxh3yw4N7xkzp0vPBR8HT9c7K2
	 fyOQpqZjNEFr7V0ucy+OH+ykWRhn8+AmcVaUbt6HMU+a5H5/Bo+5MVt71omur7Ay3C
	 otDlwnY1EFE9XMy8FzQbRGlnn8XCa5JfKh5UAf/nilKFfb06HZ6h4aJR4gVxNQelwG
	 qGPrRoADe6AXp5CdFdZe5icldQZpb60nED2yzKkB0WftWu2VfPVLPOMT/z131vGjYx
	 JvrauPwq4pEWkLKxeGv9FQha9iVT/xbLftr1NvfPjCmYP7OHgzSdTgOZiT33JzUHab
	 PQC81CBG7ymVQ==
Date: Fri, 25 Apr 2025 07:50:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_io: redefine what statx -m all does
Message-ID: <20250425145001.GP25700@frogsfrogsfrogs>
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
 <174553149374.1175632.14342104810810203344.stgit@frogsfrogsfrogs>
 <aAuKGV6N1RSnbVoq@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAuKGV6N1RSnbVoq@infradead.org>

On Fri, Apr 25, 2025 at 06:11:53AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 24, 2025 at 02:53:23PM -0700, Darrick J. Wong wrote:
> > +The default is to set STATX_BASIC_STATS and STATX_BTIME.
> 
> The default without this options is to set STATX_BASIC_STATS and STATX_BTIME.

How about:
"If no -m arguments are specified, the default is to set
STATX_BASIC_STATS and STATX_BTIME."

Thanks all for reviewing this.

--D

> ?
> 
> Otherwise looks good:
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
