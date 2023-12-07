Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DfBgIGKw"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EC0D4B
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 22:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3U1AfWBPAHvdSIlNEIFK5RojZAeY3ZlHdfbjXmpzdtM=; b=DfBgIGKwxSkbJMbpsaZqH3uaQJ
	LwtMyrc+wDkuSD5aIwmF5R66xcf3WG8ixwdLS7e373PRuJqzU8cGhii08EJw7/Alywioc8oFiiFbf
	M+4vnv7AJRzx7VnakWAfKP8gWr3GbiIPiMNQ0Z+82TD918OMupBXKZzE2Sf7dLhTJ1FAGpeuQywt7
	05wNTsRuSMihaOFDkZGlLaj5LeeenJGfDGlVXYFUChMib8s3Sq3svTsLd8kJAZHI3EYtcxBKWNREK
	1/N+qu+TOGb2iC7ksp7FKmotOJ88HDEjDekiPsp3SrP9wltR1Qr/1H3Bc8WPsTsxx7JZOxEBwm8RF
	+c8ZCtgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB7XM-00Bx3Y-2w;
	Thu, 07 Dec 2023 06:07:04 +0000
Date: Wed, 6 Dec 2023 22:07:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: skip the rmapbt search on an empty attr fork
 unless we know it was zapped
Message-ID: <ZXFhCHxQD/9GuQiI@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666238.1182270.18118442139749127193.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191666238.1182270.18118442139749127193.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 06, 2023 at 06:43:47PM -0800, Darrick J. Wong wrote:
> +			if ((VFS_I(sc->ip)->i_mode & 0777) != 0)
> +				return false;
> +			if (!uid_eq(VFS_I(sc->ip)->i_uid, GLOBAL_ROOT_UID))
> +				return false;
> +			if (!gid_eq(VFS_I(sc->ip)->i_gid, GLOBAL_ROOT_GID))
> +				return false;

Having this in a well-documented helper would be nice to have,
but otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
