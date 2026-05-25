Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFA63A9D9B;
	Mon, 25 May 2026 07:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779692843; cv=none; b=md0gmzH3fHdV8V8NtJFM4DohULQ9mu0S2hdrysxhhlXXKBQzdeWLRkAqbts3FduEE+eppUgJ+vn+pRfXncnFHUNCG+SUhsjgQwPOLfKefZqQOYGxW4aAKRr+lNaA/JRjeAwsMD+5KU90BHBPdtB9FbBeHHmU6WnN/YOTGybQddw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779692843; c=relaxed/simple;
	bh=ZBgjeSkb2D8Jguda1BBstvS/A0xeXLPEkhHpXqFE/HQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tVoVbCo8r0ode/vY4zaqHmOzaCYgfBhjCemFkZyoRhjOf4fBJDD2+EVd1ElXs0hcQqO5pam/Q6JgdJQPbI8ESyAIQNCYjM8vwg5Sj+rvGlBWU8Qn3oWgX6BoN7Gl1Z2D436H6ERiYD4z8hes93Ntc2bMoYY29meGgL+ydoJjh2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xbnspB3h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xbnspB3h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+d7PX2NcjtUHzTFbEE62EesXrZp/XO3eOjdCPHwyr1E=; b=xbnspB3hNQWkc/6HM/ZdrUqFGU
	tzi1VdMadrQOnC9b1ZZVGnj1wf5SOiT10McOxugYIkHgrZpPARlJDIjfL4LUw9I7o9fSBn1+gKwdk
	n7p4bYoZiwD4kvukPUIbnGEn00i52rDjrfhOgOx9wd5XgI+x2VReVBJ+F2M83cnt00v0xFCso1auj
	kVZwNEeE9Yzd/fOKiOtTjCBJJ0XVyv96DvBMTA1O5G4FTPcvFFl8CjTGNTyA51TjO6AtnaajxBCdk
	YFMcwx0CZ0VJnkZb6X6tvXGuTEqVBIkJtq492fT02h3n1vzgKgLMmEH/BjMAcSOrUPcgj4ZrRNsSH
	vyZJaemg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRPPF-0000000GUnL-2wj9;
	Mon, 25 May 2026 07:07:21 +0000
Date: Mon, 25 May 2026 00:07:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v5 01/10] fstests: add _loop_image_create_clone() helper
Message-ID: <ahP1KZ6aCNVqn__m@infradead.org>
References: <cover.1779367627.git.asj@kernel.org>
 <7b0edc0be51fd3ba222a4d0f204cd406c98085d8.1779367627.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b0edc0be51fd3ba222a4d0f204cd406c98085d8.1779367627.git.asj@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 21, 2026 at 08:54:51PM +0800, Anand Jain wrote:
> Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
> image file and clone it to another image file, and attach a loop device to
> them. And its destroy part.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 9632b211b58f..a2ee23c45003 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1503,6 +1503,56 @@ _scratch_resvblks()
>  	esac
>  }
>  
> +_loop_image_create_clone()
> +{

Please add a comment explaining the function and how to use it.

> +_loop_image_destroy()
> +{

Same.

