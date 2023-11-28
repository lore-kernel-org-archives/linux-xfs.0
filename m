Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y+QNlJpf"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CE4DB
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V0D8ckcvmMlIADFlzR0X+H41wWCQQyqusjKIpIs1ncY=; b=Y+QNlJpfRJLjV8lqe3NSlYFKaz
	2/IdPY1lFPDslrEH2hidlNqFBtZhoZwPteayPBSsG2JtB9tteBl8W9SuteybzdvLacd6UiUy2mAxx
	fX+678tgh1IAv8Z6Xz5Wp2bZ3I0ozJF3bjrncGfNGVA+j4MFhudzj5o725WLis3kctb9sICYRptjh
	HNc9tyow+eKhhtwMN4wOY70KBmdpsvlLzCSZ3q9/vlhlwPPJh1ADV75ljHqkm2bFE/5tmhsZevKw/
	YJmuFfPB+N7tvhnBbSw6D8HrUu0ZbvsS51REQ42J8D5PunK8z+dhG73ydd0+difvoEDUvlcqVGRC/
	Bmlz9mlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7qnF-004A9t-18;
	Tue, 28 Nov 2023 05:37:57 +0000
Date: Mon, 27 Nov 2023 21:37:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs_db: report the device associated with each io
 cursor
Message-ID: <ZWV8teJB7tdNtaoi@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069443096.1865809.13119575401747000666.stgit@frogsfrogsfrogs>
 <ZV70BSL4TBfVZdVA@infradead.org>
 <20231127182414.GC2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127182414.GC2766956@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 27, 2023 at 10:24:14AM -0800, Darrick J. Wong wrote:
> On Wed, Nov 22, 2023 at 10:41:09PM -0800, Christoph Hellwig wrote:
> > On Wed, Nov 22, 2023 at 03:07:10PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > When db is reporting on an io cursor, have it print out the device
> > > that the cursor is pointing to.
> > 
> > This looks very useful.  But I wonder if it risks breaking a lot
> > of scripts?
> 
> <shrug> There's nothing in fstests that depends on the output of the
> 'stack' command, and debian code search didn't come up with any hits.

I guess that's about as good as it gets..
