Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24E335675E
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 14:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792160785; cv=none; b=BrYEw7v9Tt4fV4FXCDXDBlMP0bJf2PNwhJ8VVth4fWcWKnFyJA16ZL4zw8nccNJKfHpXDqzTOpnz4yRyA1mtKhJrPrWjTcGmpqm81EYf+X0CdjalcsPfcTz6oQh8qt8T6vA4N6C/aWaDd6A9FShpaI2QDlcdCKZrQIJ/M6eIBEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792160785; c=relaxed/simple;
	bh=lXVHjPCAYcLXVIhcGLWvijxrbTsyM32zfBe8H9DOsBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n1leLH+ea8iIBA5mLmE7OvFUo22DDk0NJtzJNBACEPYY2YPDa1e23OmSk4EteffT6teY7y21BZX7RL/Pap/PJJR7mqdU+Gn8TxWHbulXmt0MjDCK06+Hi11ODqnS5ot902btr/zzH4Zz/xD83JO5UBkSrkdlj2TKDR6CZe3gw0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jFXyWep4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ni4EBfi6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jFXyWep4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ni4EBfi6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792160782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uv7dkC3MPmwvohP9wCGMJdv25KGLHW3gqkljVo/xMA8=;
	b=jFXyWep4jQ9IhOUvCtqHyBUzA2JseW7eZxo1MAsdXuOfEdlbavHs8Y0ZHx2oGo/tl/q/MV
	Roj15ClFG0HPipXmuaj+8/WP5RpgXW+0PLEryoE+TT24HOmJb1CMyPDE/r42Tpqh77spAt
	w0FNccXwyBiajnhn7d6HQEXwLYVB8JE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94--rIYcROcMiWzooGdnaiw7Q-1; Fri, 16 Oct 2026 14:26:21 +0000
X-MC-Unique: -rIYcROcMiWzooGdnaiw7Q-1
X-Mimecast-MFC-AGG-ID: -rIYcROcMiWzooGdnaiw7Q_1792160781
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-917a510b22fso709776d6.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 07:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792160781; x=1792765581; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uv7dkC3MPmwvohP9wCGMJdv25KGLHW3gqkljVo/xMA8=;
        b=Ni4EBfi69q+B0SyAboV+FVQYpGxIb53KdwAp2fbvj/pq9o+9HemyaBDEGrBCTN8Cv7
         ErgTC6uMyTUw+/Fn16eloajf+LMTgc74QBV5OY2zi5Rk7SmcaB8S5xFU10zusg4wJy16
         PAc7FMUVH6R2y34sel6XkP0aVjJyNMGIOFs3ppczqPEM7OvANuK1sYueehvyahEGD37I
         Cw4olk3XbRblFxexpsRzaFCATFEnD1d1rFrs+1XvVEzqVYwmAuw1Gf04YLwCCpYXESQD
         KLCwxGowgy5IriiZxK8Dp8IOjZsz9kP6PFfi9e+MxR9mH/c7PjTDrr/2Ln3ijUr63G+P
         4bRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792160781; x=1792765581;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uv7dkC3MPmwvohP9wCGMJdv25KGLHW3gqkljVo/xMA8=;
        b=wUbQxJHuUxKAFc1qy73Gyn6uAqiA1vf2jOAr0SxK8HS606DDk8cbUu5yzpgNRW6zgP
         6siwM4QHGTPit4fEdo7/T7bUg7aEGX+ya38cs03WzVsOPOOuWvKD6/5+zvhSURUoWNvC
         CDhcQHX8cbtS53X9z8fQ7YXmP2cS3Regnn8UoWl9Enj5EBQ0WERTMLTeOx4Oc+wI0WI4
         of38DMfvWvimUyYLK5N8imtLL+hbEaTyLOgsDg6mOrSRC/bMvxHBXUNIlO1v5ki3Vqxq
         mTNddNxS2TsWTnR4PORZlA2h5ch/3o6rSF6z/WSWFye1u8aVvz4fkxesxdnVmcN5ce9w
         dNxg==
X-Forwarded-Encrypted: i=1; AKwUvBwAu6duaeqDzdmLQG8DZTEPTu4m4zmrXiQBAt+y2uPpSOTVdO91qR/AglkU43BHAkqVtXml0pRGkwI=@vger.kernel.org
X-Gm-Message-State: AFq9FYI7A+SbvVYOx6dqvC4c0v6WlZPMzQqfeFtXVGgaIp9ZPMvME+dw
	xxfbuym7HYTWupNqv8hFHqVuKeKL2MtVEgAbjIk4KSWujL/8680jgQUrr0DhkqMVyFdZQyKN/DH
	sUDW4JHnW8KNa46mjY1JfaNAdYiHjw+4vi8MLy3M5Izg+O3oQ7jpVt5zjcrAgxA==
X-Gm-Gg: AYBFou2QTWNdrJm1RywA50eH2cPstwEc6T+8KEaLRuvprXQMwD787selmUtogsrFl0K
	tHJH0zaZFeoFpIVk137OpIDlV2w76TS/rMFchtfM0Bsay7K4SM/1EMfZnTI2QaerDovBKqSIs88
	5ssiyLKaiuh80CKyRHLWri5mynPFk9iaQ9mXQjCiS+jYdb77kjpK4W112oM3Jdpc+TnpljtHl1u
	/1yVzMU2qnQSZXXmC8pkknLwhsH3c94Nt21NefDgrYVYww2ERHbfxumu3gcNyXCvmyqOTwm+L3f
	/zEiGsSuUCBsXPSHPZlWvIuqZVLX/iZ2dKBaBopDS5lxosL/g38+HSzuXLKWpV9cF70ysTrgUKn
	HHxbL3uQCLp6GLlx3+T7fOC3kJVn/EbFAFebWkFmNXKzJdQ==
X-Received: by 2002:ad4:5f4a:0:b0:915:e85d:882c with SMTP id 6a1803df08f44-91bde91a642mr3866576d6.0.1792160779756;
        Fri, 16 Oct 2026 07:26:19 -0700 (PDT)
X-Received: by 2002:ad4:5f4a:0:b0:915:e85d:882c with SMTP id 6a1803df08f44-91bde91a642mr3865886d6.0.1792160779143;
        Fri, 16 Oct 2026 07:26:19 -0700 (PDT)
Received: from [192.168.29.231] (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbae22d0sm24249606d6.28.2026.10.16.07.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 07:26:18 -0700 (PDT)
Message-ID: <a785481f-74a4-468a-b164-0b7a55c04246@redhat.com>
Date: Fri, 16 Oct 2026 10:26:16 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix bs_xflags copied from wrong compat field
To: "Darrick J. Wong" <djwong@kernel.org>, Reid D <skibletz@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, sandeen@sandeen.net
References: <CAGNJ+_2p_qyY2xx0b7wgHg+PJWLSQzYmfRqk3UCpue2f6GchVQ@mail.gmail.com>
 <20261016050847.GT2705364@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20261016050847.GT2705364@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/26 1:08 AM, Darrick J. Wong wrote:
> On Thu, Oct 15, 2026 at 10:11:57PM -0400, Reid D wrote:
>> From: Reid Downing (b1nv0id) <skibletz@gmail.com>
>> Subject: [PATCH] xfs: fix bs_xflags copied from wrong compat field
>>
>> Read bs_xflags from the correct compat field in
>> xfs_ioctl32_bstat_copyin().
>>
>> Signed-off-by: Reid Downing (b1nv0id) <skibletz@gmail.com>
> 
> Yikes.  Good thing we don't actually /use/ bs_xflags in swapext.

Oh good grief!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Brown-paper-bag-on: Eric Sandeen <sandeen@redhat.com>

> Cc: <stable@vger.kernel.org> # v2.6.29
> Fixes: e94fc4a43e5c39 ("[XFS] Add compat handlers for swapext ioctl")
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
>> ---
>>  fs/xfs/xfs_ioctl32.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- a/fs/xfs/xfs_ioctl32.c
>> +++ b/fs/xfs/xfs_ioctl32.c
>> @@ -124,7 +124,7 @@
>>             xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
>>             xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
>>             get_user(bstat->bs_blocks,  &bstat32->bs_size)      ||
>> -           get_user(bstat->bs_xflags,  &bstat32->bs_size)      ||
>> +           get_user(bstat->bs_xflags,  &bstat32->bs_xflags)    ||
>>             get_user(bstat->bs_extsize, &bstat32->bs_extsize)   ||
>>             get_user(bstat->bs_extents, &bstat32->bs_extents)   ||
>>             get_user(bstat->bs_gen,     &bstat32->bs_gen)       ||
>>
> 

