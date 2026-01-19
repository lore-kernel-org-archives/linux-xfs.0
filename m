Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB72F2C11F0
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768844933; cv=none; b=T6Vxf0T5Esu4TT8fch4CoKIU99L3vGTTCuF15oLvFXfLVL6bF6fpgqguiuXl/8UqqNcQYUEhnUZInTgFCNes/INs/6e8rbbld+E/5Pu6dbuyNQ9OqzeZcxj9Jfn3Py4b3LzsyW2wDo77ZpSyopO9uwRZsW+i4RgH2BNsRzzWMa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768844933; c=relaxed/simple;
	bh=7lhi6dC4hjqb2o/WtHOmm6+TrckUAwWkajDHUNU3nls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=euY9eNzrsRAw7bl6DIVy8myGl9T0g6ZtPt4lJmEQwfydHQyc+oLc+vImGyOYb8PvTsR8us5QUQ3BmoOmbCZHsKokmw843SGrOPwh5nXEveChgV/o4HtzBAi5jeWJ0xbvLpIve6BevpOL92wRTBy7HcjrzxhfPKn0h9N7HZFD6ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FEoNrXLU; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FEoNrXLU"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34abc7da414so2787517a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 09:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768844931; x=1769449731; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kgJ96kKXRX1r9FKbMkdGhgK+mi4fabcbRigLxxVlAGE=;
        b=FEoNrXLUWl1W0FDDNeoLKKHshZ5aLrEYSpglYrkHxQxfk0Dq6cMIjrBDPOJ2v2Jtgi
         VZ9bwFoQf/78zhMfHecugwHiqYPB0544yk8HM3RyQbHxBjW3o688G4jiy55FyiV8Y4G+
         lLaMqDszsS+jIx/U6k1Tv0sV1RKX7/VynleQW+rm4xW7COF+PexfVYXCY+pO061QOmVt
         3L8r2fOhVhfDdTii8wTbam3qWB0/tYDhrHhhUweVinUSVszSmnL0rUNT2adjsmmDqSPN
         xcb/kcKd55I/hm43aljY1swSwWnquenUHu0jCm4ZMZAE3RWJG3ol9nScJ/IbL1540F9h
         rOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768844931; x=1769449731;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kgJ96kKXRX1r9FKbMkdGhgK+mi4fabcbRigLxxVlAGE=;
        b=vz6NDhtvDqYbWiD9WyJrIsHJAqNHmkcXYo3tJagkqJc5TCyHf2ZvBFubrMNYQ5NaXh
         jTBmYpAobgKPr6/UJOtzyZ6L6tfksrGJ6PTHZQTVtY+qxOGr1jTPoTyvOwn3zRFexmjb
         uCo12tKN30RmGgKaeU0F0nfXd7iRmMvlqY4qIDVpaF8CSk/L0zy2hlajrhj1dLpEeQU0
         F+RG11CEGY3AAZQzmAip0ebPqbJ4R9itXmpzXAOrv5XHV8Uu7cQwYKyIl8q/1kXjNQx3
         QCbpSekbg7HEYmBFkNuja6VKpNr6dvIUKOz7FWYus1nQJoVAKxnSMcT808TNQ62nvwPb
         nRcA==
X-Gm-Message-State: AOJu0Yzpc8EpUrHh0f6f3nWyjd0JIwzUW8RKzUxwBlvCFo8e8Q18zqtN
	UK4JXjsNwltOxEK5BcLpGK1Szl0rPpiyZwB7wTlLxUTE6gJ3RNvW8xMFOS16Jg==
X-Gm-Gg: AZuq6aL0cro1I6qGMI7jLeD4v3RIJzgJkIcaUyZFCdIp3mMe8QGwZ/xATSdYgZDaDqL
	i6p+n/IbbYcp/J7ANth2ZQKQTkT8NwxTB5PavTcTdVCcvVrYDb25cy9/2Xw2sXbJso3czLICA5t
	QOueB6bD5ybU/hRtjoGoE92gczDXcs3YziDQE6yBFj6wMV/00kLtiFe+F/+cOLC3pFcOfPJpr0x
	kL3nmTemfV+1odh3NG+s5aSOf5q7zdahQA1Q8jzpJegXFqOTG8K5dx52sZS9Hwr0jfZqKp2xFvT
	HlEcSNw8w8T+qiUda/SNbJSdstUm9/G7zunhsMmxLTC+l/O9u10kyInVTTToDJLb+vf5ApuTWOe
	U8r1kMuJdo/a818ANX8/bXNn8UEj/DUiHKGor/OBUBY/wAyeWpjIEwPeKHdnU71Tf8BWAP3FJL5
	aQ93V6ui3QLx/I2aex6nIlBQ==
X-Received: by 2002:a17:90b:384f:b0:34c:3cbc:db8e with SMTP id 98e67ed59e1d1-35272f891c7mr9345071a91.25.1768844930684;
        Mon, 19 Jan 2026 09:48:50 -0800 (PST)
Received: from [192.168.0.120] ([49.207.204.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3527313c2a9sm9841385a91.17.2026.01.19.09.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 09:48:50 -0800 (PST)
Message-ID: <d231892c-596c-4185-9683-db20ad442288@gmail.com>
Date: Mon, 19 Jan 2026 23:18:19 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] xfs: Fix calculation of m_rtx_per_rbmblock
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org,
 hch@infradead.org
References: <2e0f36968b112303466c5e07a88c7e9949f769fe.1768822986.git.nirjhar.roy.lists@gmail.com>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <2e0f36968b112303466c5e07a88c7e9949f769fe.1768822986.git.nirjhar.roy.lists@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/19/26 17:16, Nirjhar Roy (IBM) wrote:
> m_rtx_per_rbmblock of struct xfs_mount should use the function
> xfs_rtbitmap_rtx_per_rbmblock() to calculate the number of rt
> extents tracked per bitmap file block instead of always
> calculating it as mp->m_blockwsize << XFS_NBWORDLOG.
> When metadir/rtgroups is enabled, the number of tracked extents
> per bitmap file block is slightly less than sizeof(fsblock) in
> bits, since some bytes are reserved by struct xfs_rtbuf_blkinfo.
>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_sb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 94c272a2ae26..b2b4d7f21a5d 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1268,7 +1268,7 @@ xfs_sb_mount_common(
>   	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
>   	mp->m_blockmask = sbp->sb_blocksize - 1;
>   	mp->m_blockwsize = xfs_rtbmblock_size(sbp) >> XFS_WORDLOG;
> -	mp->m_rtx_per_rbmblock = mp->m_blockwsize << XFS_NBWORDLOG;
> +	mp->m_rtx_per_rbmblock = xfs_rtbitmap_rtx_per_rbmblock(mp);

Okay, so there are some build failures with this change (reported by 
kernel test robot). It looks like xfs_rtbitmap_rtx_per_rbmblock() gets 
conditionally compiled and xfs_rtbmblock_size() takes care of the 
metadir enable/disablement. I will keep the present code unchanged and 
cancel this patch.

--NR

>   
>   	ags->blocks = mp->m_sb.sb_agblocks;
>   	ags->blklog = mp->m_sb.sb_agblklog;

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

