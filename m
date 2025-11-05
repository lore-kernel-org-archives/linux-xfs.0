Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FC8321448
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 16:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762360399; cv=none; b=FYiL25gZu4uaZMdTQUqCfov2IWnz+3rsS8utokzYe85XqN6NXK8G6+pVPUusY04ka9JSCXCLATSMmwiVg+f22hXLMm5BNnOsAnI63ZV6kN+irzDKIUWh1PxMe/GMicTxeIvpxohEWsShFyUWj9K40d+6FzCLAEGMmOVStdUKMgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762360399; c=relaxed/simple;
	bh=Q3KigkSvYwK5JS9sgke5e3cj+3o6CQW5ok3nCz3pwtk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FU7gPqfJ3REtuLJCoywTt5RMtksMeYUTV+EZou8wzl2hpjkaAjjFO47kCAm8DP/bc/305gEQ3dyvf1alIl1xinZdhkqSuiW+cjNkIgLF/xYFObFiob1hl5dvlPyEnO/T2TLvN0sKwF84RHlJDNE6QIXc6sh4CMPa81LmZN7aPNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MWu2qJtv; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MWu2qJtv"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4711b95226dso1625e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 05 Nov 2025 08:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762360394; x=1762965194; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxgECH2xm74nun5bYq3yo2lzpHEkoDKEqM0ldiRMQUQ=;
        b=MWu2qJtv8JOAzbF1l/Dfac/mUsfdWhU2PrESm+dpybLCBJnwzUc5LHrzFeyYicizZV
         QL5LsPtr47GPBuYwF8wfqqratL1fUBnLrJQgjcd1b6s1YA5rBYsnDmKZtyC+Ow4HlU7q
         AQAzpscIlmpbTdyPvdctdJ4BMh5qMwsRjkj6Fvd9CQpDsyMSs6TflhqWP9RFDLa7M+s9
         2x+sz6cJAfEGwCS44z+5XqDOE7iMxrzY9LgrIibeHzjTnzPqRpjtAaPxUpMHDj3E8GAt
         yMCulqkogs5ujpeBt7WOZ06BLnkdGw2GL+AKqfoZKxG1ywoPe9n9aKsPQ94PivQ4Ssmu
         HHaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762360394; x=1762965194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fxgECH2xm74nun5bYq3yo2lzpHEkoDKEqM0ldiRMQUQ=;
        b=dYjXAdecoazJx208AN6KeVwVTeSTduLq91FNb0EV2/3/NpeGJLzV4Dr/dMbMe0JerY
         cBm2oQDAfQIK2E+dpjxNmY9AxZXFj+tmWrdtiGODWzGJZH6dCtdu0st6qYAoJQbyNibo
         rQYBFSrrqPj8riSNNzgaZJSU24/kaE1kh8XH3/mdRkBRHMol5XpSmLBwhkQxBZ6vo+ot
         oiyhaFPpXJSC7gVxQwGuh7XOdEgDKTWG2n1MuKudaoM3IK97VO9WMlRLgz7wSdhrmDEP
         +LzjIg2STUAssvUsCzzzN6A+YwmRj5iF75/bWavg90Cmua45SzbJwB38cCHxhfkhB8O0
         uumg==
X-Forwarded-Encrypted: i=1; AJvYcCX45sgwFRIrTDitugrbVMv+eK9OWJ89VyFtgFB8ZjgqWV9BzvLV19FETZoM6vEAFhkB+kkxZ/DX/5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDHpmkqQkgKuzk7qK273jJ8WD4rBKMIPluIybzflZqJwEvgWHW
	En9mKy3qW5u08z2UYktOVsSIJi5VO7J2aA+cstgqC8GnM57cGTB/Q4FnQKE0EdRy99e0AH84U82
	LaoOXVGccbBXZR1crFl3y4ZEL+zPDSiKCoGWPawund2utW6xniJeb
X-Gm-Gg: ASbGncvzWdPuoO2YiA+7zAFNvGDlYsnjrKKekH1pL1ADMEax27/ApnWMJbVrT58Cxlm
	Dee182tcpYLvwDzHPm1nY6VQuW8sl5geFSURG8tUO7WTXcdpEifmdOz9Cb5bBMecTW2k1bs7CrP
	/0iIQ9bH1NVLMc1u2BcgTQY6s4WA0MGV0P66r90lgQkxUC1O4Pv4kKbg2wWzDSQI7Ynx4NN8Jey
	ti9Ap5DBIDpdC0un/fxozbgSYZvZ03tiSHCBMHCJOpAiPXhs5vKe3QQb/1tlLoxV/CqQhnUkL/A
	6NmpUmuL+uwWJUo7LFMvk0TlWow1hOj9KotPF+9hK/DSDBy+g6LKIflwYg==
X-Google-Smtp-Source: AGHT+IEz7I4CY+GlSdoe/bflZWVcU0m0o1McZfVokzTIe0B2RRVoH+RBVlVjzJASkrgFqD3eiDzaXjnkv21y5vlztVg=
X-Received: by 2002:a05:600c:4584:b0:477:55de:4a6 with SMTP id
 5b1f17b1804b1-4775cdbe238mr35989165e9.3.1762360394279; Wed, 05 Nov 2025
 08:33:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104-work-guards-v1-0-5108ac78a171@kernel.org>
 <20251104-work-guards-v1-2-5108ac78a171@kernel.org> <247c8075-60d3-4090-a76d-8d59d9e859ca@suse.com>
In-Reply-To: <247c8075-60d3-4090-a76d-8d59d9e859ca@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 5 Nov 2025 17:33:03 +0100
X-Gm-Features: AWmQ_blmtnDHlxA5kivLFHuNDFJT0rxb6Yv2ZgkGpfB5WfZtUJKHjLM2jWHF-pQ
Message-ID: <CAPjX3Ffptip7onCpm30OiC+zvfNV05_B1GQYM4-Lem-V12_ERQ@mail.gmail.com>
Subject: Re: [PATCH RFC 2/8] btrfs: use super write guard in btrfs_reclaim_bgs_work()
To: Qu Wenruo <wqu@suse.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 4 Nov 2025 at 21:43, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2025/11/4 22:42, Christian Brauner =E5=86=99=E9=81=93:
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > ---
> >   fs/btrfs/block-group.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> > index 5322ef2ae015..8284b9435758 100644
> > --- a/fs/btrfs/block-group.c
> > +++ b/fs/btrfs/block-group.c
> > @@ -1850,7 +1850,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *w=
ork)
> >       if (!btrfs_should_reclaim(fs_info))
> >               return;
> >
> > -     sb_start_write(fs_info->sb);
> > +     guard(super_write)(fs_info->sb);
> >
> >       if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_BALANCE)) {
> >               sb_end_write(fs_info->sb);
>
> This one is still left using the old scheme, and there is another one in
> the mutex_trylock() branch.
>
> I'm wondering how safe is the new scope based auto freeing.
>
> Like when the freeing function is called? Will it break the existing
> freeing/locking sequence in other locations?
>
> For this call site, sb_end_write() is always called last so it's fine.

It needs to be used sensibly. In this case it matches the original semantic=
s.
Well, up to the part where a guard just consumes additional
stack/register storing the sb pointer. That is the price which needs
to be accounted for.

--nX

> Thanks,
> Qu
>
> > @@ -2030,7 +2030,6 @@ void btrfs_reclaim_bgs_work(struct work_struct *w=
ork)
> >       list_splice_tail(&retry_list, &fs_info->reclaim_bgs);
> >       spin_unlock(&fs_info->unused_bgs_lock);
> >       btrfs_exclop_finish(fs_info);
> > -     sb_end_write(fs_info->sb);
> >   }
> >
> >   void btrfs_reclaim_bgs(struct btrfs_fs_info *fs_info)
> >
>
>
