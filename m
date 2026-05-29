Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6F43FE37A
	for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 18:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780078033; cv=none; b=ZVp2bfOHKn27Nc0NivKsSE+IlTZTEU9+fwkwS69FLyKgHAMLU/umRIF2LVEaKJaHX0lWNHtDjs2PJLJdFYPyLMIxShQYUMihSZqSSP+jBUwQYEbTH978VrvK+p/6c9/GFm2TTE/C+/TV6MTlbPJR0wWSAVF/1ybEcSWPIS7DIUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780078033; c=relaxed/simple;
	bh=gyISUfdsmX8+bCOukzAu956JSpWhDARDdGNk5yJUhr8=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=bsbBZp0CYk5jlYWU288AgfydDGJLTfAxqn9cTxpAb0NBiUpjmMUTAzZ0YR/Ra3b++D++UGyJfflj1RoQRYRaF87S5foRwGrcqM/jZovBWrjKr7ZXBUcb3Q4kJMfIdiopI9UdesxB8DRo/4zDgkSWnj8XFRCmqTW/iwNKpbaW5u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 9361D180F2C1;
	Fri, 29 May 2026 20:07:08 +0200 (CEST)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id +09uI8zVGWqmAz0AKEJqOA
	(envelope-from <lukas@herbolt.com>); Fri, 29 May 2026 20:07:08 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 29 May 2026 20:07:08 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, dgc@kernel.org,
 linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/5] xfsprogs: mkfs.xfs add auto|autodetect value
 for -d/l/r concurrency
In-Reply-To: <20260528045736.GE6078@frogsfrogsfrogs>
References: <20260525075752.4159504-1-lukas@herbolt.com>
 <20260525075752.4159504-4-lukas@herbolt.com>
 <20260528045736.GE6078@frogsfrogsfrogs>
Message-ID: <83b5632310b23658971064d9b97bb580@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-05-28 06:57, Darrick J. Wong wrote:
> On Mon, May 25, 2026 at 09:57:50AM +0200, Lukas Herbolt wrote:
>> Add autodetect|auto value for concurrency option to restore the 
>> current
>> default behavior concurrency detection on SSDs.
>> 
>> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
>> ---
>>  mkfs/xfs_mkfs.c | 11 ++++++++++-
> 
> Needs a manual page change to note that you can say -d 
> concurrency=auto.
Thanks I will add it.


-- 
-lhe
