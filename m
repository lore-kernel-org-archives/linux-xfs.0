Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE15238A711;
	Mon,  7 Sep 2026 05:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760407; cv=none; b=gaEsFywtbhLTgbj1YPVTA7vE1MauKY5r5rNExpWMg129CmmIYq5cqNQSQWDt1Dm9SDJ1awfsNoBGB8XGxLlzfwLo7vTGTZrAhZp0WKcFfTdRa0x4WWmIQUJseIVWXT8OjqHRjKtD5OZOTIczyycON89pm8b3uYH8nGh84p5LCO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760407; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZP9oBNr5JsCwUoREaiXr9jXzzF7oICD4XKrYlcZP9LsTwWYImyzG0cnrcPL/GIiE8aBM1LrwPRSdzxzmF2O0/eJqjC9es79YPSpdcb1kDEKxG0K1E1OrYmIz5XGsTz7x3p2DtkBnzKD1hYI+wR5cKzlgzPcCaJfloidrQUke0VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 869D768D05; Mon,  7 Sep 2026 07:53:22 +0200 (CEST)
Date: Mon, 7 Sep 2026 07:53:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: cem@kernel.org, dgc@kernel.org, djwong@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	yangerkun@huawei.com, chengzhihao1@huawei.com, wozizhi@huawei.com
Subject: Re: [PATCH V2] xfs: remove several unused and never-implemented
 declarations
Message-ID: <20260907055322.GA31689@lst.de>
References: <20260905010354.142327-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905010354.142327-1-wozizhi@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

