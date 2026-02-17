Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC9121ABD7;
	Tue, 17 Feb 2026 05:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771307476; cv=none; b=B817Kgp8ffcS8iGy88uazw2+/nSAGwM44sU23SfjcSlkf+W90cSjUEN6GGEkTxaV7jYbs+JyFG5LgYrM7HkI25HB9sPsHkFTmOG/kZ8Ue+uCH/c4eb2dCL83j3FHiGuGVo+UOSODojEAxXxQ6+ng1qGar6cyw0Da71IjFjF8LAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771307476; c=relaxed/simple;
	bh=IvdmmAkiQbI8GM6eL5zuHPV2rPVW8fLBTRizzQSBji0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIzCp2i5u1sscIu1+1jXSgqV51f6ay8/ufuBE1mE7KD4iMNkPEQPy5Cj9kRQp3eEC12ddrvSEPfA33YYdLPjRkkmq4uA9Yts8C9/9q1Cm/W5sRDei/dKx1gQMhxlgMmuefTPzlb2tbTrzFloDsu2PDg1ijdzr+YqxRN4OJTnO/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3B5B868C4E; Tue, 17 Feb 2026 06:51:03 +0100 (CET)
Date: Tue, 17 Feb 2026 06:51:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, jack@suse.cz, ojaswin@linux.ibm.com,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260217055103.GA6174@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

I think a better session would be how we can help postgres to move
off buffered I/O instead of adding more special cases for them.
