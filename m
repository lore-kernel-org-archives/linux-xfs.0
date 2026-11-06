Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961850;
	b=fI2dkpdkypyO92k3nBkEgJi6BfYcGAq7d3jksKdZDBz2jEfLQ6ANNRqY+aP7TWcc4Vjt
	 dh3FriNB5xSQzWir3KVYDUek3ETwjMtzYL7gr5CWylin56n6vRHdnKhBYFDgMN8MheqwV
	 ca89WlVcShU0bvnVFn6uIxerL/tSLYpq5gRLrgVJWN8u4gK5JlXEBP22V/DwXQMclT5JD
	 Tfhc0FOqPkud+Upfah22hrZ+Q0bP/hxAgmKap0WHacykVpmbzZP9bpXHpooy4j7uIKiCF
	 DAaqAEaIWZeXE4cFJKd52hSRf4YJjjAA/9KmnkJGvVuvtRoGG5LlaHMvo3uX7INLewQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961850;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=SyHLvzb6celL0jDL0tyCZxUmWdmbDgVpxG3dwtVayYo=;
	b=K1hmS+N8rtLhhvUrw1+JRV+TUq7CbMx4q0LYkeZYg/JvyoYotoXK4ga2GSurKg8Td5GU
	 5ZFOE+4SpG2NVWAs/jw4Nu/axV4GVlrVz4feKBO7jNUiQqSpy+p0E+nsxnow5RXjod0Dv
	 no3hx5052xIdTY8L93Iz4TaD9A5RbUaXj6Q3D20nlA3hz5AdhdfPE9xyj/OzZhrCUJ4JV
	 gPTfytA/xqO1U4gDPRAjkgdyDqODHfJlM7RqToz/UmQCyNCJ2L2PqUJ/cvgOqOaMIzb2L
	 UHr5gTMeIo9z6BOsoqR9+0pP9ApAv9srCqykzlDJhcVcqReriWRdEwKa1JSPASfJLsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30745606A33E;
	Fri,  6 Nov 2026 10:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30745606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1CCC268BEB; Fri,  6 Nov 2026 11:44:04 +0100 (CET)
Date: Fri, 6 Nov 2026 11:44:03 +0100
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
Subject: Re: [RFC 5/6] iomap: refuse dmabuf iterators on contents-encrypted
 inodes
Message-ID: <20261106104403.GC5668@lst.de>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev> <20261105065847.196540-6-mengmeng.zhao@linux.dev>
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
In-Reply-To: <20261105065847.196540-6-mengmeng.zhao@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

I think contents-encrypted should be content-encrypted.

But we really need to find a way to make these checks more
systematic instead of sprinkling them everywhere.  E.g. have a flag
in file->f_mode to allow it, which then only leaves the direct I/O
to buffered I/O fallback as a special case.

