Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4DC3BB69E;
	Thu, 30 Jul 2026 07:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785396565; cv=none; b=hOUuKSW2r0v+kQbH29U5C4+DEmh0Dn0sJFBO2Aj1ycatipM5zUZs0U60HOEQhDDbtlGXjHsl2Pou61xO1ZXWEoul6bXAlExe+2e7lf9H4pzvbyitr7COJQ1WWN+RjAAMHQDfHPgEM4afU6xtykFOrPNzvw42G6YqtkxvQJ1jKnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785396565; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtgNE9kuHe+OkstTBecWtyQepVi5GQfwAXXyAoINTSXRXWcETN6qhvqCr2eIqCEOEh4R8B1MFgs7Y8QNZoyKr+ZcYTcgWWoubd84apVKCp3sdOf0pTjfYBO6P+qAVCvWIzG4pZnsrBvKIIPXn8zV8QrPO1qWCMY3/KU//1N8DEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3834D68BFE; Thu, 30 Jul 2026 09:29:08 +0200 (CEST)
Date: Thu, 30 Jul 2026 09:29:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org, changfengnan@bytedance.com,
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com,
	bfoster@redhat.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v5 01/22] iomap: release the folio batch on iomap
 callback failures
Message-ID: <20260730072908.GB7104@lst.de>
References: <20260729192737.3190206-1-joannelkoong@gmail.com> <20260729192737.3190206-2-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729192737.3190206-2-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

