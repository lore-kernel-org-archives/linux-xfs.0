Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85068151990
	for <linux-xfs@vger.kernel.org>; Sat, 15 Feb 2025 13:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739626460; cv=none; b=j8Jr9X+QO0ki5FfCzexf3z9pWoyqERKBb9IR95hcQnXn9JsvwzuzIZmtDx7YrCiaF3o9BXmlNRvW6B96kOOh5NPvYKuWOOHvuZwrDB40BR0p+HrzkClMFmUaPdJF3GNoXF4kuDUw/PlHGMou1TkFd1AIR4PZGSqUr9qhEqzDaU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739626460; c=relaxed/simple;
	bh=WtC2GbwCedtZMmXg8Qensd9f1ydLSOsf1VkDH7vDKok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuKXjKB1ttOkyoP4dc1d8IdDIv79BhlHcHPrjMUzvfN5DaTwcmvTc9ObsZD3VxavXzSZDjeR4EOc/vK9YJj5nkdI9bR8aPWwsC9GZ2CuEma+kWWl0ogUxrNA9Wd1ZLSx+O1u0/MAWIXvz54akvpDET2pK+xiVwHhcZV9dvDE608=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B0+ehhOu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B0+ehhOu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739626457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lZEes/IKM6B0YDSI3Q43LqBo5+9X0FnqE4vfn12Pd5w=;
	b=B0+ehhOuNLnqYvk8uO6hGCn8iH4laaTSZu2Ety1CeNbL5JspmmN6V86YQ0PpsQKVESC4SC
	5QJyvgs8hVS1Dr/RC+wSnz7iL3Vifq6IMAZZ1qFedq152/oquiSYcstjYqKcmwMauNVKao
	u+otGeZ1ysBLIhHv/KYYLSmA4ScNS2E=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-kno_3Qr6Msi-Y_II3X7RLQ-1; Sat, 15 Feb 2025 08:34:15 -0500
X-MC-Unique: kno_3Qr6Msi-Y_II3X7RLQ-1
X-Mimecast-MFC-AGG-ID: kno_3Qr6Msi-Y_II3X7RLQ_1739626454
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-220c1f88eb4so46680275ad.2
        for <linux-xfs@vger.kernel.org>; Sat, 15 Feb 2025 05:34:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739626454; x=1740231254;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lZEes/IKM6B0YDSI3Q43LqBo5+9X0FnqE4vfn12Pd5w=;
        b=OkTcQkjn4qVD64XgSMtDp8Seoj2nNb/xBSI9OkRg7IsM27XT144Gv0bvWp/SvDhuCd
         0tQkoPld+yMLDOiBdeTk9g/5dx9V0k9/pZjgkKX9N8/UXqjmrT48boBQ4lNmHvQrTBxi
         fv14si7RAmZTk91fy9v7ClBbSzQCrZDQXl0N3JhldunEcpXE0jt+B0m39VCkHQ4xmWHo
         W1OR2qUxEpIMTwq1IPaWhHqqMbwRJ7J7V87FVGokV26UMW/Kq4wefLQgsKyqkXqczuOz
         tpthOmKsjkp7uXySkeEpor9bdiPcyeYGNXlDQdYsPWE0nKL6PCzwPH/2EG6fZEdhjPoo
         LN4A==
X-Forwarded-Encrypted: i=1; AJvYcCU58DHPi3l9ykh/sJTeKxQ9a/ssb6GXVRKD6Et6NXH1HMGp+a/XXg6Xqm7KyPZN9LJopTs+V1TNhJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww9a3hHyffglo8kMU8f5TzrF6XoRBz+ux2f9N1cgetBdd87n3Q
	v5lROtak237hdSEv6yzDuqFFQx3VtfCFbcPrc7zCmbj9LAdacRW0g1l2OF+bSM4/5GLAq132emL
	g4p2LCbSNThXL80Mx+2GM4Nh/qJM8dYoDxu9JhoGpYtODCz2IHZHn42EyFQ==
X-Gm-Gg: ASbGnctyNc1XLslUWKXtY3c/HKtJ0XEfjBMnd5JQDK32VpP4YIYWJMExPKPPnhYOVmb
	R19IUExYZDr4IOpQHWXBgLKSxCrLquWIx9BadXYIiym+W/KriWe7MlKPiXjdtld5i6FtOuZLoKw
	BB1d9KD6s14c4Px8E5JiyrLhbXbDxojIm0Cbj+p92Mf0+4HpD8PyRI+UUHfdOHmBKNCR8BM0sjN
	BMrR0wo1G66jFLOuwRi8rDiy7G+An2NpYFuT44utM0RK7NUcrD2M/OOdZouGfxs/tJww4NZ8+OB
	YqVIwUjoR08+NhARzbXqQ7LPSUJbW/alm4ajGYaj/ZRk3A==
X-Received: by 2002:a17:902:ea11:b0:220:f4db:98b4 with SMTP id d9443c01a7336-22104012399mr57018335ad.24.1739626454424;
        Sat, 15 Feb 2025 05:34:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF53R4PjmNymCIcqascu/2DIBwNl5r118ctAFHiMJfKw83XgYcYgnIFoqfw7YCtS3haP+0/iw==
X-Received: by 2002:a17:902:ea11:b0:220:f4db:98b4 with SMTP id d9443c01a7336-22104012399mr57017975ad.24.1739626454061;
        Sat, 15 Feb 2025 05:34:14 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d5349556sm43703045ad.19.2025.02.15.05.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2025 05:34:13 -0800 (PST)
Date: Sat, 15 Feb 2025 21:34:10 +0800
From: Zorro Lang <zlang@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, dchinner@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/34] common: fix pkill by running test program in a
 separate session
Message-ID: <20250215133410.wczc7vvmuahlqfpy@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094569.1758477.13105816499921786298.stgit@frogsfrogsfrogs>
 <20250214173406.pf6j5pbb3ccoypui@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20250214175644.GN3028674@frogsfrogsfrogs>
 <20250214205031.GA509210@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214205031.GA509210@mit.edu>

On Fri, Feb 14, 2025 at 03:50:31PM -0500, Theodore Ts'o wrote:
> On Fri, Feb 14, 2025 at 09:56:44AM -0800, Darrick J. Wong wrote:
> > > The tools/ directory never be installed into /var/lib/xfstests. If someone runs
> > > xfstests after `make install`, all tests will be failed due to:
> > > 
> > >   Failed to find executable ./tools/run_setsid: No such file or directory
> > 
> > Urrrk, yeah, I didn't realize that tools/ doesn't have a Makefile,
> > therefore nothing from there get installed.  Three options:
> > 
> > 1) Add a tools/Makefile and an install target
> > 2) Update the top level Makefile's install target to install the two
> >    scripts
> > 3) Move tools/run_* to the top level and (2)
> 
> Looking at tools, it seems like there are a couple of different
> categories of scripts in the directory.  Some are useful to people who
> are developing fstests (mkgroupfile, nextid, mvtest); some are useful
> when debugging a test failure (dm-logwrite-replay); some are useful
> only to xfs developers (ag-wipe, db-walk).
> 
> And to this we are adding utility programs that would be used during a
> test execution.
> 
> I wonder if we should split out these scripts into different
> directories?

Hi Ted,

Thanks for taking care of this issue. Yes, I talked with Darrick about
that. I provided 3 methods:
1) Change xfstests/Makefile only.
2) Add Makefile to tools/ to install the scripts we need.
3) Create another directory (e.g. scripts) to save the scripts for testing,
   and give it Makefile.

After talking, we chose the 2nd one, something likes:

  TOPDIR = ..
  include $(TOPDIR)/include/builddefs

  TOOLS_DIR = tools
  TARGETS = run_setsid run_privatens

  include $(BUILDRULES)

  default: $(TARGETS)

  install: default
         $(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(TOOLS_DIR)
         $(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/$(TOOLS_DIR)

  install-dev install-lib:

The 3rd one is good to me too, as tools/ directory isn't used for
test running from beginning. I think we can let the patches of
Darrick be merged at first. Then I can send another patch to talk
about the "separated directory" way :)

Thanks,
Zorro

> 
> 	  	       	      	    	- Ted
> 				
> 

