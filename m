Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72632E54BB;
	Thu, 21 Aug 2025 16:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755795265; cv=none; b=ZmF+JiFhphpCkSQEA/4uVZjETsbMQJenfdnl1h14qX0TEF1MMGwYqMNVkoFfH0MfEi0XNQ+N+VekecRR+e4t1TfbgtjNAG7mZNg/ImWN9pSn083oSDhhvpYqd/2HhEDxo7GIn342nrG/DkefFwxjYnky5Qk8ZJI4Qwseyre9jZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755795265; c=relaxed/simple;
	bh=bt+tEXL0o101qeK29J89ca1C04CoxJ9sH7VeW3cYQKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EAm2imMrWgVR5inw2nq6hn927RJslgp4CvFi83La3QH0u4mUREoJt6uurL/Zr77Eak4RvC7V8/qkqaBAxaKyGKYadyHWlIzpyTrP/OY5OB6OT68yBEmI6GWoWNMt8jf3nbl3l7ODlg80fxQ3ZJNHDBumozfBi7zOa1Wzph17E58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j7N/qHGx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j7N/qHGx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=iPnqnQzbSMv2nhZCkJ+MksbPL9Ipc1Ay1hgUjybJex0=; b=j7N/qHGxtBYJNa/3bQfGE7Dpq8
	C0AkCqRoODmVcHqxNuf1AZ1S6zDgM7GrBDe20pAxKQhO8n2IJ0nRcwwwZbzgrKp7q8xAONQBvTo71
	rYZnvAv1fqb2+mBhSvGPTJT/kwR3AE4ozokyGAlnMPnSLQC/zQbFYoR/9n+WcRExXe/nPcgf3EeZ3
	fxi6lEkxQSaM1eVFLeFdElUeVTaw3PyEcLyuZNAcFZbEJ+LCyyW1NZsPmWIsXWAZX6/TBECQfsYOl
	VJGVx+7Alhgt4zkyuxRuztc7AIqb2x5IZ/itCBmiVCnWqBrDQaD5nB106DYkTdjE/ZkqRtB07YS53
	ds1wAtOA==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1up8YP-0000000HarF-22Ao;
	Thu, 21 Aug 2025 16:54:21 +0000
Message-ID: <70c48801-83fe-413f-8a8e-5db71c8d1c8d@infradead.org>
Date: Thu, 21 Aug 2025 09:54:20 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation/filesystems/xfs: Fix typo error
To: Alperen Aksu <aksulperen@gmail.com>, corbet@lwn.net
Cc: linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org,
 skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
References: <20250821131404.25461-1-aksulperen@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250821131404.25461-1-aksulperen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/21/25 6:13 AM, Alperen Aksu wrote:
> Fixed typo error in referring to the section's headline
> Fixed to correct spelling of "mapping"
> 
> Signed-off-by: Alperen Aksu <aksulperen@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  Documentation/filesystems/xfs/xfs-online-fsck-design.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> index e231d127cd40..b39b588bb995 100644
> --- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> +++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> @@ -475,7 +475,7 @@ operation, which may cause application failure or an unplanned filesystem
>  shutdown.
>  
>  Inspiration for the secondary metadata repair strategy was drawn from section
> -2.4 of Srinivasan above, and sections 2 ("NSF: Inded Build Without Side-File")
> +2.4 of Srinivasan above, and sections 2 ("NSF: Index Build Without Side-File")
>  and 3.1.1 ("Duplicate Key Insert Problem") in C. Mohan, `"Algorithms for

In the PDF that I looked at, section 3.1.1 is

  3.1.1. Duplicate-Key-Insert Problem

if it matters.

>  Creating Indexes for Very Large Tables Without Quiescing Updates"
>  <https://dl.acm.org/doi/10.1145/130283.130337>`_, 1992.
> @@ -4179,7 +4179,7 @@ When the exchange is initiated, the sequence of operations is as follows:
>     This will be discussed in more detail in subsequent sections.
>  
>  If the filesystem goes down in the middle of an operation, log recovery will
> -find the most recent unfinished maping exchange log intent item and restart
> +find the most recent unfinished mapping exchange log intent item and restart
>  from there.
>  This is how atomic file mapping exchanges guarantees that an outside observer
>  will either see the old broken structure or the new one, and never a mismash of


thanks.
-- 
~Randy
