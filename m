Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3E227510B
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 12:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762257898; cv=none; b=ePweCxQE9t8XryaBmquVJ/GGQp52/4zVf+iC6v6tSfIZpGK1Hpgb90umEpiQ7HlMlmeeIXyQMl8EHL2qWsX8JSLuH6nj9QLLEJiSI5YJrAAF7qWE4mTNnIh51RY/zcoAjeyONfN5Tjm+6mkPxIYpC4JM2e8B32UVNBctYSYJK7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762257898; c=relaxed/simple;
	bh=91j83r0a/744GsjSSpvMj2vPPbbmwRCLqH0NKKKQxTs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=K8/octdNImSsRwmFjvmz95LciYZnwqM5ztiviKvLT8YuSNjha1wtSiWZU/CsHb3PzDRIqg6qMIoPEIpjqQWC2deb8ba490X8Ealtrn6e2rmYkpPj+cgdvsEtxVEUg3x14989uxAe5oDiptxzFoDb6yPSlnPF8TZcFDRuS3rE+Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VfPVlvIU; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfPVlvIU"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29524abfba3so40685395ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 04:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762257897; x=1762862697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hIMOgpEtwvgPznTb3R/noQ8H3QESHZcJ3b2FNe/UuI0=;
        b=VfPVlvIUyTV8qIihY9JjSsKeyNBWMl6UMFmRHCYWXD/joLcLMadxUuigePc7OhaZrY
         poj39NwZlF7+axyTDmSBJZ4OAlWaIr7WNFIwvrpEi3HxnWPGVIBY+gLnWoFBRlDDThYl
         j5zBzjXV9t/sahOazDTvFdKATZUWOqVN1tY2AzxYG1MId0HMuxoSEe2F6b82KB1ne/h+
         LEDmMa4nPJ6uRvAYKezrrO6KUc7QMaqhzHqVkUS40HQUtiFYcPk+XmZH/a9FvXU2/hf4
         6a80ov5PHP2a0+LlvS8un7oaNXSNfvizKWZKs7QCnHqx/okdk249o3XS+QCDKsBfTnTM
         /yXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762257897; x=1762862697;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hIMOgpEtwvgPznTb3R/noQ8H3QESHZcJ3b2FNe/UuI0=;
        b=Ac9dOWmbMH1+r/FsVeA7IHY2FklBm00FWUWXZ0NpdefjopFsTQBmDk+elu8Ed4OY1P
         rEvrKJepqWZThBCf/t/1npClAPaAuz5YyW3o3mKn2AlDcjJ9gSXDuI3GjhWYa7Y1JPps
         B1yqn66gAu5NAX5Mj0SwEj93/gQZMutPcINYi8b3A9DPg6Ij7Zc63oUQ2vro4wwBHStF
         CRjOVS1OsmpIgjHBuYB1jt/zUHDe+GBZqtAtFkOlm6iuFuthRndDMoSnMMLpaknnKpax
         4gfuCDSXVn/poill/uu6p5kcLXmsPaRcVE0XsQekJUZV/QN3wA/6x9/x4RaQtcjZyvQU
         Si1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXyylq+/xHY4MR7OvfvU58T1F6tTu6jk2dtqatSO/Y5TyKHqz8DBdo1LUKT3MXiKBbzLL3Ruc5BUf0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxG0dg3J/d3PW/ps+HPIpVL7PMS2nEa08vK+MjO6rt3gU5Gr+sA
	sQbIX0Tf0NtTuMvY0AAEt3yjFRHizdc6+Af34AEj9BVq9R6ha3R2Hf4W
X-Gm-Gg: ASbGncsGpYEsHRqUwCHz/2hH/GW9sPpbOchHLdY1Q1g+/OXLbbMxvs38bFOp+21uZPK
	nzXROIxzWCM1hyhQ2j1RQneFSWRheXJK9feBLfhojL7NlTqDr/VYCEPuEa+u1VOqQyk5BNhaILz
	o99DuADrf+NmloCKAjLVab5iuS2sJwy4P6abMs1OHbxBl+wgOKKZUw83+vzmO5tOo9n8IaT8xP+
	DNlJ0CydmGfTZ7bwLv3mmWqC0xs2gP4f3+TdzT2Jqu/aC7lpjdZTpEYdNGqM/iYm7Oc8tWsX4oG
	SnqLMjJRm/K1rMZQU/qlhuEYMe8aA7GB7vakyRc1RYE/FEwYbGWvyXYMAoWHXDaVWPZGXmqhX6p
	KAi3CzcwsE9YmSIdeOvKx9VNtWAFbioAUjl3OYtBrrq8E1uXMKQULoZneR9o82xmSya2GOWjVlx
	XFcY4xbTqvFaHtZD1nzrvp+h27Ge4Lr2epXrVs14utY2mmjr9VVLSx1A==
X-Google-Smtp-Source: AGHT+IHhptMGeN6GUWdSr3woSCYhxUw05Wn9RRD4O2T5DayZS0jhPNbaRMV4ZHTfd4sd7Ew85mCkaw==
X-Received: by 2002:a17:902:e88e:b0:295:fe33:18bb with SMTP id d9443c01a7336-295fe331993mr38565105ad.14.1762257896410;
        Tue, 04 Nov 2025 04:04:56 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.200.106])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2960199831esm24707045ad.37.2025.11.04.04.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 04:04:55 -0800 (PST)
Message-ID: <a05cde7d15d85f2cee6eafdb69b1380c8b704207.camel@gmail.com>
Subject: Re: [PATCH 2/4] fs: return writeback errors for IOCB_DONTCACHE in
 generic_write_sync
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christian Brauner
 <brauner@kernel.org>,  Jan Kara <jack@suse.cz>, "Martin K. Petersen"
 <martin.petersen@oracle.com>,  linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
 linux-raid@vger.kernel.org,  linux-block@vger.kernel.org
Date: Tue, 04 Nov 2025 17:34:50 +0530
In-Reply-To: <20251029163708.GC26985@lst.de>
References: <20251029071537.1127397-1-hch@lst.de>
	 <20251029071537.1127397-3-hch@lst.de>
	 <20251029160101.GE3356773@frogsfrogsfrogs> <20251029163708.GC26985@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-10-29 at 17:37 +0100, Christoph Hellwig wrote:
> On Wed, Oct 29, 2025 at 09:01:01AM -0700, Darrick J. Wong wrote:
> > Hum.  So we kick writeback but don't wait for any of it to start, and
> > immediately sample wberr.  Does that mean that in the "bdev died" case,
> > the newly initiated writeback will have failed so quickly that
> > file_check_and_advance_wb_err will see that?
> 
> Yes, this is primarily about catching errors in the submission path
> before it reaches the device, which are returned synchronously.
So, what you are saying is file_check_and_advance_wb_err() will wait/block till the write back
request done in filemap_fdatawrite_range_kick() is completely submitted and there are no more
chances of write back failure?
--NR
> 
> > Or are we only reflecting
> > past write failures back to userspace on the *second* write after the
> > device dies?
> > 
> > It would be helpful to know which fstests break, btw.
> 
> generic/252 generic/329 xfs/237
> 

