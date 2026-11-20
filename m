Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795189319;
	b=hVd747JXps3w1+LsaQ4zxP5dtKQsfLdgDQPT5ew8To/oIE6XGlJCp+YqG7jEn2cPbm43
	 ItABYlT3ErRQ1FDHr+UgWUct+RjR4JFdljWZv4w+pHnKBOibXy7BE20N3FP2AlCT+5J9S
	 ihGWP5TIQdAkqLK6FkxxEmP8a9FOFdpuTO1HlUSnvBgF0tacvdGoOvRwX6074Zkbjglxq
	 Zvwpt7hIfLKHkv7Er8ON5JqaQl2SYaOSyHXinYbxk8e+BiYnHWoT23DEmSRF3cn4HzxVk
	 iLIHI+1zpVBPbJoHOhK7dB/fMut9cayxApnjP7oI56ryUZ8OUQCpqfC6H7JtRf51iCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795189319;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=PJvrCL4sp5MCpICPfOZGrfI2absbUrXURUFg0F6qHVg=;
	b=pwK80v1cYb3jD6SG2f3psolJqrWgyzNkyYHFEwRB7eyCDJo4pjVrw682mDzg4JM1MOKN
	 vcvJU/L3crvZl/9p7p1gnSGgaP31WxcQnWR8VfNG2QIxIFwy2UxURMT9eTVDip49p+S3M
	 zmr9d5pnSdQe142Jou5QV3lX7UVkXf0nfL5GJd8GcalGCdPK+ve7AJl4nG40T88KfWcK8
	 b6dBHR8wqTpl5drjI1DJszGcuhtyQUTpau2ODp/Hzq0gf62XXZ/EBfDKTn0ooonPpfn+V
	 vrj38H061cZIffpSXSize9VGP/Ivy1LCSwd/0B3CvRqHKR2wRdFYm+VAqPnMgVJJ06A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABCC606A320;
	Fri, 20 Nov 2026 15:41:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BABCC606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6114D6732A; Fri, 20 Nov 2026 16:41:53 +0100 (CET)
Date: Fri, 20 Nov 2026 16:41:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj1072538@gmail.com>,
	Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
	Sumit Semwal <sumit.semwal@linaro.org>, christian.koenig@amd.com,
	Philipp Stanner <phasta@kernel.org>, Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, asml.silence@gmail.com,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, Li Wang <liwang@kylinos.cn>,
	Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Subject: Re: [RFC PATCH v2 0/8] ext4: Add dma-buf read/write support
Message-ID: <20261120154153.GC28611@lst.de>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
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
In-Reply-To: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 13, 2026 at 03:06:13PM +0800, Mengmeng Zhao wrote:
> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> 
> This series adds dma-buf read/write support for ext4. The dma-buf direct
> I/O infrastructure allows dma-buf to be handed to file I/O as an iov_iter,
> but currently it only supports raw block devices. To better serve the
> GPU-NVMe direct access through normal filesystems, prior work for XFS has
> been discussed at [1]. We are also interested in this field and working on
> it [2].

Can you an Anuj please work together and merge this into a single
series covering both XFS and ext4?

