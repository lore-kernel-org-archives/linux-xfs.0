Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794527482;
	b=gogO7B3PUE/VPsdOgvdk9HBXq93lq0kjI42E5AzgsjAWjWox7y4UHP3ikf/hhBUPSApG
	 hGzmaPH5CzBgdND1pWqjUUMNCWWLmZUKJ4Nc+1wACpBWMrVT+HgTSXtZPiIuFn/6IPNJV
	 KZ4fEwz5sKW7jY3VeGnQdBzmcK7d8M5OyowNjjQvPPQFR9zbt3lsnkmpcqg+AfvBrLhuz
	 z7vRMZYI1RVhb03cialcxz1BkuLY7oqEzLcviuHsvbvTYPlR4hZfScr7g3mcvVXw+DBZQ
	 xklKQ1o2oDaWl2ha+kqb1DJYZtkxWCSVQF9GxbaSI0jTpf1aN5RlviSXRZNJuX2moyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794527482;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=R/LyeV9/UsRWV8cI6F5TmoGFA99tg6+j0Ce0Yl2vNmX3Gptcnnl7uph0HeBM9spPQ6yG
	 67v518yYUW1ZrD7sQfOBpak+mR4/sCseB2o+AyxeJvAc5c1s++92TEY1hGXib8O0z/Hua
	 M8+cqFSkGqzXg1d2kRVFzAy/Dwf1bJUDTAbnxhw81wPzwENC07MLlqNGMqu+AkjDEJiVn
	 CxQheC8iycc7tFkkNX15WuuFN8eitIyxmuJHC4NFC1BO/rs47yjsLuOgE78YzW7FZv3aJ
	 Q7nJCg9pUIwcn8AIqqlSbrQil6iuqQ3DrDYCDuX3/y4izBAx1gfbrPH6umF5K3/MgOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCD8606A31C;
	Thu, 12 Nov 2026 23:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BCD8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70A0768D0E; Fri, 13 Nov 2026 00:51:18 +0100 (CET)
Date: Fri, 13 Nov 2026 00:51:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, cem@kernel.org, david@fromorbit.com, jack@suse.cz,
	djwong@kernel.org, josef@toxicpanda.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v9 14/14] xfs: test for realtime and reflink under the
 pNFS locks
Message-ID: <20261112235118.GD13410@lst.de>
References: <20261112214604.67875-1-mason@kernel.org> <20261112214604.67875-15-mason@kernel.org>
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
In-Reply-To: <20261112214604.67875-15-mason@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

