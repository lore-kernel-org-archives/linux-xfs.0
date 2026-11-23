Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795398721;
	b=mn9bpmNnFbeWLYfISpRlVNTRTB53FA+7tpXuZNY1E1SSznbq1q6kIu+0S9y6NQAHLAv9
	 QN1WvsmXeEtj3rOYHFCTfx7AmXqz9e75X5j1rPocriazWChsQpIA+wMwH+Jg+SZU2gV/7
	 OCgoZc8d+Ya9qDYY/HSbEWWGtJFC09OvimHc9QsUm22//wc/Qg54fnCWxdUext+XBywQL
	 vhwdABFQQ4b5eV9dGPAU+m+M6bzPObARXt0sGTOIa/kn+cnK2LycQ/8wsA7Ct4vfPbHvT
	 20mB5Nh1i9xqP5oiJa0Z746Unqz2mL1wnK4Vas6Fkyvi8PfONeDgRqkGSvfkVeY5NCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795398721;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=YVtyufYB92pslMYc1cNPbAx48nCwMK6/elZbLI4VZ4c=;
	b=rdBw+0J6bN/AUT4U7a2tHgznuonQzjpn6twbiUSsetJvyeebWPeNjO55wR6gGkdWBhFa
	 d72Lw5rogcQ+9ah9bGhhhsBuFIAWj66MMatkh+xcHMmMejG65gRWubRX6aQ7WD74H489b
	 NVniZS63fZxAWra9h7zBNAQf6+h71KXRfq+ImDRE2UU9wSTKCMOhnToRXdnItpEiH2t6N
	 Kiuz6ktdMNkFMo9h540umfDwh5PUvxDcnYbs0Ms6bR909tQOqlpRI1otupPbUr+ct7Pzr
	 C2XQ/U7vXLiPP2QmGiFJ/+qcgAzDLAgHBWIrdgeEK+TyIZXTAVSAnDw5+VzM/5DL6Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XJO+XIkm;
	arc=none smtp.remote-ip=91.218.175.43
Received: from mta0.migadu.com (out-43.mta0.migadu.com [91.218.175.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3974B606A31A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 01:51:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3974B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XJO+XIkm
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=e+QHWbBPMWAeiyatS48Y4WE7Tii5hCDimKpeiM65Zg8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795398718; v=1; x=1796003518;
 b=XJO+XIkm3rkM9nMrQaJ88DBU/SbDNDS8sX/2dIaj3cwmRrKirwqyb+I0+uhLyek6+NMpIzpi
 feptrx/ngiR7GStYVclrJX2X302KeSUwM1np0LDwreiaO4CnEGlTK2BETzp5dn6xGe4YcTGokd9
 xsy7UnLpMsmmUcjbVs0s4weY=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1054823f21723493;
	Mon, 23 Nov 2026 01:51:57 +0000
X-Mizu-Trace-ID: 1054823f21723493
X-Migadu-Flow: FLOW_OUT
Message-ID: <361c4312-f77b-495f-9ee4-e0b9612b4463@linux.dev>
Date: Mon, 23 Nov 2026 09:51:41 +0800
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
Subject: Re: [RFC PATCH v2 0/8] ext4: Add dma-buf read/write support
To: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj1072538@gmail.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, asml.silence@gmail.com
Cc: Jens Axboe <axboe@kernel.dk>, Sumit Semwal <sumit.semwal@linaro.org>,
 christian.koenig@amd.com, Philipp Stanner <phasta@kernel.org>,
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Li Wang <liwang@kylinos.cn>,
 Mengmeng Zhao <zhaomengmeng@kylinos.cn>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261120154153.GC28611@lst.de>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261120154153.GC28611@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/20/26 23:41, Christoph Hellwig wrote:
> On Fri, Nov 13, 2026 at 03:06:13PM +0800, Mengmeng Zhao wrote:
>> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
>>
>> This series adds dma-buf read/write support for ext4. The dma-buf direct
>> I/O infrastructure allows dma-buf to be handed to file I/O as an iov_iter,
>> but currently it only supports raw block devices. To better serve the
>> GPU-NVMe direct access through normal filesystems, prior work for XFS has
>> been discussed at [1]. We are also interested in this field and working on
>> it [2].
> 
> Can you an Anuj please work together and merge this into a single
> series covering both XFS and ext4?
> 

Hi Christoph, sure, I'm glad to work with Anuj on this.

Hi Anuj, I'd be happy to help pull our patches together into a single
unified series and send it out for review, if you're okay with that—and
would appreciate your review once it's posted as well. Please let me know how
you'd like to coordinate, or if you have any updates in progress on your
side before I put the series together.


