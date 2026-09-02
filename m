Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB37D360EC5;
	Wed,  2 Sep 2026 14:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788357925; cv=none; b=F6P9NdJxzONapVkVKHPSfXL9+pR59uNtfdxr4Wvb8/XnOzwLfLplBWlk3bqF71z5Qh8H0un58xFVaarYJ/WJDLp3zjqDbAxkiOwfEq26FknuN5VlS40KXoZs3vyFUpTZFqAXmCmBObsPB3GtzOAxMlkStYgnfyiLrNEqGbXXJtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788357925; c=relaxed/simple;
	bh=O03zeslTTrPyKSUS1O5GlN4EAAvJ+tiYk1kkKMGqOWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OGVzzAA417Scu/O/oa1xEEvwm0uLPINhMWEBBMZuYau5l3RrP/NRf9n8y4fmHWEZRB+s45GgryTbBO/V9FWWik+cyl/Zrkm0315d+woehSnYDw79jelD0Yd0tqCMd+gnhqhtcvVvagqGrQLEGiMpjLkYiPncO1IOw8wiC+nxgAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B39836732A; Wed,  2 Sep 2026 16:05:20 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:05:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	brauner@kernel.org, dgc@kernel.org, jack@suse.cz, cem@kernel.org,
	axboe@kernel.dk, kbusch@kernel.org, ritesh.list@gmail.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 1/6] fs: add write-stream management ioctls
Message-ID: <20260902140520.GA23766@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319@epcas5p3.samsung.com> <20260717125538.508925-2-joshi.k@samsung.com> <20260721030338.GU7380@frogsfrogsfrogs> <71ae458a-a6e3-4c6f-8fb9-7e8bc088bb87@samsung.com> <20260819070814.GB1541@lst.de> <076db8e7-6c6e-4d91-b442-1471ad7a5c27@samsung.com> <20260825065533.GA24808@lst.de> <c6064b06-9e34-4790-80ef-c76333c2a11a@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6064b06-9e34-4790-80ef-c76333c2a11a@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 26, 2026 at 04:12:52PM +0530, Kanchan Joshi wrote:
> So based on the above discussion, do you see this as the right interface?
> 
> 1. FS_IOC_WRITE_STREAM_GET_MAX : query max write streams
> 2. FS_IOC_WRITE_STREAM_ALLOC: allocate any write stream (if available) 
> and return stream fd. No flag whatsoever.
> 3. FS_IOC_WRITE_STREAM_SET: set write stream into a file using stream-fd

Yes.
