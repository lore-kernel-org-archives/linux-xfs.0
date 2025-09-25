Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B9817A2EB
	for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 21:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758834564; cv=none; b=R6wfuImyau/0hsG1zSkMtY4ufnAzg9uEd5kBDGV8CYg6UMv16+ZScg3MXKdAuc8Ezk9EPVY+MPJdl/TMrAE0oSU8J5pRzouKezwpbPVZbu/SqPdcL3HLqgSdRx6r+/jQEK+wXBKVpNVIsgugYx2++NvQW+2fKL4MLOUvFUPF32A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758834564; c=relaxed/simple;
	bh=iQWe8FoXhH50EMMo/LSrrVf4q7zdyzyedba5qEWOqXk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TjpuzoCP80nIOMKvosEayXF5AS6h5imYTiTlO8+NtDsIoVL1ajr9/zJnSQA2s5u5AmjbJh2w82fLuu4agzjhQdx4/1i8PkY2iAyZ29MPXlb3uypN2n6Shhr/p4K0ACFqlLZ3igV5T4SbzX5pSLOSEzgR7NNHsptcfOTzrDm+nQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5b347a18.dip0.t-ipconnect.de [91.52.122.24])
	by mail.itouring.de (Postfix) with ESMTPSA id DF978CEF9EB;
	Thu, 25 Sep 2025 22:58:38 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id A184A6018B7C7;
	Thu, 25 Sep 2025 22:58:38 +0200 (CEST)
Subject: Re: [PATCH v2] xfs_scrub: fix strerror_r usage yet again
To: "Darrick J. Wong" <djwong@kernel.org>,
 Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
 "A. Wilcox" <AWilcox@wilcox-tech.com>, linux-xfs@vger.kernel.org
References: <20250919161400.GO8096@frogsfrogsfrogs>
 <aNGA3WV3vO5PXhOH@infradead.org> <20250924005353.GW8096@frogsfrogsfrogs>
 <aNTuBDBU4q42J03E@infradead.org> <20250925200406.GZ8096@frogsfrogsfrogs>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <64881075-46f0-ec0a-f747-dbea46fc5caf@applied-asynchrony.com>
Date: Thu, 25 Sep 2025 22:58:38 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250925200406.GZ8096@frogsfrogsfrogs>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2025-09-25 22:04, Darrick J. Wong wrote:
> Has strerror() been designated as thread-safe at a POSIX level, or is
> this just an implementation quirk of these two C libraries?  strerror
> definitely wasn't thread-safe on glibc when I wrote this program.

It still is not:
https://pubs.opengroup.org/onlinepubs/9799919799/functions/strerror.html

Pretty safe to say that this particular train has sailed.

cheers
Holger
