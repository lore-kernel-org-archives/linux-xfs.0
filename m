Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB6815574F
	for <linux-xfs@vger.kernel.org>; Sat, 12 Oct 2024 14:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728741964; cv=none; b=Ij5xSZx10OTZXLGHI9J3DHTM9ssG7g7kTdfgOv3FfntvQPe/kidb9k62kBP4QaPs5hMhlSlZNSmCAQfXAIDG2pLcYtSdiYuIfRvJqswvjkjwkBPw+hY1A3D1Ez29HjxMFkDvQ9G1OX+2PyUYBnyQjPBMazjHmzfwC7/FMoOvUds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728741964; c=relaxed/simple;
	bh=NBksyTOGWe4Nt8KqI4uApjQlOLOGrnw160iwZF/dcKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R22oxs7OgWdYf5Wcbc2j7uQPlClItC4mqV5VqJc7ApAnD8ZzGn4Y0xoCpt3/7b+vZ/sAC0wZGNMCli7zVulsxvVct3mcADdOciW2x9iDC2e9PcQ+2gRveygHZb3Ne+W6JZPQKoxzIP1Bx0TdBC+9ths6ohkQAav0rE64UzWu1Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQVfXZEZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQVfXZEZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728741962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=waFDwgPr4QcJIxhWov0AkVYaGHbJ4W1aOqTw0mnlcSk=;
	b=DQVfXZEZAB/o3GgF6Qy3cBUA3Sx8HO72rNnHOf7nL6hH+w/eLwXLa2Ps3DiEOndOmWVxup
	cmTvb5DhsS5A/uI/Wsl+LJYNSrGk7B2AASXHfumGCA7pAVSitcf3Ycafllr1jIfzSRJL6W
	1wec3AhaFB0BvzN2XRo90uQxpi2JNXw=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-D0QaXwS3OTqKzQjSbv-0vQ-1; Sat, 12 Oct 2024 10:05:58 -0400
X-MC-Unique: D0QaXwS3OTqKzQjSbv-0vQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-71e03f4cbe1so3710949b3a.0
        for <linux-xfs@vger.kernel.org>; Sat, 12 Oct 2024 07:05:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728741957; x=1729346757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=waFDwgPr4QcJIxhWov0AkVYaGHbJ4W1aOqTw0mnlcSk=;
        b=GExh8dqW7DO/5GB3Gshkkwx2XcoJVDftkpZzbR9rmmJv+dXJALZ2huASE0aFM+PYNZ
         6qi67dgStK6i/iyqqX1DytJC4NJ06dUEoTD3JrBDIA6MGlQOkX9XJAKoAG1sNIGtLTuK
         qda6PcGhpHnvjAcriei/ckCT2iH7TdFtd/7TDs3k4Ka+nXgdXnL3/hW8As5l9sPsToGC
         FfYtmrdZKyEMapD0OXBr1QREet3rA1I0Z4eYpQppCLteOp2RB4SpD9ItMT5Wo7p8oyGr
         aK9u3kyePKeLNnCPsZJLLOjElD5rHxzqMfARfDVWEobWqm3ZndlzlWaON4YYJZpPmRFG
         lkow==
X-Forwarded-Encrypted: i=1; AJvYcCVgxNKYafkDNpVceACTo71uSn4Zb6pfUsTeF1I5KnUO2v6DgBzHTbpK7MfjGTuWhq8tUH+z/D6gvHk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7QlDOPsRp/nJnmItUPhKPeXQko6icioUfR/DG6rsiKAQVrV+c
	BYc8TCoqyLqkvAnlt/rvqC+TRl/ZgS3fDGi9kDCfnWak7sEre+vzCbxXUijIU7gW9NiBWURzCOy
	3lhiLrABqCasbtqx95vCZ4uQFFTWwF2uVfxxRZFf6viSff77eBeR+OFsK0g==
X-Received: by 2002:a05:6a00:1252:b0:71e:659:f2dd with SMTP id d2e1a72fcca58-71e37f4edf2mr9636647b3a.20.1728741957679;
        Sat, 12 Oct 2024 07:05:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOcIar4YRVXK9mEh/hhK+NDFYUIxYOnGopKwwWU/UhwCmi5Oxf/aZxhd++QLkTL7P5kcpEfg==
X-Received: by 2002:a05:6a00:1252:b0:71e:659:f2dd with SMTP id d2e1a72fcca58-71e37f4edf2mr9636615b3a.20.1728741957349;
        Sat, 12 Oct 2024 07:05:57 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aa937cesm4163289b3a.132.2024.10.12.07.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 07:05:56 -0700 (PDT)
Date: Sat, 12 Oct 2024 22:05:53 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/122: add tests for commitrange structures
Message-ID: <20241012140553.hpgvmjfajdfdjtgh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
 <172780126049.3586479.7813790327650448381.stgit@frogsfrogsfrogs>
 <ZvzeDhbIUPEHCP2D@infradead.org>
 <20241002224700.GG21853@frogsfrogsfrogs>
 <20241011062858.p5tewpiewwgzpzbo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241011181920.GO21840@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011181920.GO21840@frogsfrogsfrogs>

On Fri, Oct 11, 2024 at 11:19:20AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 11, 2024 at 02:28:58PM +0800, Zorro Lang wrote:
> > On Wed, Oct 02, 2024 at 03:47:00PM -0700, Darrick J. Wong wrote:
> > > On Tue, Oct 01, 2024 at 10:45:50PM -0700, Christoph Hellwig wrote:
> > > > On Tue, Oct 01, 2024 at 09:49:27AM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Update this test to check the ioctl structure for XFS_IOC_COMMIT_RANGE.
> > > > 
> > > > Meh.  Can we please not add more to xfs/122, as that's alway just
> > > > a pain?  We can just static_assert the size in xfsprogs (or the
> > > > xfstests code using it) instead of this mess.
> > > 
> > > Oh right, we had a plan to autotranslate the xfs/122 stuff to
> > > xfs_ondisk.h didn't we... I'll put that back on my list.
> > 
> > Hi Darrick,
> > 
> > Do you want to have this patch at first, or just wait for your
> > next version which does the "autotranslate"?
> 
> Let's drop this for now, machine-converting xfs/122 to xfs_ondisk.h
> wasn't as hard as I thought it might be.  Would you be ok with merging
> the fiexchange.h patch and the fsstress funshare patch this week?

Sure, if you hope so :)

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > 
> > 
> 

