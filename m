Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A555280029
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 15:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746543808; cv=none; b=uxvykHtzlkM0bnh/wfsRo3aNN9enc6CyyztCEOtecdboxH5E12Nsh2pvvg4s+c/UlCSemcSWnDCLpjZIyMv1lDWGuaOr9FYdWhVqNVavFjv+usddNinO7Ns6rXXBJC6yBwQRUPhLh5PGuhPNe99L5TpGTrZLNvCW/qgifFotlRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746543808; c=relaxed/simple;
	bh=8d9y7ErAjrQOqXuTSOAhEkVIMlXmxaC6B2austCbO/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHH1NX1hCXSjSbEUbCUGNnYznd6HnAtgyyNXheDgYshAe0LNobBzhdZzAL+oUc+Xb4B2xkxItAYsyS6ntRYq+eGkh2n8t6t6fjZyfFzmwis0Uu1921TJCSxp2QLQjYpjddOY+HO5o715k7gA0ovUmN5Hwhu2PQo5DvqcalagUE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=duDKAhIR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="duDKAhIR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746543806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aXH29pQMVy4AFRYT+iKQo6DbbvX/wUT7EjvyqhEcdds=;
	b=duDKAhIRpEbrCqbwshT58QmIWfA7MmzKIuxWbeLIamyxXBVGabLYGQWPjS7lZeNKl0Lgfu
	/P1ToDpq82rcvjnmTVbpLzXytRfbWh0aXdPLQHivLAiL0FtxsTy4QvBm2kfwBXLiyTHlfQ
	qeEAJutO4vZduDUsBtz0mGeff3FmzXA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-3fJAWwTsNdic1G3-_NNA2A-1; Tue, 06 May 2025 11:03:25 -0400
X-MC-Unique: 3fJAWwTsNdic1G3-_NNA2A-1
X-Mimecast-MFC-AGG-ID: 3fJAWwTsNdic1G3-_NNA2A_1746543804
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22c31b55ac6so79386605ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 08:03:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746543803; x=1747148603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aXH29pQMVy4AFRYT+iKQo6DbbvX/wUT7EjvyqhEcdds=;
        b=YYTo5DFRp5AWmodwPlwZJf8wSRZNcD8ErGL3CncYOk1J0s7SUTQfXQzyMC77f/tvUu
         OWx6gdIDTvgUx2PIcJSUmgBr59MpJbTRfIyhARmNc/KRlZnZ+dMTQXZ/eCYf3i4+gpOd
         c5AMJPmaOYnqtyvjTO+dEibCI3XGFFsxUnMGYzl7qzYDS/QitOz+ULhOAeCGo9sLq9QL
         VVk07gB2vYwCHN6VA3e+gR7UH54N/vZVRfPlnDO+B/e1e85RF3Tq1aDN/K+SEWMXp0Xn
         AuNYODIW+mfpCrySu6XCS5rgOmrDfGZqQHbP9VJcc51cXZDwo36sGb7PH9A8G7QVrwcl
         js3g==
X-Forwarded-Encrypted: i=1; AJvYcCWl6NjhvWTfeNJpIQEapyyF2wHLQRR5nq1Zs4C/gmktw19j/qBLPQri826ll8l5APPJzTXCEJD62qw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEYSnxvLnYKGyHjhjouwPmbGsNbqCfXXH4XcUFWy8ECyx+qMhe
	h9vvURkWu4wVNFAjqKpTBAOH3FCuiQzzkcCrG1Tz9aUFcWVIpjbCFXToGQKq60sZK+rWY8IEa+H
	4kuIdAqsenwbHAhnBcWPTElM9p2MbSvZ0T+qZctvXJBxLJlLAjETjnZ0Boa3mdeCCFA==
X-Gm-Gg: ASbGncvS8Foci90fMkbIiXHbmtIxzQtsSYtj07GEbSrHPLJ0pA+RP9Xzuuko+Eq4F09
	wYhRsTDhwaAHERMbH4Q7PvdnsvYP1rIobfJjrN7b/BSKbpFZ/ibhpg3lh7+UfoLTYehXrZlY5cM
	yBXQYhfQzBcB2ce0WJUm9/c+SAQhqODcWP+ozcPcSKEA7uSJTAlivJnveQgxxSQ/57tranHaUB1
	Hfyc0KvlhznJsGQkUnHQqiuYgzH9kkmO7mZCZn3IQ1UR+4P5EiV1BUYMrDTQmLAKQP2Ff2Kx6gW
	aPHGxI2ID1ZL7POrD91I2MK6AdYe8jQr712Dct9tHcKWH3Fa4Dq7
X-Received: by 2002:a17:902:ef12:b0:220:ff3f:6cba with SMTP id d9443c01a7336-22e3637c4aamr51936105ad.38.1746543803501;
        Tue, 06 May 2025 08:03:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzJ30l1YniISkWfcZGEXxVAdWUIYEHNTBNN13j9xo6yVGOoS2bHKkxOo79oeFDE+EwgmX1fA==
X-Received: by 2002:a17:902:ef12:b0:220:ff3f:6cba with SMTP id d9443c01a7336-22e3637c4aamr51935745ad.38.1746543803172;
        Tue, 06 May 2025 08:03:23 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e3b99dce9sm15152655ad.6.2025.05.06.08.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 08:03:22 -0700 (PDT)
Date: Tue, 6 May 2025 23:03:17 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
	david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH v3 0/2] common: Move exit related functions to common/exit
Message-ID: <20250506150317.dtaqcp6ocwfb2vwg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1746015588.git.nirjhar.roy.lists@gmail.com>
 <aefede43-9ac6-43bb-a22a-47dc0f4c8cd9@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aefede43-9ac6-43bb-a22a-47dc0f4c8cd9@gmail.com>

On Tue, May 06, 2025 at 02:19:07PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 4/30/25 18:15, Nirjhar Roy (IBM) wrote:
> > This patch series moves all the exit related functions to a separate file -
> > common/exit. This will remove the dependency to source non-related files to use
> > these exit related functions. Thanks to Dave for suggesting this[1]. The second
> > patch replaces exit with _exit in check file - I missed replacing them in [2].
> > 
> > [v2] -> v3
> >   Addressed Dave's feedbacks.
> >   In patch [1/2]
> >    - Removed _die() and die_now() from common/exit
> >    - Replaced die_now() with _fatal in common/punch
> >    - Removed sourcing of common/exit and common/test_names from common/config
> >      and moved them to the beginning of check.
> >    - Added sourcing of common/test_names in _begin_fstest() since common/config
> >      is no more sourcing common/test_names.
> >    - Added a blank line in _begin_fstest() after sourcing common/{exit,test_names}
> >   In patch [2/2]
> >    - Replaced "_exit 1" with _fatal and "echo <error message>; _exit 1" with
> >     _fatal <error message>.
> >    - Reverted to "exit \$status" in the trap handler registration in check - just
> >      to make it more obvious to the reader that we are capturing $status as the
> >      final exit value.
> 
> Hi Dave and Zorro,
> 
> Any further feedback in this version?

This version is good to me, if there's not more review points from others, I'll merge it.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> --NR
> 
> > 
> > [v1] https://lore.kernel.org/all/cover.1745390030.git.nirjhar.roy.lists@gmail.com/
> > [v2] https://lore.kernel.org/all/cover.1745908976.git.nirjhar.roy.lists@gmail.com/
> > [1] https://lore.kernel.org/all/Z_UJ7XcpmtkPRhTr@dread.disaster.area/
> > [2] https://lore.kernel.org/all/48dacdf636be19ae8bff66cc3852d27e28030613.1744181682.git.nirjhar.roy.lists@gmail.com/
> > 
> > 
> > Nirjhar Roy (IBM) (2):
> >    common: Move exit related functions to a common/exit
> >    check: Replace exit with _fatal and _exit in check
> > 
> >   check           | 54 ++++++++++++++++++-------------------------------
> >   common/config   | 17 ----------------
> >   common/exit     | 39 +++++++++++++++++++++++++++++++++++
> >   common/preamble |  3 +++
> >   common/punch    | 39 ++++++++++++++++-------------------
> >   common/rc       | 28 -------------------------
> >   6 files changed, 79 insertions(+), 101 deletions(-)
> >   create mode 100644 common/exit
> > 
> > --
> > 2.34.1
> > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
> 

