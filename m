Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BD5214A74
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 10:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742553620; cv=none; b=M8eKc5504scuTWsnMwc09j1qhfISfoJvsMOZabuV/adZvnWF5FNfChIDpoeC6F315EiH/R7yC62vzjVyao7DjPXULia0Ix2IwjNe0ms0MJPxu1C8vmX5nokVR5WL93uvtN7yQi71d/0/gWW8mN32rFhDqoKr6X9GdjGc4/XbS1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742553620; c=relaxed/simple;
	bh=keA/OUMh59tK1p/3eBBG4OZqcXlEJyFeb3vnd4dJmL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWnuS+aSLYe6+CnnOLePGSr1XAxXHydOwmELz/ok0vTvuNks8+7Zelv1x/+Dnxa1f+/ydZyl5I7lGmsAB0PDBbDcG3pEctKZtiUfKv+hnXlZS6kO6ZP8lthK9mwuSfIhKDrD/bt6283inuGeefE4v2uEE09G0/zX91XkSv2bj64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OWvSIoaN; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OWvSIoaN"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so18975535e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 03:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742553617; x=1743158417; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ixNuLvanyaco0wQA7vSAFL278mg24lB5E/26HJbUbOk=;
        b=OWvSIoaN17uJIFGeximEWmSypjCLOOxyOkD/UBvtG4S32O/rUk7YrqVH5u6FR38rw0
         tlXKDhRyl/1tSvQxC0BDAUQrn2U0iO6jMOUazEP6I2z5TbtaF0UhimvAu/c0SxaTPVg+
         mrdr5psDq9KidffnqSYbIqBep4rup4fYudfpsJBVgLGxa59QAupIEiyk4htH2hk/NNjU
         mGeBi57FkBdcUhYrMvAkyMFxtvNH4+hFqnt9ntCZZwIFQcJ5VcWGl7tC43CptD/odQVN
         S7v0+8l1c5qPFAs/pYkeCjYOm8uvcNIfuhCmB202Ant2c8iym0yO9wf8PxA2/t7vJRUt
         fL3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742553617; x=1743158417;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ixNuLvanyaco0wQA7vSAFL278mg24lB5E/26HJbUbOk=;
        b=Y0Gj4/qyfvjeYPjYdZueAYIUFhzYhgUCKAaD13flFjlezp0VGD5btn+D6CBZ8IExGE
         pg1x14AtRX+TzRJKxKPaG3Rxtc8IZPSvo6PAxWDp7L0eC7CAtTCTcHlDCwlPCK5tAYDR
         5ukDwQ/l4w5lJq2WglJzivyE4OiEbyffXLCf+inb9vOqOp0aInz0fRYk/o1CVrn983qn
         /2ZPGhVujPSilsn/KtY6ueyNhiIqfdCAIdrV2jOaDB85Bma6vKtWUXEytFoxo9QbW1zc
         bFahL8KY5gA9nwPegWsWat1lNGl+b0PQrze5JJWqAa9068HkUPJUqpikuvcFuuCPFfep
         6brQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLNHVEqlST8m8ONSDILINPXmjgA4dvLzdbsyyPcbfzTEXZ7nUHXQ30sxSwaWW7unfgGibF4qBCpd8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw28WYK7GIKyERAAY3Qy7b0XUaX/89XsUEFYNboyM8MR2/xn/1m
	3MvIrcvtsetJwHrVr3N8KHUdibJ7aOUt7HyM5ugHIZQswDcweaVBEwC8uOANiVM=
X-Gm-Gg: ASbGnctScSFogGx/QnsIZNFGL6Gqrp2kTHLNy56F/+y0tFMQnLJOb3CTl2NjBfd5k1C
	9i3S7c0aSUEqLAloFdb2iuSg4jBhy18J/YmDR8KMdvHI5PudeIB17AVKhnjtUJp+jaH+FOZAtJJ
	5jn+QdQeSdAvJLftCmgaww1MKpeVZ25PFSvtaJ1Gsa4kxomg1MbV7rViPzsDzOQV4L/j8+1y9KV
	TuUFtv2R/U01QzfGjYuZ8lLD5XXyfUMlEIUXFVKTyERBTw6FPgnhCj+WP+vgsY2g/BR8VLQnmc7
	vKpYwUuSjGLTndqqZmEmTplzGei8R7u1kosKXP/fc2FsZfP6e0TXrshN5aIzirsHZdoj8eXFeU2
	CtZKJbNjujAgrhfa0flXBU5QiM+0RxEwlJwNRbiQvz7/DaYDp0ej0+bwYvu6Q1A8GMy+1R6Kfc3
	RP4ySMoZPpS2rks3Bvvg==
X-Google-Smtp-Source: AGHT+IFCqrz8IcuX+/4i1bYx5eOZ2uB/Ha8J127JzYPmP+M7dpcQDBa++6sQn9yPNG9LbJAG+/olcw==
X-Received: by 2002:a5d:47a5:0:b0:390:f699:8c27 with SMTP id ffacd0b85a97d-3997f902e3dmr2570376f8f.12.1742553616661;
        Fri, 21 Mar 2025 03:40:16 -0700 (PDT)
Received: from ?IPV6:2003:ef:2f1a:ea00:b220:7501:321e:5c31? (p200300ef2f1aea00b2207501321e5c31.dip0.t-ipconnect.de. [2003:ef:2f1a:ea00:b220:7501:321e:5c31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d440ed4cbsm74522575e9.34.2025.03.21.03.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 03:40:16 -0700 (PDT)
Message-ID: <2136af4d-d224-440d-85b9-2abaaac501c2@suse.com>
Date: Fri, 21 Mar 2025 11:40:15 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] ioctl_ficlone03: Require 5.10 for XFS
To: Petr Vorel <pvorel@suse.cz>, ltp@lists.linux.it
Cc: Li Wang <liwang@redhat.com>, Cyril Hrubis <chrubis@suse.cz>,
 "Darrick J . Wong" <darrick.wong@oracle.com>,
 Amir Goldstein <amir73il@gmail.com>,
 Allison Collins <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Gao Xiang <hsiangkao@redhat.com>,
 Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20250321100320.162107-1-pvorel@suse.cz>
Content-Language: en-US
From: Andrea Cervesato <andrea.cervesato@suse.com>
In-Reply-To: <20250321100320.162107-1-pvorel@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Petr,

thanks for checking and finding the issue of the test, it was really 
helpful.
Acked-by: Andrea Cervesato <andrea.cervesato@suse.com>

Kind regards,
Andrea Cervesato

On 3/21/25 11:03, Petr Vorel wrote:
> Test fails on XFS on kernel older than 5.10:
>
>      # ./ioctl_ficlone03
> 	...
>      tst_test.c:1183: TINFO: Mounting /dev/loop0 to /tmp/LTP_ioc6ARHZ7/mnt fstyp=xfs flags=0
>      [   10.122070] XFS (loop0): Superblock has unknown incompatible features (0x8) enabled.
>      [   10.123035] XFS (loop0): Filesystem cannot be safely mounted by this kernel.
>      [   10.123916] XFS (loop0): SB validate failed with error -22.
>      tst_test.c:1183: TBROK: mount(/dev/loop0, mnt, xfs, 0, (nil)) failed: EINVAL (22)
>
> This also causes Btrfs testing to be skipped due TBROK on XFS. With increased version we get on 5.4 LTS:
>
>      # ./ioctl_ficlone03
>      tst_test.c:1904: TINFO: Tested kernel: 5.4.291 #194 SMP Fri Mar 21 10:18:02 CET 2025 x86_64
>      ...
>      tst_supported_fs_types.c:49: TINFO: mkfs is not needed for tmpfs
>      tst_test.c:1833: TINFO: === Testing on xfs ===
>      tst_cmd.c:281: TINFO: Parsing mkfs.xfs version
>      tst_test.c:969: TCONF: The test requires kernel 5.10 or newer
>      tst_test.c:1833: TINFO: === Testing on btrfs ===
>      tst_test.c:1170: TINFO: Formatting /dev/loop0 with btrfs opts='' extra opts=''
>      [   30.143670] BTRFS: device fsid 1a6d250c-0636-11f0-850f-c598bdcd84c4 devid 1 transid 6 /dev/loop0
>      tst_test.c:1183: TINFO: Mounting /dev/loop0 to /tmp/LTP_iocjwzyal/mnt fstyp=btrfs flags=0
>      [   30.156563] BTRFS info (device loop0): using crc32c (crc32c-generic) checksum algorithm
>      [   30.157363] BTRFS info (device loop0): flagging fs with big metadata feature
>      [   30.158061] BTRFS info (device loop0): using free space tree
>      [   30.158620] BTRFS info (device loop0): has skinny extents
>      [   30.159911] BTRFS info (device loop0): enabling ssd optimizations
>      [   30.160652] BTRFS info (device loop0): checking UUID tree
>      ioctl_ficlone03_fix.c:49: TPASS: invalid source : EBADF (9)
>      ioctl_ficlone03_fix.c:55: TPASS: invalid source : EBADF (9)
>
> Fixing commit is 29887a2271319 ("xfs: enable big timestamps").
>
> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> ---
> Hi all,
>
> I suppose we aren't covering a test bug with this and test is really
> wrong expecting 4.16 would work on XFS. FYI this affects 5.4.291
> (latest 5.4 LTS which is still supported) and would not be fixed due a
> lot of missing functionality from 5.10.
>
> Kind regards,
> Petr
>
>   testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c b/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
> index 6a9d270d9f..e2ab10cba1 100644
> --- a/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
> +++ b/testcases/kernel/syscalls/ioctl/ioctl_ficlone03.c
> @@ -113,7 +113,7 @@ static struct tst_test test = {
>   		{.type = "bcachefs"},
>   		{
>   			.type = "xfs",
> -			.min_kver = "4.16",
> +			.min_kver = "5.10",
>   			.mkfs_ver = "mkfs.xfs >= 1.5.0",
>   			.mkfs_opts = (const char *const []) {"-m", "reflink=1", NULL},
>   		},
