Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F02E18E025
	for <linux-xfs@vger.kernel.org>; Wed,  4 Dec 2024 20:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733344555; cv=none; b=AK3O90jOO/1G+VciArHUey96k2CNi88OiBjRH5k+jsOy30t0EtdEnznXYYyck+d+T8rQewiwJFKOPM6oivKip5UHzTD94s7lEH6RyJkqnS2qVDZ134oxMus4N87OqAWxATBUwjhzU0fN463A87QKOP3rkul1C4yHR7YZ6G1BOkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733344555; c=relaxed/simple;
	bh=dwsIj7rF/UbLV/atW4hBLLySXtSRMmClsIp+6KLmPr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WTwc5WLQVbufNFOFe3mqfHR/9jXW5EcfcgyTLUcyHKPCYzm4SRHzwq2eDdV4qBRmDhj7dRwfFLM3k9XKhI+t4jdW4RmWp5otDDdphWPlSIPQKH1K6yjyJGzCtZXtClJhxloHbsTP73w4i8T7DZzPrNWrTE5A56JT6RPPLZiEYaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=d5FJM+ft; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="d5FJM+ft"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7fc8f0598cdso1075398a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 04 Dec 2024 12:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1733344552; x=1733949352; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mQZ3ixdeegE5/EEa0czgAF/6xs+UOqPhbexb5HMQfZM=;
        b=d5FJM+ft6mEUfFxmCgRrdXo6XqSObj5q/yzraF5A/15PbyFM39ukFlpOSSPb6tV0Qc
         uIFAGYV0phdUVPHvI6U4SmYOJLn1AxJCYyAryAiq55FWR5+8VeYP6Rbpx9FROHbCO3Li
         Tikhb+UM4YdpZiRPiRWz8ff4oo+zvVLTF92Ju4Ob+M8p6c0FhH4Z0Cpj7YDEl7/FFSxU
         84LhvhnTnTq52rR2dhWIc68BXB4eQCP0Iscwti40qA7OWGEEr3a5xA2mDld5N2fSBma3
         ci01Nw+MgyMNDp0+w9bN5R1eL2Xh6c5TCfEUy8H3i7GLJ8ZHiKAa0LmyYO1UmFi4e4vD
         zJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733344552; x=1733949352;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQZ3ixdeegE5/EEa0czgAF/6xs+UOqPhbexb5HMQfZM=;
        b=Jz6YHTM78YamCxCfKZcolDt3RlezTENYr+6eLlebLNjw3zW0MoiGA9XrBlr7h1GDLF
         3hVHCAmDtyuOrXsdpswTeZ+ejM7FtlD+q9WtUJq41q2YD7ZzGk1IhuS+vKKzFkPuGike
         Uzifhbdj40KIfsABgaBjCNM551GmEogzknNwpKoX9L2UhoKFqrRSm0JyRohLyqhi0tws
         oF/+BNtjG6y8EyblVdxWv7DPnRcSC0FdrpAed0BDQxXjF/yF6nPOt6jIzsSIL8D6NBEY
         ovrQZjbad8MeQP06OF/+baKlpHMJHQluSISWoEYp7vorJx6+tgiD+L/mgpgguF8TFw8i
         6/SQ==
X-Forwarded-Encrypted: i=1; AJvYcCUg83XlowBI+EDPQl/yQaHWENmvYZf/RKV4jHjlRmXVygij2OWRq++Y733ED4LpDdT3HeHv+kxdSyI=@vger.kernel.org
X-Gm-Message-State: AOJu0YydOyz/Rnui8uMO3/LofzfdJKOkHli0PusWb3j2O+TG8FBom6Mu
	HR6SjOssidOEzw90ialDuakpjjJ6Rhc5LiV453XVhU8mRT78JWV4/ZUxL4ohvFw=
X-Gm-Gg: ASbGncvQdQBT++SR+CYdzUfsKmxMrhbs5dj/0X9KBgTBoOdb8iUWG3cNrGjZJje2Y0U
	TUUYHi5ZjsRuOjbhU+HUxLt40GegUeiXDJutA3Mda1LlfcI6F4Ub6Di6hoRy5s6vu4UUn1Xbzdr
	DD7W2EZnaTTt9TmC5ypEXJc8mxxaZBrGQSoeIQy2X0uzN0EPCHZJgJ1bV2wIZh4zSBE/XdDxbFS
	rqwIGjAFSeSWMnPfg87VWPwMJT/eCKhLmV7igEE84bcUvO379cJ2osk3HA2FbMY/Ro882i6TCdI
	JULQDQfJgNERZxJsfJRlHUoeiw==
X-Google-Smtp-Source: AGHT+IE5TCbJB7PPg4ebeiry/v/Jkmsv2ke29ZWPC9q48qLA0mTR8XrInBdtFsAWOrWi0r9nNIoepg==
X-Received: by 2002:a05:6a20:96c3:b0:1e0:b319:fc05 with SMTP id adf61e73a8af0-1e17d3a3cdfmr926833637.12.1733344551740;
        Wed, 04 Dec 2024 12:35:51 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fc9c2d5be4sm11941204a12.3.2024.12.04.12.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 12:35:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tIw65-00000006gBh-2ey1;
	Thu, 05 Dec 2024 07:35:45 +1100
Date: Thu, 5 Dec 2024 07:35:45 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	dchinner@redhat.com, hch@lst.de, ritesh.list@gmail.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 1/4] iomap: Lift blocksize restriction on atomic writes
Message-ID: <Z1C9IfLgB_jDCF18@dread.disaster.area>
References: <20241204154344.3034362-1-john.g.garry@oracle.com>
 <20241204154344.3034362-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204154344.3034362-2-john.g.garry@oracle.com>

On Wed, Dec 04, 2024 at 03:43:41PM +0000, John Garry wrote:
> From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
> 
> Filesystems like ext4 can submit writes in multiples of blocksizes.
> But we still can't allow the writes to be split into multiple BIOs. Hence
> let's check if the iomap_length() is same as iter->len or not.
> 
> It is the responsibility of userspace to ensure that a write does not span
> mixed unwritten and mapped extents (which would lead to multiple BIOs).

How is "userspace" supposed to do this?

No existing utility in userspace is aware of atomic write limits or
rtextsize configs, so how does "userspace" ensure everything is
laid out in a manner compatible with atomic writes?

e.g. restoring a backup (or other disaster recovery procedures) is
going to have to lay the files out correctly for atomic writes.
backup tools often sparsify the data set and so what gets restored
will not have the same layout as the original data set...

Where's the documentation that outlines all the restrictions on
userspace behaviour to prevent this sort of problem being triggered?
Common operations such as truncate, hole punch, buffered writes,
reflinks, etc will trip over this, so application developers, users
and admins really need to know what they should be doing to avoid
stepping on this landmine...

Further to that, what is the correction process for users to get rid
of this error? They'll need some help from an atomic write
constraint aware utility that can resilver the file such that these
failures do not occur again. Can xfs_fsr do this? Or maybe the new
exchangr-range code? Or does none of this infrastructure yet exist?

> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> jpg: tweak commit message
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/iomap/direct-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index b521eb15759e..3dd883dd77d2 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -306,7 +306,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  	size_t copied = 0;
>  	size_t orig_count;
>  
> -	if (atomic && length != fs_block_size)
> +	if (atomic && length != iter->len)
>  		return -EINVAL;

Given this is now rejecting IOs that are otherwise well formed from
userspace, this situation needs to have a different errno now. The
userspace application has not provided an invalid set of
IO parameters for this IO - the IO has been rejected because
the previously set up persistent file layout was screwed up by
something in the past.

i.e. This is not an application IO submission error anymore, hence
EINVAL is the wrong error to be returning to userspace here.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
