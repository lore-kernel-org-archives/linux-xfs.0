Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F104D1DF75B
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 04:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297955; cv=none; b=aB2+5Xycku6P9IRcqaQYw4+AII0GynAkBE6ecfbzX1LnzUXOmvEq5Sy6qQcvFRhUcEhPA/b+aBAZ6DyunyA0YPIJWNk08Z9JsUjb5ObX8pK3S+ENzZz2Aye6S0MFPAZHfnC0r+LlKtHQN6pxW/FocMaVVzZRn4V/jb5cS/xGIzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297955; c=relaxed/simple;
	bh=YXKh8pb9nIIHYgxVcXtEcLf/eUX29cJKhCqgpXSflXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Eb6L48WwuQRwnqAjncBR4kkj59rcTCtzClVtA2Xu/x3sCmP5+edNKIR/3/uSt5a3yq6mvTrB2G8Srj5aYWN5JzY4fMQNilcycwNKbZPmT7QKBewVCaiwleB0ArJtMSuRf0T9AsMB5Sa6BUyeGQToXQT1nog6P9kkyeAuMYZYtO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NKG6zYnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NKG6zYnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD19F1F000E9;
	Wed, 29 Jul 2026 04:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785297953;
	bh=OHcHK65NVmKWD8Dje/5wZR9y8huRdTG+FfBI1DvfCkc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NKG6zYnxpUbPT0zS8T5IPkKkWjGzsgbIZ9SHsHXMJqQB7wegHReshcl22W8PPfEAF
	 l/s9gWEqLLAB8JtX+0mDzTSflH+jqBscRc/0jWmXEXnKJdL6UJPShQ5sHAHCS8kDDl
	 QS4HvePfaf4WD5IkUhrAEx0+4h1Q1kx+JMmSMc+PzhaihyiRF9xK6DAIv6nP9+H4CA
	 Pptf1L8bKdCZQeXpZc/pTav01bShjvacETF+wNEEtMQqVChnb0bxVEyKQ0pwJgcYWE
	 T0zTNov51hnbgt1yCVIh47MmULfh3cVhbQTJpNVxfcojwdGm/Dn8kGEqhf1p40K2ud
	 u0/XbT1p7BBTw==
Message-ID: <171ae5a9-8524-488b-b999-8bac192f926e@kernel.org>
Date: Wed, 29 Jul 2026 13:05:41 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs: add a comment to describe xfs_gc_bio.victim_rtg
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Cc : Hans Holmberg" <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260728080650.1777545-1-hch@lst.de>
 <20260728080650.1777545-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260728080650.1777545-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/28/26 17:06, Christoph Hellwig wrote:
> All other fields have comments describing them, add one for this field
> as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me (see nit below).

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  fs/xfs/xfs_zone_gc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index e4f70e024632..e2bad83b10f6 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -103,6 +103,7 @@ struct xfs_gc_bio {
>  	/* Open Zone being written to */
>  	struct xfs_open_zone		*oz;
>  
> +	/* Realtime group currently evacuated */

May be: /* Realtime group currently being reclaimed */ ?

>  	struct xfs_rtgroup		*victim_rtg;
>  
>  	/* Bio used for reads and writes, including the bvec used by it */


-- 
Damien Le Moal
Western Digital Research
