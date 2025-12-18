Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E7F21B196;
	Thu, 18 Dec 2025 05:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766034918; cv=none; b=cBl9JqU0jWFkoCEPmQR1zzPolW8nAukgOO07NtkGrYtN7fAKVRzkHY1VmMFZsjjK24v7zSavGBneOUolui7Adhms+Os4o7qWeMQsWMqbJ5Yy9dAxXTSV+2Ley2uT6flalYdedqOPszJukOAI1Ucb6TWuyjYj93JH+DP8RS9V/pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766034918; c=relaxed/simple;
	bh=pZxlOMsvE+RH64A0rSpIUqm1vokkH/Qn2MzrD405vQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aw/uO6wKaM608x6SG1xyjNCfaW1blUx76MstQ/vLBGNz4GbsQNAQDv2LqQjh1xotrzqhBhNXVNVdN6zoCrlnnCDir4Gy4cK7w7L8t2QDJRu9eoLL9RgZIw35vJsj78jDEy2tpOt/o7nqjcHIMxDqRIJD+knBmSp71omVxH7dq8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DlXsNLWy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DlXsNLWy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pZxlOMsvE+RH64A0rSpIUqm1vokkH/Qn2MzrD405vQw=; b=DlXsNLWyGVACHQopBo43OKOTbE
	L2Z4elzxjIShvywtgctmFqnKNuN6iyI7sc+uo7cx44sXqLiAHBUBYY+GTEtlmt3b9Eri/TM/Q2Gf7
	M2+6SH1Uc/VyZzs+EL1ZJRCoNIPQpjvhVhHueU6m9MCBiJognqqIFDRUCAbHYyxGBtdYNWJqikE3Q
	WdMFI6sx3MkyrmGcUNbZzDZJnh/K6eiuPtzZzXfgrwTkO/2PJcCJmO34EDCUrXMlFudPyonZnbm9H
	sMKdwFUY+5V/BZFnAjm6xuwYHonn50X/qqrRtYx2KvswMBsjr4vwKrOpUR0XajEAcP3V6WMaK3CFE
	3XjkA3Dg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW6M7-00000007osb-1ujc;
	Thu, 18 Dec 2025 05:15:15 +0000
Date: Wed, 17 Dec 2025 21:15:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+ccf9f05f06b4b951f3cd@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, cem@kernel.org,
	david@kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	lorenzo.stoakes@oracle.com, mhocko@kernel.org,
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com,
	weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [syzbot] [xfs] general protection fault in workingset_refault (3)
Message-ID: <aUON4007YupX-eRQ@infradead.org>
References: <6942c6f5.a70a0220.207337.0063.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6942c6f5.a70a0220.207337.0063.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This looks like more of the freader mess and not xfs. In fact I don't
see xfs anywhere in the call stack.

