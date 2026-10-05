Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48169477E20;
	Mon,  5 Oct 2026 11:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791199585; cv=none; b=Vq5un9MZE2FyhIzS86PL4ul7v+ZgyR88Im8Uu4FzXcQ6aTTc4ketZDk1GDGdL2bBQT2qr6hLqrChs+RkvEiGSTtS8DoyqzHkF/xFJmq9aW05VZ8Wf2Y9ZIpzhGz3yzslZs2ZS8gTLXNQrreAr1XRja1B4Tbcr6Cu1TiwG01JTJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791199585; c=relaxed/simple;
	bh=uuS+4VNJNVGqobXQ9R2K3Iau9vnH4lmRz07PVfqR+EE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jxZbDVLbjNXnVCH3lk5YHqrZd5ybO/SOCKB+gDJRbzIOoLRE5OqoxlZj9B7PcMrqI+/Y+bhjZ+kvq85SebacNJkp4o+aUg3YY67vTx/VW8RmrHCN8oqpPQP0O3Om4+Nhm2HX5nIcG+IGEnD6OKE2+edW8PyiPs283ziVCveiXbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dnxfPnlE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dnxfPnlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215401F000FF;
	Mon,  5 Oct 2026 11:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791199583;
	bh=m/RFPJLbxCCsKLCIEVyjoB1hnKSFrK8qIznZiVq7CJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dnxfPnlE+42vQT4C95ek8OLdUjS7Wr+HWYBSC+aAPDlopzSF1LVHjdHGQG+pdYac3
	 po8ww2oKHe78fL5qpW5UgPRkJjcCevWbsJyTl80sK/nzOMDpJJOcA+qzWRK19Uh8dc
	 VGzIQY6FnyMegIqHrQDOthh2MkzdPhG6+aoyQn40ZPvbeivJyaVq/YtCcPqziPclrp
	 qb8kUAMutvVmCzMUHS9/wPHMC/RgDuF9/HkMRX9jFbG9Jjcxusl3UHKwyumbzuEsPB
	 SjLOML9rTeRWBawSXYy2FE0+7y/Gy6y9srnpvqZ4R1UUZeExPVrT+VfS+1vGmHH/dY
	 gwYR82EHOcl6w==
Date: Mon, 5 Oct 2026 13:26:18 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, djwong@kernel.org, hch@lst.de, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v17 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <asN8lCPmZpA0tp5S@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002232542.GA15366@quark>
 <asDvqctUgrxflcCa@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asDvqctUgrxflcCa@nidhogg.toxiclabs.cc>

On 2026-10-03 14:07:23, Carlos Maiolino wrote:
> On Fri, Oct 02, 2026 at 04:25:42PM -0700, Eric Biggers wrote:
> > On Sat, Oct 03, 2026 at 12:36:41AM +0200, Andrey Albershteyn wrote:
> > > Andrey Albershteyn (19):
> > >   fsverity: report validation errors through fserror to fsnotify
> > >   fsverity: expose ensure_fsverity_info()
> > >   fsverity: pass digest size and hash of the all-zeroes block to ->write
> > >   fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
> > >   fsverity: don't allow setting DAX file attribute on fsverity files
> > >   fsverity: hoist statx reporting of fs-verity flag
> > 
> > Would it be helpful if I applied these six patches to fsverity/for-next
> > for 7.4, or do you want to wait for the full series to go in at once
> > (presumably through the XFS tree)?
> > 
> > - Eric
> > 
> 
> It's your call, I *think*, this is too late for xfs 7.4, so I want to
> queue it as soon as possible for 7.5.
> 
> If you want to take the fsverity patches into 7.4, go for it, then the
> xfs ones I'll pull in once yours are merged.
> 
> Sounds reasonable?
> 
> Carlos
> 

Fine with me too

-- 
- Andrey
