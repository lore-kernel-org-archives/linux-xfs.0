Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FAD4645C
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 17:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JF7xB8vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6C8C433C7;
	Tue, 28 Nov 2023 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701190942;
	bh=EGG+/yGNEBeffnTkYSLPxRfCIm7q0lk95qG0+mzThqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JF7xB8vjII+zTEMN88HWUtD2pZbPl9feztTNHFg/jaclhDAOLFQooSdLhRrxLzKlH
	 zrO1AVRdoGnOZOLN2RWVfQHwaaz4SJ6CUrwqLsaY66F5uyadx7NhM1KTiUT7Eg2jo5
	 RW4qYzIPnLNnPVwGdUUEJc+KSWDIpOU7kppj0uDtfr3sgiH7scK9SujEv/6/clRcVm
	 FRisxBgzcIjB0SAVuMOAOwwZYBQ3HrmLbCzjo4hJM99BxgXaQcXOA9yTPn1UvWrH5D
	 nZyWTFc5Gpb/li33V6k0UUGS+jSZITTuiSYXk1kBpMJlP4/Bz0P0AYiSC4zX4queQR
	 87HTxcZ9TYncg==
Date: Tue, 28 Nov 2023 09:02:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: implement block reservation accounting for
 btrees we're staging
Message-ID: <20231128170222.GY2766956@frogsfrogsfrogs>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926207.2768790.3907390620269991796.stgit@frogsfrogsfrogs>
 <ZWNEzd9aCQpKzpf9@infradead.org>
 <20231127223451.GG2766956@frogsfrogsfrogs>
 <ZWV9iC0HHYkJXh3r@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWV9iC0HHYkJXh3r@infradead.org>

On Mon, Nov 27, 2023 at 09:41:28PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 27, 2023 at 02:34:51PM -0800, Darrick J. Wong wrote:
> > That had a noticeable effect on performance straight after mounting
> > because touching /any/ btree would result in splits.  IIRC Dave and I
> > decided that repair should generate btree blocks that were 75% full
> > unless space was tight.  We defined tight as ~10% free to avoid repair
> > failures and settled on 3/32 to avoid div64.
> > 
> > IOWs, we mostly pulled it out of thin air. ;)
> 
> Maybe throw a little comment about this in.

Yeah, I'll paste the sordid history into the commit message when I
change the code to use div_u64.

--D
