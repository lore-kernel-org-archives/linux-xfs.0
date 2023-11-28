Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17052209E
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 17:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I2y38H8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F90EC433C7;
	Tue, 28 Nov 2023 17:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701190882;
	bh=ZOkknGVGoeU6jzoxm9lhlFEl0ZNJd/Hm2UE+qemj384=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I2y38H8vooEaenwFmekZGktF75uYGtoFz5Sp0MfBNvAgkQlH1A+nsHWd6MQaJTMwv
	 YoSe1Rrq1/fzmYN0lj9UFtMo+63NK7KHuRXjhM4gRSAIuycElr+lBRHAWVAQGLIBp1
	 bUPGVmq1SMK0ndWRkyd1EB5ATJ8msYcEeu3WmeLepMtFscckOymTAU3RW0wJ++TV+2
	 Qw6H3bMqzhavCPKIL580sTyGUk687RvnlbOwcDd1IztV8k79LlRP9w4yPaXAJOEhzb
	 siHvMkTwcqAv6qNGoguy1Y8IyAUFwtaiUTtHKQTrVM4QQGaNylAw4di7FHvAjwohdL
	 w5QoQzcbG9MzA==
Date: Tue, 28 Nov 2023 09:01:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] libxfs: don't UAF a requeued EFI
Message-ID: <20231128170121.GX2766956@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069441966.1865809.4282467818590298794.stgit@frogsfrogsfrogs>
 <ZV7zCVxzEnufP53Q@infradead.org>
 <20231127181024.GA2766956@frogsfrogsfrogs>
 <ZWV8izIb2XTOc9dJ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWV8izIb2XTOc9dJ@infradead.org>

On Mon, Nov 27, 2023 at 09:37:15PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 27, 2023 at 10:10:24AM -0800, Darrick J. Wong wrote:
> > > It might be time to move this code into shared files?
> > 
> > I think Chandan started looking into what it would take to port the log
> > code from the kernel into userspace.  Then xfs_trans_commit in userspace
> > could actually write transactions to the log and write them back
> > atomically; and xfs_repair could finally lose the -L switch.
> 
> While that does sound like a really good idea, it's now what I meant
> here.  I think if we moved the actual defer ops instances out of the
> _item.c files into libxfs, I think we could reuse them for the current
> way of operating in userspace quite easily with strategic stubs for
> some functionality.

Oh!  You're talking about moving xfs_rmap_update_defer_type and the
functions it points to into xfs_rmap.c, then?  Hmm.  I just moved
->iop_recover into xfs_defer_op_type, let me send an RFC for that.

(You and I might have hit critical mass for log item cleanups... ;))

--D
