Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACF1212D7C;
	Fri, 10 Apr 2026 17:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775842024; cv=none; b=cYe4+TJjh+IWO2jS0BIIkMPKXCspH42RfK06DxUtoYUTglsj0a301hRAQH5zzjmso2LvGgkuOhXzoZFGSSNnSESDCmbnbkNc6rT+PErDXLKktCTSqDbr7kddjoaJcQjxargCde+1yLzT8e5g29p5hjsfghNEEmLK12FYMpGTRvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775842024; c=relaxed/simple;
	bh=MeKWoGu1irZER9DE771qwjB8+VuUSKCAADJXlpirO9w=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JUFm6Jdzs5Bsnf8+bcbWAzF8kMAyih3NWCefR+EinRmdtFDAvhVJg+T8fJq1aTy/1YjTqGcF0oO7q9rFITk7oTo1W0IO/dc03NH1zWOpXHtYtyHX8yNPwAll4lj6YCUpjGWtCcFNe6wVZ4oBciW2hicYUPE2eptzj0Y7GIAyhF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=kWCkvjW/; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="kWCkvjW/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775842023; x=1807378023;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qVQHTcwFQAlCnIa0usSwILhD/4sFUm4U1HLsOsq5SgY=;
  b=kWCkvjW/0PezH9WzBpDMIGluZRnGVJTW1hXjwnUgJngoak/DQ291RqH1
   5Mh3AE+M5P9hx/2a+A/XXhicb5DZbQcCFAVGSZKfnUQqxwjuqUVdj4ZAY
   oqQrMOP9z5PqghrPqvTp1jCuAUd9QuKZAJKhc4cgHuiCE2dEn9sb2J9oO
   x+okJl1jEDOeQqKadKxUrx024AJKfzn6rPvg6DCgzN5b8mZGjVrfSQKBQ
   FCTwuoG5rfqu6ixxyxurnyRKRYeafc18ZaqIvP94dRE+412mD1mrwAjK9
   70DVJwuqon6Lu3v9Hvl7Yo9yHFtaZmx1UoZI0xSEutMB8S814VDQX8gpq
   g==;
X-CSE-ConnectionGUID: ql4oBA/ISYqNGa028hdN7g==
X-CSE-MsgGUID: VSeTncyUSUStn1wE4yNDdw==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="17042071"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 17:27:03 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:24341]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.2:2525] with esmtp (Farcaster)
 id 2e90eddf-c7dd-4585-958a-cf45faa167a7; Fri, 10 Apr 2026 17:27:03 +0000 (UTC)
X-Farcaster-Flow-ID: 2e90eddf-c7dd-4585-958a-cf45faa167a7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 17:27:02 +0000
Received: from c889f3b07a0a.ant.amazon.com (10.106.83.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 17:27:01 +0000
Date: Fri, 10 Apr 2026 18:26:58 +0100
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Dave Chinner <dgc@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: check directory data block header padding in
 scrub
Message-ID: <adky4hw3YdX06wEF@c889f3b07a0a.ant.amazon.com>
References: <20260408172749.99216-2-ytohnuki@amazon.com>
 <adbKxVodbqAdM9Ol@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <adbKxVodbqAdM9Ol@dread>
X-ClientProxiedBy: EX19D042UWB002.ant.amazon.com (10.13.139.175) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Thu, Apr 09, 2026 at 07:38:13AM +1000, Dave Chinner wrote:
> This seems .... a bit of a hack.
> 
> For simplicity, performance and long term maintenance of the code,
> we should zero the whole directory block header region
> unconditionally. This means we don't have to change the dir3 blk header
> initialisation code (except to remove the zeroing), we can remove
> the manual bestfree zeroing loop, all the padding (implicit and
> explicit) will be zeroed, and we know that any future
> changes to the dir header structure will automatically be
> initialised to zero....
> 
> i.e.
> 	/* initialise the whole directory header region to zero */
> 	memset(bp->b_addr, 0, geo->data_entry_offset);

Thank you for the valuable feedback. I'll rework this patch
along these lines.

> You don't need endian conversion on a value of 0.

Understood. I'll fix this, same as the other patch.

> Why only update scrub? Why not add code that unconditionally
> sets the padding to 0 on directory data block writes? e.g. in
> xfs_dir3_data_write_verify() alongside the writing of the LSN into
> the header?
> 
> That way any directory that is modified ends up having the padding
> zeroed at runtime with no additional cost, and so filesystems will
> slowly correct themselves over time without needing to run repair...
> 
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org

Good point, thanks again. I'm also looking into adding self-healing in
xfs_dir3_data_write_verify() and may split the changes into a series 
for easier review.

Thanks,
Yuto



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



