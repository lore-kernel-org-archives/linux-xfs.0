Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11A919BDC
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 05:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717393026; cv=none; b=XgFfOLc1XZHx8u4Oa/XURaEdLMiFjSYgk/q6ggmbH7BPz690xIE5g8Y15puD1eKmGftAuqZWfhLs+hprnT1gWF1/Kd3vLXodoSpC3wHjU21rsqnjTzA+Fvp9NnjLXBWtNkXiXNGSgKQ+0aYCt0WUwOBXwUQiJG12kvjjsTaCRtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717393026; c=relaxed/simple;
	bh=RCDSlJ1CWsCt4j3GWISBX9doLTarUCrwN/hbCu0ST9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OwqR6yLrwJQcavhN6di1kgPD2YDVxVjfpDCJGqurS/mys0Wh1THG0G+5bEkblBqRRU8T1TUyiNPMP5EWLCWLNRL350VJVcRCvW/vqux0dgWUa8AyvMqvNhK3vWCD6niARrVO4g5/SreU2mbqkZFKiuA9GmtTTATvUXxqZycUsXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Kv1YOhZL; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Kv1YOhZL"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3d1b587910fso2132448b6e.3
        for <linux-xfs@vger.kernel.org>; Sun, 02 Jun 2024 22:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717393024; x=1717997824; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PCSfF5uMrQdhOSkDwFDjhrTBv2EipeOTqf22cOuZzXA=;
        b=Kv1YOhZLXzcTmd2EXQsFeUcSUUlFvbmMt9sL1hZHmnvsmVOBOoyRMRqwGB5V1RYaR5
         7+zzgQsRd46LH/ZsOjX/xgUUg/nNQ3DsVhFq2ejQX7RmpIWjDxZOaSVeMvnTh6HtWwEi
         xkGbtLwi6RsSbPF51FfrR/CQZ1Q/CQor2aKmO0ePTch4+rJ8BF7CZ3IrtMNOCe05kJKO
         rq6XaHC/5A2hQzJTZI57FRF+D/9M9EtlnHS6kB/gCERoqsi891iW+otfKVBhJe3pO1KH
         Jd1AMf3qhVnAihg3bCTMbIzup95iRS+zyBovH9LwF9aAQFVp3pGKojmQYMWrqgTBvgH/
         xA7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717393024; x=1717997824;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCSfF5uMrQdhOSkDwFDjhrTBv2EipeOTqf22cOuZzXA=;
        b=pGh/dob4j+q3XA72x1TXbyz4hbHfXunxZriSPcHzKhk/K/FMA8MdqEeF3Si+LoSYNI
         cJFejSSMwUSAt4wRTX9n+mY4a36AeWDtsttdx/uCwr/+SUif4cJOLjwLNqUh0MZkHXFa
         5V0Z9LYw29JO0WpDCGpJN8fDHlxDNenCi65XeXiupD2f3eORqY+5mLad42qsueV9hzyV
         G6z/kQUTaSXlotjD2qFwS20EXUaa1jRAM6PNcTP1Nz1/k3KHqerUJDRkyMUKzGOw2soW
         qYns4srO301GBYLa6UKJNEd2vIJJZWG/2rSjud/AQoCD8TMjenCzPpg+3gIxeJtNoY6k
         mttA==
X-Gm-Message-State: AOJu0YxMZKCO6Rf0O/1XGM3YWqXexy93nFPKG6sLXylUNm/SaMDWZKvR
	V05aVsFguCLtEm473pWwK15qKWXikScgQWA0b7D1P2avynB29Vcw8B4grVFlB8vWzfuOxoB4KWF
	a
X-Google-Smtp-Source: AGHT+IFjhLQwVyeJHk6yF0UgyiXs28/M6kL/Y3s+OgSbZVsBrL2mO1Es5BTL6tO1obU1Z0mg9iJx0w==
X-Received: by 2002:a05:6808:bc9:b0:3d1:e8e5:7c1 with SMTP id 5614622812f47-3d1e8e50897mr7503144b6e.49.1717393023693;
        Sun, 02 Jun 2024 22:37:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702425dc4f3sm4733763b3a.78.2024.06.02.22.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 22:37:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sE0NP-002WEM-33;
	Mon, 03 Jun 2024 15:36:59 +1000
Date: Mon, 3 Jun 2024 15:36:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: lei lu <llfamsec@gmail.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com, djwong@kernel.org
Subject: Re: [PATCH] xfs: add bounds checking to xlog_recover_process_ophdr
Message-ID: <Zl1We3cIcUGGW1yN@dread.disaster.area>
References: <20240603041410.79381-1-llfamsec@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603041410.79381-1-llfamsec@gmail.com>

On Mon, Jun 03, 2024 at 12:14:10PM +0800, lei lu wrote:
> Make sure xlog_op_header don't stray beyond valid memory region.
> Check if there is enough space for the fixed members of each
> xlog_op_header before visiting.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>

Finding a corrupted ophdr chain this deep in recovery implies that
there is either a runtime bug when writing out the log buffers
during checkpointing or there is memory corruption occurring during
log recovery after the log items have been read from the journal and
attached to the transaction structure for processing. If that's the
case, then addressing the buffer overrun is not fixing the
underlying issue that needs to be triaged and fixed.

The only other way I can think of that this might occur is malicious
corruption of the journal structures on disk. If that's the case,
then you need to state this explicitly so we know that this isn't
a potentially critical runtime bug we need to spend time on
immediately.

Hence we need to know how you found the issue, what it's symptoms
are, how to reproduce the issue, etc.  ie. you need to explain where
you found a CRC validated journal structure that is internally
inconsistent. That's -critical information- that we need to assess
the scope of the issue that you have uncovered.

I asked for you to provide this sort of detail to be provided with
your last overrun fix - we need to know how such failures come about
because they often are just a symptom of some other issue we failed
to capture. You might have all the details in your head, but none of
us know anything about what you are doing.

Can you describe what tools and processes you are using to find
these issues, and please try to include such descriptions in the
commit message for future fixes to issues you find?

> ---
>  fs/xfs/xfs_log_recover.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1251c81e55f9..660e79a07ce6 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2361,6 +2361,11 @@ xlog_recover_process_ophdr(
>  	unsigned int		len;
>  	int			error;
>  
> +	if (dp > end) {
> +		xfs_warn(log->l_mp, "%s: op header overrun", __func__);
> +		return -EFSCORRUPTED;
> +	}

Why did you put the check here, rather than...

> +
>  	/* Do we understand who wrote this op? */
>  	if (ohead->oh_clientid != XFS_TRANSACTION &&
>  	    ohead->oh_clientid != XFS_LOG) {
> @@ -2456,7 +2461,6 @@ xlog_recover_process_data(
>  
>  		ohead = (struct xlog_op_header *)dp;
>  		dp += sizeof(*ohead);
> -		ASSERT(dp <= end);

.... where the pointer is advanced and the overrun is exposed?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
