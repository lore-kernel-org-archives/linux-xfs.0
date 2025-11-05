Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBAF2836A0
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 18:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762368031; cv=none; b=dP9VvHTgZ9M4Wx1TVxaZEJ4dhI91U2JuleqnB33wFoRS+YuCEUtwala297uiZ+y9A/U3jHc7ZDvttc8M6MnL1hzoS1WyZl2qG7eZerEQuj3RMKd57Ptm5CKdRliSZ/XOmmqQNJoy45+2tBoi4K7zbid343oTqIWPMCaqS9BMUUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762368031; c=relaxed/simple;
	bh=AvBw7pIapYDjfqbEZ1bgncfbRO2NgqW+PZq/6jkqGM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GFv5qnA4uDgmx6rKAs4U0ZYwy43IQUe+3TVtnz45SZOothbGA0p63hPRFAsci0e944hzwwDv1/TTZkumE9PNvIs/KQWdjxH3Y/d7IBrrMrExbqtrVNEsCSd0kzUHcEMbN+w232LK6ZiaGSS1ngUp9/be05nkjvptptc+3qpm8dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gisM+4T3; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gisM+4T3"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-429c8632fcbso110762f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 05 Nov 2025 10:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762368027; x=1762972827; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XIyQJV0BoOq8cM6bW2Nc4tys93TVUqC9F2FCguuU5Y4=;
        b=gisM+4T3Q9267eqJ1ys58qBqAdKRrmOcVQb1cdNiSx2qEd6cyvWlRcW8mUU8WvIePz
         1HrZfi4mV+sXAsV/7HQHl1PJQmjJb667uvzaCzODUDwSeMD9VZv76Ye7JZyc5T2nSzp5
         ZuXCqKHPHPXQra6fPgpeIB7w9aXpQPJXACBYR8fWFMxgSz3Kvs1JAboHCMbeQB3C+2Wa
         0wLyX1yRhzSG1+7YSeGI9RNx8iAFDkUmKxSncp8mB7DrF06FvWOqzhpmJHKiIkynBLsw
         w+I38X/mNLUSVaukwi4bauaUP0xoBjL5uqF+s80cMD7Shg2gfpNSm5mfzEXHN4hEEUy7
         X7RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762368027; x=1762972827;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XIyQJV0BoOq8cM6bW2Nc4tys93TVUqC9F2FCguuU5Y4=;
        b=PQ4vFiXGfSujMx+mZJDa4B60UyQOt8ag2nerHbKfgK5+Gv7Gn9Js66MGXx3OWmkM+a
         PrGayPW5lofD8NYgpHfOalproh+vnuvub/B7tDnhJ8/VBRJsrTiS2vkx1OWhx0qGvdIR
         sZ+T4wkSj4rPR8z9RRE7xJejHQB4HDH1eMUXpcNQlhDShW1By3GUrkDGvRkafGiH3jQj
         ihKMx1xU1Rw1LfIHUFBcDzePCIRjULNqK4NX8fElToOQxp71V4stlXBLFnivpO+VR5rF
         dHYkaXSRwH2DUP9VM7daFYw1ZcZ1qbnHiXRYwDZNWFi8mUztR09uxBZm0RCSBOzq6lbn
         DbYQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8D7edgUkG1f2nR2XVJgt5h/ubemp6mY+V/irMQzXzwH2mUP/LdHeQTxigohogg2AqD/SIg8OXfRA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv2fGCgah7mFW6fE80+IeIuzXdx26HVKTQLO9mV8NzNKdUSUjG
	BdY6u9hIoJrhkCmNqg8zlnrp3GMlqkPLAYXNinbM8Ul3T07SNBldiJbKIEe+zqfhVNgZ4McogqW
	VBl9Zmmol7xSlmnMUWr7LRBdZo+C+0Ryp9lUJZql5kQ==
X-Gm-Gg: ASbGncttL/qbIZUnaYWHgOhi8Czcm9XhwHFs6Qvfvkip/aeMndjVS2lZyAvd54z4W2v
	sd6jYdhVDszfTTCXCbRQq2U7NItr0lEruU4k6SIV0M5ILiGT5VFQAQMNZbV7hsDBChAD2DZxP4s
	jZNNQNUQ5Cd3orvIn+rmz5lK8vaSAC66CIG6cm0gLduz4tiU/FRasYhzPaSlc/EzAY4PvH1Zi4S
	n0sZIGpfj63dUMcL3g8m+jB5+cDI2KjOiOE8/+9KGbUOoPALe3QhCKErtD80K62InxyFnFNWQRM
	ppyg3XriZyh2gOl5lAKrNRb6/CjeEI1RJv7o0gOZ/hb2zq9cUQj8O4Mrzg==
X-Google-Smtp-Source: AGHT+IE7JHWAjENwi47IGOpfVP4yA/c0uXNjUPhrOCm2JpvPKV7uVzx/cwlCOY7h0IJ+8GoTWuRVpHEfcxcTPv30XiU=
X-Received: by 2002:a05:6000:2184:b0:429:b8f9:a87e with SMTP id
 ffacd0b85a97d-429e32e9348mr2957432f8f.20.1762368027493; Wed, 05 Nov 2025
 10:40:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104-work-guards-v1-0-5108ac78a171@kernel.org> <20251104-work-guards-v1-8-5108ac78a171@kernel.org>
In-Reply-To: <20251104-work-guards-v1-8-5108ac78a171@kernel.org>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 5 Nov 2025 19:40:16 +0100
X-Gm-Features: AWmQ_blzod4RW1ZTgCh0cBumT4ZK5h0yfmsbksJOvdN6HEySSPMcZBN44FECEdQ
Message-ID: <CAPjX3FfyQ4wDD54_=wz62OBsSO30C2f7dmXZcKEu2JgpuER_KQ@mail.gmail.com>
Subject: Re: [PATCH RFC 8/8] xfs: use super write guard in xfs_file_ioctl()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Nov 2025 at 13:17, Christian Brauner <brauner@kernel.org> wrote:
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/xfs/xfs_ioctl.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a6bb7ee7a27a..f72e96f54cb5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1408,10 +1408,8 @@ xfs_file_ioctl(
>
>                 trace_xfs_ioc_free_eofblocks(mp, &icw, _RET_IP_);
>
> -               sb_start_write(mp->m_super);
> -               error = xfs_blockgc_free_space(mp, &icw);
> -               sb_end_write(mp->m_super);
> -               return error;
> +               scoped_guard(super_write, mp->m_super)
> +                       return xfs_blockgc_free_space(mp, &icw);

Again, scope_guard where not needed, right?

--nX

>         }
>
>         case XFS_IOC_EXCHANGE_RANGE:
>
> --
> 2.47.3
>
>
