Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A91442B0B;
	Tue, 15 Sep 2026 09:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789465453; cv=none; b=Tf8LFklagwbX+K5OMlr4gKVHvOepxlHP9x1c7du3oVzFYX+rGq5J65jMV6laf68ptr0+KsGKuVxqq4CZk0jG+rKTpCKCrQ0nFKixOZDIyumXJhJGAb4WW63z3kY5tAX9kBjr+vw4jpwm8knzgsG3E40SeP2jXYecKegYIyfRzjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789465453; c=relaxed/simple;
	bh=/d/6UT9Tt7+cK3IKuJfxUE+MDhYAk50ton9R1V+E1CE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YPyHKzN0bIUWMWDYxAfg8525YKMxHYwJcc6sL90d01VAQv7xeshWKYYG95qNdqYsxcfQL1oP6SF8gcxGEiA2d5YjJWwzni8jcp3dUa2i7/AcEYHBt7q88+XA4aSw2hkD+2OrgRoRa3oivmNwuYIl863EM76C+gp3G+BLbsOC71o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDpp6YwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDpp6YwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EFD1F000FF;
	Tue, 15 Sep 2026 09:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789465450;
	bh=Wd/U+NK0oGgiF2xTFzkDdA/Wbw1a0ilLs1r2Pg2weS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eDpp6YwTOPT4vz6okqtpu+NQG3CnXVKRDwZTh4Yb8W+/kiSdTJcT+Qoz/bjXM6Jea
	 0ZlZV/KGo6UL0UOhjgA4MriKxMkZUU9BrXWEEzmUSZmqhhB4k2uKiOownDLsZtz0Kn
	 JeyIrJamKiY1OCcAex4+/64pzKxX6xMvCrr7iDOV3YRVkbTfVhbaAZrkB0//0/CAxY
	 M0KTcXpfZgfVm4i2xSveBJMhfhx+DsUTXSkhG2TS33FolYkceHOJmlBD3ynWgk5Dsx
	 bCSYvAqV1XLqVLiJZal26e+ScDviNjoDYWa215Bn4dtX3jMmGOre7K7dhAggUnqVEG
	 PC1wmx0WnbvCg==
Date: Tue, 15 Sep 2026 11:44:06 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	"Zhou, Yun" <yun.zhou@windriver.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH v3] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
Message-ID: <aqkTUtYv4fbo_v0G@nidhogg.toxiclabs.cc>
References: <20260731031010.2627884-1-yun.zhou@windriver.com>
 <20260911174247.GK6265@frogsfrogsfrogs>
 <4ff8e91e-a5b2-4754-ac9a-20f64f169af0@windriver.com>
 <20260915043105.GB2705364@frogsfrogsfrogs>
 <aqjj04f66MqUXgdV@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqjj04f66MqUXgdV@infradead.org>

On Mon, Sep 14, 2026 at 11:21:07PM -0700, Christoph Hellwig wrote:
> On Mon, Sep 14, 2026 at 09:31:05PM -0700, Darrick J. Wong wrote:
> > > 
> > > Alternatively, since xfs_ioc_setlabel() is currently the only caller
> > > and it's kernel-only, we could just move xfs_sync_sb_buf() out of
> > > libxfs into xfs_ioctl.c.
> > 
> > Probably safer to do that, since there's no other user of that function,
> > and none in userspace.
> 
> Yeah, I was going to suggest to move it out of libxfs as well.
> Either xfs_ioctl.c or something like xfs_mount.c if we think it will
> be reused elsewhere in the near future.
> 

+1, and indeed it has been merged. Gotta be a new patch =/
