Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A357176056
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 21:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724794821; cv=none; b=Bbf9wMfQq4T1IYH/D24LSvDCy1yvJ33w5I3Ts2V2JyehkYzvJvf3NyXTQi4RI9mNvFw8dYukT88Hv3HkJ3Cwgwl5Ezf+uSmQpPfFi74LXqZuZe+dpscnxvABRu+OUyX9bEfb79CNv9/AsLr5HGvGcsq4SxnjBaB9QotMaNqbFQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724794821; c=relaxed/simple;
	bh=vAyzJ7N+gVcFKso5BBxKNH5LsTED9LIrXmMM+DFFeU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebfdruZzg9bHqmZL/29QWmo3ZxFu3ZODXH+K5mnuZYFD96dpunozXGVcOApxdzoey7pDtKmg3lSvZCG+S6YO0Ud+xG1aeBEupovfEXNrqfA3oWnLeu5VrOayeTH7IBpZEOU0VPFzmWIoC/QHuDjvFJG5ogPz44fv8keEE3dHt/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KZIN1d8L; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KZIN1d8L"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-71430e7eaf8so4794746b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 14:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724794819; x=1725399619; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EMbIJK6fO6CqZq7jSZ5BYepAW2O/2mw4Sjkia64ehLw=;
        b=KZIN1d8LDn7/zdTPil4jyhti8vMfWSVZu07AwyLyLDH/hhqOUP62BYL0Hr3xKKLIgA
         3fbHbba/rH1NCpVUSugTDuWRCMucvb9BP5NYbqHSl5Hi0foYEaRORuIOa/PKhcilG+FU
         yCUr+Q5Z6n1/jHAuAQk0VL2BjjNSsFjH/RgWOnp78WVYIo2Pnk69hta7KwooNQM96Sd4
         qKkmSlaMMwXG8NoR6jQgtmCFoafYLYHM+GYFNazOHW1tRc08nJxoD4XS8gICprQAfoeM
         wmkmE5cIxg9ithUsg7yno5nycRpE1WvVQeUvwT70wHhgVHn8gcrwzrsOL3VUiYuhPdNl
         y2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724794819; x=1725399619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMbIJK6fO6CqZq7jSZ5BYepAW2O/2mw4Sjkia64ehLw=;
        b=jZYChuPjuxmk1VdlASFSbaeb31P1JBeXaZRNcf7xvZxXbAOrC4WCSJXjRKcJ9jefoO
         LtYS2G1LSOWT38u5/YnbtfbGay1LHrCdGlsnT3rPXPKGSwFRxvqqHOsx6ta6toaeN/IY
         sUQcQTlTcUST6zZSm4Xndh/CV5wvcvlxkTNTHulcwyGl7qya0WqpOu1W2GfjSTdcME/h
         8OVH8XmDxFwLPl5F6tjayaqTOS/j8S+Ae2Wym2eMIs32pTBk6tUkr5FSZA0x7bDv7r0G
         YebFsILlSzcNbE733Px/SU1wt1wLv7IWyuL4uTz5K+ON5ZDGoGUd98mADfsmeVIcIY1i
         ilZA==
X-Gm-Message-State: AOJu0YzTdtjKfUJlI83HMaS4yrzEvYx1+DVNlztCxZiQGNpWC+59s9RU
	sUGOzaDeGl0J1AVxlyh2p4OaZmgUyEws86DQ0pxdK6Q8dvnjS4tXEaNLyAr/XHZq9lNkW/9UylR
	q
X-Google-Smtp-Source: AGHT+IGRnEn7rqUsf/yvTYcIr6AzSEPTYpAVN8qf923gjeq1KDedMjCNq237ZoQMHTHnY/P7MVLYaQ==
X-Received: by 2002:a05:6a00:1950:b0:714:2881:44cc with SMTP id d2e1a72fcca58-7144577249bmr14873868b3a.10.1724794818841;
        Tue, 27 Aug 2024 14:40:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7143434294asm8901035b3a.216.2024.08.27.14.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 14:40:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sj3vD-00F03x-2W;
	Wed, 28 Aug 2024 07:40:15 +1000
Date: Wed, 28 Aug 2024 07:40:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: bugzilla-daemon@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Bug 219203] New: xfsprogs-6.10.0: missing cast in
 /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec) causes error in C++
 compilations
Message-ID: <Zs5Hvxzxiq3wQGU7@dread.disaster.area>
References: <bug-219203-201763@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-219203-201763@https.bugzilla.kernel.org/>

On Tue, Aug 27, 2024 at 09:07:03PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=219203
> 
>             Bug ID: 219203
>            Summary: xfsprogs-6.10.0: missing cast in
>                     /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec)
>                     causes error in C++ compilations
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: kernel@mattwhitlock.name
>         Regression: No
> 
> C allows implicit casts from void* to any pointer type, but C++ does not. Thus,
> when including <xfs/xfs_fs.h> in a C++ compilation unit, the compiler raises
> this error:
> 
> /usr/include/xfs/xfs_fs.h: In function 'xfs_getparents_rec*
> xfs_getparents_next_rec(xfs_getparents*, xfs_getparents_rec*)':
> /usr/include/xfs/xfs_fs.h:915:16: error: invalid conversion from 'void*' to
> 'xfs_getparents_rec*' [-fpermissive]
>   915 |         return next;
>       |                ^~~~
>       |                |
>       |                void*
> 
> 
> The return statement in xfs_getparents_next_rec() should have used an explicit
> cast, as the return statement in xfs_getparents_first_rec() does.
> 
> --- /usr/include/xfs/xfs_fs.h
> +++ /usr/include/xfs/xfs_fs.h
> @@ -912,7 +912,7 @@
>         if (next >= end)
>                 return NULL;
> 
> -       return next;
> +       return (struct xfs_getparents_rec *)next;
>  }

We shouldn't be putting static inline code in xfs_fs.h. That header
file is purely for kernel API definitions. Iterator helper functions
aren't part of the kernel API definition - they should be in some
other exported header file if they are needed at all. The helpers
could be defined in the getparents man page in the example code that
uses them rather than exposing the C code to the world...

I note that we've recently added a static inline function type
checking function to xfs_types.h rather than it being an external
function declaration, so there's more than one header file that
needs cleanup....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
