Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6522232341B
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 13:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758633426; cv=none; b=XGVdpSRCxtvzj/IwWXXpIyXnYcuhzxVpeBRIbu2Ri5Zn0XY0dj+rIowX77idNCGh4uvoDACTTxdRQDdK4k2Mkj4glBfspZWFF6aRYCpB2qtl9+TufAEixbLPwCs/5+Dyce5+p7WqGIcAIfml0gy6NhizejQ+teCmMUpbF23Z564=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758633426; c=relaxed/simple;
	bh=MjdyuQrqVvsTBegSnd3yU00JR+DMJq7p6mLUJWTlZdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/8CpRyCFwCDQFLOqHAwofGhEeH58kjQI2eODO/QMZJtp1CerxdBQKKQszn7nuHC8tnum1VmFLJPqlOLiSmhI0hIYEDd+kIFkiE8R65KQ8bb1j4Wr6sY1OAdNjOj2W6k52JGCeElGuyr5lJS1VnUpjoUIooPz8AsIEpg8G2LA8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=yGwEv5jd; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="yGwEv5jd"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3304a57d842so3995948a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 06:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1758633424; x=1759238224; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DGZ8DWqCix+BtHtElOYwM96MkEfMXUBhKMzH5BSjHrU=;
        b=yGwEv5jdMt4Rgfi0m0bN3rxya9s2FAbia8xtqcTwhc19IK5r4PXmdK+C7UWreg1NfH
         4sk+1SJaFqWoZk8UMTPHgcndklOJpzScvLF5bjkG6gqoUSKB2k3ZVGlgvwgMKVkiX9tQ
         HMMHDCD3TrzFuqxXTV9HAJcgYYX2He2h5yQzLxkZURdzd28u2rXo3M/TKNd/GoKCTF5R
         SSJHzKnVcZ1kR/S8ehZjuwzeAqAlS4edQgRc1y0V8xkXIINs5b4r82gsRo8F8hz5liGg
         WFWMrwFtm4OO2twE/EkvNGL9ESDPBnyP6iVe3AlnhcR6cmuUPbA6c7z1EUU5XrhnwxMP
         WISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758633424; x=1759238224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DGZ8DWqCix+BtHtElOYwM96MkEfMXUBhKMzH5BSjHrU=;
        b=s5cXq3TvKVBSww6gxUG01AQbdPJgz5PEWY5wRqEHWh5iCn9A1nu/91ub/HcdfWRB+6
         URDO88bnHggnBmcGBRQ49r2CEE77DAT31s1z+D+uOvhX8q0mPA8gd0gUMDVfEHadaKa7
         WUTX+yW/7CXrUpZS9T+qH2Dq/yc38SbylLgurff0m6Za62/KEHla8iXgmbFNcnYW3itG
         tgfebeZXH1BfyRHygKMGjHAtz/9/hHfyQ0VcYpRZ0bAlcV9kcUSic374Ajvx06CCMFPK
         9vkIu2AxXgRtzQp/okJdR2y4RfDi6/B5FGLXnl6lzilRp+eaTQpUeiCFxGXCPXJ7LBsO
         q81Q==
X-Forwarded-Encrypted: i=1; AJvYcCXKctWYNBBJAMPlrHDFygshK3z0s2VR8BKUQtBlHirgNP19ffOoKKMmgKMVbDFGz73a/RR7ReTM4MU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfxQLFqvz8Kn2uBGrfLe8XVnfADMwrmbCwOWlFq4lbGe3uiRM/
	o0+/agfaAHSpEaq56PA3jI8igzNt1PT6liT/Jp1ItQ8jmYLqiWwr8TARh3mJsswrf0c=
X-Gm-Gg: ASbGnctrjZdYlTM9HtVZhpKNrgKOC9mg+q5EgLlsPAuwlc2oVOw7XUNnWxYOoDFKglB
	r/seZbL0YxgnIsMlQehyqwRW0U17IHpcT2LaehQscD2Iz5FY+HbwWWtmIGhj0GVzz7NuHlryduj
	EgcN60C3R2IVLbLqXFitZsjmCJxBdqfGa0Z1ujYqyRIwkWViaMnpRQSjjxTp7EMaJLTLKh1pWJy
	IrpdmvCnNwEombcxzRte6XkHQQ1ythjo3u6wdggOcN+ZALiIAfaPL0vwZPWB6r91a78+v1KvBxq
	LASIHGYa7jzV6tT0v7azNb9WN7KH+D8sryQFoa7rNXUibGeK3CRg3HYSKr1HfW9dsBs3dEbEdxK
	8/HaZb33LSJb3C7g8elfdowPjFWgbLpwrFBIfj6rPNeNE6CYQHOXH+RwmrZfJbkU8rILSTFhBk1
	HukuHbtTs/
X-Google-Smtp-Source: AGHT+IEK7PfWxNFc7fb1bUErPP+++ZIWocUE2B9M31SxyszIkGAjugG30aXgLbzSTbCpFRJZYYXACg==
X-Received: by 2002:a17:90b:17cc:b0:32b:9750:10e4 with SMTP id 98e67ed59e1d1-332a95e0514mr2945365a91.27.1758633423462;
        Tue, 23 Sep 2025 06:17:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b551705bd02sm12047994a12.41.2025.09.23.06.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 06:17:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v12t9-00000005h4t-0IOy;
	Tue, 23 Sep 2025 23:16:59 +1000
Date: Tue, 23 Sep 2025 23:16:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com, kernel-team@fb.com, amir73il@gmail.com,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v6 0/4] hide ->i_state behind accessors
Message-ID: <aNKdy1vYsWoMvU3c@dread.disaster.area>
References: <20250923104710.2973493-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923104710.2973493-1-mjguzik@gmail.com>

On Tue, Sep 23, 2025 at 12:47:06PM +0200, Mateusz Guzik wrote:
> First commit message quoted verbatim with rationable + API:
> 
> [quote]
> Open-coded accesses prevent asserting they are done correctly. One
> obvious aspect is locking, but significantly more can checked. For
> example it can be detected when the code is clearing flags which are
> already missing, or is setting flags when it is illegal (e.g., I_FREEING
> when ->i_count > 0).
> 
> Given the late stage of the release cycle this patchset only aims to
> hide access, it does not provide any of the checks.
> 
> Consumers can be trivially converted. Suppose flags I_A and I_B are to
> be handled, then:
> 
> state = inode->i_state          => state = inode_state_read(inode)
> inode->i_state |= (I_A | I_B)   => inode_state_set(inode, I_A | I_B)
> inode->i_state &= ~(I_A | I_B)  => inode_state_clear(inode, I_A | I_B)
> inode->i_state = I_A | I_B      => inode_state_assign(inode, I_A | I_B)
> [/quote]
> 
> Right now this is one big NOP, except for READ_ONCE/WRITE_ONCE for every access.
> 
> Given this, I decided to not submit any per-fs patches. Instead, the
> conversion is done in 2 parts: coccinelle and whatever which was missed.
> 
> Generated against:
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=vfs-6.18.inode.refcount.preliminaries

Much simpler and nicer than the earlier versions. Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
