Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961730;
	b=SY91GNFgFGN+ibXm9JoThmuszOkkNshybqBmSaPaV1amdjtiPTMlVOwAi8e6USY/9EC/
	 yqmHS7x7ZXofUkA71AnrqVJclhDBDh1LPCg1UURzoOQaWbOjIXoYc/I32ZGfSj3nPqOeg
	 /nDDZs5I/5wQlesLCSnVo70vGb4lSYHkh+1VMWSGYEKP9koRD92fFXuQyaSvYbcBDSPwf
	 rq1BAtb/KKWkPU62oZYo+qADJfsbqaS9G7vzCDZ3ChzKWbi31jHekg0MzOafYWsNt9rLe
	 sTWqli5MZ45Ujba5g1BODUbYUQWnFUpa5L1uTyqSLrafJPtT0jyJXzsSpoR+JAjfa/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961730;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=Y9kFrNqpqE15U9jIYdrxg+czSD6JG0cMxUhVLzPeOPE=;
	b=kIa3PH5BS3OIb+h3RqNPlpR0k4ceLYvkZiTmmCmtc93hU9NdeKapHG9R8Xi8hhaJJ8Hx
	 s5c2FivCWdJ7jQPwTe0ggM98rg8K98o2Wp3fOn8xc/wOfpYfbrqDuTi+YcFrOrtnTaup1
	 tpYI94043DHybc2vzbHAUduz8h22KXMQN1ajrvy6F3U/RInuDFlDR+o9XC0pnVT512lcK
	 3ukjDMVllERLZkos0qpsMj73BnDNx4QIf1fziDcOqvVWxe23eF0xP2B2dggMRKyODDhcH
	 dqq0hlvLGQIh1pqYliOzd3nIRyM9OY9oOen9ttGj4fHY9YL7KNEa79A+zlSUGZRaVPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B804D606A329;
	Fri,  6 Nov 2026 10:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B804D606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CF4B168BEB; Fri,  6 Nov 2026 11:42:05 +0100 (CET)
Date: Fri, 6 Nov 2026 11:42:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
	hch@lst.de, Anuj Gupta <anuj1072538@gmail.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
Subject: Re: [RFC 2/6] mm/filemap: refuse dmabuf iterators in the generic
 read/write copy paths
Message-ID: <20261106104205.GB5668@lst.de>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev> <20261105065847.196540-3-mengmeng.zhao@linux.dev>
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
In-Reply-To: <20261105065847.196540-3-mengmeng.zhao@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 05, 2026 at 02:58:43PM +0800, Mengmeng Zhao wrote:
> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> 
> The generic copy helpers cannot touch device memory.

Which generic copy helpers?  This doesn't seem to touch copy_file_range
at all.

> Refuse a
> dmabuf iterator in generic_perform_write() and the filemap_read()
> fallback while keeping any direct-I/O progress, and report a busy
> folio from generic_file_direct_write() as -EAGAIN instead of asking
> for the buffered fallback such an iterator cannot take.

I suspect the fallback code in the callers might be a better stop
for this.

