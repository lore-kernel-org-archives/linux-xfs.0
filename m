Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cz80g4++"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F26B92
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 20:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GiWnLQFPzT3hiV8izSsdpwcv3PoEi99+u0ZcdIhDmzY=; b=Cz80g4++ndJ6sY/V93lQ/pBdU/
	Q05vAKRNtplHWjN7kEYH6YKG5HxSyHDbNl+dRBbWCGl+NwfH5lb3yKhGbju12RyqMPTx7BcDX5Fxf
	WqLV/XkP0z4GbUCCQmNsrYjSbYnoVX15zT58NVXj+EC7pOXq8Gc5/9IJNO0AQQvsg5F4yD3hew9mv
	IC5HxjVxR23VLF237HGHwBix4PC1GcPTMy+7nn4E2SwexUURMf2qi5A2G2Z2z1kJRTIx/VvJQfRXQ
	JLMGrYO+motGgISc2CoDJgfJb3yLvGxLRuXO7bsprrpRcVW/FPt8vauYR9ql88l+WoRaP88ipN3xz
	c3Uq/+4w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rA0mi-002zvb-2W;
	Mon, 04 Dec 2023 04:42:20 +0000
Date: Sun, 3 Dec 2023 20:42:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: repair obviously broken inode modes
Message-ID: <ZW1YrEe7ULkUq9fr@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927551.2771142.12581005882564921107.stgit@frogsfrogsfrogs>
 <ZWgUYG+Hv/rO3upQ@infradead.org>
 <20231130211856.GO361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130211856.GO361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 30, 2023 at 01:18:56PM -0800, Darrick J. Wong wrote:
> > Maybe I'm missing something important, but I don't see why a normal
> > user couldn't construct a file that looks like an XFS directory, and
> > that's a perfectly fine thing to do?
> 
> They could very well do that, and it might confuse the scanner.
> However, I'd like to draw your attention to xrep_dinode_mode, which will
> set the user/group to root with 0000 access mode.  That at least will
> keep unprivileged users from seeing the potentially weird file until the
> higher level repair functions can deal with it (or the sysadmin deletes
> it).

Having a perfectly valid (but weird) file cause repair action just seems
like a really bad idea.

