Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E031DD0EF;
	Tue, 28 Jul 2026 03:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785210650; cv=none; b=WyIEQTlIwJM780g2lOQmytN6VFjjLqBO4/11lT2p30tnk5kBDSlms+bAi30M8KHnnsW9vpvRhYjttPfShIG12DiYp/yOGNOk3CEPOKYwCy/zdItE1wwcL82w0TU3xUGPonXmWxMhWc86ZjLiq60v8NTrTRto1P5fecpvmbRbVPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785210650; c=relaxed/simple;
	bh=E7IaVvuXtiUvLqB2WD17U1iqvjUO/Ptxc/o62CKJeN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxmEhZKE2SC48HXQAU5Hwws1pNnc1hhvTOGzP5qRr3DzGh1KV/ctqOFTm74wW6jBVXUIi7V1XtnSa2GSLD3WZ38iKKpCyMEoSCnQApQhMNiSFVlod0Lnny40n8ZYT5lUupaRIVULyrIil+c4s886jze6TuoKkH+jKtjX2XW4bqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D257B68AFE; Tue, 28 Jul 2026 05:50:43 +0200 (CEST)
Date: Tue, 28 Jul 2026 05:50:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org, changfengnan@bytedance.com,
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>, tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 00/21] iomap: convert to in-iter iomap_next() model
Message-ID: <20260728035043.GA19120@lst.de>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

I've already reviewed (or written :)) all relevant patches, but
the overall state here looks great.  Let's get this in ASAP.

