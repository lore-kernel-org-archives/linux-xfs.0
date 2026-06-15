Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8048402B82;
	Mon, 15 Jun 2026 15:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781537090; cv=none; b=VbydAC2cnA9jwtsaKE96lWv8N4Gv91ztwTV+PtF5G8Ra1+S8hpWGbkhMKGml8GXNISCNCDKmkGtqQddbx7Gl5MyELmWj0MK9SpksE6zg9eYDp2M7rzM0sbfqRdZ8TFAxk16KTET+z4DSovCM6uphbyOn5iZmeNyZeUqMIz9MB5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781537090; c=relaxed/simple;
	bh=nIK/39fAmPpgHmpMGK1/7OvAJKB6XeLZLO09qm430Jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XmPkWD+nfLR9CxyKdHupw5Mwzp++edCm19irTsj0CoB73r29oWU6+UGFLste+887XmA6UxNNZ5/iqYGKwqD4wSTFPJQ8U1Wq18mZMkbfwmAqBbppFnbo9I3baNhF+PXJnAPpsJqCDWzBWZX9yT2fBRDjJ884b7k71+jv8ieJYlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=Z+0GJ+b8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LOxosUqP; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="Z+0GJ+b8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LOxosUqP"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id D75D4EC014B;
	Mon, 15 Jun 2026 11:24:47 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 15 Jun 2026 11:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1781537087;
	 x=1781623487; bh=rL4ZvtW2mK43ifRCN39O3VR6qGcctpUk5i7p9Klw4+M=; b=
	Z+0GJ+b8/iL0RDhErmsq8KRg+/XmR5AirXKjCLKxj5CbFDEZqv05nUFQUVvpcswQ
	4wjLLQxzAeaX3gomoFmWcTEx5Qqvq69nmg9nn+Z0sLaMR+ZoUykith4UuyyQkvSa
	tQBjcDKr5rNkaGT7wSkUGbZbt2BjclJ1dTU/7o8IOHphScAHyjme7TV32oT+TqC5
	YFHdEcTZb/kRjU6y/ZrUl1d1DC0CXYg+JJ6xIYg6bEi+GjrCtHWGUBexRbCKG+SS
	QiNKsidOgSgRgFStV77m2sYexzbIwG/ZGiI7gE6E6wJvOLNtWt+OqNaEB4YQSmPY
	vz0CfetUpxUXwI10uEYlIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781537087; x=
	1781623487; bh=rL4ZvtW2mK43ifRCN39O3VR6qGcctpUk5i7p9Klw4+M=; b=L
	OxosUqPmCa7UpS4B9qmj/KzFe/0foMM5JHihmuLtkKHZqIHXY5fzmeRtH3vI5LBG
	sDGCM9Im275q58M8SGTnh5mQsDKH0xX8ScXoiFVwlk44utIFfWvQXxfAlvM/OQ1G
	3mzZxhOrsSlJqoDjoq/fLarelbVuc8A31AF4GsAO7AevM7p00H9lc+jvCj3roVew
	rzlApuoigkvmR07qvq22vLc/9xPRFUDAylQcdadVoECjM6MT9LsdfAoWL/cZqEjF
	4GkV4pY0itDRc0pUA14EsWCKBMRq4+KWAFozgNm6i69nvxZq8T1My2GIadxlldS3
	sNoJp3haukIC9izKMkm0g==
X-ME-Sender: <xms:PxkwaiIQenhR-1U9_vQS9s3zdXMOLWdjvyxKpG860KETFgYedxC1nA>
    <xme:PxkwarqUcNflhbZHXRlfUhg4I8y4AsJmVh2Bg-xa_Ce5Eq6UUAA8dsOu0o41L-sfI
    FkudoK0whpx9FJqG1XFT0f5hJkZdXCtJK2dDBnQFdYh5GoLsw5P05U>
X-ME-Received: <xmr:PxkwaiwsHH3rdKjkoi4M_9iDWIiJmLT-5TVHsaNWD0xV11dwi1x-DrHXo5HG0de6wvDeyYcdPD4XRzhtTbB5o0PgFqspiw>
X-ME-Proxy-Cause: dmFkZTGAilDK4TSrjUGt+EPIo2lbAuo73AG4lrWPBIgFXUw1l/Xi6yCybZIrexuRG5hdg3
    8poM9p1u3xDALSzdFdV1doCm1uCUIDAUzs9hHVlnC2/O2M6Xno/RkCixej9sFN9HzJqsbQ
    Iv88Q/qYcO/YSZNhl8u8nNbU/1VSzBVxd143ZliM3Y6Upxc/Dq3k+3kTq8QpkHnaVArqen
    42eIorZm1LsEJYiFpa2vCEqaITWhZPwuRrXDUxGEeHUPjy/1SrcXp4nlW5dzl+xIAaW+dK
    mAv/I/S3RKI6CduJBRkFKcVAvNmu1RYTXOr014YhM5bj8GbaGJTWmw+izlIc+QOx1yQIpf
    M9xQJlq/xn+NSeoDMcBz3OMQdbR0FpNYXadZWJggzO5hL6v+EyYbxe/IzJK6CW0Uzfz5OP
    VFn2O3UabzWxpBHyKX/dbq07OGSNhDRt+WjESLm9MhltfVW0p8johflZDF8bytVmyCJeC1
    tVpEE8HVFPSGFnDC5aBuf1Dk9TzzH4keAPLj1E/HCIiDqECsdNUyUwJ4sqo490xR+PP02j
    Wrc3Mbj3EQeOa5VIFUSsF9R/tHKdkb4gav0hGbM3/KN/5v5UBrlO+tsHdwH5869zWc1E/Q
    m/wA6NNWcpGgP3hcTHSb8Qqq2yYzeMcFgQlfxtpZNTiJ04eeGkwFHFqhw8Ew
X-ME-Proxy: <xmx:PxkwanOwOnmAVR0M1y1yF-7kQxBK2Wj9t4kkxa_ehwq8473XMsnX8g>
    <xmx:Pxkwav66wRKRyicf2jkGZC9Mebc_q_2Vt5vQxg4P4rQPhJywJR2IUg>
    <xmx:PxkwaokTFqiC8q4R3v1vRm-U0SUf4dbi6GOY5JitMVmzE3-Ev5UeMw>
    <xmx:PxkwagTCAoB34pSLM8nIIZuxZj0FP3NoR02b-oXVFDIXuCjNPs78eA>
    <xmx:Pxkwala_e_02nS7wuQPb5q1yTHbPMjTx5Yh5sh80Sa0NjUOaGPvYkhax>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Jun 2026 11:24:47 -0400 (EDT)
Message-ID: <acb2b053-e987-4c3d-a672-6e1f0d0f5a94@sandeen.net>
Date: Mon, 15 Jun 2026 10:24:46 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mkfs.xfs "concurrency" change concerns
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
 <ajAJ6lXJWcko4epj@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <ajAJ6lXJWcko4epj@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/15/26 9:19 AM, Christoph Hellwig wrote:
> On Thu, Oct 09, 2025 at 03:13:47PM -0500, Eric Sandeen wrote:
>> Hey all -
>>
>> this got long, so tl;dr:
>>
>> 1) concurrency geometry breaks some xfstests for me
>> 2) concurrency behavior is not consistent w/ loopback vs. imagefile
>> 3) concurrency defaults to the mkfs machine not the mount machine
>>
>> In detail:
>>
>> So, I realize I'm late to the game here and didn't review the patches
>> before they went in, but it looks like the "concurrency" mkfs.xfs
>> arguments and defaults are breaking several xfstests.
>>
>> 4738ff0 mkfs: allow sizing realtime allocation groups for concurrency
>> c02a1873 mkfs: allow sizing internal logs for concurrency
>> 9338bc8b mkfs: allow sizing allocation groups for concurrency
>>
>> Specifically, xfs/078, xfs/216, and xfs/217 are failing for us
>> on various machines with between 8 and 128 CPUS, due to the
>> fundamental change in geometry that results from the new
>> concurrency behavior, which makes any consistent golden
>> output that involves geometry details quite difficult.
> 
> Did anything ever come out of this?  We're hitting errors in exactly
> those tests in the zoned XFS CI (which also tests regular XFS).
> Shin'ichiro recently spent some time tracking these down, which
> finally made me remember this thread.

No not really. IIRC, I don't think Darrick felt that there was any
problem with the code as it is, I wasn't getting my points across,
and I decided not to pursue it further. (That's the sanitized version,
in reality I got pretty grumpy about it, sorry.)

If we have more evidence that this really is a problem, happy to re-
engage with discussion about a path forward to resolve it.

-Eric
