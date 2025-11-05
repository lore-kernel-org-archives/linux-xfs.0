Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AD82BE7D9
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 18:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762367630; cv=none; b=n5KRd47tkjnpUMS0fHiUSI8RAiBY+GDbCgNpudh3VE19iuaS8rCUiRcMX/kEHIZbWREkOuDy6wjnR2oeP4nKsLZN1SgqhCVUlD4fkp30uPdxqOF11P73dEHGR50wNN5V8FMzp++keO9EmU/1akQQ3XmRKWgUU7CTrOIo57o0r9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762367630; c=relaxed/simple;
	bh=QdIsCbGU61ikoVL7GQujIgBmKZhEQF493waeOpnzVho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lA9OD5jDD8xqdxKrZiikSH3DsOoNF6qsB0o6/2DrcBFhqQarQwQUaHQI5GOfnRKTrFbqa3rr01+uaTC1lPetAA/E905IFV94g06fBjNc3SAYailct+wpumMhf1IKfvviKvePK/AVgDNmpa5Pk9Ql4Xz+d83t7ganarIPsHelaVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SjKKMhOk; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SjKKMhOk"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-429c7f4f8a2so694353f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 05 Nov 2025 10:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762367626; x=1762972426; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Xw9BgXv3xuEvlMmxJm1mpqDieF/LQYS6cC55AYGAEG0=;
        b=SjKKMhOkVclgt5wp06tjOozRABfkZ157n3Ix5SYUyCzRY+YcIQn4QR4INg0zTXV7c3
         XQqAs/5SJF8dWArGKQr5D8jX+CBl8EQVU7u+hurVf1xXm1M0uR3lMX+wHxb8vRNPuSPK
         x4WoIBrMnpNbP+QNvjLsL3J8WYSLS2PzrFwkVegZOaDDYG5rYoQY90YxxZe2tqFrcVZ/
         NsAs0WqPGEAVPNGME6r72Hs9paI8xPPjpmqTY97a0odiAAIGcM8+DhblCWihcvFVsiCq
         v42x1ScK1W7eFMjWRS/gnctfipQXCjKwSEDOC/acfQ41eI3++x+s0/1tRNrYLaCQPmfx
         A5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762367626; x=1762972426;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xw9BgXv3xuEvlMmxJm1mpqDieF/LQYS6cC55AYGAEG0=;
        b=HrgQ91Xtib2AcVhgkSmknSRE6Bdh0guhBfZ4Gu5q7CZ9ijN025TQQEmf+6JFCm2UDW
         m1yygi/xOpWO5TdFavMNwFUz89X92+JKcWS2riQLvcAtcgteeed6NgorbTslrGU+ms4Z
         cFRavRanyCTVlnEjs4s4mkLFLnkchLrNnCCEGVRVJfOna91NXbO1it2+SJo1TZ49yXcl
         ktEKxLSDnbD5LzvYAldb+lvyyGEeD0hkh1Jvdfs6geSrEEQhUKZsvh09UKUxsmp5KWXp
         GomZW6aZHfpDmNVzOvSqwzqFV1t7lDl5xukopIraArTRIjvtFTXsEMScvKTFA4Qa+ig3
         Wuhg==
X-Forwarded-Encrypted: i=1; AJvYcCVjp4Q31teky2wKj3wNI/+5QEc0hK0c3olZyuZcTTQTGNB6tmRm4jGCBbV3TegaMi73cXvkwEB3M04=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVsnUAAt7j+EWEKl4kewcFIRTXV60puHB+SPl8Rp7GsjeoctWO
	e1A4bDdVMnFRwHOoA1uY/aM7f5dxk5v7mlLaeTi/fptZTkudFiS6jhP+To8i3wOTNew6068bjd5
	70UHeBjvRcnU4iLM6kojadA4EqqQamANWSiUtW3blTa8w80D7elJ5TmM=
X-Gm-Gg: ASbGncs1C/deXdDCFh0vj9TARjfH2MXBV+nauJ6US6MnhNaCGfSSwIpVh2Kp9Mbk/CB
	cZ2oN9IaaymTpPKHVpYZMDs1Mo5ZbryfBpzvvfBgh4Ci8yYcm/GlxCgCOndGbarfMe/7a7N3JQ6
	NscsYFK33mt4W2qsgEGjh8LeMJqSyj0ofp9ytRHey+CDvubzt2weXnikpHYg3NFPcPNJOHcpssO
	Q+ycftsSpT95yDkJcxylSf0zWpbjVREaEEZ7igVdWMR/L1UlHUhxsOIYgilWdJTs9AWHPfZf6l4
	undSwA41n8awgQZ10ZzEb1RQBBcik8i3/9bWgrLPDDfWGF7wPIbqoKjRhQ==
X-Google-Smtp-Source: AGHT+IFCZTc3E2XHwDCl+YRtQQFR97QktfT8RGPDVIDrhNNHjq8LIXQFn/CmjbQ3aTH0Rp5kdEDKiM0TTWzYhWFlzC4=
X-Received: by 2002:a05:6000:1849:b0:426:f9d3:2feb with SMTP id
 ffacd0b85a97d-429eb18aaacmr432745f8f.23.1762367625965; Wed, 05 Nov 2025
 10:33:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104-work-guards-v1-0-5108ac78a171@kernel.org> <20251104-work-guards-v1-5-5108ac78a171@kernel.org>
In-Reply-To: <20251104-work-guards-v1-5-5108ac78a171@kernel.org>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 5 Nov 2025 19:33:35 +0100
X-Gm-Features: AWmQ_bl6PadzQPI3bpD_bJBLSeiXboTP6hljfgJQkUA_P8mn02EqfL9ZuICWSd8
Message-ID: <CAPjX3FeEZd7gX1OeCxRXrdBMafHOONB2WQO_JOZuxKoVEygzuQ@mail.gmail.com>
Subject: Re: [PATCH RFC 5/8] ext4: use super write guard in write_mmp_block()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Nov 2025 at 13:16, Christian Brauner <brauner@kernel.org> wrote:
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/ext4/mmp.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index ab1ff51302fb..6f57c181ff77 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -57,16 +57,12 @@ static int write_mmp_block_thawed(struct super_block *sb,
>
>  static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
>  {
> -       int err;
> -
>         /*
>          * We protect against freezing so that we don't create dirty buffers
>          * on frozen filesystem.
>          */
> -       sb_start_write(sb);
> -       err = write_mmp_block_thawed(sb, bh);
> -       sb_end_write(sb);
> -       return err;
> +       scoped_guard(super_write, sb)
> +               return write_mmp_block_thawed(sb, bh);

Why the scoped_guard here? Should the simple guard(super_write)(sb) be
just as fine here?

--nX

>  }
>
>  /*
>
> --
> 2.47.3
>
>
