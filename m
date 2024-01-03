Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072FC1D530
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 19:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GiTZdSrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6356EC433C8;
	Wed,  3 Jan 2024 19:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704310626;
	bh=SxeMn2BlVCDYVwXwUdkm/Gh+73XMFwCDdkY6iC5IjM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GiTZdSrDofOH0IkqqQyiwL/q5HPftEFIl7wP51pTmkDg4NZsN9jBZsOSwIPi5rPtD
	 lJ9gs46GOJZxCdffwDKE0YROT8Dfv7HBRQda9a/DPSmJMM4z5E/ipmRni2Gb7rirv8
	 916VwaSGBwn92o7aVbF1tPYPUEE5jPdboFXNeyYmCyPo7tOrMMbnKhKxsVi+o77Q0r
	 h+I0Y1s/8w2DfxteMZT5uM8QmK5mc6tt/AF5uIg5FNzC1h1+Q7DHsgFAa8G2qa1H+7
	 /DZZbcAZMR+1UWcKeFteitrl3FEcuTfgc9u/LdMOBMdopv1hF1TrPcWFh6LvxNLXvR
	 BChj77kdiR0ug==
Date: Wed, 3 Jan 2024 11:37:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 6/9] xfs: consolidate btree block freeing tracepoints
Message-ID: <20240103193705.GS361584@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829675.1748854.18135934618780501542.stgit@frogsfrogsfrogs>
 <ZZUgfWT3ktuE9F5j@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZUgfWT3ktuE9F5j@infradead.org>

On Wed, Jan 03, 2024 at 12:53:17AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:15:07PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Don't waste tracepoint segment memory on per-btree block freeing
> > tracepoints when we can do it from the generic btree code.
> 
> The patch looks good, but what is "tracepoint segment memory"?

The size of the ELF segments where the ftrace strings/code/etc are
stored.  With this and the next patch applied, the output of:

$ objdump -x fs/xfs/xfs.ko | grep tracepoint

Before:

 10 __tracepoints_ptrs 00000b38  0000000000000000  0000000000000000  001418b0  2**2
 14 __tracepoints_strings 00005433  0000000000000000  0000000000000000  00168f60  2**5
 29 __tracepoints 00010d30  0000000000000000  0000000000000000  00240080  2**5

After:

 10 __tracepoints_ptrs 00000b30  0000000000000000  0000000000000000  00142170  2**2
 14 __tracepoints_strings 000053f3  0000000000000000  0000000000000000  00169860  2**5
 29 __tracepoints 00010c70  0000000000000000  0000000000000000  00241180  2**5

Removing these two tracepoints reduces the size of the ELF segments by
264 bytes.  I'll add this note to the commit message.

--D
