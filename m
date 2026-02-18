Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1433C32573A
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 08:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771404568; cv=none; b=aXeBRtglH+GqbTI5iMqa0JDluba+WQKL2Ad7RI15dfADz3HwXO+EA8L81WchiMwSI0I1Oy6m5pAq+OpJYnCtiNvOIsk6egeLZr41utfGrJoP+7yfW8VW8gwUYKzXBPg/6y06qVprk2uLr6TMQ6LpbuVaI3yaFYT78vHLZ/he0ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771404568; c=relaxed/simple;
	bh=W1Py70lKCU7Y+bog2YpPg24NmSly1GVlKHBKO46RPNE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=IVistd5gsXu0U/NP7aWZjfr9th71PiocBCPwCtpdlaoUyTFRbJwH1/74PVdEo6H9dZbj17EW5VZRxSKTR/ds8awjcH11AYUaEPGmVo5KfJrQvJlJGU+8nr+X/EUi7E5FoklPlC3IcYpMdVwcvoRE5bCeOCJ7A2gsY9kaCA6unK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JtT/1LJX; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JtT/1LJX"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2aaf5d53eaaso31300735ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 00:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771404566; x=1772009366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0WjhSTFINE56X703LwF7t5Px9EIzptaQB3vxXbhcGVE=;
        b=JtT/1LJXOj4m6jhW2D5TSBl2tgUYl3juqlJ6WHxfRBgVf3xb9w9wb9rR8jq8j1egbU
         86cwSQdfFqkNkuoK5F8oAip8C3r7n5zE4SxBG4rB+pEg1pMuIPhqNGifCWHcm1O8Juch
         +XuV2dMShpI85X6dlePJoKCpx+Rss2NVH4LaW7wt4+rDEHfU7c77kpYrNAQt1ocT3Jqg
         S/Pnu2Pw/IjbQQwAPdfw8+1UR6RiwCnlbQnjGU+qVwp3X0P+EjXcoGYsujzHp4w8cIjG
         MXIONiDMPVg4gsYU/pYCsDfO7u46XieLJxvtz6x3ndq3GdeQv8HAH1qIXHQwLidaoodj
         Fv7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771404566; x=1772009366;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0WjhSTFINE56X703LwF7t5Px9EIzptaQB3vxXbhcGVE=;
        b=v7dGA0wYxJfEmvEtqL/7j5X7V5kbwQeO24dpg9ZHvgF/9nlcvNJgplCwOfudd9Rff5
         SEbigat5P8qjsPn7mIygVsBiNu/t8Lk2ZW9c+MQTi3AReSw4DrGahnsNIk+/q+9MqVKy
         8d00+SFxQ2+5AZTpuoD9QRrdDMXV8OUuhaLeyBEvw7RzAjZkh30xvtf7rQZHcA+lyUsJ
         hj1gvJkjFcECzc4rItlpR3M3CFAb4YeSVjDWjH2L8OdwE/IWv6R2JxX7LTOgS/IUeta6
         Ys4kxocHKvNTMdf6aw57ygjLUHcElaBGC3xSU1qCwr626YkNg4BaBgSYQGupSuu9Kk+/
         gFMw==
X-Forwarded-Encrypted: i=1; AJvYcCULYB+YhvAJed3iaL3o8DyHN4zoA4G0n0wdI43P1kQC/ISqTlpyOxpfyJUopyB3lE6NMhEG+0FJm80=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSS7dQbbH8+ffM6Efi7n4Smpy8nqehzMD/V03rauK5cDh0MKD5
	HHfWZSKV4P/yWWWBToYWQAmWJIMsxR21ezETUFa1deT4apyH9C0Mmbwv
X-Gm-Gg: AZuq6aIjdbsT1/UiGQ0QqzYv1vX47q+GHVFKrbLiy3EiqNmHNDyPg1lyQGvwZfsd4tt
	F+Et8vFl8TPi16WkVNFCHeywaPP8NBEMC81IlIrDxLYTBG/O6N3rs14fe8K8gH8MYv9f/PaIlhv
	XnkeO8tbRBVurfcYoyr1eTO9Aa4r5v2Ux9B+6vqExnxCTwxFs+FvDb0+AVYpVjD4heOpg065ive
	pjA5cH7BVOaVF8quLRSkgBg44NfQs6kEyk/RVVRUWL4+lXn98VbdYQv0YPLy2BNi+qFaqUL9MWX
	gwcSVvUi8VbkZBiXhpZT6ASD5mGDZU6pwvJnzzomtVPl2LVdlUMcnSAdnB6aKNHMYLxlSBHU9Ga
	262rdvvMK3WKvCsotNpvrDvwW51LeMLAi/fV+hKVfnfy5zvr7MJe82X/5UHct7ky4x3T8I1PwWZ
	fr1xjPR5aZiheParJYV6CxkcBHB/2L1zT1a0dUqm3eXfl0ArPJLzyOjUrMgVIU1tjmdb3OrCNJs
	8yAQWNW
X-Received: by 2002:a17:903:46c7:b0:295:6e0:7b0d with SMTP id d9443c01a7336-2ad175445edmr146717455ad.56.1771404566337;
        Wed, 18 Feb 2026 00:49:26 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.205.118])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm126140245ad.36.2026.02.18.00.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 00:49:25 -0800 (PST)
Message-ID: <91050faaf76fc895bbda97689fd7446ad8d4f278.camel@gmail.com>
Subject: Re: [PATCH v1 2/4] xfs: Update sb_frextents when lazy count is set
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, 
	ritesh.list@gmail.com, ojaswin@linux.ibm.com
Date: Wed, 18 Feb 2026 14:19:21 +0530
In-Reply-To: <aZVUEKzVBn5re9JG@infradead.org>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
	 <3621604ea26a7d7b70b637df7ce196e0aa07b3c4.1770904484.git.nirjhar.roy.lists@gmail.com>
	 <aZVUEKzVBn5re9JG@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2026-02-17 at 21:54 -0800, Christoph Hellwig wrote:
> On Thu, Feb 12, 2026 at 07:31:45PM +0530, Nirjhar Roy (IBM) wrote:
> > Since sb_frextents is a lazy counter, update it when lazy count is set,
> > just like sb_icount, sb_ifree and sb_fdblocks.
> 
> The comment you removed explains why we need a different conditional
> for it, though.
So I just moved the comment and the updation of sb_frextents from outside of "if
(xfs_has_lazysbcount(mp)) {" to inside of it since sb_frextents is a also a lazy counter like the
sb_fdblocks, sb_ifree. The comment talks about using the positive version of freecounter i.e,
xfs_sum_freecounter(). Do you mean to say that the updation/sync of the sb_frextents should be
outside "if (xfs_has_lazysbcount(mp)) {" i.e, done irrespective of whether lazy count is set or not?
Please let me know if my understanding is wrong.
> 
> The commit message also doesn't explain at all:
Okay I can update the commit message
> 
>  - why you want to change it
How about "We should update all the free counters only if lazy count is set, else it will be
unnecessary work"?
>  - what the chane is (AFAICS just the conditional and not how it is
>    updated)
How about "Updating sb_frextents conditionally based on whether lazy count it set instead of doing
it unconditionally everytime when xfs_log_sb() is called"?
Does the above 2 look fine?
--NR

