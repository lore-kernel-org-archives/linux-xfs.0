Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96AA3BB4A
	for <linux-xfs@vger.kernel.org>; Sat, 25 Oct 2025 07:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761376791; cv=none; b=EFzRjDPepTXDOOlsGCWyGcw0GLwvLrwTfUJwhaXsJtWde1aw6g1UZr52TZUKZRE0TCAB4/6KIPURJIoz5xwdW+ssyLFIaHbKHMNpJCGvoRU7aCxqIF5o1fZhpv9+dUuQPXyevHWsYkhCYE79vg4WoHvFqzGGXlyieTaNpG0ZdAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761376791; c=relaxed/simple;
	bh=6D8fINuKahSn/sAi3JHwWnkoP2nsOan8pYQRhQVBbN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jg/IK6mstjVX+rkCRWaU4/wiw2RJDPdMxVPkjkkP38FznVUGKW9a/yw6l9PQC4+isEZPf8IY8l22jWK/Vy9OhYmSOKf5fgFA+ba870A8fw7U+2ZrmupQRVbjKsx1yO6idEyx6OIltIXhgwipp/KDv6voQCKTaGc2d67A6cN/heQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ToPyWiV0; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ToPyWiV0"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47117f92e32so25869195e9.1
        for <linux-xfs@vger.kernel.org>; Sat, 25 Oct 2025 00:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761376788; x=1761981588; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6IFfVys3GuE+pRFTFTXpJFMaFbUNYePrdEwH7CfBK3o=;
        b=ToPyWiV0SMEE3vbaTNuzFtU1qZ8QErU99Y6n5iGBKYvva9fEb7Z/mNMuJzhkwbm22q
         sSBvvPbIyCa+kVf2lH3O9s56RtcP61Iyq7CFtG7LtGuW3T0mYW9BJ5eYPhXLC1iIzKm1
         R7nxd5XTXIUbDt6/3NSa7nPbg9iBkETVvTyiP31Mqcf24Ls93aXWyHXJG2RB19HRK1DU
         txkzej3fOuCFPDR18L02DNv1Yig/Eg5mvmW2T82uojkE0lH5l311yhrwMJaGclhuQmUu
         V1bQJz4hY+Y1ORDkkX9mjWUPTGnIsslheGTUnktWuzPhy0tDxyrs9aNrDyCDei4Xy04a
         x73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761376788; x=1761981588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6IFfVys3GuE+pRFTFTXpJFMaFbUNYePrdEwH7CfBK3o=;
        b=Gwwl+HkD+d4El/xNJEpxh7eJTv9SJDI+2T0qov+HTdPhwF0qnbBc52Y4jqGd7O9szg
         s9brLtNc1YhgwfxKfHRRCWhjY91OH7I62Cepj8b+9QZCRYQdQ2vnmr+LmnZTMrhkTOuA
         A7+EIPl3uKrfLjABmpuBv0OrPrY3M8rTMbhESNSBSRMG7158VKWcbUCpJ1ni0WPfP83s
         YxjgjNTmEzav6o5WEfVUVJM3BFi2nVQO7uM3wwc70ItGSfzdgppmNIClENDjTCzryPAp
         7VPPwrFFddu+sykmxvcQK0/T/uN4uW4ihtArBq8P081F93/b+m/dKhBFEFu47T56wN2x
         CSwg==
X-Gm-Message-State: AOJu0YwhxHN8Qtg72XDZAhdCxxLpFO9r6hxKngjaBSp0wAVEpzyltdJL
	QBWVsFe7rO23RyBHkX9sFJ3JfkvbWmnEUliVAfWRMxgQbqEdN3ZjzPO6gDc1cA==
X-Gm-Gg: ASbGnctuWY+HuZOMSWJayhMRO1gtKwjfE+3tkaOo6FAEMGx8vQtnv7Cq5vuWCOtcU3s
	FTXWLDgcPOm6oKVuC2a7gz6gdkYSh+KCg7cPhEyv1jnURseMcYEGJBlbUzPCIEiS7cgH0BO08Hd
	1ENc9CP9DQT8g6fB9LelO7N7LVVdJ16Nk/aCd6GjdnJS4ve170zwAAFz0SaVLOuOzrOpLSJUK3C
	IGp+pP1EhZILunBx6xJJN344Oo9Yri0F5gNNTCsR28YDODPqXQUF08i0/7tLIQEb5JV1Y2ZG27e
	IylrZjK/tk8Lny3ol/aXDAaogSA98Mm4W8xM+jB+AmX660jOL+6w8+SPrCbXD5EZieOCjm2CFZe
	VUXQsz2Q7FhE4uJWuiBexhdlUBoN118bRPYNaRCUF0+/2ZqkWX3UtahNEAzlKYgDM+Wt5TSKswy
	k3npTDQwY33anKpLDlPaMHGOiCyfvXrOV4Ynl4+UCZEncZ208X
X-Google-Smtp-Source: AGHT+IFQQrcboMgkgtg5sbRYopXLhYQD6H8I5cE+AYM5G1GTzFc9HPZ7gEtVlJHaVnChKXydzyNknQ==
X-Received: by 2002:a05:600c:828a:b0:46e:39e1:fc3c with SMTP id 5b1f17b1804b1-4711787617amr221456185e9.5.1761376787885;
        Sat, 25 Oct 2025 00:19:47 -0700 (PDT)
Received: from f13 ([2a01:e11:3:1ff0:9dcd:df29:3054:53fe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd4924a4sm19605915e9.7.2025.10.25.00.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 00:19:47 -0700 (PDT)
Date: Sat, 25 Oct 2025 09:19:45 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v1] proto: fix file descriptor leak
Message-ID: <6ko4ay7ukugftkbgtpsyf7brzpoiuzpubhmpzmzdc5ayvqpbat@fkapik55vnis>
References: <20251024193649.302984-1-luca.dimaio1@gmail.com>
 <20251024213511.GK4015566@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024213511.GK4015566@frogsfrogsfrogs>

On Fri, Oct 24, 2025 at 02:35:11PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 24, 2025 at 09:36:48PM +0200, Luca Di Maio wrote:
> > fix leak of pathfd introduced in commit 8a4ea72724930cfe262ccda03028264e1a81b145
> >
> > Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
>
> A few points:
>
> First, everyone makes mistakes, don't worry about it. :)
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks Darrick :)

> Second, the canonical format for kernel-ish formats is most probably
> something like:
>
> Cc: <linux-xfs@vger.kernel.org> # v6.17.0
> Fixes: 8a4ea72724930c ("proto: add ability to populate a filesystem from a directory")
>
> but this is xfsprogs, so there isn't any formally established
> convention aside from "Darrick copies the kernel style and the
> complaining hasn't been harsh enough for him to stop".
>

If it's needed I can re-rubmit with the new commit message, let me know

Thanks
L.

>
> > ---
> >  mkfs/proto.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/mkfs/proto.c b/mkfs/proto.c
> > index 2b29240d..1a7b3586 100644
> > --- a/mkfs/proto.c
> > +++ b/mkfs/proto.c
> > @@ -1772,6 +1772,7 @@ handle_direntry(
> >  	create_nondir_inode(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
> >  			    rdev, fd, fname);
> >  out:
> > +	close(pathfd);
> >  	/* Reset path_buf to original */
> >  	path_buf[path_len] = '\0';
> >  }
> > --
> > 2.51.0
