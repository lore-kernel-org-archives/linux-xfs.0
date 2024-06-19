Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30762155336;
	Wed, 19 Jun 2024 17:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718816583; cv=none; b=fFMtLdcGHz8KcdazblkinOdVMDhLqPgq2DTcqooY9o2LBITyWfEmH0IK6yHS2EUO0cKJOvo55VONc3ybdw3iPZ4TA+8CdYRx5ZU96fVpG2Ymu3to/Xw4f+w5LdPMQU7Dpp0at3JVBGKpxu7Z/Jiv6L0FQtfzglhGLPDazZPP86k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718816583; c=relaxed/simple;
	bh=UeW+EMiSNiNKsYJecQMNhbdOcrLdfbZorFRxTbWaQAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=huRhMMoQK4zDYNwcN9TOCzO1WpOQM1I1ep1vFPw/V9ZMUxzrqSNfSQXrAtAy0fnuftCds5NRSrx08yFvjxNjZ8kt0zkisuL6ERCXRCI6FAcz9qCi5rfkDezE3WV0/n/Jh0G4yaGR7fA7ZOAi3OdxJLVthpHcBPIPb13fZklP8Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6g9lRUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6g9lRUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5C5C2BBFC;
	Wed, 19 Jun 2024 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718816582;
	bh=UeW+EMiSNiNKsYJecQMNhbdOcrLdfbZorFRxTbWaQAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R6g9lRUXzGaHyZyxKnZrAPBUhdKg6KmMjDK7/aVzq1Jmx49nDGltV6tm9Y1TArS/n
	 UelSFefU9iAnPDy2VI76L5SgUvNq+MV+SeNIjMhDZ721CbI8bqXh+MYdF4FbT1lTmv
	 p/eIc/vE1ftMUg1Mkr9BijvPj96tAnQPQpOHQ43pcDjXc/ifLmIQUd/TrDf8jXJM9p
	 tRX1spYOHd8CFBflUpJDPDb/vLSbRNANbUjkFxCKrqT0O6F/k+yaP8dtxaM6YbFCzR
	 /JBGQO3NimLhvkl8l95HxfHtqFhJQTJ/feSw2hxta0Ghs2w6aewPpsZUBKy+PLAVFL
	 H2Ymz0evcYUcQ==
Date: Wed, 19 Jun 2024 10:03:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 06/11] xfs/{018,191,288}: disable parent pointers for
 this test
Message-ID: <20240619170302.GQ103034@frogsfrogsfrogs>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145899.793846.9319639235704732288.stgit@frogsfrogsfrogs>
 <ZnJ3jnD3E--H4sJ3@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnJ3jnD3E--H4sJ3@infradead.org>

On Tue, Jun 18, 2024 at 11:15:42PM -0700, Christoph Hellwig wrote:
> s/this test/these tests/ ?
> 
> > +	if echo "$MKFS_OPTIONS" | grep -q 'parent='; then
> > +		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/parent=[01]/parent=0/g')"
> 
> Split the line?  I also wonder if a generic helper to remove mkfs
> options might be useful.

Maybe when we get to the next caller?

I'll split the line too.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
