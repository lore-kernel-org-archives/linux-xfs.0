Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FA64014A3
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 18:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779906053; cv=none; b=h+GP+6lbDmgnNzR6DiEvrQSQjxqiRXW91lzYyrCNdK4PjB/11RDRZ/W2W0iyjGZXZYvggudkVhv5iJvDZI0LgZM3V1DfTAN5HdiqSHyEqBiTimUXwg2A4jgzjg5A5dOWeyA0dlQf/X7YQY68fVo2Eeg/81ZWAOXADLc9qFbilWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779906053; c=relaxed/simple;
	bh=XFjs5u68yyxgZr2wCX3o5QNepS+RwgCPH6xiNQ7fbKs=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=oyChdPdYQmfM+CFusfAhht2sj54temTmBOEb+U8dWOfXL8YyAgWftMGMeJJHCC1XIYDxtTiZiwKKtxnlHWiMufwE34hkwz0dVee+Ph98kWkZ0cR5H5bcbdVrwNZQhHp3j2DNO/J1ilqS5RF/tkBW28hTdk8bYiDuXFIfvAvHDh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 1BC4E180F2C1;
	Wed, 27 May 2026 20:20:38 +0200 (CEST)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id 66H7A/Y1F2o0mToAKEJqOA
	(envelope-from <lukas@herbolt.com>); Wed, 27 May 2026 20:20:38 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 27 May 2026 20:20:38 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: mkfs.xfs replace assert on 0 size file with
 error and usage
In-Reply-To: <ahbnHnGL0U4Sj7aF@infradead.org>
References: <20260525090543.4178496-2-lukas@herbolt.com>
 <ahbnHnGL0U4Sj7aF@infradead.org>
Message-ID: <75488dc094fc2d88b6ad79b66d72ce9d@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-05-27 14:44, Christoph Hellwig wrote:
> On Mon, May 25, 2026 at 11:05:44AM +0200, Lukas Herbolt wrote:
>> Running mkfs.xfs on zero size file ends up with assert() and coredump.
>> It would be better the print error message and usage.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> It would be nice to add a generic xfstests case to try mkfs on
> zero size files, and maybe also weird things like character devices
> and sockets to test the error handling in case you're looking for
> another little project in this area.

Hmm, I thought about the test. Thanks for the suggestion for the "weird"
files. I will look into it.
-- 
-lhe
