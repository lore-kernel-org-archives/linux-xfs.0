Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A349733F8B2;
	Fri, 19 Jun 2026 08:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781856917; cv=none; b=Vi8VlKlKM6AcsXFtikoGiddNolBmHRhkBowE4hvzIWGbU+7D6v5WEhpEvsymjOOsUG+Tm1wsCXhnWenL4O9ROXbqKUsFgup9zCrzgFhnc8Y2nIQ7V5pu26N0I2XBQIncQOh08HXHwdDsOb/MpxRp04k+FTDZMJ405d01/vo5Ifs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781856917; c=relaxed/simple;
	bh=TJ/5N3qcXoJ8MWSXQuOomI9KXw8NWOruAShKtcam2Qc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eV5zlbYbagqYiU/4ZgVB5Fw627b6imgGeFjWTfMgh1Vmxg6LVQEMUwx8yqV3ZLkyWcoqeqFRIDK8X+PUlD7C1kHpSYFO4/uXrjXDDfa7IYB5CPphq1ItSLtNuypEewADfUVQEzM7O8jNttrCL252llUOFJb7cm51peKNxMd3W2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gBmOSTpv; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gBmOSTpv"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781856912; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=H09kVhZKvVnGT/8zcbwbAdfiVXItBYmg1/F6osgjWjA=;
	b=gBmOSTpvxv2GrMbo1l6bqE7cUADSr7/hNGJ8olj97hmd/qEVC3FRGFfBpC2RkT6WJ8QuOJRc6r58+2rg8es04K+z+Ewu+WItGL71qOSC8YJ08l2DFvYhO2te4brVBKm4vV95q3MSqLMakCeVAaNt5CYp3ypKPOxXaUCvpXJWLWQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X59ET.U_1781856911;
Received: from 30.120.66.214(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X59ET.U_1781856911 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Jun 2026 16:15:11 +0800
Message-ID: <e2f45d1c-c4ad-482e-8a3c-8072209eec1b@linux.alibaba.com>
Date: Fri, 19 Jun 2026 16:15:10 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: submit read bio after each extent
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
 Ritesh Harjani <ritesh.list@gmail.com>, Joanne Koong
 <joannelkoong@gmail.com>, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260619050105.439956-1-hch@lst.de>
 <20260619050105.439956-2-hch@lst.de>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260619050105.439956-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/19 13:00, Christoph Hellwig wrote:
> Currently the iomap buffered read path tries to build up read context
> (i.e. bios for the typical block based case) over multiple iomaps as
> long as the sector matches.  This does not take into account files
> that can map to multiple different devices.  While this could be fixed
> by a bdev check in iomap_bio_read_folio_range, the building up of I/O
> over iomaps actually was a problem for the not yet merged ext2 iomap
> port, as that does want to send out I/O at the end of an indirect
> block mapped range.
> 
> So instead of adding more checks move over to a model where a bio
> only spans a single iomap.  File systems can still create iomap
> that span more than an extent if they want to build larger I/O.
> 
> Reported-by: Kelu Ye <yekelu1@huawei.com>
> Reported-by: Yifan Zhao <zhaoyifan28@huawei.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang
