Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AT37nhGf"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C961B4
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zn4CCqLicceMUz1CERZxaoQyI1RxPJUKZshJMU29Pa8=; b=AT37nhGfKkC7TYc7yulSrqNu65
	QJi9PoHIUjURdPfrZrd0245TzZoy3QOvrbB4im18tcMnAvTCyp5O8S9fY+q2WzypK3Fs4LVgpLBgX
	IZOg+X/zh8LsjDVojOresgxG23P4P/EjwD064XElx7+5iBpQx19jWqaYKAs57aN1IChII7OETipuW
	M3ihIWlY/K7W18hw39jg+C0F7MwDV/UVm8qixt76cqjHYMuY+vig9Z1p6NTXaIaw3mhCkIPDM7gTl
	rQEY1nQLgCHnHp/rC12Qcdfufd1a/doIsaeNIWbhcBXYn5gBFAWfNISiDHthkbwafd8HIexO/2Efp
	TkFwHAGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6xn-00Bu1j-2r;
	Thu, 07 Dec 2023 05:30:19 +0000
Date: Wed, 6 Dec 2023 21:30:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: repair free space btrees
Message-ID: <ZXFYa7v7m1vkuwnY@infradead.org>
References: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
 <170191665696.1181880.11729945955309868067.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665696.1181880.11729945955309868067.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 06, 2023 at 06:41:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Rebuild the free space btrees from the gaps in the rmap btree.
> Refer to the linked documentation for more details.
> 
> Link: https://docs.kernel.org/filesystems/xfs-online-fsck-design.html#case-study-rebuilding-the-free-space-indices

Nit: linking the file in the kernel tree that this is generated from it
and requires internet access would seem more useful.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
