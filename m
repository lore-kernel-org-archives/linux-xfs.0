Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A832117F7
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2024 00:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721091380; cv=none; b=IC40F1+jqZsXnD8sqA1J31eKrjoMRRt+MmYGwLBgCyIgFrAltsWkfZc55UCvt1N9fZOCcv/It6Peg5w/OsV39BY9d3MwETGJOCGFXfPR2zEgKfuYBmb9EWGhkWAPpHIokUMbv2KAoi+XobnEHcD+PRAR1HFgD/n497Ebt171mzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721091380; c=relaxed/simple;
	bh=3txL1CxNjkkhvDJAuZ00iT7oMft01yfrjplFXbIIeKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYs4JD73Z8aMLpmsegXzHPTT40qKfHNtgSzv5SXy9PYLbc0tH8Q/kKdTmmMYchmbUM5KYtncXhdN82h1IWRgSUxll9ggSogA9QbxRhxOVUfDQpsFUeU9e5+EDYNZoyrbs7BM3xC2/pJw7z+XvhK64j5c4vnfiSLJQC38WHiQ/PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=av5BXRXm; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="av5BXRXm"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-767506e1136so3571740a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 17:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721091378; x=1721696178; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wqoUK1MN6ibdHA1dwG+fUeHoz+Bw3JbVlhq1WhYVUhE=;
        b=av5BXRXm1+Ff75eN8Y237ju3xzWyYdcqBNNasOFtbgNi7DpdsZiWpnGjPGI82V9W0a
         PbvC8nCoPyPQp2AEmeGCiAZs4KI5852owI2PwauX7/bDy6Uzyk5nK45QAfvObuqaIeNz
         lR7J7f2K48Yqy/FNClO/53BA3NvvkR+kNmAwL+N8UghrMp4VdrIpiY71qB3RHcgk3T2J
         zrVgSAwL/BaiwbmVy/Q5Z3zioumjfbZbTxSGXIIVBZQzg4rIYDCjoT2AbIa5h5AZbBO0
         9dxPzb64yno0qZF0DV6j042QkUOLlF830cvzv/L0PhqYePW3YaBPP+yzIcNQgimrqNvt
         deHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721091378; x=1721696178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wqoUK1MN6ibdHA1dwG+fUeHoz+Bw3JbVlhq1WhYVUhE=;
        b=Stz1I1LnjaLXf4/V51N0YhsIuyiPGpK//bEv0jcrmxRvnSe4qw+jbtmbCfAS9zTVNV
         81feuvm2qcPnXC+RqNEFyqv8G/drV+Ce79SWFNZ7pgpLCPMPdGTtGHjWQ+E6s7J7wDz3
         EOq9lgKzphJNMXRqaob22YYHV/3UHXjLcqJb4cnqaTVF8uH2zsKi/4Oq0zbNF8MWhILv
         mYg2sVSnslGREhKC+BI02lsd42Z/LnMjpFBWGOSp8ceFPMhnK1TjonSyoE2DQMK3nP42
         KdPa1sxIpSGNNAQxM2i4sNaAW7pGoPTBfkP1Q/Bp+HkvotO7uRUBT4EDbZNzaPJ43zZl
         5kmg==
X-Gm-Message-State: AOJu0YxKdR3ug+zx3o/pN52udV9DNpFZM2TcmIecAG5jy+ZaTC4xYU+K
	4nvNP0y9IRukGUvmWqFe2KeG6BFfzs5karBAk3fwUo9Cpw6OO/PqgZv3eb2hlZI=
X-Google-Smtp-Source: AGHT+IE9TKzyogDjH+JuoPhf/Zllfa8E6+1jdb/0kyEkPrYkeS0N1NJtZb4iFpumgFaXDZqwxOXnAA==
X-Received: by 2002:a05:6a21:e91:b0:1bd:2c3d:ccae with SMTP id adf61e73a8af0-1c3f215f99dmr363727637.29.1721091377905;
        Mon, 15 Jul 2024 17:56:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7eb9ded7sm5027707b3a.7.2024.07.15.17.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 17:56:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sTWUJ-00HKGg-08;
	Tue, 16 Jul 2024 10:56:15 +1000
Date: Tue, 16 Jul 2024 10:56:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] spaceman/defrag: readahead for better performance
Message-ID: <ZpXFLwHyJ4eYgQ0Z@dread.disaster.area>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-9-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-9-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:27PM -0700, Wengang Wang wrote:
> Reading ahead take less lock on file compared to "unshare" the file via ioctl.
> Do readahead when defrag sleeps for better defrag performace and thus more
> file IO time.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  spaceman/defrag.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> index 415fe9c2..ab8508bb 100644
> --- a/spaceman/defrag.c
> +++ b/spaceman/defrag.c
> @@ -331,6 +331,18 @@ defrag_fs_limit_hit(int fd)
>  }
>  
>  static bool g_enable_first_ext_share = true;
> +static bool g_readahead = false;
> +
> +static void defrag_readahead(int defrag_fd, off64_t offset, size_t count)
> +{
> +	if (!g_readahead || g_idle_time <= 0)
> +		return;
> +
> +	if (readahead(defrag_fd, offset, count) < 0) {
> +		fprintf(stderr, "readahead failed: %s, errno=%d\n",
> +			strerror(errno), errno);

This doesn't do what you think it does. readahead() only queues the
first readahead chunk of the range given (a few pages at most). It
does not cause readahead on the entire range, wait for page cache
population, nor report IO errors that might have occurred during
readahead.

There's almost no value to making this syscall, especially if the
app is about to trigger a sequential read for the whole range.
Readahead will occur naturally during that read operation (i.e. the
UNSHARE copy), and the read will return IO errors unlike
readahead().

If you want the page cache pre-populated before the unshare
operation is done, then you need to use mmap() and
madvise(MADV_POPULATE_READ). This will read the whole region into
the page cache as if it was a sequential read, wait for it to
complete and return any IO errors that might have occurred during
the read.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
