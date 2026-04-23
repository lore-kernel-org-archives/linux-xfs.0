Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A69336889;
	Thu, 23 Apr 2026 07:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776930604; cv=none; b=QPMi2tZ30CJDex1UBO0SMyx1Bcp4G7tmQClIAlpaQT/H1i7McDUkBjANzUPYBpqpFnT7WDo5Oyyr5BYJ/fzPzyVu0YLHoUS9VNh+LwJBI24d70D+m1nO9kW2kTmNEz71MKwwrnG99VFXKhUSOSlgEbUVGKYvWH2SNeKJtZISyys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776930604; c=relaxed/simple;
	bh=koqL8dxZxOA09htDg0QCTLSwawsfF8YelfZuloNAXX0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUlAG239gsF2uWcEnJoKAxHif3h0IW1tXm5/6GxXFDCvxGNeAeq/UKhwQY0x8EFUYfqLRnXghRN6DLSLAbV11+BuBMF/upGrIID5p8dwqtxtI34k9QHWgOULKqernME11voMzZsBWBlBxCPcjQ+58y7Pvk7mxRydBXbtukmobjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ILLMj09P; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ILLMj09P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776930603; x=1808466603;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YcK7BH6LsUHbw1GNzyuxzRAV3F7dtPPFqbVsRERJVyk=;
  b=ILLMj09PqZGDjsSJuVgJrVM3HW22TySEpk+KHdohqbDF+b0g69t+bfC5
   xUr2n61CWpBwUAlxbNanA96Cp9zXoj1xt5hvv9oktGexomeVoRmfVxP27
   Q3hIyx4/ylvnwWkYDiZIJgPcDVQXeeF4qDQSubE3xGaoWtE6arD1DehMM
   V2PhvvrtKn6Kd3yBIi9H6jpcnZPtTl+xT5YsT4fdhNjjYTxw0PdJQcHyp
   aYTezFM7bJhTtcRjPa/QmUisY0H5FxW+MiI6GSPMCAMyglABcugnUWTgE
   5h1olQH6idEXkMYSt3KfikQ7m0zxiiMsIlA62SRMjHtkcJJAjBkveDx46
   A==;
X-CSE-ConnectionGUID: oStCjAsETt+6IZUQXJzVUQ==
X-CSE-MsgGUID: qvsU8lI5SpS5wAC2VCWYrw==
X-IronPort-AV: E=Sophos;i="6.23,194,1770595200"; 
   d="scan'208";a="17794715"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 07:49:59 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:20048]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.57.50:2525] with esmtp (Farcaster)
 id 48bc638d-21d4-4a96-b019-6ff473a7c96b; Thu, 23 Apr 2026 07:49:59 +0000 (UTC)
X-Farcaster-Flow-ID: 48bc638d-21d4-4a96-b019-6ff473a7c96b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 23 Apr 2026 07:49:58 +0000
Received: from c889f3b07a0a (10.106.83.12) by EX19D001UWA001.ant.amazon.com
 (10.13.138.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Thu, 23 Apr 2026
 07:49:58 +0000
Date: Thu, 23 Apr 2026 08:49:54 +0100
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Dave Chinner <dgc@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: sanitize da node pad field on write
Message-ID: <aenPIqHNZBfhVQvk@c889f3b07a0a>
References: <20260421054311.25301-2-ytohnuki@amazon.com>
 <aefxp5uMg43RQqtr@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aefxp5uMg43RQqtr@dread>
X-ClientProxiedBy: EX19D045UWC002.ant.amazon.com (10.13.139.230) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Wed, Apr 22, 2026 at 07:52:39AM +1000, Dave Chinner wrote:
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > index ad801b7bd2dd..f6054a47d24c 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > @@ -318,6 +318,8 @@ xfs_da3_node_write_verify(
> >  	if (bip)
> >  		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
> >  
> > +	hdr3->__pad32 = 0;
> > +
> 
> Please add a comment explaining why the padding is being written
> unconditionally here. By itself like this it makes no sense at all.
> 
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org

Thanks for the advice. I'll add the comment and send as v2.

Yuto Ohnuki



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



