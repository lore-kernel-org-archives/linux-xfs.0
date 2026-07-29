Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54642400987;
	Wed, 29 Jul 2026 09:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785315623; cv=none; b=p5qz6FZzRItbSlJG0X+06xcsU0RJtud1wML+6cI531G1+upB6i8EiVMXgJE46RrbPaOlskrx1fVYM5791Q4hkFrTVQKVTA4PuNccAWxxNT6nNthTbknQePmXfd4tzUnHElAlljWeP8h/5RiWGftLJ5v/0zFLjQ51Ax2YB9MI5J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785315623; c=relaxed/simple;
	bh=jcuQtevEerw/A6wn20c0rr8xik0xiI5Auqu5npUa6E0=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=QuYeBkDXhhv961vrmCEHEbqsWkAp6q/0FKr7MZjqQhMqc97eYtY6wJ54xbswHyLjlhUbgJWlxvj2NJ+9Wkt9Y+gg0utWRq41jf9bJ3QXqapFIrlIc54gPtA1zBiM83VuYedOy2vnBwTdd9QLNuJWfTy9wBv9XXBsWU+ZYZvZY6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=XlLz8f2m; arc=none smtp.client-ip=220.197.31.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="XlLz8f2m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=ANcUODjA3VpWjjYEN5SkyJZz9EKU5KnA+PCUCHa9VuI=;
	b=XlLz8f2mw9ORUPBPbp9FfTsZgMnf/CkbyVflpAxuMwTs1odTcNaSbklduFalP5
	22Fg+ta3BDaDYGj2uaU1Sdnl2yZfcXF/gqgUQEsNMSTnuE3vHCDfCGTc993Oy7zf
	kv53gkcZ246E3G2r30jz+0sl/wWQQalppuYkaqV8nUYY0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3b7L_wGlq7vLoEQ--.13331S2;
	Wed, 29 Jul 2026 16:59:44 +0800 (CST)
Message-ID: <6A69C0F0.8010206@126.com>
Date: Wed, 29 Jul 2026 16:59:28 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, 
 Hongling Zeng <zenghongling@kylinos.cn>
CC: cem@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix fallback data device flush for realtime inodes
References: <20260729073918.64505-1-zenghongling@kylinos.cn> <amm6-JkURolQqXDo@infradead.org>
In-Reply-To: <amm6-JkURolQqXDo@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3b7L_wGlq7vLoEQ--.13331S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF4UJFW7Cw4DZr4rZFyftFb_yoW8Xw1rpr
	Z3XF13GF4DKFZxGryfZwsrGFyfJws3Aa1fWryrAry5C3W5XF1Sga9rKr48t34UtFn5Aanx
	A348uF95AFZ0kFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-sqJUUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBoABlNmppwQA+5AAA3r


在 2026年07月29日 16:34, Christoph Hellwig 写道:
> On Wed, Jul 29, 2026 at 03:39:18PM +0800, Hongling Zeng wrote:
>> xfs_file_fsync() has a fallback flush for the case where the log force
>> was a no-op, for example fdatasync/O_DSYNC overwrites of already
>> allocated file data with no metadata updates.
>>
>> The current fallback path is limited to non-realtime inodes and always
>> flushes mp->m_ddev_targp. This misses realtime inodes whose data target
>> is selected by the inode and may be mp->m_rtdev_targp.
> No.  The rt device is flushed before the called to xfs_fsync_flush_log,
> as we need to ensure that the data is flushed from the cache before
> the log commit.  For the data device, the REQ_PREFLUSH case takes
> care that.  After xfs_fsync_flush_log we only need to take care of
> the data device if the file is on the data device and the cache
> wasn't flushed as part of the log commit.
Thanks for the explanation.

I understand that for realtime inodes with a separate RT device, the RT
device is flushed before xfs_fsync_flush_log(), and therefore the
post-log fallback path is intentionally limited to data-device files.

The only case I was worried about is whether it is possible to have a
realtime inode while mp->m_rtdev_targp == mp->m_ddev_targp, i.e. the
realtime data target is effectively the data device. In that case both
the early RT-device flush and the post-log fallback appear to be skipped
when log_flushed == 0.

If such a configuration is impossible by design, then my patch is wrong.

Thanks for clarifying.

