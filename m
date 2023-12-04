Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1Sp2UA+E"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFDEE6
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 20:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ji6mKHd9e9uYYFqbJTNaa87Kwz6226TfoJyZZr6OMAM=; b=1Sp2UA+E5r29hDN3kkqzqONlW4
	dqGAyevdfOZ1u7uWngvBlJlCznehmGFEoaLmYWn2Em+js5ZE8q6cPBRqEp9MuNoTsvV4TXePpgaEI
	zVaBgiHOq4TGz1OFsdnVEsBfbAB/irGYEsX25By/lrcAZXRpUWC1PK9xCXq38TyQfUqbXncbeSPFd
	nPUSNxQ7w50QEpDPy3QHTPHxNbZsQKuj2bmFTKnUqtFhf2rM9t8hweh6baQ1nqVlGdYiSfYwVxNyW
	DEzEG3SSNMbJYVVwFkDDkb5SrvuG9eX5GwNOI08UWorgAgE7D6aCa8kDS5I8Lb5fAu0B+ld26H1+3
	U6jZUYug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rA0tH-0030NL-15;
	Mon, 04 Dec 2023 04:49:07 +0000
Date: Sun, 3 Dec 2023 20:49:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: repair quotas
Message-ID: <ZW1aQ0mL09Nn2wKv@infradead.org>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
 <170086928871.2771741.2277452744114090363.stgit@frogsfrogsfrogs>
 <ZWgetfZA0JLz94Ld@infradead.org>
 <20231130221015.GR361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130221015.GR361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 30, 2023 at 02:10:15PM -0800, Darrick J. Wong wrote:
> sorta slow, so perhaps it would be justified to create a special
> no-alloc dqget function where the caller is allowed to pre-acquire the
> ILOCK.

That beeing said, a no-alloc dqget does sound like a sensible idea in
general.

