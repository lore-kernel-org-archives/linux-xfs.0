Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275951;
	b=4BG/15czQ+t0Px0osnx6nLVWJQu1Mm2Ow3XFp7sqEKX7b+TTpHar9RDpMlhHeRXX243x
	 OuoxH+qL5OA5cKTBb4o+7ZTOyJ0yIkhYk3dIGFuQ+s8WRpRFZNyxJt2QW8bu4KV1/bsD8
	 +rSP5w1t2qc1KZbgdcjMgBXxQg6tLRG+dDD5ZHZN5dv6cbFF2cyBiCovU6PxtjU8mlhbM
	 aPm/sALE2RXwm8feeCfxvVhPaVVnGGCLSEixy32QK4OCzBU/E28UCJiEcz8S1GOArqEoR
	 1GBCPdFs4WbP2D65AT63j4wr0TOLYfP2HGhwWIux7txmXl9m8VyMs3ZNgaq9V+hXZTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275951;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=/4ZhXoN9av/i/nAr+j+V2/Gl9lTBcVPLoPBLDasBqrQ=;
	b=F+2p9FRaNY1VSW1wFyXtXtTDbydCAd99LlIn16REtsGTkviK3V/w7NEKfdkdGbbzCpfC
	 /gnXj+4KpmOh54Z1THtfW1GHKWaShsYzTVctkGD8Fc3Jcl1FpA3LU0Du1SRiHpMFR9Ngf
	 Rp0/L0d6v/RsrXlClCLHCImPjlBRdSZ/r4HyxiJIOROhEhdAzzGu+4bGghbnUis98Sd5D
	 dG/I7r/I4YZqYA3CUoy6IH7+KIEq2jR6DUCntKDxM7rh0YyY7P9jjsCPRfhlsoOUJ8DMc
	 pnm70yJPQzSKNFKkXcubQ+9xUEFVXGr1prdHENZdXsLr7+SOvcmvRxVdTEMfRFxRW9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0750606A31C;
	Thu, 29 Oct 2026 12:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0750606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 685CD68BFE; Thu, 29 Oct 2026 13:12:21 +0100 (CET)
Date: Thu, 29 Oct 2026 13:12:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Chris Mason <clm@meta.com>, Josef Bacik <josef@toxicpanda.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: don't mark unwritten parts of a folio
 uptodate
Message-ID: <20261029121220.GA24197@lst.de>
References: <20261029-work-iomap-ai-fixes-v1-0-7eda63bc1b13@kernel.org> <20261029-work-iomap-ai-fixes-v1-1-7eda63bc1b13@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-work-iomap-ai-fixes-v1-1-7eda63bc1b13@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 29, 2026 at 11:34:48AM +0100, Christian Brauner wrote:
> on disk. A source buffer that ends in an unmapped page is enough:
> 
>         ftruncate(fd, 4096);
>         pwrite(fd, p, 3000, 100);    /* 16 bytes at p, then PROT_NONE */
>         pread(fd, buf, 4096, 0);

Can we wire this up to xfstests, please?

> Willy reported this back in 2024 (cf. [1]) and Zhang Yi posted the same
> fix (cf. [2]) but it never got merged.

Should we credit the original submission then?

