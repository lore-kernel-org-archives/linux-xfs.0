Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F851364EAE;
	Fri, 23 Jan 2026 07:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152583; cv=none; b=V8eFo1nXZ7liJN7iFjiCkO2AoC+T7322T8/IB+5koBYN5u0yPj18atHiYQi7VgRKUVNogTN/TA3zy/cLEtVdiXC5E4JbLKW74Q3LmPHwt7bnGpesp3pg9aiunVX/4IhhlwGEHD2mZQfGT++sYjf9OB2N8uoKtOaerACP7CNp4ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152583; c=relaxed/simple;
	bh=VcJuKri6TkxIWa+hj93qXOH/gz80rtCbN5j4muZA0T4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JM1UIxCu/4IlhVIM+dnAvMUtPuC8QVc8UtarOUd1C7lrrGnF/q0Io8zzWsKYox+efjSCMPvoLYciVn6xbxxZeZ8piSQOtBLkMhy0R5Ksmkcas8zsZt+1I+aw2OM9Qysg77+qePW2t5edfmj5oehs4MkzoQzXvd9doJ6TN54JSQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6A4BE227AAE; Fri, 23 Jan 2026 08:16:13 +0100 (CET)
Date: Fri, 23 Jan 2026 08:16:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/14] block: add helpers to bounce buffer an iov_iter
 into bios
Message-ID: <20260123071613.GC27176@lst.de>
References: <20260119074425.4005867-1-hch@lst.de> <20260119074425.4005867-6-hch@lst.de> <20260122172556.GV5945@frogsfrogsfrogs> <20260123055128.GC24902@lst.de> <20260123071139.GT5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123071139.GT5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 22, 2026 at 11:11:39PM -0800, Darrick J. Wong wrote:
> Ah, right.  How about adding a comment so that future me doesn't trip on
> this again?
> 
> 	/* copying to pinned pages should always work */
> 	WARN_ON_ONCE(copy_to_iter(...));

Done.

