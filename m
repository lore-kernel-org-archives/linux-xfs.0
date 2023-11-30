Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eT22hh4n"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09BC10D9
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 21:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h1+InFvA69FbL9zZtYbDDyUjif0eqx6O9nd7kL+QvNk=; b=eT22hh4noBaYD6QzQmjbQ9ZVwz
	D6Lo5ueegVwAHbuxvrj+6Zxxe8w8S6/aLtC95A0slhQ9Rzg1ZUSlxh+wOPWY2PWrNs4ctiAOm5CGN
	6SQqg290WJWbPbNSr3xryXlL2p1RNwGqWebL7mnzPIVtkhkRLiXH20n44p70rxDubcy4vxH7pNuRI
	RQH0XsjrPvFyOBJ0SA0GyPVvoV1HDhzqp8am0wp5FLw3b4RyGo7sXsYCsGQGagRtOlZMdLdQywCZT
	79lZKI7hjWJUWphoVgYnc+b1ZmeW7E/k8qS6Wxr3FOR/9fZ/3UyAkBit0oIl8/vopLcIrGjqBpt2b
	Mz7KHJhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8ZV0-009xXN-1c;
	Thu, 30 Nov 2023 05:22:06 +0000
Date: Wed, 29 Nov 2023 21:22:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: pull xfs_qm_dqiterate back into scrub
Message-ID: <ZWgb/h1keHc8kyVS@infradead.org>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
 <170086928838.2771741.6827852837191818932.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928838.2771741.6827852837191818932.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:56:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There aren't any other users of this code outside of online fsck, so
> pull it back in there.

The move itself looks fine, but what about just open coding it and
getting rid of the indirection functional?

