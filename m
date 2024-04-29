Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAE0F9DF
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 06:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714371447; cv=none; b=mrMD4+VgErgkTnxq8rIiaM7dZ57OZcXWX9mbz9Y0MXtpn2Rz2iU66w6fG3+NBffkz/DdGhVOLkNd3oo226GlFeNJoeSHTD/HCbxMS11C78XYeaLI1aBJHvoNgzdRMZ33LigYYop1pP111+iQg+wBPTS1VNodENI37hKRC1Fc7rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714371447; c=relaxed/simple;
	bh=TCDxt6jfk1CFHI4fBO0lPKV8vsHQHqRGqoAcKI5sRPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zi+gEuyK1m6rnEu1v1n/Rvod40FGV3t6ZZs2/pjAlx8Kdcv+ES759A6WkLL1l0bL5fk/8TuRH8AXrgEa3uFPn06zlUzjaTW0Qtk6YyRDfVj+hZBAavZ/V+n9h2tCpiTFxg/hyDST58XYDnvLxLqwNViDtJQc65pnTROrgijX6Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 153B1227A87; Mon, 29 Apr 2024 08:17:22 +0200 (CEST)
Date: Mon, 29 Apr 2024 08:17:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] mm,page_owner: don't remove GFP flags in
 add_stack_record_to_list
Message-ID: <20240429061721.GA1010@lst.de>
References: <20240429061529.1550204-1-hch@lst.de> <20240429061529.1550204-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429061529.1550204-10-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

Please discard one, I developed this on the currently checked out tree,
but it has been sent separately.

