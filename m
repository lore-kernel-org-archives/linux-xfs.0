Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793119759;
	b=E3WMQU1/Bd7Yn8pWeGuQoKDcSR9/m3hfwrAU4QkFwobvOAm0fW35RQ1lGgI5CC/lB7fS
	 hpSfpAfLXu3J5ygCkH5rRhmiqPXBn2/fA/hQJpRx61Zk4kfodSbZKcq7A1xAQ3Ou5t2Vn
	 WSrmMylXcoquBlb/UcT6cHfO5WDrSzmN6M5pgIsgMm7LhuDv0NsNkBTtD7X6z2ChItDdv
	 mS5DnbW8ykNu1ElzvSEUb6wMpCDQV8mqDWYtfbPP6qSpbuE2/idDNDvJTPVXozpvDQR+W
	 rVy4OFcVYTBg87hlu317Wgz0t6iZhOEo09QZrSPvyLZE7ZmnBJB8CfKG+dx1fPb8Oxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793119759;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5h6BBHIqEoVlVYK9N7Wra3yA9g0iuse1t0EMDjWEH9Y=;
	b=Veaq2clsWlCCYefvENmgffuO83seJJO4z/vexyqKO0mxd0LX67wx2IQ6wPnW5aFWnQrK
	 OaaJqPK4eFgRZyrHowfbHeYOZ2iOvKLANsx1G6zEdxPV7puTOc5dgMHPHgRfuKHWD1ebt
	 SPwe4lyU9knAyXcIeJHKi0QimRmK+83TUpVd8S9qE68hr9BNjUpGAWY9hmhw7hYCLMzch
	 PNePZFm4ilAp2Nf2AvkfvPKstq1Z1pHtaOm/tqObd+TmqiYr1RaxEqGDrH8DqiH5CaV7F
	 njm0mQFjiDaJWram0N6lMbKyykxVN6/fNZFoZ2jFEs4XRXMILSnm2t35s5pIhrCV/Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="UB/oMyps";
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E417606A31B
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 16:49:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E417606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UB/oMyps
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a210470b49so386795e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 09:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793119757; x=1793724557; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5h6BBHIqEoVlVYK9N7Wra3yA9g0iuse1t0EMDjWEH9Y=;
        b=UB/oMypslgUErxwg+EMLW4/2jYT75wR8k/sQ4y9j1+chvoi+4sXibjHZc+ZP4FCwhe
         EejVkr5Nn4OLNRcDUXAzlOSyqyz7ZB6b5iv7fHyXL0ukmPozJ+GXBP2KYx4mAivO3OC6
         32azoh58l973/j9LYPpQdWo5fp1zMXjQxiIZnEQ6wFSd7uWecaZUrfYFLMDKLG6n8Zkt
         fzMjo6UxS/QOpKEn74pb1rGJkwe4UQmz96kG13Sg8JNrTawgIUJDhssCDdWI5pV+GK6l
         om7SbkfCCjv9NUI2POcmovIopR9MmKLLdAqeu4UwUaKNUqcOrmnSNRXWHeT4zDk5Etje
         9qqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793119757; x=1793724557;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5h6BBHIqEoVlVYK9N7Wra3yA9g0iuse1t0EMDjWEH9Y=;
        b=i4PhSfCLappJ3IOHnHFMsSFs22TCWXLmrl0l8cpRdKYTnOl2qiuRyOAC6zO/29Cxle
         WywXMrfsQ6FpQK4pfNfe+PvMwPud8JcTYg0gTM+a2VU9Pvaog2bCSbR9QDLgf9t0TTAl
         NG5F6ryIILXfsh5YAtuUp1arGEOnVYXo5wbSE+MH9na5/psQGg6gCW7pxQyr1vygOyJI
         kasvO39WWl30Li5OGBACYFxschBZWGTn0rctx/VX89xLS/pWbj2yfECkBnAumeJl34xi
         GlqJ7lyrNrdg7ooiNVYJnMUekXy8SEsUwfLlJT/KAlXMgheBM+ildSP8gp6f5d9KxpKU
         X//Q==
X-Forwarded-Encrypted: i=1; AKwUvBwT49mkU1rObNINR77Ix7mowyq+LZgeaIwoqk+nSy5DiRs/IbXeYzItHL6r4bIExq9ZZaIUNq05yx8=@vger.kernel.org
X-Gm-Message-State: AFq9FYIxV/3y90zpxiLzwSUUSuYwaSAk+CLG6ZTBDZtCRKJ4X8W9SdOv
	AxnVH/fuWHL/oWSX6wxjm1g8PYXNn+tlVEkLk2msqFezLGH/DuG3m0wK
X-Gm-Gg: AYBFou3FCVw6FmShai+Cag8YbZNAvoRXeIM4Xdtnx/iaIjMI9515gjx5hPDYaOI5B5f
	gzT+Vu55oMYa1WoZU97E5NfX0IVGpPzofdDX4JNV78LdEtBEAVpO6vXO5VbpI0tQafd7w1QEXuu
	sMXB/rUKZ83LZUSXjxgoYpLWMHQGCxUKT55KUDA2VPKLIZYlSp4HfT12JecDpboUNfOoT94uzvf
	1lEnoqYCmklrs5nHvKZw2nUyfEcOyd9AO01Xayy20WAz/D7l/XebmwaQ+Az8jSIX2ITwun2Pl6J
	dFGYsPIVqERV6KSi4wr4aBYDmRxEHQ+Qj959T3I1nQA+lzM7omAqvgB7rAqDrVLp4AdOPiJvcaK
	WfZpcNr0X3A8ykJmZbiTjKVcSg1lig+aLXNq0/qwYxM3u77nAKJIXwQofnZKVWQnAjSKrvRISkh
	zGqLiGa6ugGL8uhp36bdTWsHuESC7REW9TopcVlcjGJPQW7KELmjCfZQaMSMq0dvacXPDrcT8t6
	b/vnc/zEkWzy0/8L6Z1EhoOoLvTxp1vofNWmSUqSCgyFML6Ify9CrqjcoOi+vREvnAF00YqK8L0
	v+U3OI26Z871znOCXg==
X-Received: by 2002:a05:600c:19d4:b0:4a2:18d4:f9e0 with SMTP id 5b1f17b1804b1-4a35acbbcaamr198161485e9.25.1793119757306;
        Tue, 27 Oct 2026 09:49:17 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd48e0sm24388392f8f.38.2026.10.27.09.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 09:49:16 -0700 (PDT)
Date: Tue, 27 Oct 2026 16:49:11 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Reid Downing <skibletz@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, Eric
 Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>,
 stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix wrong compat fields in
 xfs_ioctl32_bstat_copyin()
Message-ID: <20261027164911.578ef6e7@pumpkin>
In-Reply-To: <20261027161748.2760321-1-skibletz@gmail.com>
References: <20261027161748.2760321-1-skibletz@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 Oct 2026 12:17:48 -0400
Reid Downing <skibletz@gmail.com> wrote:

> bs_blocks and bs_xflags were both read from bstat32->bs_size.
> Read each one from its own field instead.

It would be much better to do a single copy_from_user() of the entire
compat structure and copy the fields to the standard one.

The function would need to be 'noinline_for_stack'.

David
 
> 
> Fixes: e94fc4a43e5c39 ("[XFS] Add compat handlers for swapext ioctl")
> Cc: <stable@vger.kernel.org> # v2.6.29
> Signed-off-by: Reid Downing <skibletz@gmail.com>
> ---
> v2:
>  - Also fix bs_blocks (spotted by Eric Sandeen)
> 
>  fs/xfs/xfs_ioctl32.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index f6875a2cc70..77bc936bf0d 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -143,8 +143,8 @@ xfs_ioctl32_bstat_copyin(
>  	    xfs_ioctl32_bstime_copyin(&bstat->bs_atime, &bstat32->bs_atime) ||
>  	    xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
>  	    xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
> -	    get_user(bstat->bs_blocks,	&bstat32->bs_size)	||
> -	    get_user(bstat->bs_xflags,	&bstat32->bs_size)	||
> +	    get_user(bstat->bs_blocks,	&bstat32->bs_blocks)	||
> +	    get_user(bstat->bs_xflags,	&bstat32->bs_xflags)	||
>  	    get_user(bstat->bs_extsize,	&bstat32->bs_extsize)	||
>  	    get_user(bstat->bs_extents,	&bstat32->bs_extents)	||
>  	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||

