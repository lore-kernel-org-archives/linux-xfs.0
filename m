Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9A2489864
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 07:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785481384; cv=pass; b=b5yYDJm1ikXGdNyhSkwTj9rOAhabVhJ1agqGgow3tFz09tqy5wTy0aG5DMPJ0SmyeA2A24a1uP0/Ra/fbi10jF+iEPc06YoRIYH2wH6DxzF6c+2W8NuJ8Y65fKnN8FgokVj0NAIDe79UxNKqC64kA3VTwgf2xr4qJxG85GM1bgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785481384; c=relaxed/simple;
	bh=SJx7bMjpr8SXTq1cdnfjAujyMlWVMQd1xFdAy3xTxbg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GyI02YY8qtNj80LPjQDciL1PJQ5gN53WV1Zdx/8rqGVO8oN0KL4azMKo4KmBE76q1y885pvwbA97FqgaHyF0J2KAUwIcK+9JbCmqE5fAzbktPEzqpe2f6UUHSn92IVcboFVONadzGWlHJkW5f7UW7bxQOlNj0oqfYkBXUePI4Wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PoNMLiQL; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PoNMLiQL"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c12614b81c9so91557766b.3
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 00:03:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785481381; cv=none;
        d=google.com; s=arc-20260327;
        b=HVs0y1Lj2eUmq7gtQ4SNfelQYNSZLlFwjBTgnpWxN7aq3EDj8btgWgFz5fAZFrqZok
         k4p3Nni70C9csfA2tPUBt1ftB5JgiMFOocKwW4t3huqf3/gab9O1FoBIU+YsLxZnh8td
         9s3IMhEVoENbfbvyA3QFmP4v1R3iOzrwpGD3PgT2IwUg4e3C4g+SwJP5GEGASMN0V03N
         faArH+Va4G0ljRRYUTiRekd8PvMLVAPNIIrUNnYPTANQ6ypHDoXt2+3dqadUanj2HtnP
         wywOKyQPQMEJFUQW8h1V85K4XFrOua/cgz52z21mWtaBkkQ0P1DoXfzD0ydfADSSBO3D
         rMEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=myDTl1nKRuAAbvgMixZszeJnFnkfBSLyfqTzMwLTzro=;
        fh=wQEcgPXy381BcswxR4YU8rre7+s5pWncMk5MUPcFMUc=;
        b=rT4LkKvDNlhDyi3xOJDd14YqCwr2Pv/eKgCQ9fjsjWFODx6Lt+kL/ttpC2bbtv7asl
         /in2XqA3yjmHbq7GQ+P2TvwHsJ29uMBjSqdfwgYyPpyHSg5phuOmi38ybrsWisO6bqp6
         vsSjI7czLaaqk6X8xbGLLetaG7gWshWH85clW+YPzLUSdCZo16jnKIXB1eLtNJsqbgqp
         u/mn8113T4iZ+uM9/0kK2FHVTUQG2mwcM0e2QwGuTYaGn2xpODjB3Zl4EExU0JbT1g7R
         clXR2uMSaOv4O+9bM251Me83WB7Qb2OW5WZYhU8dm+d0W6EasPhtGnNxPkRCOS4AC59S
         5NZA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785481381; x=1786086181; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=myDTl1nKRuAAbvgMixZszeJnFnkfBSLyfqTzMwLTzro=;
        b=PoNMLiQLsEMTst8atohVToV1WZCZawy3Y6zTQ8YDiTiiLFyqDigajFAmD46J7ILFlT
         dkdvhw5AKXjlxB7eBQrycS1tnq9BxT8XvT94ukgbxldB25oyWkmJd1sayCPHip6ZpBd1
         ZoO10YjcWvcuA9TGgClz6rENYEi5qD7di2zA/Dx+S69t9W7lbUGjfaBggdRiq/ygzByv
         E0hGgSVk5FHXSWkrYMdz0Rgno238ZIJJPUYbh6Zt3eD8axAkE7TbXGqYVs5mBBPHuRH2
         qo6e8w7V2Tky/Oj8VRFozr44Nclik7uSdp+wW4ulCbuA42JU/s12no02LMGoQm6YR5L3
         TsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785481381; x=1786086181;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=myDTl1nKRuAAbvgMixZszeJnFnkfBSLyfqTzMwLTzro=;
        b=aTkEF0XLwI8n0+oO6yu6CqIIOn3m7LcH0yR/YjaLA/M4jWDQjv0XfOs4/JEhzUp/3I
         e5vSMIrpHtW4TIZmfkxFUGA+f1tXZc2SI6XdL7owb8IuOeRMn03r1TCJ+qkpEtnzP/LR
         ddi5CtRfpzWydpqrzG0SO7/lCgYNOtQztpnzuyP2W8K/Wyi0Tis5yDF6An3N41gABJAL
         5Twj+XI+xkN89uWBj/msUmfmHr3HAk+hifuSObn9ZMGaKcxvVDX8J/+SCc1GQUpRa0ZS
         kYJB5dLLSega7b8jVigNsq/VS1a/MRXDlmvEbsEY6GoI412iZ3i/vaw7SseazoySY5ZB
         c2Bw==
X-Gm-Message-State: AOJu0Yx24rHKcEGZmZ8D9hggFNY8y68u1a0Stcq5dysGy37+r81dLRpA
	VDJgm994/Z7sgD06abXwCKsDvzwr9DRpfeKqkUQf38G5GkoaZ01tfVbwnErIdkLU1W0YKVQX0/G
	GC3Eh1OTI3XO4zAAb+0ZoOSqqvrENL/a5rpsS
X-Gm-Gg: AR+sD10iZh1vn9GAbxwkXRyOGGNb6jvTDI90vXANZTgk6SnlsYTIM7G773gihnHU5s0
	ppkHxaQTfUNzAAKSfxoM6FSfMeKSkun3225VGbTPFuTJYdPaVRmh7YdSLG0HhLq2vkSloMbSR9V
	71PB/SLHPjmY2X1R+415lGxv1G7mOcBeL2bPxxyncDKPozYSWgkrN8KDwIgbSwKzQlUnjsDe+hf
	tKWJ35+m1+dwFF1oUsx5vXhGJ4TcpFMQVVQiUG0d3Jx5M11ydsaaOlxrLPhkjDqCYC1LOIghYX9
	FrdNT4i9Aygn92bOdztItzlIXU5JBn+Yl++8XbFrpZXAjAxfkIMrUjm5DhLpzIyPFTWI1QMAGLF
	+7w==
X-Received: by 2002:a17:907:d20:b0:c16:5a9b:5966 with SMTP id
 a640c23a62f3a-c1fd24c8bdcmr47614066b.33.1785481380986; Fri, 31 Jul 2026
 00:03:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731061448.192010-1-marcelomspessoto@gmail.com>
In-Reply-To: <20260731061448.192010-1-marcelomspessoto@gmail.com>
From: Marcelo Mendes <marcelomspessoto@gmail.com>
Date: Fri, 31 Jul 2026 04:02:49 -0300
X-Gm-Features: AUfX_my7ZSlmSbXk5qrNFfjELe9kAQNvd2cGavJ2_GPg0O3DknKy03hd_4Mpvfs
Message-ID: <CAB4W1t7q3QTc+udz_NOhYP+aqbRzU5EXFxr1ctXTCcbA05swyQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: add guard before freeing buffer log item
To: linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've missed the original discussion about the issue
(https://lore.kernel.org/all/68a70f15.050a0220.3d78fd.0024.GAE@google.com/T=
/)
before submitting the fix. I will work on a v2 addressing the root
causes, and this patch can be ignored.

On Fri, Jul 31, 2026 at 3:17=E2=80=AFAM Marcelo Mendes Spessoto Junior
<marcelomspessoto@gmail.com> wrote:
>
> A buffer's write completion can race with the CIL walking the same
> checkpoint's item list during a forced shutdown's simulated commit
> callbacks. Whichever side reaches the item last should be the one to
> free it; right now completion frees it unconditionally, so the CIL
> walk can end up touching memory that's already gone.
>
> Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
> Reported-by: syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D4e6ee73c0ae4b6e8753f
> Tested-by: syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
> Signed-off-by: Marcelo Mendes Spessoto Junior <marcelomspessoto@gmail.com=
>
> ---
>  fs/xfs/xfs_buf_item.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index f4c5be67826e..c86c4387f52b 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1072,6 +1072,9 @@ void
>  xfs_buf_item_done(
>         struct xfs_buf          *bp)
>  {
> +       if (atomic_read(&bp->b_log_item->bli_refcount) !=3D 0)
> +               return;
> +
>         /*
>          * If we are forcibly shutting down, this may well be off the AIL
>          * already. That's because we simulate the log-committed callback=
s to
> --
> 2.55.0
>
