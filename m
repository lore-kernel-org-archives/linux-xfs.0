Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795656373;
	b=LbFraK9Ph9wDRnJgGxCPVXWU8Qu/B/CvXRetv0jaJW6Oz4ffYyPPhQcthxeodknTwuMJ
	 mucsJLG4w1Zwccsl/qQsJ6Wl4hcb5oGfcma0Q0SguKQ2wkUV5AO7qjwvu5miqUO6Bh59z
	 rP/7Y5erEbEf7iVeDOvu8bmz38lmg4Zz0vKnjJWQYB1vHdPOwa8e8EsMMvkAyErqM+BsM
	 zm6SZTQHxH/n4xlCpcLL6xpaVd8JO1LjXv5zTEaVZ3FyY1zpwhnJGsFFQa/0XysBwm3qv
	 45PuYc4+2TwDXH1J9/UmiHwtRj5NtxuDHcLEVqcJidS3qwTVJj84pPfbtCR43LeoHRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795656373;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Z/SO45JEq1Tj9RqYNIrS64ldH+SeEVWmw+AWikVk48g=;
	b=TMp1D9zfghJms0gKytwU6YdtJB72N4/15ZPeFZ24lta4gyQm7UXFfuatKBNYAtx4/7+9
	 aMjpk4NhuTYfvlI472CLRc1LwlW50POTrRgQtucOMB7sKGrtHC/vZ3fX9movXr5VKLt8O
	 CxcZyCAPKrQg8/XFTSjRFZeBliOXTslZB03KSxxm91O93HcqYj9OE8wEQjrJwosd58ZeZ
	 lHee6q9p31CKwLjdVjjpxtZfV3uV/nuGwO1l7Erup8Z71JqjTOecTc9/8J9AVFnpE6cVY
	 uUE4YGJ55709wRVCnk2v74k61UPmL2+I4z60BXN77Q82zu7Mymh6dm8rcXaq/FsmYNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=azCOmnH9;
	arc=none smtp.remote-ip=91.218.175.118
Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C2E606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 01:26:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5C2E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=azCOmnH9
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=D1UHaW0a6adTmdkfzXoJGoIQXD78CQO3jmkmbRoDsZs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795656370; v=1; x=1796261170;
 b=azCOmnH9erdm6Cq7Lccc2+ysEQanywkkrY/DWraFz6VtuY9rw5S6c40xDjasc3xluUPip9RY
 9LlRCC/MO58LJfhVW9AZjuFfWx23EihJRfUS6uorsOTBqOlZ7A9RHqSr19rSjOPdhipYWREZ+2/
 J0Qroccg40VVunhAUitk4yE0=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f65ccc0d161a6465;
	Thu, 26 Nov 2026 01:26:10 +0000
X-Mizu-Trace-ID: f65ccc0d161a6465
X-Migadu-Flow: FLOW_OUT
Message-ID: <3bce3a69-e41c-4683-b1ca-9477dd41a7e0@linux.dev>
Date: Thu, 26 Nov 2026 09:25:51 +0800
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
To: Anuj Gupta <anuj20.g@samsung.com>, Christoph Hellwig <hch@lst.de>,
 Pavel Begunkov <asml.silence@gmail.com>,
 Christian Brauner <brauner@kernel.org>
Cc: Anuj Gupta <anuj1072538@gmail.com>, Nitesh Shetty
 <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Christian Koenig <christian.koenig@amd.com>,
 Philipp Stanner <phasta@kernel.org>, Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>,
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
 <361c4312-f77b-495f-9ee4-e0b9612b4463@linux.dev>
 <CGME20261124084131epcas5p3098eab1bc134da7aefcc83c646b54a9d@epcas5p3.samsung.com>
 <20261124084025.2101804-1-anuj20.g@samsung.com>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261124084025.2101804-1-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/24/26 16:40, Anuj Gupta wrote:
> On Mon, Nov 23, 2026 at 09:51:41AM +0800, Mengmeng Zhao wrote:
>> Hi Anuj, I'd be happy to help pull our patches together into a single
>> unified series and send it out for review, if you're okay with that—and
>> would appreciate your review once it's posted as well. Please let me know how
>> you'd like to coordinate, or if you have any updates in progress on your
>> side before I put the series together.
> 
> Hi Mengmeng,
> 
> We already have updates in progress on the XFS side.
> 
> We will consolidate the combined series along with your ext4 work and
> related patches, keeping your authorship.
> 
> One more thing that we are looking at combining is the ability to share
> the registration across files. Pavel had mentioned this earlier in our
> xfs series [1] and posted a series too [2] which needs some more work.
> 
> FWIW, we also had ext4 changes, but intentionally started with one
> filesystem (XFS) so that the common interface could settle first.
> 
> [1] https://lore.kernel.org/linux-block/4649a20f-aba9-418e-987f-66f21ab24410@gmail.com/
> [2] https://lore.kernel.org/linux-block/cover.1793751001.git.asml.silence@gmail.com/

Hi Anuj,

Sounds good, that makes sense given the ongoing XFS and shared registration
updates. Thanks for including our ext4 patches and keeping the authorship.
Feel free to loop me in once you post the combined series—I'd be happy to
help review and test it.

I looked at Pavel's patchset as well, and noticed it adds a new f_dma_io_tag
field to struct file, whereas Christoph and Christian want to avoid bloating
struct file. Did I miss something, or do you have a different approach in mind
to avoid adding fields to struct file?
