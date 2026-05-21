Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8663E1A9B24
	for <linux-xfs@vger.kernel.org>; Thu, 21 May 2026 09:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779356542; cv=none; b=O4oop+mnldLbV1FhRwhbfA2XfDExINl91CVoVZE1BOr7Yqg2HZpACsAt2Rp/f9iDuzkUscP483m1Y/JpHGO9dCZD1vo8irHcPDjRymfu8QRt39fxEXN6iHsGqGSgHjBGV0RBp26S6BdXyF1o4lJEXWgt7qdUkgnFGul0wZUMzhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779356542; c=relaxed/simple;
	bh=/n6YuXXsfcsk7J7Yb0y1thOCuPSSvlN7WSB70uhim0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9Acpj5sRiMxG6WxG9p8gsY0/oBcxpXpRMlX3/sHlcmvbPL0pQlQPup7zjgG7+2RTdTByAkO2KiwSIjJOYfTj6NoxCaVdX/HG4oPylM/HMbHHuaJ7KUG01fL3JGgPL8LCwjLX0CBPHLV79KfcxTZlzUMIbKyWePG2VXTQjUcQCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kh8/BsFJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gE2mTH44; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kh8/BsFJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gE2mTH44"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779356540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
	b=Kh8/BsFJ+N6NzIDXyEfuJMusSPC4pdhMnRpqdY6VJpyrzj+6EAyXXCJhQ/EU3F0MvRdYFq
	pcIvLNpjMzfGwWRINgYMzxhI8TFlUFogQlVlr+T3pkZ8QtAG5WNZTLdd3hfbl3tUmQO3Co
	heWoxqM7gN6k73M+fyHIh+X31EqjNu0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-VTu8GjYbN3m6L-Rjwjk3Fg-1; Thu, 21 May 2026 05:42:17 -0400
X-MC-Unique: VTu8GjYbN3m6L-Rjwjk3Fg-1
X-Mimecast-MFC-AGG-ID: VTu8GjYbN3m6L-Rjwjk3Fg_1779356537
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45ea38c03a1so598232f8f.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2026 02:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779356536; x=1779961336; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
        b=gE2mTH44GayFr9mtAkmJVfSU67d3tm+/YLoN17BfGZH3Kca71yP9gzWsOKPeIsBvRD
         laEPjmCECV77JeVn2SVjFX74IqeEWHDMu8tUR8rhrshkr5wxfi2XcsVJccvbpbFEoWPv
         T0aUIqhFrL5b/ffdNRMW5j4OnaKfqZS5jKXSx8i7zQFOkQn+EJQ/EZi9N9/nAPflgD+5
         dy6pfrWDU14zulEvGUGFZnzpcbEeVydktffcHNVHMhfkzW3gi8amUGywq1wodNRvSV7A
         SWesHKw5+EIirgvWil3KTxyyGqJCG5WJq03iNKYm/EYtJ/BjPsF9U4QLV9nW/dOAZEDz
         6nnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779356536; x=1779961336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0WzMLsQukLw8E3UhBm+/KFb/Fo3mZZq0u+Zrumr4RyU=;
        b=GaYJPMGXk1MTrH4DfY0R/ccnwroMHxAdN24yj6pcCyFycjlNWsB+K7zptmedkxPMBr
         l0ZCvYzenjhlfYT1/PrIUsmRIjQq5BIIi4F3I35ulCEPD5jAhcZVFJz8QAMgGYz2TD+Y
         a2/oHrWdaVzzD94GfezMzyUhOUQzpCrQWUtgadVzN6/8mkh7FLxPZWJPggtB1m3ROzCz
         RTAhuWmBZFpzRCeu79+Gs6DQHhfBiuyFVHHKITPI2k8KxTla0skTGOUO3hjD2y9fD1xK
         5xLxoGSpaHdHt+5zML5nQpdOhNI0xCqrcUpo0qig21PjAlDJgDH2YdT5M6TNgLa+/fuu
         UtXA==
X-Forwarded-Encrypted: i=1; AFNElJ+keX3MWXvTNGcGGbM1lYkPdNBt+Ncg4s+ftQxqTOoN+hCuGFsDnS0xGfTdPVy+CfRwWc+xelFQckg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqpJf/Ul9jG0s5YiIohBW9bG2urKczI7ezshOUpjL0bjDznyTK
	eUTLjUvrHtxt9KnhA7QFT4it2Pr00zpbg7Euz7HaFmbv17+mumoXMaJSQIJjYeW6vgUaXFUIY/y
	W+cJTICLoZAYNYzYQr5shizsG/zWvhXfyVJpw3g6tEAZpJP1AL/gdrqXi7cl0
X-Gm-Gg: Acq92OGGsyinCI3vSpyF+mD1xTPyAyPa0Vw9CCZ1l7IodkOvcOGrs2NE4bIGHA8Cp7H
	QSYLHmzjfItWsipmiOfSkFytGUsMHW6zN6x+ID+dAXi7PVl5M6+tQLtCJZKEtodSTv0sdYYN9uW
	xF8yKIs6gmJm3hvKU6ZHEZZtCiGfoYap7Zkj5jRHUamkCPKLRPrYiOtfQkluRUfx92wH2oT6cAt
	lYkptb2kl9McEDdMu6+pMun7GZAyn1AstWw1nOaadl0Cxx6Y06xecPnSdEZjeYXXSxQoCT6/ctz
	QBo8AThMwKVYK213m6GbpaMIpcf0mNwFSVKHfvdEfQwScDECpISWuB53RDfHPu2CIzn910tUlnS
	KT3GCYilXGI6+daHOtC7WatNG5R3gpdVyHeXMq3smcnZ7OxY5WqCg83w=
X-Received: by 2002:a05:600c:81c9:b0:490:3cec:52f5 with SMTP id 5b1f17b1804b1-4903cec55f5mr9775995e9.2.1779356536309;
        Thu, 21 May 2026 02:42:16 -0700 (PDT)
X-Received: by 2002:a05:600c:81c9:b0:490:3cec:52f5 with SMTP id 5b1f17b1804b1-4903cec55f5mr9775515e9.2.1779356535822;
        Thu, 21 May 2026 02:42:15 -0700 (PDT)
Received: from thinky (178-221-68-189.dynamic.isp.telekom.rs. [178.221.68.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4903c9abbadsm13930015e9.8.2026.05.21.02.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 02:42:15 -0700 (PDT)
Date: Thu, 21 May 2026 11:42:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org, 
	david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521090705.GA14254@lst.de>

On 2026-05-21 11:07:05, Christoph Hellwig wrote:
> On Wed, May 20, 2026 at 02:36:58PM +0200, Andrey Albershteyn wrote:
> > This series based on v7.1-rc4.
> 
> How are we going to merge this?  It touches at three subsystem trees
> (fsverity, vfs/iomap, xfs) so some coordination will be needed.

As most of the patches are xfs, it's probably make sense to go
through xfs tree

Carlos, what do you think?

-- 
- Andrey

