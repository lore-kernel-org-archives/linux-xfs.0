Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACAA18AE3
	for <linux-xfs@vger.kernel.org>; Sat,  4 Jul 2026 00:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783123651; cv=pass; b=PKl05S8FjemyTsu5bVxb0kWFT3wy9jP4zy0FCULeqVQFxoJoUMpO4Kv0AwkAzi4jqlFtXHmLC5p4AHvCmt+kC0FUsRfDzwKSu0c7hZC8+c1SZZKxTiVOhBsirCHQeEklTRlKCXIPq8DMdgcV4/7xfO/phYS9Shy2ZSZgUk3BSC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783123651; c=relaxed/simple;
	bh=vDHlcWmL4Cd5UT42ugQTjRnKNbXE5dy2ocFAsQoM96Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LD72R5dNcYbvQvGNyUWFSlZy8w+vPXzyEERDZDpCZWU89J9xzBFz773aNWu92FTbA5Y91A05WUqv9N5bAPcIF3W2aqKkLQWbLFvLtb1qxhub41QWuh1I/YBlJDTQfgzygnGVC+1un5ArVc+qLzyrou9A4aMhHhqu96zD38dgGgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ki+A0bbK; arc=pass smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ki+A0bbK"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4703bc0a99aso600244f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jul 2026 17:07:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783123648; cv=none;
        d=google.com; s=arc-20260327;
        b=i+DT2c80AJYb5aL2Zc8akxAQGRCybVOGelHQy+N6JFRybBGQvHlk4CWW1aPxy8CWF4
         AGtS9LR4hxzSzoGeEgzmpyD0t4y3jVWpr8WEZtXMW43slnhz06KlV5eE3/O6ZvyZjZW9
         e4v7PKz8/jamvRh5i5Vv2oKEZnZ703ouMNB6YrA9t5+bCjtjkkh0Df4ejNvxrLCch/GW
         OuvzzvyaxWdChGJVgkMQ3QzL3aEEQ2J6nE3dX1PbWZGz6Fcw5fzjzgxWYDWuJ+lHFE1H
         /xZNFdKLwhrj3udpRaytRoGxy0On8Te6IplbSAxkxjbpbiA1RDiWL214F/ZsO2kzRNv9
         udaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vDHlcWmL4Cd5UT42ugQTjRnKNbXE5dy2ocFAsQoM96Q=;
        fh=YTc8THpYSVVzm8A6IrlZbGVx67Vv38UZtHqmuWB23mQ=;
        b=PJDJ1oVU3m9Ajg7iiAqrhpyG/E8V8CyzZyixOZZc6Ggtl7LNs4ILAEv78rL1MduHoX
         w/NkmQnNemVL4OggU5+unLhFZ/MCqfTvd+TBcssxndna2SxIQpzIsXMH//IuJex+np4G
         1O7wN/l69//PAEH4coI73bFjef/2wlFb9dA/cmUUZpZAvJWHVdUwKawuMdyDcJ07f5gc
         Kewi7UqWjtxtNb13NIn8eb07GAbvpuJx/wY4VxIs334mk2rtubjKSHrEnZZFGn2bRaTO
         hv0FaIHJYf063WUjF+OCY1P+ucbWIK2LNVEXVVaXOYU9h5MRGmbN2oC5Zawdm4/FB2gH
         ykww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783123648; x=1783728448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDHlcWmL4Cd5UT42ugQTjRnKNbXE5dy2ocFAsQoM96Q=;
        b=Ki+A0bbKzGZisB5V1frmhFAWaHUmml0lSbQaVT4Wc5AmhzhtZiLEbRZGydmphq8WNu
         WrbBGAVeEXZVheyQIXek9+iwrKEFyjDmDNjeQ1/NyvUuQ5dsYdUtXTjABn+tjaAB/nM+
         S0Wt95GY8YCt3jDhTRz8W7Q1099fwMbIhKWJ932bivc1pLQOIYh19ZE3SztF0jA7Ml2b
         XH+TxsMIt1sDuEMNW3dxNJALZl6oiW0wYrC4CsLSyo2jPbJpAZNQcObp88gjMG61DavX
         GCmbL0ElaaG9yqIIMsqfxzSqiMiROvFy0wb9rXwTnnpTlND5XlVL6vJf6zgLpsXYLko+
         RYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783123648; x=1783728448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vDHlcWmL4Cd5UT42ugQTjRnKNbXE5dy2ocFAsQoM96Q=;
        b=TrVqBVDBtVWS+UoVJ7mOxkL+Kkb0PP4UHhz4NGqN1tfyhD8cQEikh8Myuowip+RZAX
         ikxNKnKRa3Pd3ILwxTzbHa8X6xPAIiXUABhuqEK8vFeBWm0fnNFAgd88IXK1f4HFHZRC
         zbB/spDvw8UluU9IbuSO9YOwInHcM1j4wGaWBJvdW3FzLY687EgFl9714wX3VS8SEGXQ
         W2kHjuRdjUouGsLffuameXwh1ma4O1zBqvx3w+NF4D3ghldIbPS0m+UQt0sn7/Z/Uj0x
         R9Wxsms5dcrRsJGgUin0rAhTLDBUzyvxa2TRWwYfpUUEVgBPH8YZDWqNz0wLLUij5Jxb
         ghIg==
X-Forwarded-Encrypted: i=1; AHgh+RrQjFqGjq5uh8YjSpwmZ3uGLsWbpn08zaFi6wNxWTvdsrCkuZN1H035uKcgaul3p/DgD6civ4As+FA=@vger.kernel.org
X-Gm-Message-State: AOJu0YznHHBWx0TLWbwSlfWH14DB9f4/IpDNSipnQtWFsJBX0O1dkBjS
	25U5R2GTSc0HYXNLRvJpC+JHoeD0kIK+GjnCvm9cq2Znh9LoKbNuJknwHPtMKK7x37Exo35TEg0
	FkyHwXiBdgh3JR9LMTlIBSnsB/TtHLHI=
X-Gm-Gg: AfdE7ckY3jqihx7BH/lgoLhOvg+8Lufc5N092DpKBEzZthj2ELQEPJYTIub8kGExP/5
	fdFBuJ58xdHu5mgKj4/aWMi3RB8SsDLHHUHKmHRw6Ugb3K7FLF74op47IwpDqJ2tYuT57i43h9K
	Cduto+yKYgf4Gnrcp2iMUsEP2PKz9OxSoCR/ilm5dQsC6mSpr2KY+pYNHJ+cZNz5jbk48aC4IDl
	pAtYEeqK8/A3ZxIOE3b9sMRTAGzeljDSAaBT30rkKeyXtZGPQwlLVboNgKIRulRxz1vi6zmGZrs
	+sk7pwZhEziqeSbZprJPzRSfh89aqapiehG5PwQZqoJVZfYV9iXa
X-Received: by 2002:a5d:64c8:0:b0:472:c426:2ce9 with SMTP id
 ffacd0b85a97d-47aa9699811mr1527073f8f.12.1783123647923; Fri, 03 Jul 2026
 17:07:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-13-joannelkoong@gmail.com> <CAHc6FU76J-YYRd2B=ZPN2DMabQjkzgG9qSzbP_S1s9AsSJNh=w@mail.gmail.com>
In-Reply-To: <CAHc6FU76J-YYRd2B=ZPN2DMabQjkzgG9qSzbP_S1s9AsSJNh=w@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 3 Jul 2026 17:07:15 -0700
X-Gm-Features: AVVi8CdQdofMwGUqV4tTaAHxeI2fygjInGMJJOumzbFcOuGU31GOE644YhYA5nA
Message-ID: <CAJnrk1YmAjfSvkX5M0mu_ts_7APbp+Zfrz0KU6BMgM5fxN568g@mail.gmail.com>
Subject: Re: [PATCH v2 12/18] gfs2: convert iomap ops to ->iomap_next()
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, 
	"open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 3, 2026 at 4:45=E2=80=AFAM Andreas Gruenbacher <agruenba@redhat=
.com> wrote:
>
> Joanne,
>
> you say in the cover letter that
>
> >This series is submitted against Christian's vfs iomap tree, and is base=
d
> > on top of the current head of his tree (commit f2727952b21d1).
>
> which repository and branch is that? It's not vfs.iomap in
> git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git; I don't
> have a proper merge point.

Hi Andreas,

This is on the vfs-7.3.iomap branch [1] on the vfs tree. This was on
top of commit f2727952b21d1 ("iomap: add a separate bio_set for
iomap_split_ioend") but it looks like that branch has since been
rebased, as I don't see that commit hash there anymore. If it makes it
easier, I've pushed the changes to a github repo [2] that's on top of
v7.2-rc1 in the main linux tree. Sorry for the confusion, I'll include
a link to a pullable branch in future versions.

Thanks,
Joanne

[1] https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=3Dvf=
s-7.3.iomap
[2] https://github.com/joannekoong/linux/commits/iomap_iter_next_v2/
