Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490592;
	b=ooR2Hrt55/FnkfP8xy8roDz73PnRiCcwBu4AX8riEtezksYzBMcLck+7ueMo4IgNNsgT
	 zKVixMDwmJotyrxRQSFxtMUOs4fl+RZ8bcr/pCJhwDe87quA23XLWG9ygp5jhb8rWSHvn
	 i0+yD7/V0ImuoCcjEwG2roshW/NRZ1QZhKhUNM133WKnPlMLkuza+eSBToMiyqOKjd7LL
	 XemIqD6Kys+8r6yzscX2AENI932EqCarAJyOWmOCPXLVOpuN9Q/wnLe39BrJo9QYbUJhf
	 mBWWD9G+5zLuwPeNR394OIz83TciMqOSg92o+HSu3IIUHijZZqbwyY9b7KpzcNM/hHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490592;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=ZgLJYhK1BjbLimpACu+jHJqradb1yXPVUqTFH604lPY=;
	b=DjLO9VeSRLkG6SH/vkyavKkb0evjS9z2LTBxgSF4qCV6KwHGAhAK8zK4PNdorMyBwWF4
	 Mdh8jurknxMvprzMumDC7lF8O4ElU5oiJSor5VJCR5Mjt1Rxb1+sH1xEfdRBI0tDymHkg
	 hBkbq1FEGvz8A9n44eV8dgEa5+m4XrRvDbokORI/YX7lxLGZzUw5egKsfCgpSwhQWkdYT
	 9gahnqnqOCg7oxXlDOHRKnfDOQiJBmwIjvvQSQenBfMZgRKduaxhrkUwRVWRFLTzyYGnN
	 bD8GLme1dqOWdd/USvDPIjdoNMfX5p7Dca2Z+IlRiA9EMZrnuSyovhIXqRPLayTfnRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6F1606A330;
	Thu, 12 Nov 2026 13:36:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB6F1606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5CA016732A; Thu, 12 Nov 2026 14:36:28 +0100 (CET)
Date: Thu, 12 Nov 2026 14:36:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, cem@kernel.org, david@fromorbit.com, jack@suse.cz,
	djwong@kernel.org, josef@toxicpanda.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v8 14/15] xfs: resample the COW extsize hint after
 cycling ILOCK
Message-ID: <20261112133628.GD22165@lst.de>
References: <20261112010229.51029-1-mason@kernel.org> <20261112010229.51029-15-mason@kernel.org>
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
In-Reply-To: <20261112010229.51029-15-mason@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

another argument for taking the mmaplock in fileattr_get...

