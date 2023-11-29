Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t5AvRPqr"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DEE12C
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 22:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AcAet+58eC9K4PMZA9aq/HBG9QKf524wz/CPa/FiOgo=; b=t5AvRPqrXDC85vCAe00VSXw85A
	C7dWKBLZl3rjRapreJQxtJ8IXmPwWUYvXiJSeiMOVueaZ+ruq0sD7a4YHeMQL/eJo24HUZNsTWNJK
	sNxZIRowINCcJZAbD1YwjGguw4y2Ej9v3fFXx5ecmdjZkCCCySDWnQITawGqM7Tty74Imk7o5RmM3
	44PtBu2RBKriZUigKltLY1X65nc5EQyJvtXaz2oSUnoS/UdutFesZcX3S770garGaKZBLVcGYhoyV
	yW1slfzX/UhQ8uS/peC0GMGlKoaRbFf5iSdukU8b3y3Tn6W08yxz/OMb/rn2U6v4fH0dFGNF88b0B
	GjLgapbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8E0I-007Dg6-18;
	Wed, 29 Nov 2023 06:24:58 +0000
Date: Tue, 28 Nov 2023 22:24:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: repair free space btrees
Message-ID: <ZWbZOiowP5CVL2KX@infradead.org>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927042.2770967.1697193414262580501.stgit@frogsfrogsfrogs>
 <ZWYDASlIqLQvk9Wh@infradead.org>
 <20231128211358.GB4167244@frogsfrogsfrogs>
 <ZWbSq7591xG1I+SQ@infradead.org>
 <20231129061819.GA361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129061819.GA361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 10:18:19PM -0800, Darrick J. Wong wrote:
> The gaps (aka the new freespace records) are stashed in the free_records
> xfarray.  Next, some of the @free_records are diverted to the newbt
> reservation and used to format new btree blocks.
> 
> I hope that makes things clearer?

Yes.  Can you add this to the code as a comment?
