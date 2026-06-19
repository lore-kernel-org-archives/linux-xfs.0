Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809B538D68F;
	Fri, 19 Jun 2026 22:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781908049; cv=none; b=D2ACbYofy5/y2J01ZzK4W0azVUShvjhfUKZn3SoCoX7/p3eIXiJT9y1xIaXjzzGf37EwWjfK3AHHib/QXmTBnZ1x13kGXWhX6frA20c5tDeqaO8JVO+g+gYvD0Q+ytnxKsbcuy57o0yw442ksRTvZ/2oP3La8cNgUSJJ1TBmaws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781908049; c=relaxed/simple;
	bh=s1kvFkQjOFC5MQQyiaescXfXUCNWDgeb0svHXyiETn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XnlWi0A94Dn0KubryR4EXmPTy0n0eqzIkiVKUE7S5GL7vsq01/p+S2kW0eeCxM5jRzzDRRn5iMdKgBYZkM+0wuVEwZ3crJh203R1Y+1KAW+j3jmH89QMAc5+WO1UhmDghgWNDnkPkN5wP+55KaQL939VU2Hn9zt7IW7jLk63Cqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=WZ0yb5DV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XgB77s6x; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="WZ0yb5DV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XgB77s6x"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 9DC37EC02AE;
	Fri, 19 Jun 2026 18:27:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 19 Jun 2026 18:27:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1781908046;
	 x=1781994446; bh=1Bpuvba+EhaQK0qSqTdLfDei81v8rnRwRb2t8L0Kj2E=; b=
	WZ0yb5DVxZRn3kNqPykO1nr+yvTJKq6aPqzQND/jxv45kdkPhKiiZh6iVRvvOd//
	TeyAKPM6Ihf7gZCTauzW8edMHxJ8wWToDuNwQM2GuZINNv6avuws4OGUCOAPA6zF
	T6XFEDxunqOL2/GSMVEiIGweze0HJzF832zeeZJBD6ZgY9GVy+oD/3AawI92oW1/
	WGP7M/ZLcENWsPD5C0c/abed8gIolEWRjtio8qv2KU2pjEMUBvc1BIZWs/CJfmjp
	byw5mJGV6laaGZAHzAPxZgFGFDrrpQ5A8am+Z7F6O+e/9kP00B37g7EyQ4MckSCY
	b37hT3i/YvJRb09VlkmQ8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781908046; x=
	1781994446; bh=1Bpuvba+EhaQK0qSqTdLfDei81v8rnRwRb2t8L0Kj2E=; b=X
	gB77s6x6eAOKaHAdyXU3M9SiKXgf4GgA9FleT9JYwOpRJsq02Y94PpTzPM+N8n8t
	tylgmWf1eeNoi2YWhSphk7oU3hPKMp5F3hxqosAXblTRSAPFQBE4LHG/H2YJNrCh
	OlNwJwbPDVwmOVAE92XQCWT8gmVGgdX4JG4aBCYGLXV8O/1+e6N3bAyPzZO8SIhC
	OpQAhsU7B6f0bz8Fwx+V7SCqQ8qz8vdDpH8v4bJzszBPQxZZ64LnZqb/Phth2jUu
	siOstPgLiRXeFYrfirzOMbNOCUigiZNftfQLSRUeIDzjP5qwCBING3ArDzLTu3s0
	ZOnLy31nikwQxQW9CmCxQ==
X-ME-Sender: <xms:TcI1au7Mc-XGj_TbzNfiipBnfIf67TACd79lp1Kev-5t7rQqtH156w>
    <xme:TcI1aomDg5p53_70Wer6sV0ClQ7uLHM4hvhFIASDh7ccVlmMHEFUVCOQSm_XMx-eH
    pqG7nwtY8AZRgISH_Fo7qUxmiFfHPvEY0B53-UxHqeFQ8qEsr-uOw>
X-ME-Received: <xmr:TcI1arrrLEphix8fkmC7k7aq12yvBjiiNGGo6Cm8JXYuXf-Sb4OivIhXG-vU1B5qUrocTvpLVTDvoabMFL6Ja_xm0SpitQ>
X-ME-Proxy-Cause: dmFkZTFA/LU7RQGfijZWEcXJNYRsjlpAzCCkVCS/Mia+kJRz4LJxVrEc6d0IYkxkoqqGeS
    wLzNmume8i9Cu/AF2WywGiYAgzkwA2r247u1rxsLiPU0lHfNocBw+KeE7SwU/AhYn3eaiw
    bZCINOIgki/GGZuyCYxUJ8CGhmZ9VI94JDapDaUBK7G5Z9/QjIK3lN10B9nKB269Af75b7
    AJoersKBzu1B3OmBhCX8KO2kRBxv2NGqb+GqDhIWjWOQ8XW6XiBDGT7QomCnJ+NuugIOpT
    gfa0xkOBWofpxMzoqRVPYmDHeXpmJmjBNU5TiV/MHzcwwooZcvJ7ahTr/jwzXZpSV2HgIy
    64k8uZIdoU9h3t+4/e60QeymujVj/g98usDomcjaX8dpkQieh0vWuZrJ6+1kNO3Wjm0ufk
    BsZcvNeEFD2AgqxvqVkZDtmC9LaGPoeQC/4sZ5Hd/ifm2yP/v9y6r8YnwhI/hQYlicKsSP
    RHmnNQARBIgxkXJyDoATIhq+uFjp68FJikRjDyL/XKFcTjQTcI9AgUJl706I1Q+eHUX/BN
    kfuXHMfU1/WvdKZUHmS/zx7LuOR9qS3TAst5M+aArT2aK2Db2mNa/xu0kp9JgcGEQsnoKZ
    R6OerjpeiIxHIi66hCxPDpscHMFm1mG4oXxQlhz/uI4RUXUn0J1F1WrNGpUA
X-ME-Proxy: <xmx:TcI1avvZrt4jzzlisynuHWg1WxxInwU3Jkohn8f1YTVZ72rpJkMMeQ>
    <xmx:TcI1aoGtiPnCOKY4me---CcoQGe4Ute2acvNlr7qtzhv4Kqd6Sv1Rg>
    <xmx:TcI1agbBaGpuI9KAa2klcgenzLV8C5xv2m-HLbGnCV_GuPbIA66qxw>
    <xmx:TcI1aoVRGiVm4kiriH8mnuipDtFR6i0dkCYkjktNJvNBngq6Yzh6uA>
    <xmx:TsI1aoWmX_WTYbVh8u83hz0xH68ciBEXN5gQDGmmvrPy6_OUzy9mniQt>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Jun 2026 18:27:25 -0400 (EDT)
Message-ID: <920faac0-2841-4d7b-95c3-135441d0ea7c@sandeen.net>
Date: Fri, 19 Jun 2026 17:27:24 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs/078: disable all concurrency scaling
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Lukas Herbolt <lukas@herbolt.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20260619050937.444488-1-hch@lst.de>
 <20260619050937.444488-2-hch@lst.de>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260619050937.444488-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/19/26 12:09 AM, Christoph Hellwig wrote:
> Disable concurrency scaling to avoid mismatching output on systems with
> a large CPU count.
> 
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/xfs/078 | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/078 b/tests/xfs/078
> index 6057aeea12ab..408170ae57f5 100755
> --- a/tests/xfs/078
> +++ b/tests/xfs/078
> @@ -57,9 +57,16 @@ _grow_loop()
>  	$XFS_IO_PROG -f -c "truncate $original" $LOOP_IMG
>  	loop_dev=`_create_loop_device $LOOP_IMG $bsize`
>  
> -	dparam=""
> +	# Disable concurrency scaling to avoid output differences due to large
> +	# CPU counts.
> +	if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> +		mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
> +	else
> +		mkfs_opts=""
> +	fi
> +
>  	if [ -n "$agsize" ]; then
> -		dparam="-d agsize=$agsize"
> +		mkfs_opts="$mkfs_opts -d agsize=$agsize"
>  	fi
>  
>  	echo
> @@ -67,7 +74,7 @@ _grow_loop()
>  	echo
>  
>  	echo "*** mkfs loop file (size=$original)"
> -	$MKFS_XFS_PROG -b size=$bsize $dparam $loop_dev | \
> +	$MKFS_XFS_PROG -b size=$bsize $mkfs_opts $loop_dev | \
>  		_filter_mkfs 2>/dev/null
>  
>  	echo "*** extend loop file"

