Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=5.59.97.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652152;
	b=ey7REXYiFnW+f7bfGtqkpX1VYzkRoKQ7c/S7cNCDhJydyzKGMCABKfy4sklg/OLteImm
	 WMxq5VooHscQ5vPTe914U4ULqw7NDzleeisKj7V87PmxnG2uy5YR5QJgqLVujsSiz1Ok4
	 hrFXg5rmdbS9li5RWUxs/Tf97oEYTfurZ54ba7+Lxz8+/5HLwcEqkVEWYhQ7dQwK6ct82
	 bhh+SNlNoyof9Hq91bPTY8yF2s1b5tL76imA3r7+QTFgmdtLloPGjPfRgI73rJxhfo5XC
	 1/W7P/yaaZc+mAfbqX4TTr/wZuZOrLa01a0tWY0lGRw/NX6pXbjrVqnttAwfLSgojPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652152;
	h=DMARC-Filter:Received:Received:MIME-Version:Date:From:To:Cc:Subject:
	 In-Reply-To:References:Message-ID:X-Sender:Content-Type:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=wsgqg3ipvoHzFtyMvNJklAHGTqSyJ+bX6cJoSVX2hoM=;
	b=keH554IalNydkr29Btj7Xui/AT3W60LKcg/R7lWxLHGrXIund9BN5x8KvrmOmwPrVgbd
	 wnWnvB+ca6TTOtM0zqdbItMoaRAexNy7saZEJXlGvROXJGdf0RFgJIWTPcx50S881mYCM
	 jSPPjdPVnRQIrlPtHW1d34wlvjWWoDDjsaU0xMUghbYZvynTNhfOAwen4UGtwt+pubMjj
	 AS9wUeTUCUE8z8AMqpub/1/bvp4d9gKZzgoueJ2tcSZhWiqSxdi3xRy8HjuVb2JyxpZ16
	 UHjKHXRuK0oqFoB4tos4V2coSNBP/DykSzjrZqvKHYH8jRIBLPh3WPD6aztwEackWzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=herbolt.com;
	spf=pass smtp.mailfrom=herbolt.com;
	arc=none smtp.remote-ip=5.59.97.199
Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F54B606A326;
	Mon,  2 Nov 2026 20:42:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F54B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id DC04F180F2D3;
	Mon, 02 Nov 2026 21:42:23 +0100 (CET)
Received: from mail.herbolt.com ([172.16.31.10])
	by mx0.herbolt.com with ESMTPSA
	id NAz8MK/16GpYHQcAKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 02 Nov 2026 21:42:23 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 02 Nov 2026 21:42:23 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: fstests@vger.kernel.org, zlang@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/619: fix mistyped seqres.full variable
In-Reply-To: <20261102081156.640279-2-aalbersh@kernel.org>
References: <20261102081156.640279-2-aalbersh@kernel.org>
Message-ID: <6414c0a66a3708e7793810c8ffe7df59@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-11-02 09:11, Andrey Albershteyn wrote:
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  tests/xfs/619 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/619 b/tests/xfs/619
> index 7e542f705e60..583be7160be2 100755
> --- a/tests/xfs/619
> +++ b/tests/xfs/619
> @@ -36,7 +36,7 @@ file1 ---755 3 1 /dev/null
>  $
>  EOF
> 
> -_scratch_mkfs -f -n parent=1 -p $protofile >>$seqresres.full 2>&1 \
> +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
>  	|| _fail "mkfs failed"
>  _check_scratch_fs

Looks good to me.

Reviewed-by: Lukas Herbolt <lukas@herbolt.com>

-- 
-lhe
