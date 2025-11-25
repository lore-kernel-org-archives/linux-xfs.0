Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB32B1EB5E1;
	Tue, 25 Nov 2025 13:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764075683; cv=none; b=kuIMYC5AqAcrdvf7XVcjfrlu8klGb5SQupWyFWXWL7l5W9DAs1hx9NbiUsDz50k0ApNsW80Mew6wzIRNqN0gE6sDYpj58isIOL48CIW7+9xHoGqkAVn9l86wb0hGo5NpfQCQPnhAHyvaXFPG20cnwxk4SI23Yj8OpHdu77/HnN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764075683; c=relaxed/simple;
	bh=k9GPEt1BgMCGYXIeiJfWjS0rSoQFhaodLdNeKFxuBmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvRqEm2G8k7YtwgOON0WV1BL/9/n0WEW0cjNmYAbtRSzFeaTZtsNC1Zmd3Vz2azy3wgjMnEbnu5e6b7qqHOBlXLELjHIRpnxS3PTSjgz9yWsiMosB8O4oMEEISfnbAqF4d443nwM2d1Xs95mn+Iwt9zlllEB87Mk6ju7dVwSOfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEabpxAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEabpxAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B09C4CEF1;
	Tue, 25 Nov 2025 13:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764075682;
	bh=k9GPEt1BgMCGYXIeiJfWjS0rSoQFhaodLdNeKFxuBmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NEabpxAC8Ickem5nQaRMcEUePp1sNSEyVOF7QsfURZIOJ6KBAl9rKMEMSGqLHnhEu
	 Fq9luDpVujDp3Wt3/d+ocRGounGq01BD3lbCNyv8ytQpnADvgu3Gy2rinc8/mkYLPl
	 pY1hJwy9ay6xfakD4KsSCuffP3+TQBc3Mnd9VxEaZMBNt2Sa/LB1TdrQSFwgpUEYDw
	 t98LVExZPScskw6YNLQsu1/RvwEbuP28B/uZ50WSN4L5dTN20iauejfGefRHz18ewM
	 JGq+ghFS9y1HQnKpZdzSmnTAwFL2wCk68KAOy+Dlc/f/sKFoLsLEwO5W17XPWJ6C4r
	 eB0ZEnM+K41Tg==
Date: Tue, 25 Nov 2025 14:01:15 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: "zlang@kernel.org" <zlang@kernel.org>, hch <hch@lst.de>, 
	Hans Holmberg <Hans.Holmberg@wdc.com>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Message-ID: <fxqupigsyfbluueh3g3g7prpu7ekikrtuu2ju2bqnkrkzqjwqb@z24rmkb44ztg>
References: <20251120160901.63810-1-cem@kernel.org>
 <20251120160901.63810-3-cem@kernel.org>
 <EffPQB_WQabsgl7V1GQULuAp9QQGB7KoH0wN5tHOvQUWRriHZorc1NPnsGnKEV1obcisN1kjuXM0KzubUhxk5Q==@protonmail.internalid>
 <9f6b4f20-9d71-49a5-a313-f860b3e8a4e3@wdc.com>
 <ba3tbnjq2dernii2n6leyc6z76lcezsjemomtm54mrbm2xcnz5@kx3qp3qgrtqe>
 <5gaSJMJwj8QaO5GNNVUWMqAJW0nU7UyjJhEYQfFJH32H2R0B9U53QPeIkh6XDMYylaiYnOE25rA7RMfOkATQtQ==@protonmail.internalid>
 <becfce20-3948-40db-bdb5-7dc64438da26@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <becfce20-3948-40db-bdb5-7dc64438da26@wdc.com>

On Mon, Nov 24, 2025 at 05:31:03PM +0000, Johannes Thumshirn wrote:
> On 11/24/25 4:27 PM, Carlos Maiolino wrote:
> > On Fri, Nov 21, 2025 at 06:51:31AM +0000, Johannes Thumshirn wrote:
> >> On 11/20/25 5:09 PM, cem@kernel.org wrote:
> >>> From: Carlos Maiolino <cem@kernel.org>
> >>>
> >>> Add a regression test for initializing zoned block devices with
> >>> sequential zones with a capacity smaller than the conventional
> >>> zones capacity.
> >>
> >> Hi Carlos,
> >>
> >> Two quick questions:
> >>
> >> 1) Is there a specific reason this is a xfs only test? I think checking
> >> this on btrfs and f2fs would make sense as well, like with generic/781.
> > I wrote this mostly as a regression test for xfs's mkfs, but yeah, I don't
> > think there is any reason for this to be xfs-specific.
> >
> >> 2)  I would also mount the FS and perform some IO on it.
> > I'm not sure about this. Do you have any purpose in mind? This is
> > specifically to test mkfs is able to properly format the filesystem, not
> > to try the kernel module per-se.
> > One could argue that something 'could' go wrong in the mkfs that might
> > be found out only via some IO, but that would require much more than
> > just 'some IO'.
> 
> 
> Yep that's what I had in mind.
> 
> 
> > I do think a mount/unmount might add some value to the test, but I fail
> > to see why issuing a random amount of I/O would prove the correctness of
> > mkfs properly dealing with small capacities.
> 
> 
> fstests does a fsck after each test, doesn't it? So that should be
> sufficient as well.
> 

I particularly don't agree with mounting/unmounting the FS here, that
extends the test to more than it is supposed to test, i.e. ensuring mkfs
can initialize the filesystem.
Although I agree running fsck on it to certify nothing obviously wrong
happened with mkfs.

I think I've got another bug though which I started to investigate a few
minutes ago. Reason why I think we should split mkfs and mount/unmount
testing into two different tests.

Anyway, I'll see what's going on an update this test appropriately for a
new version.

Thanks for the reviews.
