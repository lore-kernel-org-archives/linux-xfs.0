Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD15E158200;
	Mon,  6 May 2024 17:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715017951; cv=none; b=Nghp4lpJTb8A47Nhbi+/w7gKfxsuuPggmnEaZuSqfvM4ox8sbRq6pFj49marpcJzjKRWgE7DLY4Ht0Ef0KdP/SzZgqtuQKlO3OcYikBv+/8vLxBG6lYcUR6yCowXU7JJsLBYfyFNWtyMTol9rN+f345UykWPWaxaz1aCLlTFJLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715017951; c=relaxed/simple;
	bh=rcbt8tPpliaViUUJItO/Qm2HvMhvotHCYiVUOtio4B8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rk9BPslnL1L6l5dP+onqW1LhIQKlwUeAjM1KexzFbJ3eiREm5rjlpeNiIcYhomWa+Is04bpw+T80wbuq4ZtfUr3DbUXyFc16GJXoVwiNMiVlB49xF4p4f8X4crjnNGH177UyPcqkjLhApoAlj8tYmlQ2WMYNbx4ZpOTYgnI1UeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YZ2zF7Ph; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YZ2zF7Ph"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-de60380c04aso2739443276.2;
        Mon, 06 May 2024 10:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715017948; x=1715622748; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BYzNbQNaS91bztsD6WkSm2BEjN5fDT34hRx3TNcIcvI=;
        b=YZ2zF7PhSwPpxZoFDkyaagWnxaE1GG2p2rECGyBopGQ854lMLpuyqGN3dzPW4+vqKd
         nJ2GbyqBQgUiozrshJ0TboSVgTmdiAIdEKxzzGg49Ah1F6Egke3niOHgW8fp6B5RiWXj
         Ve0/DC+fq7+jvb8nF71MGdXLrkeBsMPJZGd2cSK6AQeuaFYuzCaE9zfWwUeEKxSu7mAh
         uen8Y3YdlY0zOnd9D/k02seNb1UilipcfG2MkgZgk9SnKPn+FMHX7vuUYZ6fXWp4IVsw
         XYaPvYtmyQdjwkc8mx1XpdQ3teaWxESneFWWO7R/EhKE0olaLgfZHumWKNh4LXEP/CUU
         sdqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715017948; x=1715622748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BYzNbQNaS91bztsD6WkSm2BEjN5fDT34hRx3TNcIcvI=;
        b=HDwqtrkpAJdB+gyqkkay9TxyrrI/03m7koqiwb0wXJJwrI+RypR4oFi/pmiVly7BxG
         Uu6CmRPr4+ceTws3FKiseZ7MnnkDIvhsJqGPzKZC8Evit5GrTSra/s1Qm94+eiH+K9tE
         dj8bxi+VkBtvt5JGtDfmmpAox1UJGpZ/PYSDYVsL82FvuasexpYCu6397t8arXjDy/vM
         ZBWJBqeu9MK1fgw8BYWwZNigr9YjVMhtB8HPG5Zi8MXjl/iwlFfF+7ER8wr0Y8xff2Po
         W72n7WMhXrLNH4hu1QgImYU+sXdVqR/pA3B9I3HiZSfT903Md/Q3EB/cz9aYq9nx3hTY
         woyg==
X-Forwarded-Encrypted: i=1; AJvYcCW1ZY5bkAYYotfsIz5eKnVOnv7FxOaq+nxBtKLQVE9ULwapgz53CbKE003viej8XAUTUNCWh4tMAZGg9i9zVaXVqbqQHKzkUuNLrA2GvkLLS1+fKYmGVLxnBe0W3NbkZz0y
X-Gm-Message-State: AOJu0YwpecLWlFXApKiqxGGAMHU52TC/6uLY1F64WrrRRnQgAm/kwyBE
	0gZ6nte5iO5A/SGihQlbUrPsgevbZRX1cbEIZRpaeZnSu+R2vlqeqKHWIFueTVmxaXiTrKtqHz/
	INTWy4qNAKqN0uUitnLplDBkj2OE=
X-Google-Smtp-Source: AGHT+IGVQaZ8QqNmgaAoecSHRhE1g3+vAvqqV8fbNFPMHaqxv1GmxcsMxY3PjHa3v2Ip9mqIGhcanHUgc5AXYKD5Kno=
X-Received: by 2002:a05:6902:2010:b0:de6:4ff:3164 with SMTP id
 dh16-20020a056902201000b00de604ff3164mr13494453ybb.36.1715017947429; Mon, 06
 May 2024 10:52:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
 <2024050436-conceded-idealness-d2c5@gregkh> <CAOQ4uxhcFSPhnAfDxm-GQ8i-NmDonzLAq5npMh84EZxxr=qhjQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhcFSPhnAfDxm-GQ8i-NmDonzLAq5npMh84EZxxr=qhjQ@mail.gmail.com>
From: Leah Rumancik <leah.rumancik@gmail.com>
Date: Mon, 6 May 2024 10:52:16 -0700
Message-ID: <CACzhbgSNe5amnMPEz8AYu3Z=qZRyKLFDvOtA_9wFGW9Bh-jg+g@mail.gmail.com>
Subject: Re: [PATCH 6.1 01/24] xfs: write page faults in iomap are not
 buffered writes
To: Amir Goldstein <amir73il@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	linux-xfs@vger.kernel.org, chandan.babu@oracle.com, fred@cloudflare.com, 
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ah my bad, I'll make sure to explicitly mention its been ACK'd by
linux-xfs in the future.

Will send out a MAINTAINERS file patch as well.

Thanks,
Leah


On Sat, May 4, 2024 at 11:17=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Sat, May 4, 2024 at 12:16=E2=80=AFPM Greg KH <gregkh@linuxfoundation.o=
rg> wrote:
> >
> > On Wed, May 01, 2024 at 11:40:49AM -0700, Leah Rumancik wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > [ Upstream commit 118e021b4b66f758f8e8f21dc0e5e0a4c721e69e ]
> >
> > Is this series "ok" to take?  I've lost track of who we should be takin=
g
> > xfs stable patches from these days...
> >
>
> Yes, because it was posted to xfs list and acked by Darrick:
> https://lore.kernel.org/linux-xfs/20240426231407.GQ360919@frogsfrogsfrogs=
/
>
> I guess the cover letter that is missing from this series would have
> mentioned that.
>
> Anyway, how can you keep track, that is a good question.
>
> There are some tell signs that you could rely on in the future:
> 1. All the stable xfs patch series in the recent era, as this one, have b=
een
>     Acked-by: Darrick J. Wong <djwong@kernel.org>
> 2. The majority of stable xfs patches in the recent era,
>     have been posted and Signed-off-by the xfs maintainer that is
>     listed in MAINTAINER in the respective LTS kernel:
>
> $ git diff stable/linux-5.10.y -- MAINTAINERS |grep -w XFS -A 2
>  XFS FILESYSTEM
> -M: Amir Goldstein <amir73il@gmail.com>
> -M: Darrick J. Wong <djwong@kernel.org>
> amir@amir-ThinkPad-T480:~/src/linux$ git diff stable/linux-5.15.y --
> MAINTAINERS |grep -w XFS -A 2
>  XFS FILESYSTEM
> -C: irc://irc.oftc.net/xfs
> -M: Leah Rumancik <leah.rumancik@gmail.com>
> amir@amir-ThinkPad-T480:~/src/linux$ git diff stable/linux-6.1.y --
> MAINTAINERS |grep -w XFS -A 2
>  XFS FILESYSTEM
> -C: irc://irc.oftc.net/xfs
> -M: Darrick J. Wong <djwong@kernel.org>
> amir@amir-ThinkPad-T480:~/src/linux$ git diff stable/linux-6.6.y --
> MAINTAINERS |grep -w XFS -A 2
>  XFS FILESYSTEM
> -M: Catherine Hoang <catherine.hoang@oracle.com>
>  M: Chandan Babu R <chandan.babu@oracle.com>
>
> Leah,
>
> I guess a patch to MAINTAINERS for 6.1.y is in order...
>
> Thanks,
> Amir.
