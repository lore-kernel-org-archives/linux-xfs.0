Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5AC196
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 00:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713313600; cv=none; b=nYFp7J3Hao7ccalHeHQ/gSwA/9hwgrNC3Wy/4Lc6NoJgIMWmVaZlDkmLr2+43GAPGmPkgPhb5tkYkJyxvV09M/0Mvv0gZl0FyjaTjvOr31Fqx29jROLGakh8GlYiXJoUg3Er6YwTMJxeRO3+ye76z1ue2IVCX7nbODa5GuWOzgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713313600; c=relaxed/simple;
	bh=s9d4im8PANfrWfjQjrUhHSg/z5FDANmBNWZx5DCaziw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u897lGQ5TcmpqDeh8HY+aIUiSonafpD1LmGBISNhELg2KfvFzR35w6L66NrpQVvxgjPcBVXyj5BHhpmmNI58wKYzMigtZ4sb1mQzbib+Pjt0n6dLb152lGyL5RuLCA/ZWjHcoNFmk8A05ppGl2I0nZk7nS2HNpkzMOgoHoafCec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b9dIIbzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b9dIIbzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69F8C113CE;
	Wed, 17 Apr 2024 00:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713313599;
	bh=s9d4im8PANfrWfjQjrUhHSg/z5FDANmBNWZx5DCaziw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b9dIIbznG/pDs2BpdVf6ojnEdNw9mSwsxqKkl2DKjyn7nulLpE228PEVGXvWjYyVs
	 PU+IdZ2kHNu0naiSadbup7pnXzbOLb7YqnSTmqLu3kZJk3IybJhP8ezxI9UkbN1l4Y
	 BOSiYaAfRjv5ckIONWnnyRD7CtG7hmm22AgCrxw2FzrJakpHx2j1S45VWHqRBIB0Ub
	 WdPqGA07cpOvqjaRqtK1wVLf8KI/xcBGrA9jOEd3Smkh6ETab3nfC7t7Ro9uNqUd6V
	 XAnBJI9mFxlCztpZf/ZFauRjK/6n8I5OT6jFz8OczGyYErgQ+/T3tw4d3rhVoYNUQB
	 jPPlcX1IHWDkA==
Date: Tue, 16 Apr 2024 17:26:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-xfs.ykg@rutile.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: Question about using reflink and realtime features on the same
 filesystem
Message-ID: <20240417002639.GJ11948@frogsfrogsfrogs>
References: <0101018ee939dd0d-f4f89d16-04ff-44ae-97f6-541a30117a4d-000000@us-west-2.amazonses.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0101018ee939dd0d-f4f89d16-04ff-44ae-97f6-541a30117a4d-000000@us-west-2.amazonses.com>

On Tue, Apr 16, 2024 at 11:24:27PM +0000, linux-xfs.ykg@rutile.org wrote:
> Greetings,
> 
> I was attempting to use mkfs.xfs on Linux Mint 21 (kernel 6.5.0, xfsprogs
> 5.13.0) and ran into an error trying to use realtime and reflink features on
> the same filesystem. Is there anything I'm doing wrong, or is this
> combination simply not supported on the same filesystem?
> 
> The exact command I ran was:
> mkfs.xfs -N -r rtdev=/dev/sda1,extsize=1048576 -m reflink=1 /dev/sda2
> 
> Which returned with:
> reflink not supported with realtime devices
> 
> Just to be clear - I didn't expect to be able to use reflinking on realtime
> files (*), but I did expect to be able to have realtime files and reflinked
> non-realtime files supported on the same filesystem. With my limited
> knowledge of the inner workings of XFS, those two features _seem_ like they
> could both work together as long as they are used on different inodes. Is
> this not the case?

It's not supported, currently.  Patches have been out for review since
2020 but have not moved forward due to prioritization and backlog issues.
Sorry about that. :(

https://lore.kernel.org/linux-xfs/160945477567.2833676.4112646582104319587.stgit@magnolia/

--D

> Thanks,
> Reed Wilson
> 
> 
> 
> (*) I noticed that there were recent commits for reflinking realtime files,
> but that's not really what I was looking for
> 
> 
