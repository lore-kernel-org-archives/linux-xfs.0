Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C719B58F079
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886442; cv=none; b=oSHKJPHCJT2oKnC2krQ1Mf8F9Jc4OLGbjRJSileV73OJh7TMZW82e7og0BE0zU3rOCg+qc9qKul+VowGAWXkNfd0MytJRplui2PwROlkaoCAJklnoiYeWG804umROmEX6bvV1P6WN3It8cUwUa84XDlUxW4Oq5dU8s6wypiRQFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886442; c=relaxed/simple;
	bh=BICT67ovd2dSHR44m80ZgblQifcQ1jU2SSeT3yJh/og=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gNJu5Jwu03NhmMB6wtRrR9C656l55Ya3ZBwPpy3srOW8BJN0QaDeUp66ftNxquhRZhGDiTnZ3a3B+VItwH/19hB59XlSIFqABdfWuyQSg+8Tnlw5464s5lHGu5OrVK1u/cVpsxm1GI8WelyAQUD4u5MKrhHKSheEKV1sfC8vwm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=IVuWP8Hf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nPMpgN6t; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="IVuWP8Hf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nPMpgN6t"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 9CB79EC010C;
	Tue,  8 Sep 2026 12:53:58 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 08 Sep 2026 12:53:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1788886438;
	 x=1788972838; bh=6aJ1Ux7jKNVDf+a5xaYh8X4uiDc7ZOI2B7o2OULEw6w=; b=
	IVuWP8HflRDig49rJVmUe2KVX289wiW4/MOb43hMwcj498SgU2ag4Ntw9RQequcs
	++zwPfXNOthQlCZ2V5nDsm2saTUEC+ucbkCeTYZ0ybXCipTZQQ5J6DGJ+HdpEEji
	lpT0TvPvAyJu+x2t4KeFxn/aDsZUA6O0Y9DtGaTJE5z+Aiv7EdoLjqPHs2hPl9LQ
	wCHSC75VuWY2KdUMLLVwwISLLlphQO7YdcZfthXpDim8/cLhYFTRcMI4aLBQ1S3C
	eCUZbFc4bCGgHR3ApQCyXhoMjmsFTBDXqUTnhw8hTJlUZiD45r3tJ+gJznteUnIF
	sfQ9DkKVRMox6JKDOTrrfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1788886438; x=
	1788972838; bh=6aJ1Ux7jKNVDf+a5xaYh8X4uiDc7ZOI2B7o2OULEw6w=; b=n
	PMpgN6tcN3oKsb8BAIRLgcZUzYPeBLrrgxQ9ISBNSQ/CqsDFOsBiwyAyVNk6fP6Y
	zmCDnvdhvlIR3mP1VaaQW3MOyjDvujETZekulVv6wSn/VxrEpgvWsIaG9WHGLznQ
	2o1P/5JaYHE2RjwK6LiJJGlrudj35IXcjnRqSeSRY0pBCOA9mtR/VoiKm0lx9DIN
	nhm0tyo0lFHxMqMhI25QrgAbdzlVT/qeE1S6AHaW4KnTHuUVTp/OBVkdg3y/JjcW
	XkW2S8DZVUU37JBzZ91ZFfP9Q59HyeLyu11+aFEl2JQzcgF2HyEoGcBpWRNh/X5T
	cF/Zuw+nXYhwRI6Eji6Kg==
X-ME-Sender: <xms:pj2gaszR-p9JDGSiNcoL1UsgqFlrR62ZW_J9CM3_q82JX1phQaE8pg>
    <xme:pj2ganRchymaZ7f7LgaCJsODdVK60baHnhIAIlmwLogVmCbgOWEnUA0Gsm4OzSEQo
    pJNFddryundllqCwzisB-4E71_QF2OQwpbkfIaLT-kFRlU4qw7GbPyr>
X-ME-Received: <xmr:pj2gajWjjIzaqaEDFFbBV2vncYWXq6WH28K1vvdPb5a4eCTWiMQBcOBYZ1kKdyHP_BAbdNrn1dfP0LpoJesc1Efk>
X-ME-Proxy-Cause: dmFkZTFWBrhwg+Pz7iLtfDikEyi4ziMXLhVcT2sXxVzdT4xXvlCtyZYmcn0LX/txwGyHeQ
    TAdcNDGEH5hz2uPUTrzeOv1G0xnCB/l2xYhBaMLt7l6ooc937RqtiXpJdKt5p8ne/DkVGu
    mnJC/sTyMFcuC6M0I9l8ojbM77CWQgChG0YnSbCOkKfYvj6xY1XPWvonYo9AoRaCZVeZzH
    Sp5eGTmP8gYHiFo3hJagx8kyTdCJzj6ySADGppnA95t9+40dj2EuLzytV1MerAINHEF/w7
    707e08mRIxyLRSu/s8zAoRdLN5zYozzuaa2fFoSPl2BVFxMh2kWCDEfXXmLTeM0RFIX5sn
    V9JaRYgfeLHZjlYWUYPTPBFZNiKYBWB/LwhwndDwHa2fnefP2RCZxCVQRgRXbr4gOrE0HZ
    yLQCLrpK0wKz7hl9f331YEQtzk/SfuMibhmFAm2rytgIuxtISSkRSl6pYER0l/VfIpcZZf
    TlNhbeLJfLEe/FY7JPzjrUQlF58OjtdGsy8RvacWHF5Xh9gRpmbajJO99PHZt4gSlcoKrl
    VXD8IZ4AqrPc2TsO6nQiNNzC/Ua0SpxT1sg9h+7n5yFQNUgbImY/wl4NqIyxL/q7qaW4bt
    izeDJDQ26YJ7AcYkybXsk2yUk5a1JkHEAnq/cvlAMyvpKBjDaZpaClrDqfpw
X-ME-Proxy: <xmx:pj2gapYpf3ZXSSU3vSfPN0xX8eDeB-9CrPLVkmdxf3ie9izdbBKnXQ>
    <xmx:pj2gap2uCss_9STjbtILcBAtkv8E0hUoZz_kRULcsh_fWYu_oRvsZQ>
    <xmx:pj2gari0v3l80fAloyWGryRNbAvg5WT8zLZ1KaG5hYemWLw09RI4bg>
    <xmx:pj2gatZViMS-K5wtYRRsyoLF7GN-J6LGkrw_08eCKKaDQF1XqfQOkQ>
    <xmx:pj2gaiEELumA4rP-a1u3w_KhepzbeyqRtEH2YHmjcLBeC6fe-4ODaoME>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 12:53:57 -0400 (EDT)
Message-ID: <8a9d507c-f060-4f78-9035-5393b633df11@sandeen.net>
Date: Tue, 8 Sep 2026 11:53:57 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] xfs: add xfs_error_report the ability to display an
 error code
To: cem@kernel.org
Cc: hch@lst.de, djwong@kernel.org, linux-xfs@vger.kernel.org
References: <20260908145422.232985-1-cem@kernel.org>
 <20260908145422.232985-2-cem@kernel.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260908145422.232985-2-cem@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/8/26 9:54 AM, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Users could opt to request an error code to be printed now.
> This relies on errname() and CONFIG_SYMBOLIC_NAME without requiring it
> to be enabled.
> Report 'unkown error' If CONFIG_SYMBOLIC_NAME is not enabled or the
> user passes 0 as an error.

s/SYMBOLIC_NAME/SYMBOLIC_ERRNAME/g

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_error.c         | 13 ++++++++++---
>  fs/xfs/xfs_error.h         | 10 +++++-----
>  fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
>  fs/xfs/xfs_inode_item.c    |  3 ++-
>  fs/xfs/xfs_log_recover.c   |  3 ++-
>  fs/xfs/xfs_trans.c         |  2 +-
>  6 files changed, 26 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index dbd87e137694..3177ec58bb2e 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -14,6 +14,7 @@
>  #include "xfs_error.h"
>  #include "xfs_sysfs.h"
>  #include "xfs_inode.h"
> +#include <linux/errname.h>
>  
>  #ifdef DEBUG
>  
> @@ -377,15 +378,21 @@ void
>  xfs_error_report(
>  	const char		*tag,
>  	int			level,
> +	int			error,
>  	struct xfs_mount	*mp,
>  	const char		*filename,
>  	int			linenum,
>  	xfs_failaddr_t		failaddr)
>  {
> +	const char *err_str = errname(error);
> +
> +	if (!err_str)
> +		err_str = "unknown error";
> +
>  	if (level <= xfs_error_level) {
>  		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> -		"Internal error %s at line %d of file %s.  Caller %pS",
> -			    tag, linenum, filename, failaddr);
> +		"Internal error %s (%s) at line %d of file %s.  Caller %pS",
> +			    tag, err_str, linenum, filename, failaddr);
I might suggest making the printk conditional, rather than making err_str conditional.

It might make the code messier, but the entire purpose of this change is to give
the user more information and a clearer view of what happened. Changing
"error 93 at line" to "error 93 (unknown error) at line" doesn't really do that,
and IMHO adds confusion and adds no value.

It sounds like the config is typically enabled, but I'd still rather not add
extra words to debugging printks that add no useful info if possible. It may
raise more questions than it answers.

overall I like the idea though :)

-Eric
