Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3237B2FE042
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 01:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789350608; cv=pass; b=CdpMBxrHq76OYpTv7KaQwkPUM/fubArCDa6F1q6durWoy97JUeloAlKvcMivl2ZDAs7JE/GXh/JXC3ygzwdnVg9th9vuR5xZj5L++VZQ6+3mzXKmDy3fkjzk3uuBTUhJoW0dVfc04I/TcAyZ6RZ0M5Bb2h+QiwosI1WjFFogP90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789350608; c=relaxed/simple;
	bh=6JDat1egMs8T2AopmiRxNOMRANZPNk5p+3KGcSZ8/GY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EQ8Aybp8V3dh4wiITVrljEDiyltsknzBC362aRdpBp7TfgDvMT6Uh/en3GKwghloUm3hh3Gn/kXerfFx5t5uvRA+eB6fol3/8n3O+bWc3bt4VjG37rfDSmlnAFy6F/LyyGY2On5S0wyfDwTPrHWUacUfkisUt7sEgrnHYmLm4Ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VfYXgsy1; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfYXgsy1"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2940d16190so383192066b.3
        for <linux-xfs@vger.kernel.org>; Sun, 13 Sep 2026 18:50:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789350605; cv=none;
        d=google.com; s=arc-20260327;
        b=bLQyyqNvz2tQtz47bI1HO0ROABaHmIpWWmCjJwVJzePW41WOHna3ISRYn6y3/3MKnP
         yI0HmlwtN8DzmvtHdp0ER99uHaJIcHnitxSiPfb29dRWHoY7uV0veoOiJK7TX++n/WiC
         zKpCSK+TcpbJYESkr1Th+hTAD5lSnZg1ccbnKAIbQyzxk8dOz73P9SmiuLQBktjGwx5J
         hwPqV7HO2D46jRzvid+jUCgqPj00+0j0dDadcxbw8rPRf5PqGiV/9uedm/kDzRQoRxql
         UCKjovfG3kPvY03UmEc40mOW3AbtnLHSDPJUqZ2E4tVXaYc05poRlpCZ6EiCalypm9F3
         de9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nDT39FdBcImVCPVb0QHT1U8B7f8POVTcW4tGeOBDc0c=;
        fh=xNOWao7YD+6s+B8mIaZoEyEl24USDHUmlpYLf137qIs=;
        b=VhDUi3cQfEzQJbo2OIycwII9hK2OFS0ivdPdPY6/VgZPMMpytbk33dC2pI8IEzrcpJ
         3+FYkD0BJwECy7cCMWw9AAdArplk4g9reJWremRgrclReeB48kLvOeS09yhwY8Fs/WzC
         rTdTWru/MTgHqVlmrikRDSEeGWIdvYcvUln8ihH+9S+C7LLgMcJkWLMHU2/p64OGFaMs
         sX0TY0zCtlBp8zF9b82leBdTXoqVQzZuxzxkmpc3OvVBlM1hyA76/ZxT0na5kNUTJUdU
         6dsTVpo4FM8fWVq616M221VaAURFcU9AUISR1iU3Dz3nJ4dn3nTVOn1tz7NTtFzFHy6t
         FHIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789350605; x=1789955405; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nDT39FdBcImVCPVb0QHT1U8B7f8POVTcW4tGeOBDc0c=;
        b=VfYXgsy1FMY1HWqok8dA/7LdvG+RsQfsDLKhPFkp9EIs0X+m6UQOnT/Oy7rPO1mC0i
         o3C4h3/F5bIjs2wN9rXSHtIjfxO4QsMVD28cSA0qsA0n9a/1BXkeNRfK/+QD3fHlMYjD
         Fo5BSv8xsbJnuk46GJz+9ILoqYSQIgg5TZcCr7tML3zuckSqnth8zi43qg0sAGmrKhgq
         xaZ4YGjnpQskXQ3k6YcCaQCaVe3Xwr5+igbX82HYTOEMpfndawReGfN4ZKEa3HQ4vqCW
         gNZ6MC62pWyXS7NiTThDaDssFwzQS5TabkyuAv7lqBXEd2PV4VXb7n+9NFfpm7NH20zE
         HwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789350605; x=1789955405;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nDT39FdBcImVCPVb0QHT1U8B7f8POVTcW4tGeOBDc0c=;
        b=hei3leKhP44Jbf8bY9W4TCRD4UsyOMgx4FJ0uTvBBRBY0PvpIDNhK76yB5O6yJtb2C
         BfA9a5RHsqHdvkFVNtB8T82J8XdfQk+OtxlVupQ2u8tdnAl1L55RZjjP4CkMx6Ke2sDg
         FIFrCqyR0MtkPh3uugsWKSVbFCSRRUubdfghXSbb39TgqKWAqaB8bjabHr3zZ9hn+OfP
         EL8RGQyH7nFsKlBkxFRvdX+26aTonZxk0YYBhhoHbOT+/2Lndz/BabBKVnTaDqHTcjYk
         odkN2xQJqdLxHrBGL34rgaET6xmrbKhhfMWNzlNo0nQ547jEYWUbCRva30OTODneaouy
         YVQw==
X-Forwarded-Encrypted: i=1; AKwUvBznD+jkUvpQ2fPYXnlI0tuOtn1k4lWKTNyCZrJeUsw1YJFNouo+nvYwqMhmQ17tW30DKFGQebRI3Vk=@vger.kernel.org
X-Gm-Message-State: AFuF++nBp0TFq5Yd3ivqCB3oqqf02Oj5/vsU6mBFpWgLN9rG7QdLYDE3
	VjXmI7ckEGNhP5wPePrYJDlxZHdtp9J1uZrjmDLE+AJJB9YZds+4GW59ystcTVptPSlEMg5DeHu
	sstv+7Z852MU26Nf5lm2xUBL+UgZuSLo=
X-Gm-Gg: AYBFou1Y8WbIirskcPkAdECGghM43ayMtqDpQ8ZSfSHW9hj9vf8CYOf43Fzou9amX3Q
	IHPbi9pvHic+cypbQsl9pXoM5ch76rb99zUYGx5L4TVc4i1Fy5Kyg2snORfN5lIaM9BiCYikNUA
	U5N6sw1dbmvoUqowfkm6OHuR1oKqJqP+wE+/biUH7WqX9E1sb8oU0vIpLH1RhCQl4O+zViPcZP3
	jmsuumlryVib0imMQu4UQtMTQ4wj2mPi8ggKlBjTCgQ32H20EIglwt9/yETXr6ZWt+VcoZEtEST
	TLx4/q+p3yT7mAhXkNE0G2FhmW1Ykij9L+RrChfpqkdqJIibhbenFH/RETyoDe+1GGYl3J2wX/R
	SN1Gmc5ijugeu
X-Received: by 2002:a17:907:1c8b:b0:c29:44b0:1428 with SMTP id
 a640c23a62f3a-c29b87811c1mr30232866b.42.1789350605077; Sun, 13 Sep 2026
 18:50:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913114528.842015-3-bestswngs@gmail.com> <aqc2igMKBhpiEeSp@dread>
In-Reply-To: <aqc2igMKBhpiEeSp@dread>
From: Weiming Shi <bestswngs@gmail.com>
Date: Mon, 14 Sep 2026 09:49:28 +0800
X-Gm-Features: AcwNN1XJfyet9Pz86i53FrvFTYUn_UoNqnMHSeKkbBlGR2ZwQU2nrN2NaQjskbs
Message-ID: <CANgPUi2OVWU+5Gsv8hy7B5nFh3n5_B+Am3Zm3f6M9Y11oX1Ocw@mail.gmail.com>
Subject: Re: [PATCH] xfs: validate buffer log item before reordering
To: Dave Chinner <dgc@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chandan Babu R <chandanrlinux@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, 
	Xiang Mei <xmei5@asu.edu>, co+af981e62f5c7171a@bugs.sh, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dave Chinner <dgc@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=8814=E6=97=A5=
=E5=91=A8=E4=B8=80 07:49=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, Sep 13, 2026 at 07:45:30PM +0800, Weiming Shi wrote:
> > Log recovery reorders transaction items before buffer item pass1 valida=
tes
> > the format of region 0.  A corrupt log can therefore supply a four-byte
> > region containing only blf_type and blf_size.  xlog_recover_buf_reorder=
()
> > then reads blf_flags immediately past the allocation:
> >
> >   BUG: KASAN: slab-out-of-bounds in xlog_recover_buf_reorder
> >   Read of size 2 at addr ffff88800e40e364 by task poc/133
> >   Call Trace:
> >    kasan_report mm/kasan/report.c:595
> >    xlog_recover_buf_reorder fs/xfs/xfs_buf_item_recover.c:164
> >    xlog_recover_reorder_trans fs/xfs/xfs_log_recover.c:1929
> >    xlog_recover_commit_trans fs/xfs/xfs_log_recover.c:2053
> >    xlog_recovery_process_trans fs/xfs/xfs_log_recover.c:2319
> >    xlog_recover_process_data fs/xfs/xfs_log_recover.c:2510
> >    xlog_do_recovery_pass fs/xfs/xfs_log_recover.c:3253
> >    xlog_do_log_recovery fs/xfs/xfs_log_recover.c:3340
> >    xlog_do_recover fs/xfs/xfs_log_recover.c:3377
> >    xlog_recover fs/xfs/xfs_log_recover.c:3502
> >    xfs_log_mount fs/xfs/xfs_log.c:617
> >    xfs_mountfs fs/xfs/xfs_mount.c:1031
> >   The buggy address is located 0 bytes to the right of
> >   allocated 4-byte region [ffff88800e40e360, ffff88800e40e364)
> >
> > Validate region 0 before inspecting the flags.  Keep a malformed item o=
n
> > the regular item list so that xlog_recover_buf_commit_pass1() reports t=
he
> > corrupt log through the existing error path.
> >
> > Fixes: 86ffa471d9ce ("xfs: refactor log recovery item sorting into a ge=
neric dispatch structure")
> > Reported-by: co+af981e62f5c7171a@bugs.sh
> > Closes: https://lore.kernel.org/all/aqZALi7GdVprcNOh@cronus.toxiclabs.c=
c/
> > Cc: stable@vger.kernel.org
> > Assisted-by: Codex:gpt-5
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
>
> That's pretty poor form - taking a bug reported by someone else and
> then reposting their proposed fix as if it was your own before
> they've even had a chance to respond to the maintainer's comments.
>
> And that's even before I take into account that the proposed fix is
> an extremely poor one. It basically punts the broken log item down
> the road where some future processing operation happens to catch it
> and abort journal recovery with EFSCORRUPTEDEFSCORRUPTED before bad thing=
s
> happen.
>
> i.e. you didn't review it, nor did your directions to the LLM that
> "helped" you direct it to determine if this was the right way to fix
> this issue.
>
> To compound this all, I've previously asked you directly to stop
> sending patches that add random verification checks to random parts
> of log recovery and instead spend time on actually addressing the
> root cause of these issues.  i.e. that we lack robust on-disk format
> verification of the journal contents.
>
> Last week, when someone else posted a random 'log vector is broken'
> hack, I said the same thing (yet again!) and posted the design doc I
> wrote a while back to provide robust, generic log item validation
> for the entire journal:
>
> https://lore.kernel.org/linux-xfs/ap8ucHIw-pKLhh9c@dread/
>
> I posted a link to the git repo where I've started this work further
> down that discussion:
>
> | Ok, I just posted my current WIP to the log-verification-1 branch
> | in my kernel.org repo
> | (https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git)
>
> That's the work we need to do to get rid of -all- the journal
> corruption issues in one go; once we have that in place then almost
> all corruptions will be caught long before any of the recovery
> parsing code can trip over it....
>
> -Dave.
> --
> Dave Chinner
> dgc@kernel.org

You=E2=80=99re right. I=E2=80=99m sorry that I overlooked the ongoing effor=
t to
address these journal corruption issues systematically and instead
started from the bugs.sh patch, which merely stops this particular
crash rather than addressing the underlying problem properly.

I did analyze the crash, test the patch, and check that it handled
this reproducer; I did not send it without review or testing. However,
I understand that this does not make it a good-quality or appropriate
fix, and I=E2=80=99m sorry for submitting it.

I=E2=80=99ll follow your log-verification work and would be happy to test
whether it also addresses this issue.

Thanks,
