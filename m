Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4FE192D6B
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 15:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753888848; cv=none; b=MakNHUk8y5Nq60kiGy2rS/vM1ndmsyfKnSuirxeDC0rkgA60RUceRMw9opxazEUiOQvtlzKgz+3eHD6hGmns8JFZYuXsb7Wv8ZXJC7MKlDc8rZlLYKLOrUEdEUlPP/wSO7ojTsV1/iHdmAG/QG/sFOMrUVywJkY53wTmXYhX1b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753888848; c=relaxed/simple;
	bh=aC9MKmQP5aw/rPmCr01SJ6abzuB5n7n6D81MEoMNgF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PEQtyhtEw4vaLJMskFn4MzItGoGd3RANzs4z1Ud52y05yDwsn6SlUVN4Itk+OvH7yy8iLA97Jpt2AaPVJNmFsqKeMZv8zBbN6QYZYXdeWH62sXUWNOgJYlQdOXffLWSpOjb3RYEqxlbCOrvKZSOy1CY81AfXFgymbnTw737SvfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NQiEuPEC; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NQiEuPEC"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45892deb246so5760345e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 08:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753888845; x=1754493645; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1XtyRL2ThXPSlQFuPJPePTsL6xsyXBWwvv58Q/JjM78=;
        b=NQiEuPECIGxABRTwD1OxdpeEUuc0IiLnAfJWNFBADgcrIXH5M87hyIRBTIVFZqqwrr
         WlG1zBWRDkA1kLyv7R+T5uwnBdJouGgcxGjsdDl8TrOglWp1nVl8ukTLjrPS1BAZkOWE
         fBNstsNiy8cS9FzWWnxw1DvaXi+z+Y6vRcjsOEQgpde4V9mmsG0JC9FTzEJzu6ASAL1f
         ZuBAqamRZUnZQXB/KbyrEjzMam9mypFaB77AFbueZEUkJsb5N3JQYcW+G7SwIOTiSAjk
         MEbc9JNO9rpe/vo4lamqd454Ejy/5P0VpnETWenIgvwl2dcPpG5sezaiP9lbwRpIIzgN
         XD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753888845; x=1754493645;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1XtyRL2ThXPSlQFuPJPePTsL6xsyXBWwvv58Q/JjM78=;
        b=ZDM6Rdm12AoAuLSiFfVOvjIUV1L9wExgaYNZs74xlXPqePmRsnQIBgLDozwaRxVsvd
         kGMUhpPOad9JXhPzMhNVvhuDg30rHsWNQG2erPJPlG53ZEMERdiNegJ157M3XOETdJ9d
         bqQLRqlDKxBhB2gVgtc7oCgwT6jR3Ze3oQi/ML4mn3hX/vOz3VRMKhWvYRUoKbwjjL+2
         a68QNdmhQZNQAa+eUDmZRkqUuryUT8XhG17IOIi4riqiTaSS0kJMJwhPePw24FPEIOc0
         Pcf2r+0gexSDCUoyYCS3mkPpmvMD9WnVdKPfMbLHyRiQU9jyu7jcncIaAUHhpEwsJbx6
         5hiQ==
X-Gm-Message-State: AOJu0Yy/yLfb00dg0Y7KXUbzHFWwsJfcK+u3Nl691tBwdZ+gEfDEGabw
	ZFQRgmxQIKxI0HeFd1YFGgK8B/EbCO8RVlIaf/rfoFgGhz0d2T6/+ot3
X-Gm-Gg: ASbGncvFzrtbsilqDq/i5o4G1h55sTl1L2sR/ENuORfqZPGrEZVpVRD77ArKFgglMyJ
	9o0kgM9vf3KcdlNzOO5oxCjJ2dAdSQOyvDoG6020BnWXN+EW8+5IuaSo2qKZ5AAsckiqudvB08O
	+dEiRAc/H3xKjZTMlhd8+C0tOnbjQoQlyWNrYtRgr/pb/n/mR5nY39vFUww3Cb3WFVUdtQjcqUP
	aDqtSUJYA4Q0oYkn1ZGZgjkPVCMPkwHuZdjB+HskydPOcyxxB2NJOoYYstoR6j7GHKa3J6F7RYz
	kGnVz5cLyBayzxDCC+PmppmAzjD5dxhjfpfZxX17lw8SbR6CLwAhlHbG+mtApVm8xRBwDT5fzO3
	8FYL99EkYR2aeHk/vPY2QQHfpr98AgpsP80Gsj+nLEW72PKVgjNyiOK8XbJA=
X-Google-Smtp-Source: AGHT+IGl2UeZtS2BdKItiYBUIZoYyglnHIWGGWho8ZNe7k+4gJ/VLSM/HnAnkDOqd5zlG7yw9TNx2Q==
X-Received: by 2002:a05:600c:3e0b:b0:456:1e5a:8879 with SMTP id 5b1f17b1804b1-45892b9c21fmr42031935e9.9.1753888845047;
        Wed, 30 Jul 2025 08:20:45 -0700 (PDT)
Received: from framework13 (93-44-110-195.ip96.fastwebnet.it. [93.44.110.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589537792dsm31157185e9.13.2025.07.30.08.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 08:20:44 -0700 (PDT)
Date: Wed, 30 Jul 2025 17:20:42 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v11 1/1] proto: add ability to populate a filesystem from
 a directory
Message-ID: <an4uufrp4vk4bqs4zpvver7sodqn3i2gtx5rjp5336jlylmmhk@bchzcckwdlfr>
References: <20250728152919.654513-2-luca.dimaio1@gmail.com>
 <20250728152919.654513-4-luca.dimaio1@gmail.com>
 <20250729214322.GH2672049@frogsfrogsfrogs>
 <bowzj7lobz6tv73swiauishctrryozcwqmqyeqck65o2qjyt5v@vufmu67nwlkc>
 <20250730150409.GG2672070@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730150409.GG2672070@frogsfrogsfrogs>

On Wed, Jul 30, 2025 at 08:04:09AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 30, 2025 at 04:40:39PM +0200, Luca Di Maio wrote:
> > Thanks Darrick for the review!
> > Sorry again for this indentation mess, I'm going to basically align all
> > function arguments and all the top-function declarations
> > I was a bit confused because elsewhere in the code is not like that so
> > it's a bit difficult to infere
> >
> > Offtopic: maybe we could also introduce an editorconfig setup? so that
> > all various editors will be correctly set to see the tabs/spaces as
> > needed (https://editorconfig.org/)
>
> Hrmm, that /would/ be useful.
>

Nice, will try to put something together for a future patch

> > Back on topic:
> >
> > On Tue, Jul 29, 2025 at 02:43:22PM -0700, Darrick J. Wong wrote:
>
> <snipping>
>
> > > > +	if (!S_ISSOCK(file_stat.st_mode) &&
> > > > +	    !S_ISLNK(file_stat.st_mode)  &&
> > > > +	    !S_ISFIFO(file_stat.st_mode)) {
> > > > +		close(fd);
> > > > +		fd = openat(pathfd, entry->d_name,
> > > > +			    O_NOFOLLOW | O_RDONLY | O_NOATIME);
> > >
> > > Just out of curiosity, does O_NOATIME not work in the previous openat?
>
> [narrator: it doesn't]
>
> > Actually on my test setup (mainly using docker/podman to test), opening
> > with and without O_NOATIME when using O_PATH, does not change accesstime
> > checking with `stat`, but also it works if I add it.
> > As a precautionary measure (not sure if podman/docker is messing with
> > noatime) I'll add it, as it seems to work correctly.
>
> On second thought I think you might leave the double opens because
> O_NOATIME is only allowed if the current user owns source file, or has
> CAP_FOWNER.  If you're running mkfs as an unprivileged user trying to
> capture a rootfs (with uid 0 files) then O_NOATIME won't be allowed.
>
> Maybe something along the lines of:
>
> 	/*
> 	 * Try to open the source file noatime to avoid a flood of
> 	 * writes to the source fs, but we can fall back to plain
> 	 * readonly mode if we don't have enough permission.
> 	 */
> 	fd = openat(pathfd, entry->d_name, O_NOFOLLOW | O_RDONLY | O_NOATIME);
> 	if (fd < 0)
> 		fd = openat(pathfd, entry->d_name, O_NOFOLLOW | O_RDONLY);
> 	if (fd < 0)
> 		/* whine and exit */
>
> Just to see if you can open the source file without touching atime?
>
> --D

Right, will do like this, didn't think about rootless/unprivileged mkfs

L.
