Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6603859172;
	Wed, 13 Mar 2024 18:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710356315; cv=none; b=PdipbWzLA/bm2eiqXhvbyYvVjL6KRT7OEwxRndfItmAdQet2+ARQtPkzqYciusFjj3G9rFS2eWOCcI9NeDhHV/bXyXu/ju5s//GzfNHQz+H1pZZO/1IudXJz9yx+4QTHVKKPtHHwliQpkuQsqwJBYCvCWqjknYd4oSX8oztUM2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710356315; c=relaxed/simple;
	bh=2tyOqMJvS9tn2CiUFTgWhN7UNDZFrhfGrHUuyDHfANk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ek8xqbO8m0Si6KPc/q9Z2ICr00Ofc/ybWl439a332sQAp5SlZkrLV4mClHWQHpZ0YwV0+559WvtHzmQ+mPFiWU/hFIDk96wNpBMSDKZOYOt690S04UTsR+w4mgk5S+OX1QslHCDaMFW/PeSiSn1vlERgQo4vJYfCPJs+JOkcsSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=WUL8gqXs; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="WUL8gqXs"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4Tw0CS1djzz9svy;
	Wed, 13 Mar 2024 19:58:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1710356308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gq4JU+uhN7ZDXXluOAWccDsn4xvAIe2hK/PO32heXAM=;
	b=WUL8gqXsUXLcKkgo4F6Y0LNDchOraDM2+uRwExxt8VYNIj71MbT7MI0JktFeVfd+2tX0Px
	saea4D/dxILWMLcESxMWLEaxV7lI3RU4SLx74Q+G3TdhzV6yaQNIGxVv53Zn72+v+f6w2N
	8XX+TNws1tApq22rTnhDW8CgGAfTY+gH2glK/L8LzNM+QlV/ITubtlHsWplRqwor8NB/l9
	b69d5PokI4XGMNIzdeAcSEHsdThwFg7P8IVbRahuIRMVUQkFi4v0ovAfWII30sYnecqxHc
	ewM6N2UEBtL/E5tA00T4dJu4J/6h34UcZva9mlxTjLaPnXShjOWBn0JqGLHteA==
Date: Wed, 13 Mar 2024 19:58:23 +0100
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, zlang@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] misc: fix test that fail formatting with 64k blocksize
Message-ID: <ggfjwyuci4l4dittobyxc4v4a66qupahnrwfsfrdh7xfavtlqf@q3ahgouvzfb7>
References: <20240227173945.2945637-1-kernel@pankajraghav.com>
 <20240313151629.i23ing6hbsghpm4u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240313151629.i23ing6hbsghpm4u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
X-Rspamd-Queue-Id: 4Tw0CS1djzz9svy

On Wed, Mar 13, 2024 at 11:16:29PM +0800, Zorro Lang wrote:
> On Tue, Feb 27, 2024 at 06:39:45PM +0100, Pankaj Raghav (Samsung) wrote:
> > From: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > There's a bunch of tests that fail the formatting step when the test run
> > is configured to use XFS with a 64k blocksize.  This happens because XFS
> > doesn't really support that combination due to minimum log size
> > constraints. Fix the test to format larger devices in that case.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
> > Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> > ---
> 
> This change looks good to me, and it really fixes some testing failures.
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks.
> 
> BTW, I tested 64k blocksize xfs with this patch, there're still some failed
> test cases. If you're still interested in it, I'd like to list some of them
> as below (diff *.out *.out.bad output).
> 

I have some more test fixes but it is happening only when we have LBS,
i.e, 64k bs on a 4k system.

But I had a fix for xfs/558 [1]. Can you see if it fixes it?

[1] https://lore.kernel.org/linux-xfs/20240122111751.449762-2-kernel@pankajraghav.com/
> 
> *xfs/558 failed as:*
> 
> --- /dev/fd/63	2024-03-12 19:13:26.569223817 -0400
> +++ xfs/558.out.bad	2024-03-12 19:13:26.489224254 -0400
> @@ -1,2 +1,3 @@
>  QA output created by 558
> +Expected to hear about writeback iomap invalidations?
>  Silence is golden
