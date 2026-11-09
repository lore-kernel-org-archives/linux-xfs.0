Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.241
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794192731;
	b=av66hAKZ0bGKXBhDFdVRnFElBA7Rlha9eaeyy97+FIJLNF3uciG0LuSztDUg1m4aUf3k
	 n46WV3koBoYWRlQ0G5XIvwfD4sqcUjZCDhkSgv6o3LUGExPgjl/cKsoCyWqurtCyQDZgO
	 AkQBA0Cza/uOF/26P2GV+EjvD/xCviKPd1TE/RPh7tqMYWasMD4KXsCTaT1kpC2hNU3lj
	 jWtGhHSVBT3du66Gg2JTxCyWsXBEVaw3Q9oQRTGqOfWvQEZO7LkloSf4ostTvKQk6RO4+
	 JyJm7NbEgmE57N+NI0Bs6ngbYfMYH0loNn5wVCj0OEEZbktb1D5ZennrFMc145xNgjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794192731;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=nWqWiduDQX/+eDY/lBNMvXq4xgQ2WR9If/niokbocYQ=;
	b=bcZQ2LtkYdA2GUJTPmGgbuyx3BeYIpsm85oqlqxmL4e987t4R3gwH79ACbRG6QzMjcU9
	 28HfHJwTJ793/AAy9X0wH1IoEtsNWnYXBGZ/HKZItiFQTqHhAr7QsCWLpmcZ3692qHT1W
	 2x2Wjl90gvZNgG5PLuLI6akQdP5xnrU3F+ZPX80wH+eCTUEBSW9k8bKPYByVBKz0F+Scb
	 7m9DOh+pKRHpWhbTSChCbtUHWG0zT/cPzHxVZaSeUkLWNkHqEEUqek/5yD32RYtF/FNUQ
	 vHTeb8PVIadG5Fdk4S1IkCCjOFqEYi6Tr8imGDseTAluTZNcfGmeyYI0djJcdR9Iuyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pKqbz5+1;
	arc=none smtp.remote-ip=91.218.175.241
Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45C9606A32A
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 02:52:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E45C9606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pKqbz5+1
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1zQrA1miKQ/sO3U4FLD9eN7ND1EAn4eFHq58nFmS/2c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794192722; v=1; x=1794797522;
 b=pKqbz5+1nAKvoDjratDGIzCVYLRnYWqr1KkI/51AbwTsIOLh1H3KSkwjZnitIUapDrfX3moK
 iBDOjWlEa0LcAglhZ0IIVJXQpa10JvLhgoeorLL1bBrmrzYqTSk7F/F73Ux8tJumFsmES18Q1nY
 WVU2IQ4+YlREcEp/U62zWKW0=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f8a5242679d67f97;
	Mon, 09 Nov 2026 02:52:02 +0000
X-Mizu-Trace-ID: f8a5242679d67f97
X-Migadu-Flow: FLOW_OUT
Message-ID: <3f45a5f9-9c87-420d-b6a5-6145c834c0d1@linux.dev>
Date: Mon, 9 Nov 2026 10:51:46 +0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/6] block: refuse a dma-buf bio that carries a crypto
 context
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
 Anuj Gupta <anuj1072538@gmail.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
 <20261105065847.196540-2-mengmeng.zhao@linux.dev>
 <20261106104119.GA5668@lst.de>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261106104119.GA5668@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/26 18:41, Christoph Hellwig wrote:
> On Thu, Nov 05, 2026 at 02:58:42PM +0800, Mengmeng Zhao wrote:
>> +	/* a dma-buf bio has no pages for integrity work or contents crypto */
>>  	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
>> -		bdev_has_integrity_csum(bio->bi_bdev))) {
>> +	    (bdev_has_integrity_csum(bio->bi_bdev) ||
>> +	     bio_has_crypt_ctx(bio)))) {
> 
> This could really use a factored helper explaining all the refusals.
> And maybe we should use the chance to sit back and think what else
> would blow up and add it there as well.
> 
Hi Christoph, thanks for the review. I will extract a helper in V2 soon. 
There are several buffered io fallbacks, it's really necessary to discuss
how to avoid these. Glad to join it.
