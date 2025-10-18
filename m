Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58046185B67
	for <linux-xfs@vger.kernel.org>; Sat, 18 Oct 2025 14:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760796333; cv=none; b=NYFYw7j65SPz9Rh8AdrC2cp3nU6XwrbuS5GV4vZXJEzbh0OFHk01oDIZSXri9ggT7MubvLVEdadTyD18EmspQS7F8E7G8ageoLNstr8Ly0HaCMvtYdl7X8mPZoDBbcCycVMQer1Ykhdl22R8PDxCSWJcN3LPZmA/R1dzJJc3dJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760796333; c=relaxed/simple;
	bh=VjP9NuW/CobZTSxmZflLMUjqw7SjbBzZHVXQVkXKk2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MfBYmNhC/QatPB1Ee/eTrtBpq2wocRIEZQk6VC97n6I4H7qF2tiZdHkGw2hBvYxA7Isli+LkX4EqjlNENbDWMvOSOqt9cbUCJzQZ3bbVlcKwDgeEvxd3U/VCPejLz3qXEp1V+kmvq62YwAcEOvkot6GafLvlOFfudCUzJKnUCrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a1OO4FR0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1OO4FR0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760796330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PhSauSM2IFyBlTKpDxEEF7KFbZU2eE7CTjj0cSZwp7k=;
	b=a1OO4FR0S6/KxSTnoC3TdLfuj9ec6WZFslwZzl5FYMxNPLWZ83E5bVmOucfa5xG2+f7GdU
	sIW4y8irfB/3iwtRERarDv8f87t0emnPxUiO99zRRoAmRulQEQZi4PK3eH7/s9OPP7se1u
	YAFqeJ0SDVFiveUWVqEozPK5Uu//2ho=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-hlzKpez3NhmSTLmBUFKXLw-1; Sat, 18 Oct 2025 10:05:26 -0400
X-MC-Unique: hlzKpez3NhmSTLmBUFKXLw-1
X-Mimecast-MFC-AGG-ID: hlzKpez3NhmSTLmBUFKXLw_1760796326
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-33428befc08so6109476a91.2
        for <linux-xfs@vger.kernel.org>; Sat, 18 Oct 2025 07:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760796326; x=1761401126;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PhSauSM2IFyBlTKpDxEEF7KFbZU2eE7CTjj0cSZwp7k=;
        b=L3yPVZI60GrJ5K5jGhKNzDvM+lIz/E/SLy/2KxE0yjzsFfqTpbhI8YgF7EFNbTGpvs
         e33fZdi8LTNmLzJeTO0pz2tKW7CiFEJnbaLmn0vhusXaSnKv3GS89p9GMBBj+td/YngM
         sZnOMq8ZOHNZxSw4kopMpKud7qkF2MNaCfH7e9YMtJsdej+GEvO49+twJXT+vBUjHw+l
         asJ52bg0uWTnIeYkcmH5GoKW0/Ve7R/XmVzqXtvAxGn7ajvF4Hr5BxPBhO0o5c/czb9G
         Aj23auw/QgKJNSbFq6Ew6cSoS063ysXP0iFEK1fk9s+S3oUAtmItsXjo+9ccFZBJQIWC
         mD0A==
X-Forwarded-Encrypted: i=1; AJvYcCVtjJaKCBfzKIK3wyRjP55MXCJCBQr1RiBBLRkmGyeJb6sy+rFsCjUGjfDfKMxTRzTZa09DEvKnvTA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy7ozqCgKTGHURAo8ivq7Qj4fiM1feti79pFW2b1/EDL5JeVY7
	IGcfMeAuEI/1O1q08QJ75ljny0eHcJZzSwcr2gPC7lVGvDjyGLrQnfyelx+kfKeOnh1btzmUU4f
	ELBKHqEpjcQVOL+SanVbkcBzd5+H04VyWxI1ArXTpnowxCn9iEhmctV/1UYzGiA==
X-Gm-Gg: ASbGncsPAZSatH0JurgG0KexpZkdsLXxu3lLIigcilUbkGmj/oCyRadXISmOHL5y1yX
	snvvxhhz/edhuEzgtY/Erai127pZzUtpsXJ6Zm5Q9hWgd/X+emEEcgKalhvS4tMOJKJ/RaecDUH
	GemzthlX5ds5StE4uU2OynXiz96v0a08nCw1Qowu+fwjjH7+YWxCKGQFeIcIuQBnxnSv6uzjhPH
	WQjsAw8M9+KLGoruH8KLFG4IGtiiiZjAJ8XFZgRbxqCvfiTn3KKjU7zN4xeZXA3jRmm2qqUpV7K
	N1MFEuLEPZn2BKiSE3aI7VtAT4IvPDiziA2V7OLzeVTPMIzrhfBzr2O69Y0nKhjM5eX+nyPB0lY
	J6X7hUeDGYqYitssz513Er9SwSmx4/++WzPnjSMg=
X-Received: by 2002:a17:90b:2d8b:b0:33b:c172:6b1a with SMTP id 98e67ed59e1d1-33bcf87c4d6mr9992956a91.12.1760796325747;
        Sat, 18 Oct 2025 07:05:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8P1OnvVde6Urgu/5G/IcNIm4QzhIalGuckBWRj7z3lbY2W8XWPFOFmdKeThbLievb//Hz4w==
X-Received: by 2002:a17:90b:2d8b:b0:33b:c172:6b1a with SMTP id 98e67ed59e1d1-33bcf87c4d6mr9992890a91.12.1760796325279;
        Sat, 18 Oct 2025 07:05:25 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a2300f254esm2894383b3a.45.2025.10.18.07.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 07:05:24 -0700 (PDT)
Date: Sat, 18 Oct 2025 22:05:18 +0800
From: Zorro Lang <zlang@redhat.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: hch <hch@lst.de>, Naohiro Aota <Naohiro.Aota@wdc.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v5 3/3] generic: basic smoke for filesystems on zoned
 block devices
Message-ID: <20251018140518.2xlpmmqajgaeg7xq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251016152032.654284-1-johannes.thumshirn@wdc.com>
 <20251016152032.654284-4-johannes.thumshirn@wdc.com>
 <20251017185633.pvpapg5gq47s2vmm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <0d05cde5-024b-4136-ad51-9a56361f4b51@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d05cde5-024b-4136-ad51-9a56361f4b51@wdc.com>

On Sat, Oct 18, 2025 at 11:13:03AM +0000, Johannes Thumshirn wrote:
> On 10/17/25 8:56 PM, Zorro Lang wrote:
> > Does this mean the current FSTYP doesn't support zoned?
> >
> > As this's a generic test case, the FSTYP can be any other filesystems, likes
> > nfs, cifs, overlay, exfat, tmpfs and so on, can we create zloop on any of them?
> > If not, how about _notrun if current FSTYP doesn't support.
> 
> I did that in v1 and got told that I shouldn't do this.

This's your V1, right?
https://lore.kernel.org/fstests/20251007041321.GA15727@lst.de/T/#u

Which line is "_notrun if current FSTYP doesn't support zloop creation"? And where is
the message that told you don't to that? Could you provides more details, I'd like
to learn about more, thanks :)

Thanks,
Zorro

> 

