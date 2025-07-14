Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC498233701;
	Mon, 14 Jul 2025 10:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752489984; cv=none; b=aRQsXEVbBM1dAkws5idy3cn1MowE+hvrdzC8aVGbvD+wHmMXhFvR+ZhzSaU5hhT4N9mxM1n9Eq67iCz8e3RHdBZoPYQrXvKFDNvwPFzmUjN7LqwUgfLt1zKvJGd8nsQvLKsoKkpWfhTlYdNgOOtcDUqFRI5XUDUs4S6btNdIcPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752489984; c=relaxed/simple;
	bh=i90h/U4It8j6YmE1GXWWlAAcqeV4kuKibWn5+OgURX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QwnmqPpNIsCRCxichf4Lu1sVAqHzO8+3kOBL2Wnb2RXVC+9Re+TQNXmjFvf/FZ25aY8IIV2ZQwfD09J6NxfpKdIbOyz8nX1FItglv0caSRoZppm7U/hYiIKS5PH4U08VJ1TF02fIvjSbKAI0T6jzMsY1ocLKHXdBrc7I0iVkTUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AF7E5227A87; Mon, 14 Jul 2025 12:46:15 +0200 (CEST)
Date: Mon, 14 Jul 2025 12:46:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, yukuai3@huawei.com, nilay@linux.ibm.com,
	axboe@kernel.dk, cem@kernel.org, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org, ojaswin@linux.ibm.com,
	martin.petersen@oracle.com, akpm@linux-foundation.org,
	linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
Message-ID: <20250714104615.GA30407@lst.de>
References: <20250711080929.3091196-1-john.g.garry@oracle.com> <f80713ec-fef1-4a33-b7bf-820ca69cb6ce@kernel.org> <20250714055338.GA13470@lst.de> <706d13cf-d0e2-4c30-8943-2c719f9be083@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <706d13cf-d0e2-4c30-8943-2c719f9be083@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 14, 2025 at 08:52:39AM +0100, John Garry wrote:
> On 14/07/2025 06:53, Christoph Hellwig wrote:
>> Now we should be able to implement the software atomic writes pretty
>> easily for zoned XFS, and funnily they might actually be slightly faster
>> than normal writes due to the transaction batching.  Now that we're
>> getting reasonable test coverage we should be able to give it a spin, but
>> I have a few too many things on my plate at the moment.
>
> Isn't reflink currently incompatible with zoned xfs?

reflink itself yes due to the garbage collection algorithm that is not
reflink aware.  But all I/O on zoned file RT device uses the same I/O
path design as writes that unshare reflinks because it always has to
write out of place.

