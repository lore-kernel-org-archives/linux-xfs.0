Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5383161BF;
	Thu, 30 Jul 2026 01:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785376097; cv=none; b=LjVc4sBvWHE4rEXYzgnDOt2VmHzH1aksG55z/r2DM4A7m0bR19wSrdbj4au+8XY2e5qJzePRK+I9kRvKCM6W5wO4wAe7Srs8LisEF5apxFTLerx5TzxcViI0einzhT1kzqkWzaEmmEqZpClYdH5pgnL6E58n7iHtdwtnrJjubvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785376097; c=relaxed/simple;
	bh=rVu+F6RnSWJJZnAftEo2/jYIH2WDE0J1yQDd2G5rV/o=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=g7uFO6v1bTn9rCFfwBoKNomN31vjpT8a9spfZmi0GMikf1JvIQvATVpmO0t4T6+uAS7liUH/1DVGnefRG358aIpAP2wFIx3xjRV1mYWmAToqVrZ2rPKe+7CMa8ndjayE8jcoBG5PyJB4iSFj8OcB5adPylyyyK8xUf1AB8dHKEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=EYGGeds2; arc=none smtp.client-ip=220.197.31.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="EYGGeds2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=xW4396uRphpjRzmMc5DBjuASLFmoZ0s1xIPgyOMpA10=;
	b=EYGGeds22wg6R7SfR4U+4fQZXUV8Xt9eRDtcHq5b5P6LPiUfoBGvBH27p/8XDh
	aD2Zf//jsz9rIS3S5uqCbVE3Ji/F7ibP5lps19gRTeHknaCXC8y5F+mFP/aF58gb
	qynCO/YyrEE201yO0bWLbYG0Pwwf2O5ikMSXNpglF2abg=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wDHjyw2rWpq5+TQEg--.14592S2;
	Thu, 30 Jul 2026 09:47:35 +0800 (CST)
Message-ID: <6A6AAD26.1040805@126.com>
Date: Thu, 30 Jul 2026 09:47:18 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Hongling Zeng <zenghongling@kylinos.cn>, cem@kernel.org, 
 dchinner@redhat.com, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix fallback data device flush for realtime inodes
References: <20260729073918.64505-1-zenghongling@kylinos.cn> <amm6-JkURolQqXDo@infradead.org> <6A69C0F0.8010206@126.com> <amoODOM31YmofPlR@infradead.org>
In-Reply-To: <amoODOM31YmofPlR@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHjyw2rWpq5+TQEg--.14592S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFW5Zr1kGFykKr48Cw15urg_yoW8AF4kp3
	y0vFWUGFnrKay3Wr97Z3WkJa4Syw4rJ3y8Wryrtry8C3W5XFySgay7trW8X34jvFykG3WY
	934j9FZ3Aa90krJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-3kAUUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBrxetfmpqrTdjwgAA3Q


在 2026年07月29日 22:28, Christoph Hellwig 写道:
> On Wed, Jul 29, 2026 at 04:59:28PM +0800, Hongling Zeng wrote:
>> I understand that for realtime inodes with a separate RT device, the RT
>> device is flushed before xfs_fsync_flush_log(), and therefore the
>> post-log fallback path is intentionally limited to data-device files.
>>
>> The only case I was worried about is whether it is possible to have a
>> realtime inode while mp->m_rtdev_targp == mp->m_ddev_targp, i.e. the
>> realtime data target is effectively the data device. In that case both
>> the early RT-device flush and the post-log fallback appear to be skipped
>> when log_flushed == 0.
> So the internal RT device does exist, but only when using the zoned
> allocator.  And the zoned allocator doesn't support overwrites but
> always writes out of place, i.e., every data write must log updates
> to the inode and bmap tree from the I/O completion handler.
>
> That being said I agree with your that the current handling is
> inconsistent.  Maybe you can update the commit log based on that?Also
> maybe rename data_tarp to something like file_targp as data is to close
> to the "data device" name for the main device?
Thanks for the explanation.

I see now that the internal RT device case only exists with the zoned
allocator, and that zoned writes are out-of-place and therefore always
log inode/bmap updates from I/O completion.  So the overwrite/no-metadata
case I described is not the right justification.

I agree that the current code is still inconsistent because the fallback
flush is expressed as "non-RT inode on the data device" rather than in
terms of the inode's actual file data target.

I'll update the commit log accordingly and rename data_targp to
file_targp as suggested.

