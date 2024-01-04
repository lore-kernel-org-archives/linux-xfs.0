Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AE21BDD6
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OxdiKYRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C81C433C7;
	Thu,  4 Jan 2024 07:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704352511;
	bh=+uca41ABqDWjDdyMvxXUfQ7F/wY+OYsTFpVpgArgiRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OxdiKYRZOaGuNyyxcyUf3dYPcVzzVEx9i9RC7fDIhrKrlL8lbsaE2AuIBINxJtE2L
	 BnjXFjHIBWfXxfPr6f4N65Wscd78yVyyEE7Loqen64TLtyU3EyA1X2pjkrnwheM5Pk
	 l4zew5Xf0L+gnYc+sG3ZUgKodbJqNdBZF6aRFLBxIel9/7nUFxTki8BnjWU8QHZvBs
	 EgG2EGxdn2dzC5AYP8D+j8Q8Ge53l2cBCGT+B2NbhCiLnmjS7uMU5iTeWZnF/EcsQ4
	 ouupZpnJbAbH0heLR66A0HWkoCSktwVhRYReoMyA9XuoVo7BeSGGzhQtZjU4tv9WLx
	 cAeosW1ioQXjQ==
Date: Wed, 3 Jan 2024 23:15:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 6/9] xfs: consolidate btree block freeing tracepoints
Message-ID: <20240104071511.GZ361584@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829675.1748854.18135934618780501542.stgit@frogsfrogsfrogs>
 <ZZUgfWT3ktuE9F5j@infradead.org>
 <20240103193705.GS361584@frogsfrogsfrogs>
 <ZZZN8UV67XGa1J+q@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZZN8UV67XGa1J+q@infradead.org>

On Wed, Jan 03, 2024 at 10:19:29PM -0800, Christoph Hellwig wrote:
> On Wed, Jan 03, 2024 at 11:37:05AM -0800, Darrick J. Wong wrote:
> > Removing these two tracepoints reduces the size of the ELF segments by
> > 264 bytes.  I'll add this note to the commit message.
> 
> Yeah.  Maybe just say memory usage - segment size feels awfully specific
> to an implementation detail.

Done.

--D
