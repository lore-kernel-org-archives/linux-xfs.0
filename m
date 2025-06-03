Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB8322FDEA
	for <linux-xfs@vger.kernel.org>; Tue,  3 Jun 2025 13:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748957866; cv=none; b=ZAOWDNAcJJZ7eKlg+fNz0k3XklIfMgt41BQmSSIA8vp5nYqmuX4nubKs17dJMM46mwAWHLO6QOjK6JXNVpcfFLE6nrawh89kvlZhl4vBiwODdq3cZlnCn2XQl1jf8T6xj9jjsDnajPCVFQP979NzYWyd9m12jBbem+UIirkhadA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748957866; c=relaxed/simple;
	bh=tQw110EHLRiTqyKmaEl6CwpwtZx8Pit5aVtH22wzAog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4lHI/5hhDji8lix1fb9SXToRGlVhe3utzxYzX6gUclx/xyy4OrUzntu9I5RLjoNlqlqaQwSHRJqChovqjN2oSLtFCTRhHDbKmbQVDFLo5DKIfljzwtM8rRaU2YGzJAZHrGzcBEJ5bNsic+5136BnkpIgLJCga5d2i88G09cQRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=fQm6MF53; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="fQm6MF53"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4a5851764e1so47125931cf.2
        for <linux-xfs@vger.kernel.org>; Tue, 03 Jun 2025 06:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748957861; x=1749562661; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UoX6ZYAbWcKDR6KFcgyyRoqI5kTXzqc7rOw8qvSUCMg=;
        b=fQm6MF53qYwSSeMTr2sltiD/eFfcQJmzi89gd1I9yNsMcxsJgeykJFQDd2rJFjqK3d
         zsk5PJSORAeq1P7oiOrJN17n1DaJdLiiW9ri6j/qiPpy1ELwXBq3K3mNGpvTzFOob5KR
         PdMSE5qvoLD5EyPMzUDX8gKj7cIeSJvnGlC8HPv1HAr2+HqHxHW4lPJXmlKK0aXsPLbe
         ApXM694n56Q3kwaR6xr1ljighNPXSA2zXEyEFsQVCifkeego146Fp/zwQ2BT8TZVbuSh
         y/nJZTYur6p/nVgIUF0FRaiQyw9MyXovFKMQoYludBFZfAhI94HajoVMu00/SH35WdbQ
         D0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748957861; x=1749562661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UoX6ZYAbWcKDR6KFcgyyRoqI5kTXzqc7rOw8qvSUCMg=;
        b=HVhlBC1cAXlU+tl9cPZj3fo3ItMtvmdv1k7RWbrdSUp785FYH9sIj/JDKLuDxwvfUW
         cbIeq5POxInrCtFszq/4QBKXOHv5ppJzC9bTI+szIrAUjpFrDM6oG77IqP8VGBC9fAWk
         /EYWXbdL8tO/snxChh7qtaC2Ebh7olk/6qj4HXvFj8qv0EOEZq83IS+G/qNV1+dpIjaZ
         oIwqmEYEGwzGY4FgLTP3uS89mfYyuJ86Q/IxU/sysvq7N3ROB2v9crHcUeIstm51H+gf
         xjscn3Nm7JYq0zyvGJM/pGcjT7dByAigzqOBqFwls+3ecas4LViCojJH8HyoiVHTh96l
         GFyg==
X-Forwarded-Encrypted: i=1; AJvYcCUbDMqzcDdDJxutJO7TrhdPtbpEUK9hmd65Dgxwph2WcB1NPTHOndROCbS696FSk8ca34kolNt/mOw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIeeT4iFnKJEq2UjhY6JPxWMzIaxSi0m8xuAkt+hrCBVOdAJN7
	rJRIulEooTIc83bzUk91L1PobgHt8FK0gmUzhHUYAGDD19FZsCU/StqqZpWXzMv0mYk=
X-Gm-Gg: ASbGnctQOdGw3wm80nh4bJYNuvmuw6TmSBq0pM1mABGEVcZzzhmr6q5T7boyKjPdnD3
	mSkFc/KBNM3Vr8+lkwQ4ek2VZg1LfpJUa6tzZeNoIuOjKkpRpp9YKQr7DoPdnuTaO7d4avgO1kf
	ljd+yfiHZ8XtAQzp+09u3HnZbQJFNi80lBisfPTID9+dol67PvWA5YXhmKx82AZTrkIs1Vl9DCh
	YW1zy27G2VgNbWepjGNpfGf1KUKQOrieU/lOePVLDIV4//G81/2nPQjC51Jq5QYX1pGzg0bMvmD
	0l6cbPEBIr7vBXz+KE+d1kjNuwbQuCou3VN0I5b8VgqNPz0xMVxuLeHJ5l77DvDKEWZTGEXyUlf
	SDfPQ3oWe90RF1JiCLGIs62mpUeT39CluPbRigw==
X-Google-Smtp-Source: AGHT+IHIja21FGplZEuqybwyfzBxoI5k6ggct08qhelvg2n2Sr3vDQGi+qZrCCr84f/KmAHse8r0Yw==
X-Received: by 2002:a05:622a:4c16:b0:4a4:2e99:3a92 with SMTP id d75a77b69052e-4a443f2d1a2mr265367291cf.38.1748957861491;
        Tue, 03 Jun 2025 06:37:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a435a36e1bsm73924021cf.62.2025.06.03.06.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:37:40 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMRpk-00000001h5v-1tYD;
	Tue, 03 Jun 2025 10:37:40 -0300
Date: Tue, 3 Jun 2025 10:37:40 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, gerald.schaefer@linux.ibm.com,
	dan.j.williams@intel.com, willy@infradead.org, david@redhat.com,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
	zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
	balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org,
	John@groves.net
Subject: Re: [PATCH 04/12] mm: Convert vmf_insert_mixed() from using
 pte_devmap to pte_special
Message-ID: <20250603133740.GE386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <171c8ae407198160c434797a96fe56d837cdc1cd.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171c8ae407198160c434797a96fe56d837cdc1cd.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:05PM +1000, Alistair Popple wrote:
> DAX no longer requires device PTEs as it always has a ZONE_DEVICE page
> associated with the PTE that can be reference counted normally. Other users
> of pte_devmap are drivers that set PFN_DEV when calling vmf_insert_mixed()
> which ensures vm_normal_page() returns NULL for these entries.
> 
> There is no reason to distinguish these pte_devmap users so in order to
> free up a PTE bit use pte_special instead for entries created with
> vmf_insert_mixed(). This will ensure vm_normal_page() will continue to
> return NULL for these pages.
> 
> Architectures that don't support pte_special also don't support pte_devmap
> so those will continue to rely on pfn_valid() to determine if the page can
> be mapped.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  mm/hmm.c    |  3 ---
>  mm/memory.c | 20 ++------------------
>  mm/vmscan.c |  2 +-
>  3 files changed, 3 insertions(+), 22 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
