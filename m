Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3F43B19A1;
	Wed,  8 Apr 2026 17:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775667814; cv=none; b=QbP6ynuAq7zAdOsSJ/9XgDGuds5SngHUHHVC3NedPpbrXTrKSGUhHjDakvj3zkh4K4EAM2tTMD0SseUSrgT6CKW/EleXUSCBTAGYfXJDEDJmPpoZXnYGlr7FHfFDiAQJND0pxlvWMGu7jtM1sjhyUvvll+u+0KEZ9npgOa1yiAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775667814; c=relaxed/simple;
	bh=YaDEdpi9kcxzRF9HeWnoKQjZF28urpsj4Rc+lw/EZAc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMeuDWbZB7j1UTxymIBmI2GZ3eZLFo1KgY9UCgvGlvsTzZRci+qd/GElK5Tsy+Jcv2Ci+dEApigbTesOS6DcaedDybVaQmHAzAZqZ5iIyYmYvl3G1XnaXQIIhC/VrPoN02AX24VmKuAIPibllQ6NZ3OQYf2GCwDoxyJpJnnFkpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=kQqLJH9u; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="kQqLJH9u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775667813; x=1807203813;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dSjeKimMpRNsCyXfDGbZChVe3mwkqRsyiVomz4uopy4=;
  b=kQqLJH9u1hOqu/HL4i+Ezzt4sJmDY3VYYxTEirZTu/Xqed57leRbbxhP
   E2Lsjig0FEu0qH1qy+JtqTQXgzVjyi+tOa11NAOpEhQWSx0Gki+01oSJx
   t89cmbZfpwSbHMp+EuSa3GtAPv0YW7gYO4R1N4yFLXRf0rm8W5GCDTPgV
   SMppLhuWwSeqokm2Rfi7W7cK7GcrSBTxua486Z5dnaJ6BHeOrlPLOzxRm
   Jb3JN4oaE4aCr1iJKEbb6CjjzDmU3R5YS/2S6uN2VIowtFNJyYJKBWcCn
   JoWeauL68SNPijgbEGCmyajDJCj8hTaI2N9Yb0iq58IGW5JWPHXqpcahr
   g==;
X-CSE-ConnectionGUID: ivt2RFebRSmldMd8BHy6Og==
X-CSE-MsgGUID: rX0OG/WSR3a2B9oNkwdXRg==
X-IronPort-AV: E=Sophos;i="6.23,167,1770595200"; 
   d="scan'208";a="16737049"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 17:03:30 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:3692]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.68:2525] with esmtp (Farcaster)
 id 9f1efc01-0d97-4b3c-86db-946cb52dddff; Wed, 8 Apr 2026 17:03:29 +0000 (UTC)
X-Farcaster-Flow-ID: 9f1efc01-0d97-4b3c-86db-946cb52dddff
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 8 Apr 2026 17:03:29 +0000
Received: from c889f3b07a0a.ant.amazon.com (10.106.83.24) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 8 Apr 2026 17:03:28 +0000
Date: Wed, 8 Apr 2026 18:03:25 +0100
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: check directory data block header padding in scrub
Message-ID: <adaKXX0JAm5e9E6p@c889f3b07a0a.ant.amazon.com>
References: <20260404125032.37693-2-ytohnuki@amazon.com>
 <20260406152110.GA1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260406152110.GA1048989@frogsfrogsfrogs>
X-ClientProxiedBy: EX19D039UWA003.ant.amazon.com (10.13.139.49) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Apr 06, 2026 at 08:21:10AM -0700, Darrick J. Wong wrote:

Hi Darrick,
Thank you for the review.

> But where do we set xfs_dir3_data_hdr.pad to zero?  xfs_dir3_data_init
> does not seem to do this...

Thank you for pointing that out. I'll fix xfs_dir3_data_init to zero
the full xfs_dir3_data_hdr instead of just xfs_dir3_blk_hdr so that
the pad field is covered by the memset.

> ...and even if there is code that does the zero-initialization, it's
> possible that old kernels wrote out garbage in the pad field and were
> quite ok with that.  At best you can set XFS_SCRUB_OFLAG_PREEN to
> indicate that this kernel should clean it out.
> 
> (For that you'd also want to add a new xchk_fblock_set_corrupt helper to
> record which block tripped the "optimization possible" message.)
> 
> --D
> 

Understood. I'll switch to xchk_fblock_set_preen and add the missing
helper for that.

I'll send a v2 with these changes.

Thanks,
Yuto




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



