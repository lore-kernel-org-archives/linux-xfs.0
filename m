Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0576222B8BD
	for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 09:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761296483; cv=none; b=LPs/VL4mwxd+EsOg0pAWhmPvDgKEF3PuWNbxtBB6pezmeWczOP49i0po1Hx34OzKBZBSv/LYuRZCjK3b6V3Vm0LyNM9dN2UjvbK4ZaRa9mXXWPYTu1FydvHKT4kzqSOxsk+UFzjF+RcPl9TGwR5ZiwgLMqdR+hlWSezShQjkwHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761296483; c=relaxed/simple;
	bh=kzd8hR8ZB48TRf1FBLYy52ZbdXMgU2pQUI3oHfpkBtE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=Nm7QJZ/XLYhX/JAY6jtqSAJwofGkv7NccuISEAqKF1dPwQfCaDxAjBZNebsvwGwtbVCgY+N8lSRi1I+z2iPbBzE8/xJafFLzv1gzCstnyQG8DuN8GP+B6jtzakiqp3tL5HOhHaKtc0gK4XxkWnSr7lSINt2RVsNKDLQX3cnOIaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FmmN4878; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FmmN4878"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7a26ea3bf76so2450978b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 02:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761296481; x=1761901281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JzOfaQD9roYcEhX3qr2200GMaOEmWqdNntaV+C+xDvo=;
        b=FmmN48785e4CoOH3n5OKyz1wzyowcEBIxngIdu6viSgpOh6bZqog7kKSWaVMX8wFOs
         AwQKnR51WVp0KQQ2Rkv+EZ7+Vk0fiOZT8uvXDIeSqZYzP1DZ8Wo04ndBJ3hn3lH+bpwm
         THir5zWbRxLgqy4AG8dcyYGlhxbEbE69kuX+YbFY892vpRqIoFtbaJ9B7tcXzvto3+Ta
         mfq2kNCfX51IR/bswYaPXPeCpmdenqIGdYJrzpcnWALJPGQDuTj/XvUaTTQOYR8zs18T
         1z4WHtf7RtwbHqWo7WvLYxxnZHNCkYhdCES622mEgaDIEmgnQXKyWlO76hVeTVCdbw4f
         TRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761296481; x=1761901281;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JzOfaQD9roYcEhX3qr2200GMaOEmWqdNntaV+C+xDvo=;
        b=ZjgDIzLHUNJ1DLupsfuYbOmwuuD8iB8BkwWn/KrkqXaTuPmMA7tZt3j+X3yDycIBEs
         bf3ENmNIrt+yy2QFdiTBWR6rkOzkgK9m5yGVfpWze+emDrJu8X+8hg5dsbsfwooZcllY
         u9gMeLh6mS5fVVeTgmFHKG17qI+qD3W4eAoDAxEF3+VpBBKoswTjuIl6xcon4sXrAiuZ
         2clpnzb/zcj5NFx9UnanhmjEOMdoAQelSM9COOuxeosU5pBl3fw+5KU2c/LCbxbemG7w
         Hd8CTWDOyEbfheFhCWXGiHA6xQ0EoVWZSjlyhDWDM8CuILIgW/V6IHhmmeulopmdYyha
         Zz2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXPEuKhyXiQH8P3KJbMmVJMqD8Dg228Ty2Nqir0UU6523x25PBwQ8KONjghqzOgbN+aJ3g/1qbwTyo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPjOv7y0NGXIJXk2M/6Rtn5wtX+qdJnWu0ErWvqdEU/UbC8Pde
	6WHLjbnHhM7pKLYcNfWw5+GNe1N6C14N6OSZD9Y1geokyGz81AsJTAkO
X-Gm-Gg: ASbGncu0fq0zhABt4afUeMbAnDUb8gFBRClBQrp23G8qgcIgItJL5/cNE61h2f/y4uk
	A2iIBRvFSQTHxtjDZtKsQvQ/D8KlRilvQodvEqY67437SAUh9BRSYrqXbdRSPuDKIv/b1I3ozcI
	kJF4QScnyJbiO8HIIKPQNdmxR/N6h6OQqrL/utUnzZHk8wTgxpLZYyu0V+3OqVCDCIpMlgQJ0RB
	B9UyH+s5OD7ZAb7YB8cqKfGtpWlD2blymPjqkcvwoWZo1p4GVVtBHrVnwMMF+jUE8P3+qTaRq35
	jSz1CfAuxLPUZI2Fuv2MZQDEbizp3RlCZz+2rfGeBHvIlVbnZx10Yb2GJG8nBL89MExofnqww0M
	nnxlr/xz83kGBa+hD6DsNXc+ENvNXXUHtKBSLvswwA+9nJwfLwzXjpMgwSojno9XNbhDJTj4UwZ
	CSqWY/3M2ICf62fTkq2wn/yt3auhTg4U2ZEIuQUED3noZ+meCJJtZp
X-Google-Smtp-Source: AGHT+IEWrEXZsXwa1nm/Ns8JJ7ZzpHbBOT23EPNhXFS4lCF44h+6JLL3rQbtrCdZsowGvK3GciFshw==
X-Received: by 2002:a05:6a00:4652:b0:79a:f5eb:3dce with SMTP id d2e1a72fcca58-7a28686017dmr1852730b3a.31.1761296481235;
        Fri, 24 Oct 2025 02:01:21 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274b8b343sm5215739b3a.45.2025.10.24.02.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 02:01:20 -0700 (PDT)
Message-ID: <95366976c8fee19ab2901c4b11fe5925042fdc95.camel@gmail.com>
Subject: Re: [PATCH 7/8] common/attr: fix _require_noattr2
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Fri, 24 Oct 2025 14:31:16 +0530
In-Reply-To: <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>
References: 
	<176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
	 <176054618026.2391029.1336336050566653412.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-10-15 at 09:38 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> attr2/noattr2 doesn't do anything anymore and aren't reported in
> /proc/mounts, so we need to check /proc/mounts and _notrun as a result.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/attr |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/common/attr b/common/attr
> index 1c1de63e9d5465..35e0bee4e3aa53 100644
> --- a/common/attr
> +++ b/common/attr
> @@ -241,7 +241,11 @@ _require_noattr2()
>  		|| _fail "_try_scratch_mkfs_xfs failed on $SCRATCH_DEV"
>  	_try_scratch_mount -o noattr2 > /dev/null 2>&1 \
>  		|| _notrun "noattr2 mount option not supported on $SCRATCH_DEV"
> +	grep -w "$SCRATCH_MNT" /proc/mounts | awk '{print $4}' | grep -q -w noattr2
If noatrr2 doesn't do anything, then in that case _try_scratch_mount will ignore noattr2 and mount
will succeed. With the above change, we are just checking if noattr2 appears in /proc/mounts(after
the mount), if yes then the preconditions returns true, else the test using this precondition is
notrun. Right?

This looks okay to me.
Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

--NR
> +	local res=${PIPESTATUS[2]}
>  	_scratch_unmount
> +	test $res -eq 0 \
> +		|| _notrun "noattr2 mount option no longer functional"
>  }
>  
>  # getfattr -R returns info in readdir order which varies from fs to fs.
> 

