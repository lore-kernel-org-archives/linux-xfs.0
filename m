Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB89417A308;
	Wed, 19 Feb 2025 07:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950363; cv=none; b=YxyTD9RqG4ABwio05MRvfSDoxbCfqvPvkFoJ8c2n2hXXvSXtD6kWFOQcTojvQy6QimFUmF5+NRw8u4qfHdSICHoJLUL3r/gj8zQvkpm84FHV5HsQGdmmDKiM7+jhXxRNC6JoOSrYs2llliZjS7WWnGeBo/8vhIkqQcb0trbVWrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950363; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vdh3Fdb/yCkugXCApz0ZkKOIXn/MkqI8rDcJHLwBrjEd9sYr/0WMxZU2e8lfDaOBGXpA8rysG8GxK3RilJB3SosxCbqJIH+W/1e6oo7GynsJzrhUR9y2x9ger8CQoSPzNK1R4wKANeChx7bpDcWglRSiPj7w3///3NJWlgEmvjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=av13/yZi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="av13/yZi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=av13/yZi/Cq2/2OJqMh5DR7MWE
	eisEWv795sakYPDbwePgkRXmvj8tpT5QXuh1OGPVvb96aa9Mzrv8V816ytZ/QwVN3FnIAnZa+mmk6
	PPv9++Raxu+P1Qkf+BW1E1rfna7/QO9GjLniGFQQgUjuE8wFvRAkscxlH5KzgQyII1p/Fndr2TIiZ
	WcQkWEdvbDUWCknGqQwcg+ZXcpSHOG+zC19sFlbWNoLyjnEvzVupKnQ+qwbiF5Aw9hzWdf357mmd6
	qG+/sh+6o+u/vJsR8xfeDtpO0usfdSeSpU1zPuwp0cMFEy40kVKAgMkOo0bXvI4EhcFXP7rj2BT8F
	nN2DHx5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeZV-0000000BGVo-2ilT;
	Wed, 19 Feb 2025 07:32:41 +0000
Date: Tue, 18 Feb 2025 23:32:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 13/13] fuzzy: create missing fuzz tests for rt rmap btrees
Message-ID: <Z7WJGQmH5-rOhdUo@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591349.4080556.636964987283271719.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591349.4080556.636964987283271719.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

