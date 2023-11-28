Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C/yyYohW"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DF0C4
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=l4xFpFI5naT867N8ZN5I0frE/+YQSErRgjQS+a3iLUE=; b=C/yyYohWoEnq7CUuoRoDWK/QGC
	zSJq99Z3VC3fMcgouTcOEdx0Fc3p2bGyIUxJuhWYgVFN8yj370MG3sEmV3/iuRqwVBGjjAAGi9rzZ
	VrD0ksSYl4943MhhxajtzzGuviz4Jg77wyR0DM7oeS0JCaaM7NsIYPnjbXyjzyaXeAItlrhzD4lVm
	RIVi4cQpsFUM+yTSrV0rHhMxFinpjiwlO1zqy/jwrl6XRIufmJpDStM3UsjNFRt/Hwp5WoN7USuzk
	LBSM7VHcY6LvmBrEf/JRaCOjOs6gFY9SsiWxYYR0LBC0jYbUZbIcAG6rpSoRFojOoAIrAG5x/+3QT
	OV6mdNcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7qqe-004AVu-0t;
	Tue, 28 Nov 2023 05:41:28 +0000
Date: Mon, 27 Nov 2023 21:41:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: implement block reservation accounting for
 btrees we're staging
Message-ID: <ZWV9iC0HHYkJXh3r@infradead.org>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926207.2768790.3907390620269991796.stgit@frogsfrogsfrogs>
 <ZWNEzd9aCQpKzpf9@infradead.org>
 <20231127223451.GG2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127223451.GG2766956@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 27, 2023 at 02:34:51PM -0800, Darrick J. Wong wrote:
> That had a noticeable effect on performance straight after mounting
> because touching /any/ btree would result in splits.  IIRC Dave and I
> decided that repair should generate btree blocks that were 75% full
> unless space was tight.  We defined tight as ~10% free to avoid repair
> failures and settled on 3/32 to avoid div64.
> 
> IOWs, we mostly pulled it out of thin air. ;)

Maybe throw a little comment about this in.

