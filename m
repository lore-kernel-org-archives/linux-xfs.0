Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D0D3115BD
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 18:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778783461; cv=none; b=o2RCO2pWd2WFuevZnuT/XlY/tO4j84ja55ZgCZSsy5mQsAU/fzSEduwf6hscTNiz81uvaXZwCjSPh9aSNMPHhAhav2UMxP0n8cr0c8Ftc1Koy1kJ3Gx+GLAMK/N8Kn2EZTurldDyUa3xB2Jf+h3tVeVKEYcwFTL4pbEgVFcrx/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778783461; c=relaxed/simple;
	bh=sBXDLpHn+FDmACYj8iVCL8mnydrKrBAMrYu3fP5qGe8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vDT5Z0uRlehQs63aMLMPzqdx4FHBMUneULI7GNefrjiQDOALEK63GdxI0AQ2S2PLus3vEyHPhrH8bvlq0FM1yIil4AoQvD/YDIPrBNimGeelLoRHHK9uCdaxKSfKcs/5RewL56avr/MFBxKbPxHILbRrdkIshwbNjSTdzBgu6Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=aEiW1vgo; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="aEiW1vgo"
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EHuuaf3111028
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 14:30:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=dqki
	LvRS0biC8wDTf7mWRqTHG4xr6lw6pw3nx+LivZU=; b=aEiW1vgogj7n5YcW6NHF
	YbDTonW54xw3FqAAekPPADUwCORx5bTzh7grpXCPPXfwnH6gVmeTcev+Dnh0bG44
	Il1GBqAswROlkVnubEUDPgMfEWWkWMpwoTuXyoaWapqNM4RLXTGrhbIRlnATX3Oz
	RhYkbCg+r8A3AD6O0954cUbQwfKwGI774KaY1uZ2jMw+pFfk2tbhcisGBL2Ez+5e
	gTCP3AyeSdrj5oaw3jxqG/tI7y1jI07auVhmJqvKafZ0nm67VdKe2Caet6gdgAyn
	DfuVt3CESQv1iyvQHkMmz1MwNC6RvKQMkvR5PeKvn323GXRBuH58ptK/j1ZnBdfC
	XA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e5e67u65a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 14:30:51 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50fbc70cfbdso201033871cf.2
        for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 11:30:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778783451; x=1779388251;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dqkiLvRS0biC8wDTf7mWRqTHG4xr6lw6pw3nx+LivZU=;
        b=oSR8IzG99pIoW/YPtO6RCWv+8LTwol1KCN5NAlajMZA3V+mrU23nTdataudon21Q6G
         PYiVRoN3SJIOKCLTkKJxt6toh4BNWBN3olCsoU5gKX4f2brZGYIrRXWXmHSX4drIAyzb
         O9KekYtSO6LjBn8tz87ueibWq0EuOW26hauhGRGuLYIR4jN/WaouUMNE01EElrtebsUJ
         o2D4lkib6a0g7kFTpCxbm/3VGOqOy7UUGKsMON0BeuR9DD+yazsZW63/riYUUUWSA6vt
         heQJhvLhL5xlSlAcrAUNu5DWR5Iu293fDZ3fmJw+OTZn5CE7EfqQJRzk7IBWNER2/3wJ
         prRw==
X-Forwarded-Encrypted: i=1; AFNElJ8jK5vNqZuepctWTZDKEQuOI5ys+I3OjSMftnXj1AwS+joT+BBeo24RSoYW3e0PyrvakttzzoqjsRw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlJfxAs/expLiZ/BlfflmGGGDXtV2Yg9QSHdogRD4GUJ4L3erl
	dxry0ud7HlWGd7KqRxPhnks6cYFHa/aWClGF027AkteFDFqnjIXP88bOfc0+nrN21UEj6J+iBC3
	xUIsB22KdKkR/sdeF2jxBWg+flwEQsnubWveWBYLFSqGo4mfK1Nzf2RNnQA==
X-Gm-Gg: Acq92OGyhuExk6Wqsfvaf0FMshaFS2krySzcCVDGI2M5eFULBkbWEZpWevtmeuzgn2D
	FO/F//OJm5r5sbvkw7gqcgofFEbfGumIbELacXRRKbSu367aALISLcqTlNtLesBQ04lgvJN46EM
	vmTX0HM6rcUDZR3B2+wtq7wwfQ1FZLTEH4+1y1k+vAUW0SqZQ1t4ntvz7Cf/A7vQ/pM50MczwjT
	VfmJEYVMkM3pwnxuuKliC/wS2Cogf1PPC5jCll8yCrc2pyntsA8NvR+pA8bHhtpouGwYQZIP4sq
	Qi2qQzmbuTcLd40eqz3QVGDBYTYjjIxIzqW3pPowbbsK8APZDJ0bCz6RjQsN+B0e25amPISp265
	s2OXSejgIEjme6HxYJtbR5wZo21TEUXjAukwPONZTovzU3r0=
X-Received: by 2002:a05:622a:5910:b0:50f:c26d:f309 with SMTP id d75a77b69052e-5165a007037mr6567621cf.9.1778783450665;
        Thu, 14 May 2026 11:30:50 -0700 (PDT)
X-Received: by 2002:a05:622a:5910:b0:50f:c26d:f309 with SMTP id d75a77b69052e-5165a007037mr6566801cf.9.1778783450039;
        Thu, 14 May 2026 11:30:50 -0700 (PDT)
Received: from [10.206.44.99] ([129.236.229.175])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516514e0b91sm12008351cf.15.2026.05.14.11.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 11:30:49 -0700 (PDT)
Message-ID: <18dd3936-9ca7-4c34-976a-a0fa09dde238@columbia.edu>
Date: Thu, 14 May 2026 14:30:48 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] iomap: use bio_complete_in_task for buffered read
 errors
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-7-hch@lst.de>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260409160243.1008358-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 4lYHQyajlGXzMA2t-1HAjJ93sKH9bmXE
X-Authority-Analysis: v=2.4 cv=WqMb99fv c=1 sm=1 tr=0 ts=6a0614db cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=nkegbr1AwBRna+m8FBH0UQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=f7q37D0tNRou1Q5H7aAA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: 4lYHQyajlGXzMA2t-1HAjJ93sKH9bmXE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDE4NSBTYWx0ZWRfX4ZjPlmSYjJvE
 KrQ6wpGyUAMkf4E3tdiXX4sfwEjuA95p9wYkViB1Wfh3Jnua+JzKsZC35x+YYwu3D09/D34no1r
 DRiUqO49IdMY2RR4hyW8Nyfq4y/l2eNyHmaQsFwHpaM6PhCJyw9eb3chm527N4dRliScNGTlTM1
 j3DkiiF5Z0ykESsxe43r01tEL4IuVBQZkF26JiVcnNqzfL1mGkd/9vsc2+NUucO6zit44lNM4z+
 /4LG7yXtnZG8efTKCi4oR5hmaYOz5wZHCe5GseOPmhq1EkY4k5yV5M6nDzyRdAWiS6kt+yhBPdy
 g4EOFOzKWqR21mRWw0DxCOgbW2wsHYMQ1d7omziWG2sBPgvW8bm9C/vpgl0xbcIM5nmYSlR4I3I
 bxZC8ZeNUwDEDK1374UbpJ0cH/dI5Mh3vjnTrcI+Mapk+clrFW+Sl2DGd4BBHrPxUOV5LN8zoG0
 aL0vhhlv55geQVID7jw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11786
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=10
 impostorscore=10 phishscore=0 lowpriorityscore=10 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605140185

On 4/9/26 12:02 PM, Christoph Hellwig wrote:
> Replace out own hand-crafted complete in task context scheme with the
> generic block code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/iomap/bio.c | 44 +-------------------------------------------
>   1 file changed, 1 insertion(+), 43 deletions(-)
> 
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index 4504f4633f17..5b9b91198ec8 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -9,9 +9,6 @@
>   #include "internal.h"
>   #include "trace.h"
>   
> -static DEFINE_SPINLOCK(failed_read_lock);
> -static struct bio_list failed_read_list = BIO_EMPTY_LIST;
> -
>   static u32 __iomap_read_end_io(struct bio *bio, int error)
>   {
>   	struct folio_iter fi;
> @@ -27,49 +24,10 @@ static u32 __iomap_read_end_io(struct bio *bio, int error)
>   	return folio_count;
>   }
>   
> -static void
> -iomap_fail_reads(
> -	struct work_struct	*work)
> -{
> -	struct bio		*bio;
> -	struct bio_list		tmp = BIO_EMPTY_LIST;
> -	unsigned long		flags;
> -
> -	spin_lock_irqsave(&failed_read_lock, flags);
> -	bio_list_merge_init(&tmp, &failed_read_list);
> -	spin_unlock_irqrestore(&failed_read_lock, flags);
> -
> -	while ((bio = bio_list_pop(&tmp)) != NULL) {
> -		__iomap_read_end_io(bio, blk_status_to_errno(bio->bi_status));
> -		cond_resched();
> -	}
> -}
> -
> -static DECLARE_WORK(failed_read_work, iomap_fail_reads);
> -
> -static void iomap_fail_buffered_read(struct bio *bio)
> -{
> -	unsigned long flags;
> -
> -	/*
> -	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
> -	 * in the fserror code.  The caller no longer owns the bio reference
> -	 * after the spinlock drops.
> -	 */
> -	spin_lock_irqsave(&failed_read_lock, flags);
> -	if (bio_list_empty(&failed_read_list))
> -		WARN_ON_ONCE(!schedule_work(&failed_read_work));
> -	bio_list_add(&failed_read_list, bio);
> -	spin_unlock_irqrestore(&failed_read_lock, flags);
> -}
> -
>   static void iomap_read_end_io(struct bio *bio)
>   {
> -	if (bio->bi_status) {
> -		iomap_fail_buffered_read(bio);
> +	if (bio->bi_status && bio_complete_in_task(bio))
>   		return;
> -	}
> -
>   	__iomap_read_end_io(bio, 0);

I think this should be something like:

	__iomap_read_end_io(bio, blk_status_to_errno(bio->bi_status));

Otherwise the error is never propagated when iomap_read_end_io() is later
called from task context. Maybe worth rearranging slightly to avoid the
blk_status_to_errno() call for non-error I/Os?

I was planning on carrying this and 7/8 in the next version of my series
so that the procedural version has users, but I'll send without for now.

>   }
>   
> -- 
> 2.47.3
> 

