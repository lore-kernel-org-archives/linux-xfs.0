Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8F456B8C
	for <linux-xfs@vger.kernel.org>; Sat, 21 Dec 2024 08:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734768361; cv=none; b=DtL0T2WWZ/w+jHyJSH2QMXl/LZmrzv0yuVcgLXV1bNUYW3I3T7JE2FBuxGZGNnPKHcR48gQPSGkv7+vN/cypDjo/FntI1bGj0aWag4HGcOTfvP0JBHVAxw5D1GfsFbtBLZPObUrjbZ+iA6VZfBto5UIVhhonSHeQfiRegrWBTms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734768361; c=relaxed/simple;
	bh=wjrI3j4bi/QuXXqAtEdbCMUvjZsthGajDten9mr20/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dAXf2e5SI5ueKn3cgT3ML1BNvnl73lviAR2vgKmBgMX7kvWfA1ZXgQ3ZaWMw8dG1zDVYs34MBz3zvfqr6+vcwoVcnTi7DsD0MnOcuc0sTMy9t9IJgu8QhTIHpbyemwGpS2GCqSb/2LRItLN7pqN6/TZdqXt7lBKs4qxb4ZDEeG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nwa+z4Sn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nwa+z4Sn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wjrI3j4bi/QuXXqAtEdbCMUvjZsthGajDten9mr20/k=; b=nwa+z4SnAnW5a9/JP8V4OPXS4h
	/hQNAfswcM/gRItDCjN6Vsf1eM44CS54RN91tzjeSgD+6bby7WtN+I86UekcEDh9At/DsMhvl6n/p
	i20e4mhEF45iwru4iv7XkCKhNq1/+vMX4qMWKSRqiCem5twlwWWM4lReAlrWnTwSe8Ls+3RSJ2TIi
	m2jeVyw0O9koy1gxggHR8W9MjSsAwaDYVMXqo5n7UhydKfq+86kCzCxrVKU40St/AQcyvrU68+Q2e
	hV5vSze+bua5lbdNAcoq3MAoggeCozGJCYyUMlZby05piLdjLu/xbiQtScrLmgp7k4nJgYHZpqbKj
	n/cUKifg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOuUo-00000006i4K-1DFA;
	Sat, 21 Dec 2024 08:05:58 +0000
Date: Sat, 21 Dec 2024 00:05:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: remove redundant update for t_curr_res in
 xfs_log_ticket_regrant
Message-ID: <Z2Z25oUtIqtV_wjO@infradead.org>
References: <20241221063043.106037-1-leo.lilong@huawei.com>
 <20241221063043.106037-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241221063043.106037-2-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Dec 21, 2024 at 02:30:42PM +0800, Long Li wrote:
> The current reservation of the log ticket has already been updated in
> xfs_log_ticket_regrant(),

Maybe say "a few lines above" as both calls are in
xfs_log_ticket_regrant?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

