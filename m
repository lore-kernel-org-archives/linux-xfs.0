Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275985;
	b=hinDAw7e5Y7kMHZF0dvO5BMJEh9x6jox1Bz4aE2QpFtSH00QiIaM41MpM8X6z5csaWsM
	 KRH9AtIE0rghmnmzjX33rikm53x8J0Kl+lEvPogXflWL7UQhg/YJb++nOeZPwjtAfR0Da
	 /u3LUimVKNbRPAc09xsAoRdSQMGAHHdKbY2xZzxTx3z/ItIbbYZnOKgQBJ5TrGR04y7DF
	 Wc0+BTdREJEby/KVjK+4C4drXkuMhH2DIw79iMH8cs9482AM5Pb6LXvysNJDYLeb2F86I
	 j5XPkYcsXrr1wqDZyaxEX5gqPX8E9KnWDlJ3pwuQMs/iiUUDYCZxEyYOid4NRCNXLGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275985;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=JQ/VlMZBYgesX1minqFyHyMA9P7Afd1+RDXwmmog4/pkqJzoVmmrHb7LeZifJIBt9TMl
	 I3btqc2Eye5y4BVTrTZftZrUc29+A3KbJEqM7YtXHqktIF75nkbBiW+3YMycdv6xriG4k
	 CGsKJckNX7+bUWvlrenPxlGrJZOTQq2ZGBNFljFXIywotapFvq3uKbnkQDdU86Gyb77iW
	 Wwsuof5QjOd7hReEmSxWanQ4DsIgo7QBFqS5ocpoOhIo6rkBihMu+q8HdJidG+jZUa1xp
	 Hd06x3wvVwRDCagH8DyEvwkKaCPKNwm3HpBSG0BR48PW73yJxJYB6l58tKUiu58lAjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012E8606A326;
	Thu, 29 Oct 2026 12:13:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 012E8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D42CF68BEB; Thu, 29 Oct 2026 13:12:59 +0100 (CET)
Date: Thu, 29 Oct 2026 13:12:58 +0100
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
Subject: Re: [PATCH 2/2] iomap: keep large chunks from defeating the bio cap
Message-ID: <20261029121258.GB24197@lst.de>
References: <20261029-work-iomap-ai-fixes-v1-0-7eda63bc1b13@kernel.org> <20261029-work-iomap-ai-fixes-v1-2-7eda63bc1b13@kernel.org>
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
In-Reply-To: <20261029-work-iomap-ai-fixes-v1-2-7eda63bc1b13@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

