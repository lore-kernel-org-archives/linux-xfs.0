Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B49916131C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 14:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712760185; cv=none; b=ISWCOrtybsXHc3no2ebqFvzEKqQCZVeUt1kSvGoGCutoJ+Yc18WOuV6Z+2UksIQFWYXc5djEzUFf7blBycgI3SC2c0ijn9AePvEpM9vvv+lAeYveclY7TiofZKK/e6GBk3gBbV8WalvixInItGsJ/E8IPR1yQjrBFnAy/EkVE70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712760185; c=relaxed/simple;
	bh=mdE4AFJmcx7sG5k9QOUqN+TB2UORPIWb6tjUTU6OHzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W69KFtqMTJ12R3M54epTgGKcvpUl8tZtBX3lGGl0MKf9Pv2aC1SNdtIr2goJTrG0D5S9LPpbO+ov8TvedJcTVDpe9lU+bpiFVp2JqTOpSUZPHwh+eQD5kiUDDVtw/LSP+Md4sMgEZhEMb9jwTBsYZBbyevINtL7G0rzmQsdQnAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iN8Zd7Ob; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iN8Zd7Ob"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712760183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uNekNL5le48V0m1euDO7VRr7+CGqhPnB+TK2XGui12Q=;
	b=iN8Zd7ObKhZYHI28xvJb+WPOsGgQvWUzmvAFsGVimujS6D6/gJKQsLxq73Al7mQCvV/JIB
	exBv7wGAl8ly2Slgj/g/BD0xgRBnqVYANDShqZbbXA3ZaqgO3afj6kXc0QbxjRbeskkIxc
	dHAxLEcVZtbfk6luVxo23QUzWRGLCUM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-sqw3liQNOaO7OFTylz7JTA-1; Wed, 10 Apr 2024 10:43:01 -0400
X-MC-Unique: sqw3liQNOaO7OFTylz7JTA-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5d8bcf739e5so5913340a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 07:43:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712760179; x=1713364979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uNekNL5le48V0m1euDO7VRr7+CGqhPnB+TK2XGui12Q=;
        b=gDQXq9sj0kwTiVQ/iS0dKgHQqDTjgY8pC3V0x/6xOtM0Mn2dHVquxpwyQlarTKzEdC
         xWv9MVv3U0jcY2YsxS9reFu+libXMvI+zZnDfhvJyb/lgg3kG7O5ZqRqmtlSmub/NhRx
         ty4+ubany9bX76cHCwksURwENCA0OTh+60Lvdvy2Qm26L1n1QBM/jNNvRgV76Fz931qk
         xMR4+HgwepU8am/FSjD/wLjRmSCKuMteYVUDuqgvr4Hu6WkGgAvhqSNNQMu/Qm8kwydp
         JejVEomARXfTzTJ3tjhaRjYvVMDj+mGa7xQlAqfndt08k04t9hfeaZY61/QgtJiYUl8i
         W0yQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxvaBqwjA5EDiuP/kXOw8Cfql/OuEcu8/VTuckKKivUJE0jLdUSiZ9/Q/bHTH4XEnClZv2Gq2VIltB9++2n4en2J6IjxiAuAIh
X-Gm-Message-State: AOJu0YztHU92L+CoGeA0pa1nCOMmMGcznwupfB2D82Fq86Z7k5PZx0un
	H3BPuZhSKZ4nunF3mqwyfFNF+29UXrcUMfMk2YdhnlZ2b5DoPxRs2rOQhun21d/g87b1vqTlLEU
	VUiAqLqtoNgeCZ7FMRaYYVccElcI3nSSHPUU3+9pY1Cus0YCFkoIIeRKCjg==
X-Received: by 2002:a05:6a21:3994:b0:1a1:448f:d7b8 with SMTP id ad20-20020a056a21399400b001a1448fd7b8mr3039079pzc.62.1712760179042;
        Wed, 10 Apr 2024 07:42:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtkhT5FYYBjohIxZ49Riv7hmG+JtNcaD1nf+XQNDLmYfNGt6QTuhclJl99LfsmfPp+Mb3Y8Q==
X-Received: by 2002:a05:6a21:3994:b0:1a1:448f:d7b8 with SMTP id ad20-20020a056a21399400b001a1448fd7b8mr3039042pzc.62.1712760178433;
        Wed, 10 Apr 2024 07:42:58 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id fx8-20020a056a00820800b006ed4c430acesm4964071pfb.40.2024.04.10.07.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 07:42:58 -0700 (PDT)
Date: Wed, 10 Apr 2024 22:42:54 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: fix kernels without v5 support
Message-ID: <20240410144254.iiqrxlm64xc6mqa6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408145554.ezvbgolzjppua4in@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240408145939.GA26949@lst.de>
 <20240408190043.oib4lmiri7ssw3ez@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408190043.oib4lmiri7ssw3ez@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Tue, Apr 09, 2024 at 03:00:43AM +0800, Zorro Lang wrote:
> On Mon, Apr 08, 2024 at 04:59:39PM +0200, Christoph Hellwig wrote:
> > On Mon, Apr 08, 2024 at 10:55:54PM +0800, Zorro Lang wrote:
> > > > this series ensures tests pass on kernels without v5 support.  As a side
> > > > effect it also removes support for historic kernels and xfsprogs without
> > > > any v5 support, and without mkfs input validation.
> > > 
> > > Thanks for doing this! I'm wondering if fstests should do this "removing"
> > > earlier than xfs? Hope to hear more opinions from xfs list and other fstests
> > > users (especially from some LTS distro) :)
> > 
> > What is being removed is support for kernels and xfsprogs that do not
> > support v5 file systems at all, not testing on v4 file system for the
> > test device and the large majority of tests using the scratch device
> > without specifying an explicit version.
> 
> Sure, I think most of systems testing doesn't need this, except some old
> LTS distros.
> 
> > 
> > The exception from the above are two sub-cases for v4 that are removed in
> > the this series - if we really care about them I could move them into
> > separate tests, but I doubt it's worth it.
> 
> Let me check and test this patchset more, before acking it. And give some
> time to get more review. Thanks for this patchset!

My testing done on some old and new distro/kernels with v4 and v5 xfs.
It looks good, doesn't bring in more issues. So I'd like to have this
change.

But as the review points from XFS list, looks like the patch 4/6 is better
to not be merged, and the patch 6/6 need further changes? So I'll look forward
the V2, to take more actions.

Thanks,
Zorro

> 
> Thanks,
> Zorro
> 
> > 

