Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C7049DBB6
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789141720; cv=none; b=Sw04Y4kXVgP1zIeuU/jSKci/7QFcmZvAshFinvr5o6KQljKK9OF/gvTuZ3rZwMKbc9xXivZmo/Yp63lRRDJ7Pm972+2OYgPPay8S1SKTfn/JtIPJDQMxL/7MQLogruhh3diYSQA/ABOjRlQSedxBfP/mOMJPBrSXyxOsn2LqBRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789141720; c=relaxed/simple;
	bh=fe+1Qj5vLyf3NdfTGRTjQ4V8No28W+RB/VYq64smeic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FbhGDjIrMGA2yILXTC5YN4AeQMx8dxoFk6THqYNtuMgAyDFJBP4IQrtl+nbsdo0vtbnJmwcRwSGIsnwn7KnLv1z4MR0A+sijyr4tC0Y16TdbX5r0ajq+AZXqztkr0KxMYOEnaNH2WBeyztyWn8wAaspyySm38jGJXInpeKuwnbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t0/m7zMI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t0/m7zMI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gGMRRLI+q42PSfB8sOU62EIWPkDt148Nggocz9G5T1A=; b=t0/m7zMIuMYYasTP7j9Oyg+Yok
	zETH6fj0+6/JB0G71votAT2OvInQu0RavQt/GQBWLGGiYrTRPm5LraPZL01VLNXE3M51Bpp1wcrfA
	/G+slQirwEiGdII/GQSvYKQyE0pvn+Rd1m7sBEj8ewYUEW7HpZgi7OZq9Z/3gm/LpGsaUXvr1elPw
	/tgRQmKxvOYHc3o/KxC++QTOZL82CyGXy6aqaazp0HmE5BIl0RwCMeiQ7vrN7DuU8V4lgZeGAlbFW
	rneBKiqpYzcP+hV3i7PU6T35gGL1y5elgjCKH9g7yVxf13q8hHABb0iVNwex36x+CdHdJPoI9+1Ac
	J9H7Hcng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x53US-0000000H8D0-0q2r;
	Fri, 11 Sep 2026 15:48:38 +0000
Date: Fri, 11 Sep 2026 08:48:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] makecfg: handle metadir quota options
Message-ID: <aqQi1BNvhModkvb1@infradead.org>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910621.4047311.16295302909903460048.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892910621.4047311.16295302909903460048.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 08, 2026 at 11:01:33PM -0700, Darrick J. Wong wrote:
>  
> +/* These should correspond to XFS_[UGP]UOTA_{ACCT,ENFD} */

CAn we reuse those?  If not at least add the missing Q in QUOTA here :)

> diff --git a/configure.ac b/configure.ac
> index 40ccd88aa2a950..8a2505e37c70ab 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -195,6 +195,7 @@ if test "$have_listmount" = "yes"; then
>  fi
>  AC_HAVE_STATMOUNT_SUPPORTED_MASK
>  AC_HAVE_FANOTIFY_MOUNTINFO
> +AC_HAVE_QUOTACTL_FD

Shouldn't the AC_HAVE_QUOTACTL_FD go into a separate patch, including
a generic helper?  I assume most other uqotactl users would prefer
that as well when available.

Otherwise this looks good from a quick look.
