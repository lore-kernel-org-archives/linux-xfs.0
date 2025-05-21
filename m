Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFDF158545
	for <linux-xfs@vger.kernel.org>; Wed, 21 May 2025 05:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747807052; cv=none; b=RU/c4SGJBJXghL9pezTKElCJoJDlDhKOks96aCEEGiyJLL5fOqYGBppflT2AoghlaZGa3pqTR7O7ZvaDEwFPEZlX4wjko42sM8QrcZOVqXNWM4bkffT+4QYqeTCwM4CBh0o5M8uU4dUypqHJsFsWKd/7R56VtVqatC31JhYY838=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747807052; c=relaxed/simple;
	bh=2ASEPURvONhhc96eK7TCkVFxOXLnvBlFnBrpR41Cb5U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=fUHypoZy6+3FNWbt3srCpd8+6B8DH9lozBXi8mpBpP+snhQVX34hPL7fE8Rm5uLe8rx5+h86NiY+bNlmtOqnrg7UjIgm8gkSU4PF3Bz+7XlI2xcVClHNTCt5ttCbSG8MzQaHL/CXywgFArp/lbQfN90U6HVvp+AErpvlnsWGkYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hWjyepZw; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hWjyepZw"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2327aa24b25so18646215ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 May 2025 22:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747807050; x=1748411850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RbzffORloq/kkZGlHfCDeW5dBB6kwREEk4BChDYgW18=;
        b=hWjyepZwwve59X3uLBWtIdBsVRpEDqExmmjFcAx/O7OZnaZ8Wn4YPmG/aBE1Z7kMJH
         GdH9BemHI6stnFsEVspOG9/OVnmA9a0jehSGnEEZz0acgTBIHmu9LyLiBCwgsHwQYi4n
         JFuGkldxSBGqg2s8VCltD8eUzQXNi6eYPi8uPEpqczvTGq024SbydPjI8uGTiVYdKwYI
         rHRMkAB7leyzmNevU9Ag/hmDrG8xlST4U4hWws8stzZTzZ/UKK+u5uhYMUkagjAVCgmd
         GFcPXbmDJ5ba7H7OHBDCMKuEK1dinQx6g5UYvLEEV940dhoAik30gpCoGJi5YQrquwAh
         doFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747807050; x=1748411850;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RbzffORloq/kkZGlHfCDeW5dBB6kwREEk4BChDYgW18=;
        b=v9fFYYd2CwebmS9ebm7eSc6bOH0wf1QpsdbYq0H+ehed393kshT/38FbLEcotwRjsS
         DhX/H6S4mnWb2dPn2dq/QeVDfz99gZGMv7YPMcwUdh8wb0iQ7LV/N04b3iO5dJ0BsuzG
         +0A5JiF00YIIdBqfAt+AlloRfiRsYzUK6Xd4YCjBAWG4Mf4zyrazJEBbU9kbp/403zCO
         kq+vZkMdnklqxBEiqDWqQNdnKftXpfo6/C9gVPIH1fC1OUfkTyrQdJhzGk0j6rjIGjoq
         pJmfJDi+UEsRCoHcVGeGzBZT8bMNmcCalW0LdfUM4tAfjfBe32onxkYRA9DgoZPfYWZd
         JJEA==
X-Forwarded-Encrypted: i=1; AJvYcCUXoU2Bcuv2vLxdkAYH0QMQKuyaUT72GLoXx6xknYxc+kg9PvCg36gQLlOs9SKDYn2nTe5PwkPEhxY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx86xrhG7FcLms9TZH/rfIYU94oJ+FZI6Qo2LzjGYsd8atMu4Sf
	TwH9mV+xbfXI3siSv5iGBjqIkJEJUyO2Q8DlYaNZQuE5VJkuZR6qWRxw
X-Gm-Gg: ASbGncsAbRH00I2JKE59/BQ5qTYxeipQeajMKXvUyafbEwiRH263iLsBrrPVtX3slSG
	86eQl2ha214nTKSNkI0BNt+vepSgQrzOxUcFf7Qi9HulaAoz7AWohL6P4NgZI7qWuYP1SUwOzLG
	YXllNwIvDFqKj/SeAJUWcZjNyiS7H60kCv/QVGUJAHRVnzMwr0s9gpmYieSyqotoxI/phscJOZ4
	6PtnLC/9N4+ZixS52FBk7fI03mt9dtRmvZ6lLF5XHuiwPZGiVDYrL22PDu6AgmxicA5HpOkoeNJ
	iqeeAHGaMjJAz97VUT2DjyWHAZTup0BlXwwVGU46r981aluhdhwMj0884/ez6ahAma4gMz0gLob
	haJrVob918gJZie4dzk9usSqw0IoE
X-Google-Smtp-Source: AGHT+IGK4SIf6aAquh7/1kN2+83kKq7mJSljL4h8tgZmPya93Za8lDCwDs0qAJTK4PU3EptMnStvTA==
X-Received: by 2002:a17:902:e788:b0:223:f7ec:f834 with SMTP id d9443c01a7336-231d43d56f2mr272729795ad.31.1747807050096;
        Tue, 20 May 2025 22:57:30 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.205.34.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e97537sm86452115ad.115.2025.05.20.22.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 22:57:29 -0700 (PDT)
Message-ID: <e32d681124cc3bffddfe3049d12264725d055221.camel@gmail.com>
Subject: Re: [PATCH] xfs: Remove unnecessary checks in functions related to
 xfs_fsmap
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Zizhi Wo <wozizhi@huawei.com>, dchinner@redhat.com, osandov@fb.com, 
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org, yangerkun@huawei.com, 
	leo.lilong@huawei.com
Date: Wed, 21 May 2025 11:27:24 +0530
In-Reply-To: <kzgijlgzweykmeni664npughps5jkgf34l7ndyj3zzwgq2wrbi@zbwrkf6xcmzh>
References: <20250517074341.3841468-1-wozizhi@huawei.com>
	 <9_MWuMXnaWk3qXgpyYhQa-60ELGmTr8hBsB3E4comBf1_9Mx-ZtDqy3cQKCTkNa9aVG4zLeTHVvnaepX2jweEA==@protonmail.internalid>
	 <20250519150854.GB9705@frogsfrogsfrogs>
	 <kzgijlgzweykmeni664npughps5jkgf34l7ndyj3zzwgq2wrbi@zbwrkf6xcmzh>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-05-20 at 12:38 +0200, Carlos Maiolino wrote:
> On Mon, May 19, 2025 at 08:08:54AM -0700, Darrick J. Wong wrote:
> > On Sat, May 17, 2025 at 03:43:41PM +0800, Zizhi Wo wrote:
> > > From: Zizhi Wo <wozizhi@huaweicloud.com>
> > > 
> > > In __xfs_getfsmap_datadev(), if "pag_agno(pag) == end_ag", we don't need
> > > to check the result of query_fn(), because there won't be another iteration
> > > of the loop anyway. Also, both before and after the change, info->group
> > > will eventually be set to NULL and the reference count of xfs_group will
> > > also be decremented before exiting the iteration.
> > > 
> > > The same logic applies to other similar functions as well, so related
> > > cleanup operations are performed together.
> > > 
> > > Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
> > > Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> > > ---
> > >  fs/xfs/xfs_fsmap.c | 6 ------
> > >  1 file changed, 6 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > > index 414b27a86458..792282aa8a29 100644
> > > --- a/fs/xfs/xfs_fsmap.c
> > > +++ b/fs/xfs/xfs_fsmap.c
> > > @@ -579,8 +579,6 @@ __xfs_getfsmap_datadev(
> > >  		if (pag_agno(pag) == end_ag) {
> > >  			info->last = true;
> > >  			error = query_fn(tp, info, &bt_cur, priv);
> > > -			if (error)
> > > -				break;
> > 
> > Removing these statements make the error path harder to follow.  Before,
> > it was explicit that an error breaks out of the loop body.  Now you have
> > to look upwards to the while loop conditional and reason about what
> > xfs_perag_next_range does when pag-> agno == end_ag to determine that
> > the loop terminates.
> > 
> > This also leaves a tripping point for anyone who wants to add another
> > statement into this here if body because now they have to recognize that
> > they need to re-add the "if (error) break;" statements that you're now
> > taking out.
> > 
> > You also don't claim any reduction in generated machine code size or
> > execution speed, which means all the programmers end up having to
> > perform extra reasoning when reading this code for ... what?  Zero gain?
> > 
> > Please stop sending overly narrowly focused "optimizations" that make
> > life harder for all of us.
> 
> I do agree with Darrick. What's the point of this patch other than making code
> harder to understand? This gets rid of less than 10 machine instructions at the
> final module, and such cod is not even a hot path. making these extra instructions
> virtually negligible IMO (looking at x86 architecture). The checks are unneeded
> logically, but make the code easier to read, which is also important.
> Did you actually see any improvement on anything by applying this patch? Or was
> it crafted merely as a result of code inspection? Where are the results that make
> this change worth the extra complexity while reading it?
I too agree with Darrick and Carlos. I initially gave my RB for the change, however I didn't
consider the above points mentioned by Carlos and Darrick. Thank you for the above pointers. It was
a good learning for me too - I will keep these in mind in my future reviews and patches too. 
--NR
> 
> Cheers,
> Carlos
> 
> > NAK.
> > 
> > --D
> > 
> > >  		}
> > >  		info->group = NULL;
> > >  	}
> > > @@ -813,8 +811,6 @@ xfs_getfsmap_rtdev_rtbitmap(
> > >  			info->last = true;
> > >  			error = xfs_getfsmap_rtdev_rtbitmap_helper(rtg, tp,
> > >  					&ahigh, info);
> > > -			if (error)
> > > -				break;
> > >  		}
> > > 
> > >  		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
> > > @@ -1018,8 +1014,6 @@ xfs_getfsmap_rtdev_rmapbt(
> > >  			info->last = true;
> > >  			error = xfs_getfsmap_rtdev_rmapbt_helper(bt_cur,
> > >  					&info->high, info);
> > > -			if (error)
> > > -				break;
> > >  		}
> > >  		info->group = NULL;
> > >  	}
> > > --
> > > 2.39.2
> > > 
> > > 

