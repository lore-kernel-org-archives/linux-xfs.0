Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B54833F580;
	Thu,  5 Mar 2026 09:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772704064; cv=none; b=CwTLlynAyU2/wOuP2kpoWn+fE9RMq4t3mvV7ghpKG8BleGGJiyIualQnFsZ1spfo9oNrTh26MffPq/ZYheQW5E/uLFHGwm5dcD4tv7Vc/S2JqeGao+WogOeQY9Jk+NnSjzQJPFjwMDzpFLuj4kIDWSJWLEk5/EbHKwzHqn5+hkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772704064; c=relaxed/simple;
	bh=JN+sSg6ikVGLCqdEbWKNBnsdGMzv1blYSTDKlR/xdgw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AW2HXP9TjWdStOHIw0FyCsvjpjz5UM0a5exJvFhD4tBCXP5oqBTI7lR1MEYRbWNoKoQcxvrxony2uVgNfSsmXOv7WmgYC4lxqxCDkHenVC6orgrZKFxpQ7OhIx3pksr/MyyKNwHM6oriKWvdgEJRAihD95DOXCglSdk8+SkRWSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IEKRWB5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IEKRWB5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B1BC116C6;
	Thu,  5 Mar 2026 09:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772704063;
	bh=JN+sSg6ikVGLCqdEbWKNBnsdGMzv1blYSTDKlR/xdgw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=IEKRWB5B2HQPeb2O9TleRGcUG3qsdwuSoDykND9xQNkwg0Z300HjURkmMz9nydoOK
	 4clfRmGeC0Bpv+m08eY/dVHP1IGS83Ft3sWtmwhj1QtQvAjLeVDSNFHKHykRT4GTT0
	 bAhjY5jVk+VIh8JVXqRYwfAnRsIYkyfJo71GAT89re0/GKWl+CU2R0RCv5rgrlctJp
	 iSYRzZGWOgTaadAphT3U5Gq0Wu8s820w2jp4jEmD06/3zBPSVquXC3YB2HJNIJRNhl
	 0agbXLi7siLgnrLLinEkz7hhZ0p6lfwCHx2DRKt13pZE7i57ZSa3/n92FN0/hI4gcc
	 I4J1f54WGa0ew==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, hongao <hongao@uniontech.com>
Cc: djwong@kernel.org, sandeen@redhat.com, hch@infradead.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <505A5848AA49D10A+20260304112914.599369-1-hongao@uniontech.com>
References: <B6935AE39B8FFBF2+20260303033332.277641-1-hongao@uniontech.com>
 <505A5848AA49D10A+20260304112914.599369-1-hongao@uniontech.com>
Subject: Re: [PATCH v2] xfs: Remove redundant NULL check after __GFP_NOFAIL
Message-Id: <177270406213.16251.15825154852692205571.b4-ty@kernel.org>
Date: Thu, 05 Mar 2026 10:47:42 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 04 Mar 2026 19:29:14 +0800, hongao wrote:
> kzalloc() is called with __GFP_NOFAIL, so a NULL return is not expected.
> Drop the redundant !map check in xfs_dabuf_map().
> Also switch the nirecs-sized allocation to kcalloc().
> 
> 

Applied to for-next, thanks!

[1/1] xfs: Remove redundant NULL check after __GFP_NOFAIL
      commit: 281cb17787d4284a7790b9cbd80fded826ca7739

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

