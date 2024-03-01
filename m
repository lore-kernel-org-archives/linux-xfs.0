Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2E940BEB
	for <linux-xfs@vger.kernel.org>; Fri,  1 Mar 2024 13:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709299136; cv=none; b=EP01dO8d+CYIo3Vv3VFT82GwDBOh3Z+/Um0tZP+cyVb72ApjQgYPDRk10ojxtork8aoe+4hE5mbmk+GBAQEUVwQkk5+qqBah730O1BxFICEr1zrX13A7SE3EcW9ycujTG/buLN3G7hXyuoql8bXhu5RT+ihl+gnPX1p+5/ox3/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709299136; c=relaxed/simple;
	bh=PJtYfWBVRd/UxEpt95Y9ls2lcEii/CYc2yk6EgircJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pFBHGJeVLZykDEsiWRJM4oBo7qLopNB8Pt6Vbe3heTL4WUN/CqZ3fpso0qwuiaUr9sGJPc5xQizVHBAYJ84vp/UP4wVzctDqgH9/LQezEROfmZ7He6t5HYwuInjcc/9ehrgHd/Mp1GO0nZ0IbcX5cnuofYaE0xzhcQQqD+q8Qbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NFqn43+f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NFqn43+f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709299134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yzT4TJwuBsM3ocKvd5noAxHjZoemCZr/htKO7aZD5cY=;
	b=NFqn43+f8xWf6sUJ5gRCRSaFtS7CZyA1PGfGb4RQOx8MhroUYCTS9HZR42Xl5AjQlSC8rm
	yffKDbvfpi6mHSYC+z55363a4P9vJAhiFmJkVZqWw63KPhkvmKfrwc3vO3ATYwO51Bb6LK
	rOM8CCqwxCt2gAG6MJ6aFdQ7+cpag0c=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-kkRPPJYVNpeCX2s7iiSq8A-1; Fri, 01 Mar 2024 08:18:53 -0500
X-MC-Unique: kkRPPJYVNpeCX2s7iiSq8A-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5d8dd488e09so1886259a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2024 05:18:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709299132; x=1709903932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yzT4TJwuBsM3ocKvd5noAxHjZoemCZr/htKO7aZD5cY=;
        b=lqgonvY7eJJM+bqaM44UcqacL0Qil1xJLrCD/mVhVheB23QpvSefAtfPpqVu3/TtJK
         aqnkitAtSzZF2Ly2LXYnJyFVvWI+TvO4C3bP53G4sybuAeIjyNo3I1TH8sNpx5RoK809
         rsCyxg/T1FkivdJqi1J9/CLjO/gp/4VwpQMpcowFm9k/30S3RXBLgrX6lBvh2ZrZalZP
         eu2pAoKzR2sDksFpdjAms6UcTFXg5uB+Ohh3A5UV3tUL8YHUwmRkyWFKiS8uEabQJEvR
         flCvRGIa97OOLStnh2Umo7PxG+8Bjt6TgY78DiC4NBTPxcYn5nT/VKu5cYzyx/6ftEwu
         Q0og==
X-Gm-Message-State: AOJu0YwMNmO0dDEWyu/6k2dJN52t0x0sSlyvWsUthzQD+9p/ukXCeqlz
	vYpfRcPWNyslEQ0Zot4N2X7290zld3qmcaRvnk8qvH7OHxbiO8DC7AEjTdfUXMZpNHEH0AklLXU
	NzaTbmWpEt4iQtlhUxsJEYN7EWFXAo+ozN8er9t7Sq1bnbiqjP01qus/Rpg==
X-Received: by 2002:a17:90a:2e07:b0:29a:83da:ed62 with SMTP id q7-20020a17090a2e0700b0029a83daed62mr1600398pjd.4.1709299132010;
        Fri, 01 Mar 2024 05:18:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXm0Xf4r2GO/8Otcdmv7XNPJubAUoG+NcYexm5gMu59IfiI1MHa5wq8K+Wah6TGCgz7b4BEw==
X-Received: by 2002:a17:90a:2e07:b0:29a:83da:ed62 with SMTP id q7-20020a17090a2e0700b0029a83daed62mr1600382pjd.4.1709299131652;
        Fri, 01 Mar 2024 05:18:51 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id qi17-20020a17090b275100b0029ad1df1661sm5324880pjb.52.2024.03.01.05.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 05:18:51 -0800 (PST)
Date: Fri, 1 Mar 2024 21:18:48 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs/122: update test to pick up rtword/suminfo
 ondisk unions
Message-ID: <20240301131848.krj2cdt4u6ss74gz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
 <Zd33sVBc4GSA5y1I@infradead.org>
 <20240228012704.GU6188@frogsfrogsfrogs>
 <Zd9TsVxjRTXu8sa5@infradead.org>
 <20240229174831.GB1927156@frogsfrogsfrogs>
 <ZeDeD9v9m8C0PsvG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeDeD9v9m8C0PsvG@infradead.org>

On Thu, Feb 29, 2024 at 11:42:07AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 29, 2024 at 09:48:31AM -0800, Darrick J. Wong wrote:
> > It turns out that xfs/122 also captures ioctl structure sizes, and those
> > are /not/ captured by xfs_ondisk.h.  I think we should add those before
> > we kill xfs/122.
> 
> Sure, I can look into that.

Hi Darrick,

Do you still want to have this patch?

Half of this patchset got RVB. As it's a random fix patchset, we can choose
merging those reviewed patches at first. Or you'd like to have them together
in next next release?

Thanks,
Zorro

> 
> 

