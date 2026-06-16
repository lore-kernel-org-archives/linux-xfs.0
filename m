Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B406F478E50
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 17:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630784; cv=pass; b=Gqd7+Mi4tl4UJZt8OqflCm3LWH8uVXUAHlnPl8uoYVI56GG8BLx7Suf865g8AgGfDoObPQq+y8mdGJF5WOXwEFueQ6DhYhsBG8J1lFcYDyxNhalGavFbUoGARJoQ/4lqdPOcCMhMIK1lBklXaJj/twnnG3ho7bcDAv4EkNmnFmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630784; c=relaxed/simple;
	bh=bK60+35u5sVRCOWvP8FgSZ7dX+YgxPLpyqqeNvY8WcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kMfaVBywe1nCWNgd0oVJHA0Ho9J9VHuGhcEC7UJaA1gwipGAsXRvTzZ4TE5R8IzT9Sr7uTjQLJ4Zayp11i8Fx293YqNU7d8yn78qBXKh/WJsbhbV5yFgoH1ya17fFDtVY8+n2CKnkb2Dt2q0EBQwpdJ87bZ5WLKl9exdWseAftM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ze34NRz1; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ze34NRz1"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bed2195323cso743986866b.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 10:26:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781630781; cv=none;
        d=google.com; s=arc-20240605;
        b=kxWVhkHwTC7eq/sAhJM+MeuwUECYrtc1JeGq8z8gQRDbb4kaQLvOZ2GBwNUt/y0D9N
         kIAkeyyrMWTo/kdLs7cb8Wn0Dg6tDFSBqRcGrV+mbrzy49L8j+OrWnIi2H6GY7PtDkoC
         IML+2F/fN1Ykjzs9t7syOumJFZ/iACnzSuVYl6yOZ8EdKhTX0NlMnijmdmXlK0Hu69IS
         0ZP34H4RkBbgG11P0eSYIUoJaAbkKEhjwDZcdCSRAVU9GLmJLiF+Uc8Ib3ga8fhiOpJ8
         RILRlkP4Y2EsvdaAn9wFcV1xym95femCXLvkHqnUv/uV4Tuujd54UycY9mm0sti4WOD4
         uT4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bK60+35u5sVRCOWvP8FgSZ7dX+YgxPLpyqqeNvY8WcM=;
        fh=F1Ry92FBK9y5YC8VwO5wVKPoHv73PXqBNfNg9jUxCZw=;
        b=ASaSScpE/VleTgu7DUUpFYcFWRmfnk7QnrVoA/xUj2YcqroN6qby6RqudZSrx7q0lD
         NYX+e5LoFuLjYcIVEche9fWWz2inTUetXCFaSp/aHTzeuG5Wr4c8NspDTINM/fVrcyUW
         naPZHaXXluDuOHZ2eWcpOTP/VLBp1jt5koltWvslbFmbr6o8dok8zT/MAxif2XRpLlCk
         7LHeo6d8clUHMn/ECpQCHh4+mZbNBiByXawx72miwXmGvhu8ZjTRaBm2L5LmSPX+qH71
         yVA7rm4jLbOciOocxMSOS33DgdUUPJprcz2r3nj9ZlicmlGPZgSwg8qG6TjoQmw2Od1x
         z25g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781630781; x=1782235581; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bK60+35u5sVRCOWvP8FgSZ7dX+YgxPLpyqqeNvY8WcM=;
        b=Ze34NRz1VnCdeaYHx8BPAtd0fPvqQ592vlKs03OTtBxOHS0p+J1BMb5ouEV0NiO3s5
         GfbqAK0jQ1do2YDUIA9X1xIEnbGbBNYAGSGSmmHWW6p+2kG1lm4lvxSBiI2P5fZMr5P5
         c0vxUVz42QRFzgaloBqwbwc4bGQlTBm6fXsYtS9PX/6SJcc1fAM+FuEchMd0JVm2uQvy
         xrDaJYPlr3AwlRS0YdDJ/MdA2xAbyCTFGDNsV3Mg0Gs4wrPuMXlHSgPiferWS/8syqFn
         x+ibd2xVgM2VyAATqPlsfr0+FaNtcwarowweFn38pQG39AsOuN/oRBJgas67jsUlKJ2Y
         KQDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781630781; x=1782235581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bK60+35u5sVRCOWvP8FgSZ7dX+YgxPLpyqqeNvY8WcM=;
        b=mFkmpzVptZ6g1uQAE+1/9/8WQ4F5RIJVI0IV9wdgTbteNMJIEH7QGvGZnDBsXFojQI
         nFiRkzY8AFTHEGOiJAVHzBzwdWHfQL2EguwIXv41VRZg2Yqzk3N4EAOkDYRDAMUlPtQO
         uflEzFzxLr+5nEPgQObEBVUaCP91aVIJsbfdzqdRpNZp0WNaXvKX1hvkBCPt8+uqsgX1
         yIa0K7Gsoxs6ayx54O45QqEYG+8+iKM+zQk802hSt8Ebui4Hi40QmVBC4JmimlwF58Gq
         6y47oyV/nblQXaKkVvTDQJjJSU17pX+FeaOCjV/VV/wnkjxGjZ7ynddgd2GtFkCg4mdP
         Lbfw==
X-Forwarded-Encrypted: i=1; AFNElJ8mcvuu03qDj0cqFEzHshiI6NPCUC15djKDY6tQFZji24Xk39a+2rAAs0WdLbYO+HIjjgj6zef57BE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjVv7ATlPFUPIIbt3SBEUkrYcdTGkcI+kI5F48FgKD86LhxipI
	rMTnJy9uhgQ2/1IJY8BRIERCPncrr1vXSOSrP/i/OTqGK6AhsURj2VVKFhtOpzRptMlI7/q7KX3
	6/VDwWK6b5BsiVEBp68NaDi+UmJ/LXuY=
X-Gm-Gg: Acq92OFs0NeBhbZN9blEbBUJ2wbRPRFsz3Vrd26Kay+EGA2BW3rUYirPY7Sr9PE5dJA
	4eKqHO1FG59GHgXRQgHtA/2LaqAyEiaJUqnLveYOkCDyJkUozFzrZGyota5efentBlvdsGflSt3
	G8LjRHYByc8YusPX3a5ur+M6Is5C4eiKq4SDiTecFfz8S1zGvO2TMGX7f7PKbNgvB8rfQ1qXl0i
	Xzd7ur+83xi64z9eSlaoreLf93bu+taNTpUx6y5JxnuRYGZp7JkAYkuNYloQ5X3EszTpcdOg5h7
	eikqnsmZ2aQic+LDa/SMPMrSn5KHlDrNhU4b6mi1+32BsRHexdCGMo9MjYvXg3DPBz1NG1dhswC
	Vf11NjyP5ft+C4xkY34zMRBa3Dv+EIjLlT2MT
X-Received: by 2002:a17:907:741:b0:bfe:ed06:565f with SMTP id
 a640c23a62f3a-c05a591069amr40389766b.52.1781630780974; Tue, 16 Jun 2026
 10:26:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250322143418.216654-1-pchelkin@ispras.ru> <aisAxyXVxf4wql2u@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260612233110.2-1-sashal@kernel.org> <ajBQPNuKCruxhkXX@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajD3Gb-vQkGU0N6b@nidhogg.toxiclabs.cc> <ajFQPY2m2A6ltvTH@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajFabPtI8UGfkyix@nidhogg.toxiclabs.cc>
In-Reply-To: <ajFabPtI8UGfkyix@nidhogg.toxiclabs.cc>
From: Leah Rumancik <leah.rumancik@gmail.com>
Date: Tue, 16 Jun 2026 10:26:08 -0700
X-Gm-Features: AVVi8CfS3ONFPuCMea8gmdSN-_pkFprQUMtGX9P4DftlzqFTx6aNlYFAra-1gXI
Message-ID: <CACzhbgS59uCYhjX80__+nPjEx=N8mKUsYyFS1+aRDpMA-b-VXQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 0/4] fix kernel crash for xfs/235 test
To: Carlos Maiolino <cem@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, Sasha Levin <sashal@kernel.org>, 
	Fedor Pchelkin <pchelkin@ispras.ru>, stable@vger.kernel.org, xfs-stable@lists.linux.dev, 
	"Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Catherine Hoang <catherine.hoang@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lvc-project@linuxtesting.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have changed teams so I no longer work on kernel and I don't believe
my xfs maintenance work was backfilled ;(

On Tue, Jun 16, 2026 at 7:19=E2=80=AFAM Carlos Maiolino <cem@kernel.org> wr=
ote:
>
> On Tue, Jun 16, 2026 at 09:31:41AM -0400, Hamza Mahfooz wrote:
> > Cc: linux-xfs@vger.kernel.org
> >
> > On Tue, Jun 16, 2026 at 09:13:45AM +0200, Carlos Maiolino wrote:
> > > On Mon, Jun 15, 2026 at 03:19:24PM -0400, Hamza Mahfooz wrote:
> > > > Cc: Carlos Maiolino <cem@kernel.org>
> > >
> > > FWIW I don't maintain the stable trees I really don't have time for
> > > that. Darrick/Leah have been doing a best effort case for that, but
> > > again, this is mostly a best effort so we shouldn't expect them to be
> > > looking/picking up every single possible patch suggested for stable.
> > >
> >
> > Now that you mention it, the xfs-stable mailing list seems to be pretty
> > much dead (i.e. the last time fixes from it were merged into stable was
> > almost a year ago). I guess no one is really working on it anymore?
>
> IIRC Darrick started it, I personally never worked on it, but I didn't
> follow the evolution there.
>
> >
> > > >
> > > > On Fri, Jun 12, 2026 at 08:20:34PM -0400, Sasha Levin wrote:
> > > > > On Wed, Jun 11, 2026 at 02:39:03PM -0400, Hamza Mahfooz wrote:
> > > > > > Any idea what happened to this series? It resolves an issue tha=
t I've
> > > > > > hit in a production environment FWIW.
> > > > > >
> > > > > > Series is:
> > > > > >
> > > > > > Tested-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> > > > >
> > > > > Thanks for the nudge, and thanks Fedor for putting the backport t=
ogether.
> > > > >
> > > > > We generally don't take XFS backports without a maintainer signin=
g off on them,
> > > > > so right now we're waiting for one to do so :)
> > > > >
> > > > > --
> > > > > Thanks,
> > > > > Sasha
