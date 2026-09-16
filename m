Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12E03BE62B
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 12:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560515; cv=none; b=L0RjcPpnaTNtol5o3+J76PzW4JnE4cFucVK/KRYJ4IYYeHXy6KFXnWDv32sWXzo70ROph77nNKndPr/QOlWk6P6pTIQP7+qo8gA/sETYnZTfsT18HUBJZmhmXow35acLMnQ1j1O14/XRuUg1BOgSJ9rtqZ1Em4y4Et3xqfgl8Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560515; c=relaxed/simple;
	bh=efRw841IHOdqICteR1s62d0XL1A9DbE1/dVABV0PcsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jnVxMBJJ5+gWDw0lZQZDUATewNbmWz6kgqZ/WxoCAWTAt+HoOlhnr8wyg8uHZ9EncUs7zp88OiLG5t0Z2UIAbqOpFF0XM2+jeMNpO22yvFXpgU4B8s0Ae6hkfJhMzkHufnn1KsrgUrrQtnwcn6g7bGh+sJ0+1iTafviZFoh+iok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQoMmW54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQoMmW54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CE41F00893;
	Wed, 16 Sep 2026 12:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560512;
	bh=lzmkpvgcdqGOt/N8y4PwxvBePxImAR9mXufzkM6hrco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SQoMmW546/Qb3pHY1V36iymQFHxvNHJO4ombNsCHnWB/bV06R/8Nv9ThkqK8pgk4V
	 sPW3/iy8WYC+wGv3tDOp/3auAtTL0LTKnSpziSXSmgETdesVaAJCCDv6KG/wiJl38/
	 KlSYB1OZfS/dhsFHVJTi6wODnl93qfO04ovZJ/oBMetB33rUiRIjuNIHu2IRfXFpz7
	 GTPfNWE/ugJG3Z8ERmJqVMdwzDVIzbrPSLUx0GpgLrLNCVIZegpNZn9lF8rTCMf77y
	 Wkz0HyNAEVw0eT2DQQL/v52cRw37fhZuIjGMV02zNrzbmyKHo2TUT4iAkh0LtdascN
	 8IGABaSHGWtKA==
Date: Wed, 16 Sep 2026 14:08:27 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Brian Foster <bfoster@redhat.com>, 
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH RESEND 0/2] xfs: fix NOFS state corruption in btree split
 worker
Message-ID: <aqqGiu9W0G7dquoY@nidhogg.toxiclabs.cc>
References: <20260911104227.2028941-1-wangkefeng.wang@huawei.com>
 <aqkIetDJZa56Qvx_@nidhogg.toxiclabs.cc>
 <954e1e73-3507-442c-aa95-569dd2e908a8@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <954e1e73-3507-442c-aa95-569dd2e908a8@huawei.com>

On Tue, Sep 15, 2026 at 05:14:18PM +0800, Kefeng Wang wrote:
> 
> 
> On 9/15/2026 4:58 PM, Carlos Maiolino wrote:
> > On Fri, Sep 11, 2026 at 06:42:25PM +0800, Kefeng Wang wrote:
> > > xfs_trans_set_context() overwrites tp->t_pflags, dropping the
> > > caller's NOFS protection. Replace it with local
> > > memalloc_nofs_save()/restore() to fix it, also drop the obsolete
> > > kswapd flag inheritance, which simplifying the fix.
> > > 
> > > Note:
> > > - rebased on v7.3-rc2
> > > - Add ACK/RB
> > > - split the patches, suggested by Christoph Hellwig[1]
> > 
> > > [1] https://lore.kernel.org/linux-mm/aqOp035i41XIrDXg@infradead.org/
> > 
> > Can you please give me some more context on why are you resending it? I
> > received an email from Andrew that he had pulled this patch already from
> > the previous series.
> > You were Cc'ed on the email so I'm assuming you didn't see it?
> > 
> 
> Andrew only merged the dead kswapd flags part without the important
> bugfix. as Christoph said in above link[1], he suggest me send a
> standalone series that we can get the bugfix into 7.3 and -stable with
> as few dependencies as possible. So I rebase on v7.3-rc2 and resend
> them. If I misunderstood, please correct me.

Ok, so as we spoke, Andrew already merged the previous one. Please
rebase the second one on top of xfs-linux/for-next and send it again by
itself.
