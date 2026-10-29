Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793234734;
	b=dik4lICPic8jxJy8RrZJ+8c3G6sxcp2Arxg5hjWoCVrofoJTarp5c32vpcAIeQF/yzSL
	 oPsc3lhSCAnmJgvR4H1X2wOhEptvrH3FpH7kNcg4/Ty+DXxDQa4vTFS4hHllcgErUd2ul
	 ++jyjL3C7z7AGi0oARZHP0DfTGriLrNPZzRd7yslyXMB0tvjT8s40SNt2PJHYoGXIoUdQ
	 qQq3N07eHPhcNj0E4iaYJPZMfvF1KbH9V35+kJXpVgkM52ZrCwpxr+T1dF5uAd3SQA76a
	 0EstO/2zuN5ze2fxMGbvu0AdSpiFrup3Obewtt+WeRSMZnuOYarr2ACgVykB3B4CuLA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793234734;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=IX66bHE1Qh/sWHYMzKZGzmSLPQlS8Qn4BjuO8xpQVSw=;
	b=ymxfvEuv+d8h+Xh14RPb2Sy6EIRw+wXl1qE4Q9pHqN7kbSoSMLgj6bg7vh1Q11u3aC9q
	 XRmLH+A4FlxNom8+A6xYd1p6b0+e2yhNEJ4tAdM0q+YJkBxJEvMNHPPusJM9BiWNBKPLa
	 cSW2mNf0/9dp/sHvNuh14mYLeYhcNk3IJe9EMIcRcRv1dTrvaoy/RGUlQzf6cY8sWdfgE
	 V2SLkYYgXSvoJ4zY+phflqx4WgNMQYmPF5oXSPsG5tfMWT63ykSuOgymKExdFeR6NNtfF
	 zeNKlkDYgxfuTaydP3P8kb9ZvZtyxD/xytFKpMsIPMm3Up5yoJ1lMSwtuTC9A+Xef+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0uUyOHE3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.68
Received: from mail-lr2-f4.google.com (mail-lr2-f4.google.com [74.125.230.68])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28329606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 00:45:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28329606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0uUyOHE3
Received: by mail-lr2-f4.google.com with SMTP id 38308e7fff4ca-3ac4f373d3bso2058371fa.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 17:45:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793234732; cv=none;
        d=google.com; s=arc-20260327;
        b=nF80Sf3E5c5rVQECg98sE0ia2/J2geLqaGyfoZWc50VAdNfkCnlJSj9rbyA3cWxxmg
         69E9p3SDJHLA+UwnDGuqHy3D0wnMtQC2poQY4UxmXv/2ZqGqm4WsVA55dPZMVXMzc0bt
         xtM3KeP1CXt+7CHp2gw41jr5cQEmsE+u3GnXjGgMoqgqpt8MHeQLvI8sNfuBEYhRUD98
         iEx8IhEf2KlGJLcvBHg8afKQJp3yH/8JF6sMz6wq5h9vnlP01FYKwJ6brnKQVrnaiUpN
         eN1fwikYEDsfaoHWCi57/O/Iyps4ArFwVl+HtFVwKsu9Wuk7NhPDjWAdeDd22+VCmdGU
         X4aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IX66bHE1Qh/sWHYMzKZGzmSLPQlS8Qn4BjuO8xpQVSw=;
        fh=izKa2iWIQUNQKYXCeXDytPSmuKRpr4AhTF2rXdWHi5A=;
        b=GNHLgwFMdQz7UTOzfysp+12S80zzlSgDzQ9DLDzypzGQqu8FSDqeiuYcQw8gLcXRov
         SreQWw4hc6MgKi0nI+I3sk/vBiiJaGdgj3Yy+BxmmKkYZSfzSxbx9tuVfM4kBxfYbzpt
         bsaOp/iAMjdFIe9ViOh1839ZMqrtjA/dau+l0OaQ7h7FAgWxUuvk2FObELZ/DcruBbwj
         99BIzNjYsp98iZSFizjqevuVh5zuAXi20hkNUIA3eNbonDjtWydyambFy5ljIA+jxlY+
         gkHs9ue1U3HtEH/NrZuxQTfbeQSD0NgUAdfCiUljpCJgUkgJ1Rv/0H9KrvwMjuRZROwH
         C2YQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793234732; x=1793839532; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IX66bHE1Qh/sWHYMzKZGzmSLPQlS8Qn4BjuO8xpQVSw=;
        b=0uUyOHE3f8jNsMWp8FK0asGRw9EbEY1CXKry67A2oKasSy2HG2zwirNGL+3eeHeCiF
         fICA8MshW9HlWQFQqeApWcIVaE6cFsDUgpN1Gf2FtjWg6t9W8tppgEfIOHVpucFW/hMg
         1h0/u2xIm2bWfHTAlbDFvqVkttTyQHL/IhzdaLhWEC2Mcdy86MkQ/2NvXVazb4Pbwk0o
         dW/vFeRaMnTV0A1e3ZjT5vX4zastObB82nkwqY7TEhnLOFwT/QQrMPcLj5gtrSCuG58Y
         DrqBy4w8+kAblPZb2vNJzaZewRbknNeqQ1AZaEtijvIeldQtr+m07a/mqpm/3AlnWpZp
         ZY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793234732; x=1793839532;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IX66bHE1Qh/sWHYMzKZGzmSLPQlS8Qn4BjuO8xpQVSw=;
        b=hIYzXvmVfaxyvvEo+iv/koZ+y1wUyRaINYGSQrJTq7bpDq0RhpUKzZM6AWSl5ABK42
         IrxlKPIg2YigtfZLJR1mVAP+B+5B3OR9QF4TUtodZtnQZuYNehV6CqMbHcRJqxzYZDG8
         pbdsxQrQvSfxZgpp070yMQAuUfJMwXq/SyDlPN/mWien7Tz7+K59Y3b34dh9WlFbz+9c
         YVKT2x+uobQYN4uqZHFEKrmVGPK41ClzbtqsqYsJTVazM2KDJwxFZOjBKGw7L4YACQet
         cfLzEIffDJK7aTwzqLH18YwJVO6gqGoHIFThaR+uLXXEaFG5dQYBReTjQhbBmuzcSJWe
         jDQg==
X-Forwarded-Encrypted: i=1; AKwUvBwsS8miM2YaXUdOUD+fVbsfMKN/Pz+mardrJEUqEPJELp4bATdPbIqUCdTFdnGPWNf+RVOAZGq4YgM=@vger.kernel.org
X-Gm-Message-State: AFq9FYIRtd0hc6b0tcmUxZbuMAbxWU1Zs33pkh7ziFZF/rxwyJMQ487J
	6aZdvDIrWnI1bjOW99AJ5nsGkHN1PpyF32mtofIBbXLZ3kGiLyxW+EPV7Z286+IEdl3HAYiFV0n
	PTqHqQbYGXn/IQwZsjNUNAgbpkar8SCk=
X-Gm-Gg: AYBFou3lThdm0ZNrpizNf5VraQi+SAQCEE41CigYA7HIpdrZmIeIX4YT7KXeZtlKTep
	NuHiKkHyU20GV5A6e1oqFSiOwnhvFUYcapeb56L4mpm2wflyEbnbbnGBh5F9brU+YRq1kButRbc
	Vea6TMwvQx+oFvA3BxeF6pYgldeOpNIPTQYwxb803bs9qTT7GFoL7kxNvzvILGXDniTSov2CoYG
	eLV//ZYnjpPtC90eBfrhuCBjqCkeZElAKy0aWDSGCrhNu4pZoiUBgX06EurGORPHgb4Ll3Sq/Nt
	Ay4rvhshUaEW7CAbRpJjGPdoKGk1YYUuSZjOvL5KHyWId90ZvovxSj2mtc21pcs2+Vb/vUboN0i
	i5fbQFoJQWZbQDMeX4+4zFLWFHqwvgUEnHHCgIiAPheJK69k2T+iTrvYF
X-Received: by 2002:a05:6512:10c2:b0:5bf:a2ce:1a21 with SMTP id
 2adb3069b0e04-5bfcad39f9bmr1447564e87.12.1793234732196; Wed, 28 Oct 2026
 17:45:32 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAO-4RZ25PZ5BM+83Vk8t5NUY3ksLGz5nzONrncipu2_MZhFSsg@mail.gmail.com>
 <auJYmq07gDhTkJfe@dread>
In-Reply-To: <auJYmq07gDhTkJfe@dread>
From: =?UTF-8?B?6ZOu?= <fengaojigui88@gmail.com>
Date: Thu, 29 Oct 2026 08:45:20 +0800
X-Gm-Features: AclHuK8bMR8xx8cfMsFzPtwhX3EUD4u5xaeiHNGfFd4E3fzBEuOQaMNxkXZrHCY
Message-ID: <CAO-4RZ1noJO3fFYZdnVLk7K=YS5uT7+=CS2PrA5XuNeZ+cxBLA@mail.gmail.com>
Subject: Re: [BUG] xfs: undersized log triggers assertion in xfs_log_mount()
To: Dave Chinner <dgc@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Thank you for the clarification, and I apologize for not checking the
relevant code more carefully before sending the report.

I'll be more thorough in my analysis before submitting future reports.

Thanks again for your time.

Best regards,
Zheng

On Thu, Oct 29, 2026 at 4:18=E2=80=AFAM Dave Chinner <dgc@kernel.org> wrote=
:
>
> On Wed, Oct 28, 2026 at 01:00:54AM +0800, =E9=93=AE wrote:
> > Hi Carlos,
> >
> > Executing the stored syzkaller testcases on Linux 7.3.0 ultimately trig=
gers
> > an assertion in xfs_log_mount():
> >
> >   XFS (loop0): AAIEEE! Log failed size checks. Abort!
> >   XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 597
> >   kernel BUG at fs/xfs/xfs_message.c:102!
> >   ...
> >   xfs_log_mount+0x4e3/0x590
> >   xfs_mountfs+0x10b9/0x2270
> >   xfs_fs_fill_super+0x15cc/0x20b0
> >   ...
> >   Kernel panic - not syncing: Fatal exception
> >
> > The log size check reports 516 blocks, below the required minimum of
> > 636 blocks.
> >
> > Is this an expected assertion with my XFS debug configuration, or shoul=
d
> > this malformed image be rejected without triggering a kernel BUG?
>
> A brief look at the code the error message points at answers your
> question:
>
>                 /*
>                  * Log check errors are always fatal on v5; or whenever b=
ad
>                  * metadata leads to a crash.
>                  */
>                 if (xfs_has_crc(mp)) {
>                         xfs_crit(mp, "AAIEEE! Log failed size checks. Abo=
rt!");
> >>>>>>                  ASSERT(0);
>                         error =3D -EINVAL;
>                         goto out_free_log;
>                 }
>                 xfs_crit(mp, "Log size out of supported range.");
>                 xfs_crit(mp,
> "Continuing onwards, but if log hangs are experienced then please report =
this message in the bug report.");
>
>
> If you turn off CONFIG_XFS_DEBUG=3Dy, then what happens to that
> ASSERT(0)?
>
> That's right, the ASSERT(0) goes away, and then an undersized log
> causes the mount to fail with -EINVAL as it should.
>
> > I am reporting an observable assertion from a syzkaller reproduction. I=
 am
> > not claiming a new vulnerability or a specific root cause.
>
> Please do a cursory code inspection next time, because the code
> often makes it pretty clear what the answer to your question is....
>
> -Dave.
>
> --
> Dave Chinner
> dgc@kernel.org
