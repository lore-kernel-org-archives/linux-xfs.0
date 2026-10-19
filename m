Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011633F4DE1
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 06:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792390494; cv=none; b=rhLZv3Bti7JstCWdJ8lnZhm7Slm7rKhW1Ys/bRwvbOH5ciSgDk1tQgf6GW0e8bNsu/UfxTQ1C+N/Sl0h+M51bNMBfU+yCRicEGKusBU7oNFF788eQ/FIuQBxPoswdd7oNO/7e3W8sLomcjKhCgGqur0j+kj/T6mO2KIhBMCoIdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792390494; c=relaxed/simple;
	bh=hLviHrUQcnY9d6Hs59o7A7DhG6hJV3vxIcScsJNeYyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDYP8HL8qyuh1lnz7lSpnoLFVjI+grYm+P155hpQSna2Xz8Y95PclxJbaCKCaMLFV+qTiI8OURf0A3clr6Z/6wyEO1MhHT2TEE/zjJr+3e9k2MZRhQM33Sy4CPJ6lHhSe5b1ASF7kNZy3crIVDUtlq42wRel5ZHqq3TLC9bUOqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b15sAq9N; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b15sAq9N"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-398a4dcf289so880065a91.2
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2026 23:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792390492; x=1792995292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CH7/2Pn88Czop2CrZPadAXkcJAGF4wsEW/e1YNB1cxQ=;
        b=b15sAq9NWihv6GFpfqSH5HJ3jmNXepVPacRSjllpONskWo3VoEK4Itgk5hQGhDqVUm
         OWiPBYy0UhE40WYO7DWnLZlZpp1Jwz4eqeXN2NSXpBe447i3vO6tMCc7g3awQB10u3Jj
         jTYX/R96bQphJx/b/em2D3HoMpomNXcg8xaw48nYpVKInNkwqKttKW2Y5t+OgBhBj5Fy
         EbpmE93ZISJExcTC6ZjYcexazX0RFzhEETQCXjJaWpZSM11D4gqsKPPoT80kk/2BPyfp
         49Q5kSYl++unHpMs6blx4qxYak19NowZTS7eZvDPax0vG4/9RmoFI/cMVEqXRgNQ7P5Q
         Zvog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792390492; x=1792995292;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CH7/2Pn88Czop2CrZPadAXkcJAGF4wsEW/e1YNB1cxQ=;
        b=ReLRnM6FU4bWkIIdHuJ/4gZ3inZGDRtnbV/eRN2d58I2AjfA8tAgMSkKnVWYi5fdqU
         eKsoNHmNzaJI9SSZwIOrhHokSZqvRJeoZFBpenJ9J1bNvUShte26H5QgJTaCzuyYXnIb
         t0nPpi3CfiKuf7UEj9ly4reM1W5dpza1z4FlA/9DFdoV1XsUJlJayw92nMQZRTjADsE5
         tueXUQm6/N+iDpSz88Kcv8w/vdptQqIZfACCclPLFY+K16UP5I0GD4EY9E+mjfWX33yi
         /AXq2LsZBu85zeaMg7jslxoexrRKSf9MMG5VVE5NYcMH/WncwczJHLGDSBdiO+w1N1MR
         jReg==
X-Forwarded-Encrypted: i=1; AKwUvBzO76cSeT5u3HRPIYST8tXg94lsbtP/70UHbvcZX6Yhd9qmLouG6PJGCwrZNEg+PV+/VylWCVV+V/I=@vger.kernel.org
X-Gm-Message-State: AFq9FYI6ngwIdqdfLUha7mVMU5MM1yhoBgJuBs99mF8TQxZLatvBZyUh
	LUx+J8L5iXTKq9rU/ANraKDoCMXWdbI2teUcecd4rBzbu6mkdIHzQ72M
X-Gm-Gg: AYBFou0J5+qNVbLF5/kpyL2GAznixpue6h49F+pxhMBCXExMX3NxRHdCXqcHJ4KP6K8
	ykZNZguXJiI6nRTnW69s7yEBcP52eOnEoIGBNW8mK9QfoHK4Jyh19W869KCLUKns1nkvd+QzIPB
	EMXuYUzO8aXBspQ7abaBjxIuTaRNDAeW5COcgZN5NcRbIzYD/wMUiLzIm2nXjuRZQw8h9VON/OO
	Hso3POWkBbQibi1bo6AP5V9RyMOxwDGmhHPTqTVEvKl6Xrg2gCzDo5Jka+2yAQ4mBlnYUbmGzpI
	lXBuPS+zr35ONw5jyouurs+nZ4o4mrs1AE4t3GJRXA87T5urEzvxTyESgQjtdL4n+ruW7bsxWn3
	2vZTU30V5dPaSi4YzXHYJW+ZY3DLA7FA+DPzfP46xdlWul0ZOyBfteksUoCScj493JEhGVGkjLZ
	xAGwBPrcwQIF5/qia2R7Znp08lZ5Rfy8cqF1rZDVYr08V0UYVsJV/75tAtJMJx
X-Received: by 2002:a17:90b:3851:b0:3ab:c80:9362 with SMTP id 98e67ed59e1d1-3aceeea8f3amr5078332a91.35.1792390492104;
        Sun, 18 Oct 2026 23:14:52 -0700 (PDT)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94794dd9sm19035101a91.12.2026.10.18.23.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 23:14:51 -0700 (PDT)
Date: Mon, 19 Oct 2026 15:14:46 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	exfat@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 14/28] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <atW1VhJXAIvtYPfd@hyunchul-PC02>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-14-60743a3dc326@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-14-60743a3dc326@kernel.org>

Hi Christian,

> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 4066bacabe37..12ad2ce938ba 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -269,6 +269,8 @@ static int ntfs_reconfigure(struct fs_context *fc)
>  
>  	ntfs_debug("Entering with remount");
>  
> +	/* Mark the volume dirty first if an error made it read-only. */
> +	flush_work(&vol->error_work);
>  	sync_filesystem(sb);
>  

    if (sb_rdonly(sb) && !(fc->sb_flags & SB_RDONLY)) {
        ....
	return -EROFS;

Before this patch, SB_RDONLY is set, so remount,rw returned -EROFS. With
this patch, sb_rdonly(sb) is false, so remount,rw skips the check and
return success even though writes are rejected with -EROFS.

I think that the condition should be test NVolErrors(), for example

    if ((sb_rdonly(sb) || NVolErrors(vol)) &&
        !(fc->sb_flags & SB_RDONLY)) {

-- 
Thanks,
Hyunchul
