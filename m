Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307A62D7DCA
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 23:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760658868; cv=none; b=lmVCP/q7VKJZz2+TxnNH/Rd2FZ0yNa0eTJx32UOonlGDHYZXvH9QYppLHc/uEtOUYnYa9mkwDyioR3rMO6k+pPr/GEzglZXZavCH8vPW3jTDo+Xq4CzPW7cOHNFjQkhSwWI/9tkdtuoHoAxHsVSBFWYSa0RtqN/E2MmjiWC6DnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760658868; c=relaxed/simple;
	bh=aK0HIlz8QpmZ8viy5ttoIR/Sw7DFRXGwB1wihf4h2uA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DAGlJ9hHFx5Fbl+3K2FdFx/qy39OyAjxzXiON9FTzEsbZkCYdS60L2FeLnqT9g+vt5qzaFtQDSsmillhFKt081NvZ7DOUkJKh/LrSvgzHViO3qWJ1taw8pHm5rxzPlOgnFlG/s3Y40nphSd8jdLf1yfMXQYPa7EivC4dLGiUFGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SFpPaydY; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SFpPaydY"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7835321bc98so1290778b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 16:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760658866; x=1761263666; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aK0HIlz8QpmZ8viy5ttoIR/Sw7DFRXGwB1wihf4h2uA=;
        b=SFpPaydYkmZo0RTqgPHQYaesHemd/H0GP21+nM6sMqFUw3+49833ouFtyPSNo/19Xp
         /ySvXuCbiI8HMa72dynXW5hLJtQ1+4NkSDvxmm9MiEnrdRl6nRyIphadSg2ci1SupXy9
         OsG2RdK3KEY8jFnkkWFuJPJekjIoCbGISPjRLg0Sn7fSNbOQEVgrEcgNhYa+pd/0yc9t
         As0qL14huA/tfikUYIqcMn1CYBMdgi4SuqVe91uAr4NN6cD6gW1dCim3n34Q1ydiTF4g
         ZfP8BaqaF7ntUsamITQ5cQ5QgflIkYH02yXuFYS6oBK3cPqVBMpHcOXEimjPixWGYBz7
         qdhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760658866; x=1761263666;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aK0HIlz8QpmZ8viy5ttoIR/Sw7DFRXGwB1wihf4h2uA=;
        b=Bqwx4VYN0WtGLfnBPd7dURl57w3YeeR8xrYwaiusrmYg1HyG/b2i5jb6gFm+V2vG5U
         7U7KHm3ra3BXf9K+kHUhnGCc5CWV1RFpa3HKfYeR/Gc+LcKHAvQpGuDqNpO1CkLBRyeI
         izkkk0RGTHhR2BEPtzImMEEEUoKUdarEQ9bCyyHWfGLKHQdkdaNxJzbVFUuBC/drIj22
         L5/bE+LdzRCTeaiWaDaMMDRjRS2OmZ/MnllU3x08x1yMYthPKc3RAMMsyZLPuO7X2ucW
         KlDvBRZNKZ82nGZLuvO3dITyW9Hk0OOoT+7+S5seAj3qT0OvzrB7uuqRW4j0Q3jEZM1F
         DiSw==
X-Forwarded-Encrypted: i=1; AJvYcCWQOg8GCCCEJq9Z0JIF4EITrOeFdeVquM0u3Pzr2ZETvpQaMGP/AKR9NESQoaVHRkABi1Mrsom9P+A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4i71+XmZV4opO+Q9Mk8jLwwWPxZN2mfsfqj9yLcoYRvGIOj7T
	T8PvDQauDuPoBR6QTcbjGq0FfxVO0ibGvxXtJum4uR3IJi7WMksU/4Oi
X-Gm-Gg: ASbGnctiCClU605DlHJW/s28FaZgTrwof4GefOzGCVeu1U8TNQG0VWiUIDapTzmehG+
	GkBWQGbjBrNxgEfnqedeEbhYlgP3DRNQm7t+09YXcz9WU67Goem5w133Q3ftK9I2vm/Xe6y3Ney
	pQr7LbAzd1rjzqXPWHYdczeSlIHcxrvygGu2/S2XOeQwjSTkygVVJc81E30oyCA1vLpZ9AwHNDB
	AuKQMv4qEl2naDyaxryIkh3VYJU9ocbTVIXYMjxeYRtkn/tVUyqrx8i65Q4jwt4kOdOwTO4Smr5
	MT6gn+0uekhHSFLxNYC1+jUgIpzhdig7CtPYMGmSqO2fs/igfrYbOjQVwBZ7ClsZYOJn5OSeP4N
	Kghe2iM/eES684eVUKDLj8sUzNgCJCeSOBgt1XxWjm50Vbs5Fo7IgxFmbtJHh266gVu/xlvfs3u
	nr9WYsoxK1HpR5XSWY7OGUcNOGFcI3C/o1ReSzz0aO0D0onEqKxzqOK4mebi9ALYYpe8gCiYl95
	5M=
X-Google-Smtp-Source: AGHT+IEQTO2Rn6Zn2mjzgAtb5MC9kioqoXxy+wCCJOa0aqfiGZuVMbJgx4ckvtvqbeTnmHskZ53hzg==
X-Received: by 2002:a05:6a20:42a3:b0:2fb:add5:5570 with SMTP id adf61e73a8af0-334a8606ff6mr2179365637.33.1760658866309;
        Thu, 16 Oct 2025 16:54:26 -0700 (PDT)
Received: from [192.168.50.211] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992bc18c96sm23614670b3a.37.2025.10.16.16.54.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 16:54:25 -0700 (PDT)
Message-ID: <96fa1a22-2df4-4047-9cc5-459e9846780c@gmail.com>
Date: Fri, 17 Oct 2025 07:54:21 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] generic: basic smoke for filesystems on zoned
 block devices
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-btrfs@vger.kernel.org, Hans Holmberg <hans.holmberg@wdc.com>,
 fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
 Carlos Maiolino <cmaiolino@redhat.com>
References: <20251016152032.654284-1-johannes.thumshirn@wdc.com>
 <20251016152032.654284-4-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20251016152032.654284-4-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

looks good.

Reviewed-by: Anand Jain <asj@kernel.org>

