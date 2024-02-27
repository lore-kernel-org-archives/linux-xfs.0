Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD1E1C6B0
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709053042; cv=none; b=nNKb3P5HN4BRlbWCMsAP3zSAeRIBVccYmawbkjEYV53xxUXBqsyU4yc03AzHLUHPdZ0kmEkL0LQu90vG2lJUG9EowhfrR0oaBRpafVBeuYNlQk3wnpD29l1ks081bMq0idLTUlTX47Jg3BgH7owSj8yu8LaUaPjgmQypaAx9+gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709053042; c=relaxed/simple;
	bh=IphGBA97nXAl2L4SnuwBOOwQmqWOwS8N8+sjrATDMFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MS6nDE1gskp9vOuJh9HQEpXx4sm5QxvKOAuNd3nLR1r5AsPl2OJSoiO5eX6/wgTKSBAc2Lryi8JYVtEAKSn4cuJSXmAw3jg0RjEvHrKQ+p8h+MW02ym9LLp35IlVm7ad861bLrJhA/aDWwyPpNn5kZakpMrO1tLL0zhQeptCQYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A47ED68D08; Tue, 27 Feb 2024 17:57:15 +0100 (CET)
Date: Tue, 27 Feb 2024 17:57:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 5/6] xfs: hoist multi-fsb allocation unit detection to
 a helper
Message-ID: <20240227165715.GB17238@lst.de>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs> <170900011214.938068.18217925414531189912.stgit@frogsfrogsfrogs> <Zd4E_0nWedVHXl6s@infradead.org> <20240227161007.GX616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227161007.GX616564@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Sounds good.
