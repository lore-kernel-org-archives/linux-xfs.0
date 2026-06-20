Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581C81A7264;
	Sat, 20 Jun 2026 08:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781943605; cv=none; b=NHdmP/Y6U6o+tIX5xYgkmOB1ue7ryxbfCrKrd2DTXBptKEp/znoQHZn2/d5QKKEBcAFHxHwWU3AwPKfzE6+XMnOxWE3LOqbS0yhgkECNfyTj14cRj7uM47+lrmNNGPqIbhaMkPacjK3ij5sS4NDtRIl1UX5uVvZF+I87LGuNIpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781943605; c=relaxed/simple;
	bh=7ssq/Nei69hZ/Jq3GYwPeCxIGbzrtdgjURSX/wTTzm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWv5rB2zU2a/pphrIH+AntMKGuBZkkJeTt6YXqdsW6kUZVrBXbNrJWneV46cfGVd4jFAQ9kvYcZNRl+fIMaDveW7/ihgdYh1CWlZ2Hiqd/LBdUjhgLnl5xP2lUDs/jEd8VoUdkPJspOx5sF8ohHVJhEzb3wNFVhy92P+7z/m1rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZoPD1+il; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZoPD1+il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017551F000E9;
	Sat, 20 Jun 2026 08:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781943604;
	bh=wfnnJE27fGIp8+gf7G6VDyHuf9cBMl3p2pt89jSm5MU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZoPD1+ilhlBkbXsV5IuWf9hP/lPNl7I0/8F0K7CS428v0IfTbGYvbrVuVTuexieeb
	 fiRLxbP2krrkR7m6M9fnQlQlkfOS9tcR8KkBhg/gaqXbklNL+iMpvCsi9+WIp6y0oE
	 fkUfEiatrnLTusajnHzvfG1OzxbnA7l8rhz/Blf2Jdbp2kZjgXOzIs1RLjTutOSV0x
	 eymWcV+xIvkaYx6A7LjSAdDQvbQ6pFnZCQWQiBgzVHlk9gX3WQFQyVSkxLO9Kav44D
	 Q6c59Ur3IuBhIeIIfqqV9FfmHaTUBHC89cNhaTJw62GCHtVbttS/NwtYxt6nLSuzg0
	 Rkpyr5UoJmisw==
Date: Sat, 20 Jun 2026 10:19:58 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
Message-ID: <ajZMRWUt3_6VSaIT@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260520123722.405752-4-aalbersh@kernel.org>
 <20260520190719.GB3424023@google.com>
 <CAOQ4uxh_hfiSwMw8ABhhrz7GguZWjHEiBmvb3eq16Wfqw0+ZrQ@mail.gmail.com>
 <20260619165448.GB3223@sol>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260619165448.GB3223@sol>

On 2026-06-19 09:54:48, Eric Biggers wrote:
> On Fri, Jun 19, 2026 at 09:28:31AM +0200, Amir Goldstein wrote:
> > On Wed, May 20, 2026 at 9:07 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Wed, May 20, 2026 at 02:37:01PM +0200, Andrey Albershteyn wrote:
> > > > fsverity now exposes fsverity_ensure_verity_info() which could be used
> > > > instead of opening file to ensure that fsverity info is loaded and
> > > > attached to inode.
> > > >
> > > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > > Acked-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >  fs/overlayfs/util.c | 14 +++-----------
> > > >  1 file changed, 3 insertions(+), 11 deletions(-)
> > >
> > > Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> > >
> > > I'm still confused by the new implementation of fsverity_active() that
> > > got introduced by "fsverity: use a hashtable to find the fsverity_info",
> > > though.  I should have caught this during review of that commit.  For
> > > one its comment is outdated, but also the memory barrier seems to be
> > > specific to the fsverity_get_info() caller and probably should be moved
> > > to there.  Anyway, that's not directly related to this patch.
> > 
> > Eric, Andrey,
> > 
> > Did you see the Sashiko review for this patch and others in this series?
> > 
> > https://sashiko.dev/#/patchset/20260520123722.405752-1-aalbersh%40kernel.org
> > 
> > It annotated some review comments as high and critical.
> > For this patch it is about interaction with fscrypt.
> > 
> > Please take a look and say if this is concerning or false positive.
> 
> Yes, this patch is broken and should be dropped.  I need to remember to
> look at the Sashiko reviews for other people's patches and not just
> trust that the submitter will.  Fortunately this one wasn't applied yet.
> 
> I pointed out the HIGHMEM performance bug in
> "fsverity: generate and store zero-block hash" earlier
> (https://lore.kernel.org/linux-fsdevel/20260401222717.GH2466@quark/).  I
> assume it was decided that no one will care about the combination of XFS
> && fsverity && HIGHMEM.  But the XFS folks should double-check that.
> 
> Andrey, could you check the Sashiko reviews for the other patches too?

Sure, I will go through them

-- 
- Andrey
