Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13592E2DF9
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 19:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754938861; cv=none; b=H3UjQhyc/lMN7G8802wsCss11zKdEMhjSExOnM6L4XNyZX197JmhFA6xM5r24h6n1ijpYimAe6ZmoO4UHcSJWGJ0GlXp0Mr2keWLM9su+0sxI8ZqZDCfNHvaUUPBU5pEkxcBMve+El6+jtGj8xRGeCpz6DxMpFVAqwCsjv3oSF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754938861; c=relaxed/simple;
	bh=ybcjvOJlMNn70eoStdwho8f04eAjfDTqsUepVF/tZCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QTuuxDTjbIo/ixRD889NLm4/w76fjmtKXuCkj5pMH8TxeBx8QeA57rog4xmyi+zJcpi1iqi1y8NYl9WwHBxADXOCInGkGz9tLjcq/Zf6nPuMJGRCXGDvs7djtZQczom47tXFjMYLcZ3ZTlkx5tFT/Yzhrdj8p9EnT9jHdhkcn7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=STq1Z4uX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="STq1Z4uX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754938834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=58JoT5HH4eptH1LhdQHcGjevevo6yl7PELRmS6dCCGw=;
	b=STq1Z4uXuOXBhRkud3tsuf3Ad/0+BmbxyLFl/U6PgMtpFWr9JuKlHK4N4s0UXco22cPbYu
	+FLTIpXGqmKkv1hiWDlxlkdkHgMIjpV+SsN175YvUu/FJJpykr6UddYO60qK58AcmpdCt1
	hnOcbteUt5UXnwRElfOrKCftt7qTuRk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-XpEoewUUO9OTFdmcccwe7g-1; Mon, 11 Aug 2025 15:00:33 -0400
X-MC-Unique: XpEoewUUO9OTFdmcccwe7g-1
X-Mimecast-MFC-AGG-ID: XpEoewUUO9OTFdmcccwe7g_1754938832
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b78aa2a113so2247980f8f.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 12:00:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754938832; x=1755543632;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=58JoT5HH4eptH1LhdQHcGjevevo6yl7PELRmS6dCCGw=;
        b=buHytO3IW2PE/KHdceITuy9Aur8U9k9I/BpNYXwIS3unkis337d5KObKx5sOjwm+pl
         Biau3Y1e+dgo1Zzb9UU2c1lP0EuHGZSKMYa+glTM2zbSvkcp/CvNgdH372fIXstHI8fY
         f+ISrAW3e2pgqz0jGhHxBd/EpQTsaQnw/Qaj4oIuIS9yxACTukn3zI5Sw8UDPwytUtWw
         zIntpICW0Twf237f9dAM34scwYrdDiPHRw1b68+KOa6lLa7HIHK8vWB0RiddMnFMcKbc
         1s9XZIz1dCFE0rowwf4OOlJKkBqwgdkd/9TLxdx4846fbjq7SfOhreBBBFF0296+esE1
         EfQw==
X-Forwarded-Encrypted: i=1; AJvYcCUvf/TXSybIPHYzecrvwxJ9kWinNl7okQEJikRF48JhkNFbpNP2+bW4BHswJQ0z73Hir9whCfcgUxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMEXwAcYa+VkEkYs+7oX6j1X8vUDRJiXnIuD8ayKPt4ObUiXhd
	uPphwyooFP3qrDlqcPZ+u6bEuvg9zsi8zElBFPdsd1GmlOR7uOjtqLmNhN5lww5UwtgErZx1zsP
	3EbnQe31mqyEPLqsnanwlSEWr8FKNIRddqIEMaVIg2x1Z4gmhaviMJ/JbSOqDqsQjzpn/
X-Gm-Gg: ASbGncspdHRk2jH5wcfE7MO4ra1VbczNHcApJA/J1dvOo+4TxCNTHLE7HuqMelJfAD2
	BLLgfJxWgxTgj8kPtMBxbBbjX1rXZ3/Oo4HhIiM1z72DEpRZRwef4Zyi9CZla4I4nCsWdc4IHp3
	FiGx3jnvFcD6bXVPqzVDkeCAiSY/anK6da4RBhqW1jzpdWaoR9IzYA7Tpc+Ya8XfKt1NLXY7Qbz
	rOMyXiTU8hSBHx000C6OZxx5JQ+ijkxjvBUcRiZKSOakUFmDIIbioIO4E8Po/f53zTMDp+W3q71
	AZ41Q6lrL4UKuh36gzX3zKCHthVMJJXfxlDgHQXyqcL0i3Chjwg4Js/s5gc=
X-Received: by 2002:a05:6000:310d:b0:3a5:3b03:3bc6 with SMTP id ffacd0b85a97d-3b911007a82mr729072f8f.28.1754938832137;
        Mon, 11 Aug 2025 12:00:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhSlMkIt2XZ85mTyNIxX5yeT/WsbII4MET5l/kPnwGJDSFQsCvBR4Sv0f4Njm12y3xRw1vzQ==
X-Received: by 2002:a05:6000:310d:b0:3a5:3b03:3bc6 with SMTP id ffacd0b85a97d-3b911007a82mr729045f8f.28.1754938831710;
        Mon, 11 Aug 2025 12:00:31 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458b866392csm232787035e9.2.2025.08.11.12.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 12:00:31 -0700 (PDT)
Date: Mon, 11 Aug 2025 21:00:29 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, ebiggers@kernel.org, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH RFC 14/29] xfs: add attribute type for fs-verity
Message-ID: <je3ryqpl3dyryplaxt6a5h6vtvsa2tpemfzraofultyfccr4a4@mftein7jfwmt>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
 <20250728-fsverity-v1-14-9e5443af0e34@kernel.org>
 <20250811115023.GD8969@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811115023.GD8969@lst.de>

On 2025-08-11 13:50:23, Christoph Hellwig wrote:
> On Mon, Jul 28, 2025 at 10:30:18PM +0200, Andrey Albershteyn wrote:
> > From: Andrey Albershteyn <aalbersh@redhat.com>
> > 
> > The fsverity descriptor is stored in the extended attributes of the
> > inode. Add new attribute type for fs-verity metadata. Add
> > XFS_ATTR_INTERNAL_MASK to skip parent pointer and fs-verity attributes
> > as those are only for internal use. While we're at it add a few comments
> > in relevant places that internally visible attributes are not suppose to
> > be handled via interface defined in xfs_xattr.c.
> 
> So ext4 and other seems to place the descriptor just before the verity
> data.  What is the benefit of an attr?
> 

Mostly because it was already implemented. But looking for benefits,
attr can be inode LOCAL so a bit of saved space? Also, seems like a
better interface than to look at a magic offset

-- 
- Andrey

