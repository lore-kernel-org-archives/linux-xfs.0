Received: from mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DE43AFD16
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 05:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790745043; cv=none; b=E5mhLXDwxiZXgY5caHxWKubo3ugBEy96kDLP+DYer4O1HDR3btoVJPi2bQvExyFFoy2eUrWssN5+Zt5IYtnXh2E4Trw4dH2nFBFmWA0AR+QNCuDNzMrXXZyd5meDYGRAnjBCQRm6fmDKGxsuQJ6QkoUrKWpVCa3DJOJF68unBNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790745043; c=relaxed/simple;
	bh=IGxS0+gfniuzzfQsMIV/UgbQOGo3wYxae58t/i81EIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TsEbfO50kh0YZlinWPS9maysLFOlRq5tH9t9Hikm+RQKNEvqyzgzHa3cnMHbwpRgW7KL+gOQGdWabSBgEzv/k6moPreDvCOCmfyTjmTO+U+HGUgu6oUIB6IZluQwGMLBZX5JpEY9vAPuBGiYizbY2p8S7ydP6Trg2AyAzqpWBHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=edKHPLIW; arc=none smtp.client-ip=91.218.175.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="edKHPLIW"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IGxS0+gfniuzzfQsMIV/UgbQOGo3wYxae58t/i81EIo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790745036; v=1; x=1791349836;
 b=edKHPLIWgCqtwcYcbS+agjx19cOq7WX/EvDEGAhMpCXY47RD8HvWaffVuO1bQSm1oNKo7aH0
 PKxuGI2LUjj8LP7PsPIipIJ3l7z6vUnd0UDFV+0xRrcIaqP3YAfa//xZbD0XSQApJojBAEOklja
 PqcRWX8ZB9XmGS/WKxgvJiG4=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6a4b71773f86c4a9;
	Wed, 30 Sep 2026 05:10:21 +0000
X-Mizu-Trace-ID: 6a4b71773f86c4a9
X-Migadu-Flow: FLOW_OUT
Date: Wed, 30 Sep 2026 05:10:11 +0000
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: John Garry <john.garry@linux.dev>
Cc: Pankaj Raghav <p.raghav@samsung.com>, cem@kernel.org, 
	linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, gost.dev@samsung.com
Subject: Re: [PATCH] xfs: don't limit software atomic writes by the group
 alignment
Message-ID: <jwtdhhbo7ukt5cynhdfrxu3xjwyk3wwg66uxhtnkokvabbokge@b6b4pk3yja24>
References: <20260925103640.932735-1-p.raghav@samsung.com>
 <41749fa7-dcfa-46f0-af0f-ed3fa5f39f15@linux.dev>
 <ffd48d49-c4f6-4fc3-88a5-0adb11d0d6b9@linux.dev>
 <050f7a77-9c0e-4cab-8ddb-6932b885e12f@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <050f7a77-9c0e-4cab-8ddb-6932b885e12f@linux.dev>

> > Just to give more context:
> > 
> > Trace of calc_atomic_write_unit_max:
> > 
> >   mount-696   [010]   449.230543: xfs_calc_atomic_write_unit_max: dev
> > 259:0 ag max_write 262144 max_ioend 512 max_gsize 134217728 awu_max 512
> > 
> > 2097152 comes from awumax being 512 fsblocks.
> > 
> > root@debian:~# xfs_info /dev/nvme0n1
> > meta-data=/dev/nvme0n1           isize=512    agcount=8,
> > agsize=268435455 blks
> 
> Well max power-of-2 factor of this is going to be 1.
> 

Exactly. I get that we should restrict max_opt to be 1 because the AG's
will not be aligned and the best we can do is one fsblock for HW based
atomics. Why should we restrict the max (SW atomics limit) to 1 fsblock?

-- 
Pankaj
