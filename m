Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792613219;
	b=WWnTNny4ifSwNbEjToRvvG3u1qNUoP5/K4RtypdAIgsiwuyIvGf4vHams+ONsl4FhNcj
	 hgcUJvCslD+YWnn/DfK1xqaKg81H4qO4VfZQLGZ8TyZ5PWN3fy8UtUeSSZ3qhRqg8sgs9
	 mBU5So6/BVWnJoW9JQhKHEvh0+CmH0YGdYkEwn/CQ1tx7pQXXv9CJGbJ+ZO6Oc3Pu9Obu
	 2MSaa0hECHxrEqb7t6BPBN136Ee48xKJkYb/lZc7Cow3vgAGu6isxIRpc9CMR7GN+2SHP
	 BC710hsWWY5UmHkDtz343fUsWEAsslSYzASafkxqt3g1wTQlVqeAWCOkLZv23ThSc1A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792613219;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=YnlEteCYpD3lQrYBKNyMuyjU/TUDJvUUBX6t6T7XYxI=;
	b=hraxUL9lsmU/xzA3Ymw7viOaRZSLVLjK27lTAolQqxB9u+oFPUnZIedPvOOQQ7sqmrLh
	 DZRTAxxNhQw+J9cNq3dZODkG17BDFQZFj53fDeBcUXdsgdLa/gCoDKecdHpcokuSrLyUw
	 1vKDazoNTuHHV6oYrrJwWpGXNvRrJ4sA+bry+19stbW9LuKIpzwfJMkDVhITXkrbePLkF
	 9fVruqZwoNUY5UBfC8OepBDxPlhmzrgj7JYsjw01foYF3gaN0PWRqLrfM6nfeuc/DML+3
	 wRKa2uG+FmL2OMkx/xdsyeLQ3JjYAs1/78o/95uyQdYVenK/BhAV6pz6Kz788V0ga4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=elrepo.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EE4606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 20:06:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67EE4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=elrepo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4677aad67bso124434766b.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 13:06:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792613217; cv=none;
        d=google.com; s=arc-20260327;
        b=KCfFEVrDb2n1drGllu/yNMRwms5hVZnZiYl2lkdZdQs9PMft2EkNrjb4Gb4Qe5cpfb
         hYy3hiMz6pGkEHbW5jIbQMTDrNf8I5uUs4pL75y5loY2Y/k6e5ldeTkT7AADYls++oNH
         cOxQpi0tbtOYliIC0C9YM0sU0wUNkXiK8E9Fgfg3MmKCowKDTeMM+MKHLF++axQYbUub
         i1HogQvc8RpVzf+aG6W5LUcRObKFwdwmyFI9tlO/tWW6pjMI0raT8gZ9kgYkUrzxMnQ9
         QuItKUfQVflCcd3iH5nGND795zJNOqfqqhDINe4NXNPdzZWqufFFabdBNoZdx2DIgrJ6
         e1YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=YnlEteCYpD3lQrYBKNyMuyjU/TUDJvUUBX6t6T7XYxI=;
        fh=JSKICFHyZt8zqmoal2//XU7u6uCTnwALWRxb+InPo4Q=;
        b=A6J4J9CIaiu+jeb/Dfx5PM1lsPsNtkOReAAz0OX8IQjmag051mIpv6+xo906gJvBlO
         QD2NdHLWSsMc7I40LWo8D3iGkWu+YtMy25KycR82lxUv5hMVL/BxOiVxppiiitLKCGnh
         pgqzeLA6QZc03xXVZarlZ2mSIE5oakJO1zc3jn8PhcML+2kcB+2cBWsOLceQPxLMN6xc
         8SQqxcvUgMvaQLjEiyZN9IcGUgtrh4xuhhqPZUv9UAciVDk1i5U9/TdPzm//YOKfL9Dq
         uBug/hULuJy2yN7bI+k5PzH8uN5Jh52WNUKTSoHUZb3/nfltGNCgha4dohCp8qRmgDYt
         4EHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792613217; x=1793218017;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YnlEteCYpD3lQrYBKNyMuyjU/TUDJvUUBX6t6T7XYxI=;
        b=fjdRDCRoG6GpZsa3u1PJ6Y5FNbpQEChgGj8O5wJ1XzQw0cPLDl3XUFI4jIDzfcqYMN
         /ZWROsTq0Ie+seT6Bu+RruiCBF0NjZGfLXDYeFSijT8QxN6j1n6AvO6fixV0n9zp5/i7
         LAOOHQux2Gx7/TJA/3dZSEjf0zXf8lsLBGhvPHvzqsFXkCmb5IO4BlvO38GzxwhJwVo6
         zWMh8LaiO5Baw8BLFqyGYikQ7BvGAproAyE/Bz80Q8uEc6fCgiavJT/HYycbRs73O+9P
         YRz4MgR6jGn01fuE8k9DoyWbGivyk91zgAzU5SVG8Ho1gXhapZVkY4T7hcRBEl6ZIp0I
         g0DQ==
X-Gm-Message-State: AFq9FYJGLuSlr3Vnf3rvIWsLQdMxCtgE81h0CN8E6bO0OFVb4QdYaNgS
	4yipd1EyqNTOOh2nMVK+mZX81PSxmVc/rlUPJKnbcs0YLQZM52ifUkEOlC/d+MbR9fDjkZOQmYV
	Au18IUeKyNEUf/rpQpXaevBjKYoFtI8LDFw==
X-Gm-Gg: AYBFou1Yj4VkzFLnrLdl2fRY/HW/Ykqea+/blJveR8NSeNW3EQnLuTIP0/drT0b83EG
	py0Iovaccjsks4XR6YiNY9u3y2SKF4PE4tEuM8dWIj39W/LNdgG4hgphe+49Q5nTRW/ucdMUZku
	YnXZuETS3snRvpu83SESZLBKXi/3tqREgLlnRyVzMpdidjcGeON1SLWivDQRagM3Qsf9ObaJ/uO
	TQy2/HaVFyjSqYvwO1ldTDmRl+Vj8DoJTVmCh6aOtkCO+NXsnK5kpyx7aBLxTwVZi6TrhDYRes6
	1+Kymgr2853PnBM9Q3/B8KtUlPsU2nbb25ApLnqovF+00zzoqqzkNTmXixfjZK5excc/0Oyj82w
	Rl1GucSL4VlLjjV+A+hEOFjwz0c9WTIEQaqoOVRJ6+TCxVn39pRMr
X-Received: by 2002:a17:907:3cc5:b0:c31:9a1c:de76 with SMTP id
 a640c23a62f3a-c467961aecdmr259826766b.14.1792613216562; Wed, 21 Oct 2026
 13:06:56 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CABA31Dp=R3nnFpRGLhw0T80derEGq4eQbHE9FccOUPnLK9qerQ@mail.gmail.com>
 <atkY6iLboERBtgJJ@dread>
In-Reply-To: <atkY6iLboERBtgJJ@dread>
From: Akemi Yagi <toracat@elrepo.org>
Date: Wed, 21 Oct 2026 13:06:45 -0700
X-Gm-Features: AclHuK_N3qPL9izNvWecEIVPfWZ2yH_RA2sgjOmrZVK2_DBtNIV2cBQRZyX9gO4
Message-ID: <CABA31DqVpjObUPC5XK_rkb25bA6tSRDKSbFn3xwouEo2SYP=YQ@mail.gmail.com>
Subject: Re: [BUG] XFS Assertion failed: lock_flags != 0 in
 xfs_file_dio_write_aligned (kernel 7.2.6+)
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 12:57=E2=80=AFPM Dave Chinner <dgc@kernel.org> wrot=
e:
>
> On Wed, Oct 21, 2026 at 10:44:16AM -0700, Akemi Yagi wrote:
> > Hi,
> >
> > This bug happens on the vanilla, unmodified upstream kernel. It was
> > reported to kernel.org Bugzilla (#222082) but mistakenly closed as a
> > distro bug due to an ELRepo build tag.
> >
> > The details reported by the original submitter can be found in the
> > link to the ELRepo bug tracker.
>
> Not actually a bug in the code. The code is suboptimali, but
> functions correctly in production kernels. We will fix it, but the
> real problem here is the distro kernel configuration.
>
> i.e. The production kernel is configured with CONFIG_XFS_DEBUG=3Dy.
> That adds lots of debug checks that will crash the kernel for issues
> that aren't actually bugs but indicative of potential problems
> developers need to be aware of when writing new code. It
> also results in lower performance and -really bad- allocation
> behaviour which accelerates filesysetm age-based degradation.
>
> Have the distro turn off CONFIG_XFS_DEBUG, and your problem will go
> away, regardless of whatever we do upstream.
>
> -Dave.
> --
> Dave Chinner
> dgc@kernel.org

Thank you for letting us of this kernel config option. We will disable
it in our kernels.

Akemi
