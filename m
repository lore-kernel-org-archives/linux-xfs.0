Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A259758103
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 17:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HRoi013Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AE8C433C7;
	Thu, 30 Nov 2023 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701367157;
	bh=NfqsZyWkqJ7Sunbi589WaJP9QYO6K5O74/ms+aQpuw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HRoi013Yc1FNZ7UDgcyqx1tDmQ+dGH9FJKIFy2rq/WYO5bA+YwHVW41goWbxDyY/u
	 14rmblIzf9cIwqRWq5lJPHzega4Gm6l492CBV3aTyAzK0Xz7oRFACQuq+snxMSBU88
	 AxCD/Tj4+Q6fsJ8gnECPHCZtkMv/6Iq1HbmCm7uDWwC1xUz7NMYF5yyY9daKurBcQX
	 kj6C8SrqzypKBvU3OzYzul/jvkd0YR7GdxE6CTETZ/LTK8wvaO8D6mU8DS5Jr3mDzI
	 iauVXGtl7ngPYHApwGl4pXpJoO4gDKMYzM04k7OUYvw0r8c3dxJca4Pz5ECm4uePse
	 dGVJIWjCwDE5w==
Date: Thu, 30 Nov 2023 09:59:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: use xfs_defer_finish_one to finish recovered
 work items
Message-ID: <20231130175916.GL361584@frogsfrogsfrogs>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120322304.13206.5309817289433296873.stgit@frogsfrogsfrogs>
 <ZWhDg3Vbj3/aA+Tj@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWhDg3Vbj3/aA+Tj@infradead.org>

On Thu, Nov 30, 2023 at 12:10:43AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 28, 2023 at 12:27:03PM -0800, Darrick J. Wong wrote:
> > While we're at it, dump xattr log items if the recovery fails with
> > corruption errors like we do for the other intent items.
> 
> Normally I'd expect this as a split out prep patch.

Done.

> > -	error = xfs_xattri_finish_update(attr, done_item);
> 
> As a follow on cleanup, xfs_xattri_finish_update could now be folded
> into xfs_attr_finish_item, making the logic a littl simpler to follow.
> Same for the other items.

That'll be a separate patch at the end.

> Otherwise this looks good to me.

Yay!

--D
