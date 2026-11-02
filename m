Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793617728;
	b=KngT9EzLCH2gZnt3gW+cBJSK6x7qTRSymh+/zhgM259XidOG7GQMNffH+Mkp0xchr6e3
	 BBl+W+PoTsOr0FNrhoUrXp/IFWd1pH70IzepNzsDbFp/+Si/vUnuF3Huy+RRcQmFkkKab
	 +Uj/o7NCs3AnUuxvdwj448icdyXpyDV7aO56rRO/bEnj0Rw/sm17MU/R5BLvTY78lUp8j
	 /y0qAOBW6qf06cqAZ9hW/O3+Ge0JGmEiWgRWOVALmHhYu7AFAf5ZOi4q7PuOwxiYw4Xqd
	 yOoE92AGdBQ/AzHv7de0g251KjryHytf2OnFR5TR6zS2mZdaytgO/8khLesmP8nEMBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793617728;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=vKivxmk0Fp/Q25vo6oTqWa5phfU7YrjeQWxvIf6IC+g=;
	b=BfaW7VIsZKOe4WzDSvqa1IHZgGLiX95JOk35hsjy/tUQDU/d7ndAuAV8Cab+2U9MtAU4
	 7el0kdi9btYkKdz6KK+MvGHFsmGVOszEX1862UZuIEMhOLuJdIeLHYHVanyIKYkPlk/bF
	 UuGxJILYQX/KSwgeNbQhXxNNr5HSL65P8pN3++KHfI92NcxhNIhj352BgVdB1YZ98BqLr
	 hfOh7PLFsTW8qH1waqifHGkDhP6cVW2Gyhr5kYyNi4BaIZDj68ydY0z8ZHXsHOWQ9aCps
	 DD/pi3Jy9U46ewykwOxbKhpqvnfqpfmL2aA56N/NAtIwEwr1KpR2EqkzQvfqDIBmWAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UkrNBaQr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BB2606A32F;
	Mon,  2 Nov 2026 11:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UkrNBaQr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29611F00A16;
	Mon,  2 Nov 2026 11:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793617727;
	bh=vKivxmk0Fp/Q25vo6oTqWa5phfU7YrjeQWxvIf6IC+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UkrNBaQr8nrfYUXUf6x/jboQX0SGbIpUnV4lCW8UH2lrmoFZTbM0DlDdc0/upJjL2
	 Z27FuwE55Ld3qoaHFLxgMxAhJqC1g2ir3zMjSvw2yPXX0ycASIXlMGMYsdvURkFzOF
	 efy5JnZR9TxeHnxmlWN8W7yLiim+KOnu3NbzCUsrKkRcJGov141WVCxsPuUwn/Jdp/
	 XHyrApUGGGF9+8Oa61qa1JRe6CHxmRUUFCA33VJWBzZBGrZX1O8G24Zm9TwH5Q382X
	 S6dTSNJqbzyfsxKrcl6teA2KMfuk9JZ4dAd0n6tkiCSyusEZtWpXM9B3au8HpPWIKo
	 n6Df0cnrNroFg==
Date: Mon, 2 Nov 2026 12:08:43 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix unwind handling during xfs_mount_sysfs_init()
Message-ID: <auhvGIXs1XVqNxgF@nidhogg.toxiclabs.cc>
References: <20261026053454.987673-2-wilfred.opensource@gmail.com>
 <auDFY4Lkxs76I_F5@cronus.toxiclabs.cc>
 <7aa0056fad8faa98a79b2df930fec1119797b51c.camel@wdc.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7aa0056fad8faa98a79b2df930fec1119797b51c.camel@wdc.com>

On Tue, Oct 27, 2026 at 10:39:09PM +0000, Wilfred Mallawa wrote:
> On Tue, 2026-10-27 at 16:50 +0100, Carlos Maiolino wrote:
> > On Mon, Oct 26, 2026 at 03:34:55PM +1000, Wilfred Mallawa wrote:
> > > From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> > > 
> > > The goto for failing to setup /error/metadata jumps to the wrong
> > > place
> > > in xfs_mount_sysfs_init(). Fix it.
> > > 
> > > Fixes: a9a7b9e8686d ("xfs: add support for lazy direct read bounce
> > > buffering")
> > > Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> > > ---
> > >  fs/xfs/xfs_sysfs.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> > > index e77917ac179d..4a6a8c92c3a1 100644
> > > --- a/fs/xfs/xfs_sysfs.c
> > > +++ b/fs/xfs/xfs_sysfs.c
> > > @@ -906,7 +906,7 @@ xfs_mount_sysfs_init(
> > >  				"metadata", &mp-
> > > >m_error_meta_kobj,
> > >  				xfs_error_meta_init);
> > >  	if (error)
> > > -		goto out_remove_csum_dir;
> > > +		goto out_remove_error_dir;
> > 
> > Hmm. I think this is wrong. Don't we need to remove the
> > fail_at_unmount
> > file *before* removing the kobject?
> > 
> > So, we'd need to actually call sysfs_remove_file() before actually
> > deleting the m_error_kobj.
> > 
> > I am honestly not sure if kobject_del would clean up any attributes
> > added there, but I think that's the right thing to do here?!
> 
> With the xfs_sysfs_del(m_error_kobj), we end up in sysfs_remove_dir(()
> which deletes any subdirs/files. So we *shoudn't* need to explicitly do
> a per file remove?

Yup, you're right.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> 
> Thanks!
