Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B65818410B
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 22:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786810; cv=none; b=TbSPXizTpx3/Vy4VA5IMcXvlxyDBLN3k2L6tZO3e4loap/qGjJ5t09EhguJxNgwmuowfzVfyU5b2mveO5avQLnECG8tXBbDDHHpkUUF45ZItzr7Phc/CBqSc7U8wphTJ/bvr9l0PqMyYJFFW4rzxrDLbNx8xmevrM03qBCEQNZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786810; c=relaxed/simple;
	bh=3Z2sgAmXzYyq3te4KaYWgRuS/1yNsn1YuL4+5SOfvto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YyU537j9BfP8F9NouTT1ecasGggg9P7Qh0pMcAxXIPfkDDfZONAx4As6jHUsYAR6/aMYRtUqwPNAjN2bUpdVhQwSe44xTDcAyGtLluI3BBRoQHjIVer/Gzw8KBlYOUfLf35Isy+xcDnk0lUSXz0/kdjEzGBhxW2/4Jm3EuUpxLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZIO4jYD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZIO4jYD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF2FC433C7;
	Wed, 10 Apr 2024 22:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712786809;
	bh=3Z2sgAmXzYyq3te4KaYWgRuS/1yNsn1YuL4+5SOfvto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZIO4jYD+wMBpR37r8/DxkePtQTHhikwZXVYtg9uq+5Hov1u1WLyZ8IIGDUpJRRiQv
	 tilgBt7zy3rq5qU8dRbY3Y7EnBGRMPhsCjs9iRcod3tvcprhAd3r8ELw1vj1+ekiwh
	 sceu+NxSCm1U7OstLogPOl1MJ9oHmwiupF2c8yLTarXr1Bf+9DlE5+6WQousYzX3vB
	 uqJOWHgxK3cTtLgMnjyCgKNW/EJ8E2Jg4dQv1w9ksssGf9HMNCgVxCVJhdigSEhaYF
	 FSZSWnfHGaztZQr3Qbatk8kervYx8MN7+SLYcCMLx46VEQSHdodFW/y8x/AuSWj+rr
	 xThJupqKlSfLQ==
Date: Wed, 10 Apr 2024 15:06:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/32] xfs: Add the parent pointer support to the
 superblock version 5.
Message-ID: <20240410220649.GJ6390@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970042.3631889.15727225239821945588.stgit@frogsfrogsfrogs>
 <ZhYsGGe431pONR9Z@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYsGGe431pONR9Z@infradead.org>

On Tue, Apr 09, 2024 at 11:05:12PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 06:01:04PM -0700, Darrick J. Wong wrote:
> > From: Allison Henderson <allison.henderson@oracle.com>
> > 
> > Add the parent pointer superblock flag so that we can actually mount
> > filesystems with this feature enabled.
> 
> The subjcet reads a little weird.  What about
> 
> "add a incompat feature bit for parent pointers" ?

Changed to:

"xfs: add a incompat feature bit for parent pointers

"Create an incompat feature bit and a fs geometry flag so that we can
enable the feature in the ondisk superblock and advertise its existence
to userspace."

Also I'll change the bit to 1<<25; I was using 1U<<30 to avoid
collisions with the other patchsets.

--D
