Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B381391;
	Sun, 25 Jan 2026 00:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769299424; cv=none; b=gqk8U2WFQ62rwNIxHK5iMISro3WgvC+gOBM5Grz5T4Z5QYK4ue4U1x/3hewFxqZNu9nMHg7FiolYHg+gh3mVoxJ8qiJ78UU0eLDcjwPDVL5FqZUWzy2Ancgn/jT2usGrqGBBbUZPNEjny/qUUViPPtPIGSJTVKCaJFPx4R+VDjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769299424; c=relaxed/simple;
	bh=J6ivqCegJ2nzRx2EZcghvIb7l0xi5a+YmvFgYUExV10=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GSKG4LZRGZhcaKub/ds2Joondj4yftUXcxT/naxjFFCfDJlBkrqeLEzW0ujaAumAZTVRyXynaATQkv9QO/lTuwllGweglUaNw5Ba6afSYRPjFX4Lioj8OFELIxExpZsqZfqgldzqu7tmKpd2kFnH4pq0JIk9zMbQOjhWAkdvThA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ZtRV/t5c; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ZtRV/t5c"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60OAvk4w3602576;
	Sat, 24 Jan 2026 16:03:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=MZH80tm4WcTJ2yic9F4VNFro7rLjCynXA+xwOyGM5yA=; b=ZtRV/t5cDbQX
	yK2AXDJZ1NLc23zMf51a1Kg68dmiwBUKZLFlYMLFBoulDJRcOOpt71pdhyh8AbaU
	NH/iVtze2DPZ5IrtiiSxP92FPYn6+4o/Rhih6rz7KaUfsPq46EIo+L9BslCvKF6j
	Dtlx4qh9iKgFN3+w6zv3bq0CrQeU8hMmqLwaUe3xfmEN32s6KghO+JTxKccph5cP
	EaX4tlWziVhDay7nzTqxJq41mjQx49Hf7GOaJIygjBRFH3866JKSzFlrpPpyjQfs
	xraoi6jKrEmC/aYJZWySzp9qrRIQTCILK4pvzpitwhmmcPcaUvVYHIAoOVhRTORS
	AQvb4moHEg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bvvsakkmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 24 Jan 2026 16:03:33 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Sun, 25 Jan 2026 00:03:32 +0000
From: Chris Mason <clm@meta.com>
To: Christoph Hellwig <hch@lst.de>
CC: Chris Mason <clm@meta.com>, Jens Axboe <axboe@kernel.dk>,
        Carlos Maiolino
	<cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
        Hans Holmberg
	<hans.holmberg@wdc.com>,
        Keith Busch <kbusch@kernel.org>, <linux-block@vger.kernel.org>,
        <linux-xfs@vger.kernel.org>, Carlos Maiolino
	<cmaiolino@redhat.com>
Subject: Re: [PATCH 3/3] xfs: rework zone GC buffer management
Date: Sat, 24 Jan 2026 16:03:04 -0800
Message-ID: <20260125000314.561545-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114130651.3439765-4-hch@lst.de>
References:
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 5FMDyFBL_5SeDDbuZal26dSJs0LffK-C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDE5OCBTYWx0ZWRfX55cBgmC05Tth
 Fv6lP8y7jMJN+HLXnsktQeo3jZsLDd0RjHR++e0Xbwz4XMmDP95ck4XwJwgm4SW2qRyGk1QYwP/
 nObhjrCsZ51JJRD0A1+zGovjOLnRLrCZooHWcjS5Lo8kAGPSzYXApk9DND1TiwJ0K2HFF8Xfhvl
 78yFKMirMKuZUKBSHpcJJ35ai6OK7JE6lM9ROOxpASXe9/CilnpEpZoiJYqH7aM22cUnaZCRq9V
 8++zrlupHY6+qNunBp0QQCtw9U0Yf6Bvq6q6ts7+FSnvqwV0qTGAZfiUdTOY2lBrYE2RcDuyfsl
 5RAnVt+Zpkk1whRJc39UoZNn1WV2B/vbXk3q8Rfoe5PAHxJSGz97cyjYCFk+41BaXa20kM8PNoX
 lfAT2YvkjmKc8aK6TA9RLDfcgl2kiSEDXWfNezkSAGTHZLcZwnAyW0vhtNWHJCoY86EgpzpG5F0
 QiGt7ks+qJCRClD9IMQ==
X-Proofpoint-ORIG-GUID: 5FMDyFBL_5SeDDbuZal26dSJs0LffK-C
X-Authority-Analysis: v=2.4 cv=IpcTsb/g c=1 sm=1 tr=0 ts=69755dd5 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=wsYDZYZaCIou5I0rzvgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_04,2026-01-22_02,2025-10-01_01

On Wed, 14 Jan 2026 14:06:43 +0100 Christoph Hellwig <hch@lst.de> wrote:

> The double buffering where just one scratch area is used at a time does
> not efficiently use the available memory.  It was originally implemented
> when GC I/O could happen out of order, but that was removed before
> upstream submission to avoid fragmentation.  Now that all GC I/Os are
> processed in order, just use a number of buffers as a simple ring buffer.
> 
> For a synthetic benchmark that fills 256MiB HDD zones and punches out
> holes to free half the space this leads to a decrease of GC time by
> a little more than 25%.

Hi everyone,

I'm pretty low confidence on this, but it was flagged when I ran a bunch of
linux-next commits through the AI review prompts.  I'm curious if the AI is
on to something or if I need to adjust things:

> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c

[ ... ]

> @@ -590,7 +578,12 @@ xfs_zone_gc_ensure_target(
>  xfs_zone_gc_scratch_available(
>  	struct xfs_zone_gc_data	*data)
>  {
> -	return XFS_GC_CHUNK_SIZE - data->scratch[data->scratch_idx].offset;
> +	if (!data->scratch_tail)
> +		return data->scratch_size - data->scratch_head;
> +
> +	if (!data->scratch_head)
> +		return data->scratch_tail;
> +	return (data->scratch_size - data->scratch_head) + data->scratch_tail;
>  }

Can this function correctly distinguish between an empty and full ring
buffer?

When scratch_head wraps back to 0 and scratch_tail is also 0 (because no
I/O has completed yet), the first condition returns scratch_size (2MB),
indicating the buffer is empty.  But if the buffer just filled completely
and head wrapped to 0, the buffer is actually full, and the available
space should be 0.

Consider this sequence in xfs_zone_gc_handle_work():
  - Initial: head=0, tail=0, available=2MB (correct, empty)
  - After 1MB chunk: head=1MB, tail=0, available=1MB (correct)
  - After another 1MB chunk: head=0 (wrapped), tail=0, available=2MB (wrong)

The buffer is full but the function reports it as empty.  The while loop
in xfs_zone_gc_handle_work() calling xfs_zone_gc_start_chunk() would then
continue adding more data, overwriting the buffer contents from the first
chunk before its I/O completes.

[ ... ]

> @@ -710,13 +728,9 @@ xfs_zone_gc_start_chunk(
>
>  	bio->bi_iter.bi_sector = xfs_rtb_to_daddr(mp, chunk->old_startblock);
>  	bio->bi_end_io = xfs_zone_gc_end_io;
> -	bio_add_folio_nofail(bio, chunk->scratch->folio, chunk->len,
> -			chunk->scratch->offset);
> -	chunk->scratch->offset += chunk->len;
> -	if (chunk->scratch->offset == XFS_GC_CHUNK_SIZE) {
> -		data->scratch_idx =
> -			(data->scratch_idx + 1) % XFS_ZONE_GC_NR_SCRATCH;
> -	}
> +	xfs_zone_gc_add_data(chunk);
> +	data->scratch_head = (data->scratch_head + len) % data->scratch_size;

This advances scratch_head with modulo arithmetic, which is correct for
wrap-around.  However, if head catches up to tail (buffer full), the code
does not detect this condition.

[ ... ]

> @@ -845,11 +860,8 @@ xfs_zone_gc_finish_chunk(
>  		return;
>  	}
>
> -	chunk->scratch->freed += chunk->len;
> -	if (chunk->scratch->freed == chunk->scratch->offset) {
> -		chunk->scratch->offset = 0;
> -		chunk->scratch->freed = 0;
> -	}
> +	data->scratch_tail =
> +		(data->scratch_tail + chunk->len) % data->scratch_size;

And scratch_tail advances here when I/O completes.  The classic ring
buffer empty/full ambiguity applies: when head == tail, is the buffer
empty or full?  The xfs_zone_gc_scratch_available() function assumes
head=0 and tail=0 always means empty, but after wrapping it could mean
full.

A common solution is to track a separate count, or to sacrifice one slot
so head == tail always means empty, and head == tail-1 means full.
