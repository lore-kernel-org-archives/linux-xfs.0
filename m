Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C3A2CA9
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 04:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721621551; cv=none; b=h4FJEv3bYtVRpDum+9NRY/yhfBvorTNt5l/BmTknx4+dy7e7ky18P3HLOvabCfwnKRuSOflbqjb0Af0FK/0HiPmpvuDhLrTZoG2i9+E+5t0EkVl5mciwyzUiDHAvq2MGWxoCEsTLSHf8rfM3Ni+7nliZH6xLxsBjzSicJDMFqjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721621551; c=relaxed/simple;
	bh=Y1181kdTcALPMccU+3dflacOmMsLjbe4QINm1XHmNdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bv9XTEBl5kYNlYvi5Qp4k7+OwWTgLSiRaPpIqvyqucy7ON3L/LM8jL50IANi/31MVjAZ5si10LwVGz8p+XAGdqlLnb09WGO48Yi7vOIu4dVKXoH8XxiOcvFphwro2K87GtNpHj0AcE+Y9c4phq51HZddAdwBcSjTL0Pv4BS0DKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tcPBT9vo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tcPBT9vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F82C116B1;
	Mon, 22 Jul 2024 04:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721621550;
	bh=Y1181kdTcALPMccU+3dflacOmMsLjbe4QINm1XHmNdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tcPBT9vo8Nijli320bMQBBSX7jfaGyz4o++ydwJnHU54iEl41tI2/JHV4LYty3DGG
	 SiQvvlYDIqU/MbTykEs406ROQ5TWHIRibQ1MEf4IEO6BBE2m2QKhXf32jBwEzfzoW+
	 DOMQgMKm0zoKZBq2KUsg3ui0ZAPO+CSkxaSylO0AOdEa2Ltd1jUcuWPoDKC5K1SfKl
	 Zvcx0qCnfZpdGC5vWe8wy8Ok/dBe9BElz+erOpHoFGK+yI7PZeOs7wsQH8om46voxX
	 RyvhsYQS6syx93Qh4/O5hf2MlomxNYmNSj5zo0qLWP5vGRTWlR9cuJYVBaNAdDFDv2
	 iJ0uRu29hlgyA==
Date: Sun, 21 Jul 2024 21:12:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer services
 by default
Message-ID: <20240722041229.GM612460@frogsfrogsfrogs>
References: <20240702054419.GC23415@lst.de>
 <20240703025929.GV612460@frogsfrogsfrogs>
 <20240703043123.GD24160@lst.de>
 <20240703050154.GB612460@frogsfrogsfrogs>
 <20240709225306.GE612460@frogsfrogsfrogs>
 <20240710061838.GA25875@lst.de>
 <20240716164629.GB612460@frogsfrogsfrogs>
 <20240717045904.GA8579@lst.de>
 <20240717161546.GH612460@frogsfrogsfrogs>
 <20240717164544.GA21436@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717164544.GA21436@lst.de>

On Wed, Jul 17, 2024 at 06:45:44PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 17, 2024 at 09:15:46AM -0700, Darrick J. Wong wrote:
> > > So I think the package split makes sense no matter what we do,
> > > but I really want a per file system choice and not a global one.
> > 
> > <nod> How might we do that?
> > 
> > 1. touch $mnt/.selfheal to opt-in to online fsck?
> > 2. touch $mnt/.noselfheal to opt-out?
> > 3. attr -s system.selfheal to opt in?
> > 4. attr -s system.noselfheal to opt out?
> > 5. compat feature to opt-in
> > 6. compat feature to opt-out?
> > 7. filesystem property that we stuff in the metadir?
> > 
> > 1-2 most resemble the old /.forcefsck knob, and systemd has
> > ConditionPathExists= that we could use to turn an xfs_scrub@<path>
> > service invocation into a nop.
> > 
> > 3-4 don't clutter up the root filesystem with dotfiles, but then if we
> > ever reset the root directory then the selfheal property is lost.
> 
> All four of of them are kinda scary that the contents of the file systems
> affects policy.  Now maybe we should never chown the root directory to
> an untrusted or not fully trusted user, but..
> 
> > 5-6 might be my preferred way, but then I think I have to add a fsgeom
> > flag so that userspace can detect the selfheal preferences.
> 
> These actually sound like the most sensible to me, even if the flags
> are of course a little annoying.
> 
> > b. Adding these knobs means more userspace code to manage them.  1-4 can
> > be done easily in xfs_admin, 5-8 involve a new ioctl and io/db code.
> 
> Yeah, that's kindof the downside.
> 
> The other option would of course be some kind of global table in /etc.

You could also do:

for x in <ephemeral mountpoints>; do
	systemctl mask xfs_scrub@$(systemd-escape --path $x)
done

(Though iirc xfs_scrub_all currently treats masked services as
failures; maybe it shouldn't.)

--D
