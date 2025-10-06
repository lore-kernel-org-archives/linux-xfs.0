Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9F72D94B3
	for <linux-xfs@vger.kernel.org>; Mon,  6 Oct 2025 18:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759776790; cv=none; b=QCZVgJz/I/Mg2YPnLSnnAWYUgCx459SLbsz5W/+ZRHQwue82KKLsUJuxPAgHC237STzBKKmlSoYZm4S6afFOJEIUEfOVILJG+HOE88767NpSPe8rW40QYarFjXjcAR5FLUoUkq3vMHE0eDQR1GGnjn9ZSIDiD242muznD2CCxSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759776790; c=relaxed/simple;
	bh=eWI9PmOJt9WIaRlYjU78S12UG6uSHamRZWNSsCfgWvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pS2Kyzb3mr7JJDYhAFMZ2JSKpO3XQtFK2St3WbE2+hSOm5DDoLG4CY1oDlYQQveBa+iZE9bVsUMjd42kfxyMQy/ylhKdd4VFPvxpmyS0luvnQ4E/TjCDgyjlvq9InaspE7keAySJH9Fuy5CtaFKZ9cKrYJsnR7YEeEhvQAdyUXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cZc/yqqJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cZc/yqqJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759776787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3AELUvjO0N+ODGhRgLstmsznCqJ4q95SzfBUYFo2Qts=;
	b=cZc/yqqJJlIIHPvNRrGGmAXMLPQwyPGyz9dgu3x+zm4Ea2kU3jYMdgh87eqsC7rAzyD4Ek
	jMzl9/uCDYuDaze+LRHfxLZufcieVFrfUvJV2DSs7QGiStH9Y3bwvxtEdyYX1uQIT8/WXY
	zBwQuCe4ZjILxjlM0lWgy0nPGgXgb4c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-9Q9q1yZ-OQm8s73AeulSKw-1; Mon, 06 Oct 2025 14:53:06 -0400
X-MC-Unique: 9Q9q1yZ-OQm8s73AeulSKw-1
X-Mimecast-MFC-AGG-ID: 9Q9q1yZ-OQm8s73AeulSKw_1759776785
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e303235e8so48890635e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 Oct 2025 11:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759776785; x=1760381585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3AELUvjO0N+ODGhRgLstmsznCqJ4q95SzfBUYFo2Qts=;
        b=Uf6PTQEn8O6U3YHcFpVQ3sBmcWpqwVN0sW8kMroK6qAbDJGzA7c4dsqFRguGpRzdAw
         qI4huYeDNUBjK7kuZ4fJdip6VB9fD8ar8Zw/jnV1eYFBJs6jTcG2IR1zzPTd2+NsgMLy
         c7q+3oeVcztSU8fOuzQ3Ou9rnXlmx8U8mftSNZoj02ZG+0CqeNnUoNZ5WwBlG8Njpxtp
         J5w4HWIk2jA6ZlK/bHd3MjrertWBU3QX0Aq30ZLBef0449IX1FSMOSNdslThQ9crcaGq
         /5FPHXMTCkjL1svNsj9lbFmoXL7aReumWn56MqoV594wnD+DSmIbqkg/tHqRVMOHgFku
         4OAw==
X-Forwarded-Encrypted: i=1; AJvYcCVgAw4mUacN/JgjmSO8+0GpGmxw0lVRcFKnIUgl0aLzC/Ncl6CWXenaoSneeGOmRqDF5gHUNt0pPZw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb/0xcXdSf047sScDQRyjnH1iE1EORup1OCOqwgkvYwY2KJpxk
	BKhfp7b/zsjxhScBRZPDLAwcDXAexlJMOXew7Sxg1n8w2kPUI0LPbDihEZ98UScxSCYBRxJYwsW
	sDBg0mVJaoSe1AlDf3eb6EOQTQTe646ERKP3JuCXP614pG2jTrZDhB6/s8ZkW
X-Gm-Gg: ASbGncswT92BUU5kfe+LmxXxq5OV5ZrczW6Tj9SrtlwGtA3ME26uydy7Y8R+RFKeCrX
	KQeLzdopJJvalLhep+UU2cxD7VKTbkwG7XPXWjM+OSjFLlM4PxGasj1Cbq6vt2bt7WLfC1MwzFt
	G4Z1R1MTDIutBas7pCLDhezV7rJ66JpSaS/7tY4s9n65n2H8zEHfmxMu+N4/b0IEbb6hfbY7tvo
	y82LuPT3PrOUMbW8+6QowV37OPaptpEeupWrk6k7qiYL3ilUJ+X04sfglNWGww3nmQhXK6jcvsS
	YZ4W4oa7DRiOtVDvxBeoettg+1pG9AzM+LkPVs1DOE0xsChJZZ7tE/9wKm1Zt8TCng==
X-Received: by 2002:a05:6000:2303:b0:3ec:1154:7dec with SMTP id ffacd0b85a97d-42567164b20mr8887682f8f.25.1759776784556;
        Mon, 06 Oct 2025 11:53:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcKlhLopprqD0ctLDeK3ZiOapzKNjpNRXsOsRWDtqgxDtwJuOl9eDtA1aAuyt6f3P21Qd/GA==
X-Received: by 2002:a05:6000:2303:b0:3ec:1154:7dec with SMTP id ffacd0b85a97d-42567164b20mr8887653f8f.25.1759776783878;
        Mon, 06 Oct 2025 11:53:03 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f0170sm22533134f8f.49.2025.10.06.11.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 11:53:03 -0700 (PDT)
Date: Mon, 6 Oct 2025 20:52:32 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Jiri Slaby <jirislaby@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
	Christian Brauner <brauner@kernel.org>, Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, selinux@vger.kernel.org, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v6 4/6] fs: make vfs_fileattr_[get|set] return -EOPNOSUPP
Message-ID: <eyl6bzyi33tn6uys2ba5xjluvw7yjempqnla3jaih76mtgxgxq@i6xe2nquwqaf>
References: <20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org>
 <20250630-xattrat-syscall-v6-4-c4e3bc35227b@kernel.org>
 <a622643f-1585-40b0-9441-cf7ece176e83@kernel.org>
 <jp3vopwtpik7bj77aejuknaziecuml6x2l2dr3oe2xoats6tls@yskzvehakmkv>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jp3vopwtpik7bj77aejuknaziecuml6x2l2dr3oe2xoats6tls@yskzvehakmkv>

On 2025-10-06 17:39:46, Jan Kara wrote:
> On Mon 06-10-25 13:09:05, Jiri Slaby wrote:
> > On 30. 06. 25, 18:20, Andrey Albershteyn wrote:
> > > Future patches will add new syscalls which use these functions. As
> > > this interface won't be used for ioctls only, the EOPNOSUPP is more
> > > appropriate return code.
> > > 
> > > This patch converts return code from ENOIOCTLCMD to EOPNOSUPP for
> > > vfs_fileattr_get and vfs_fileattr_set. To save old behavior translate
> > > EOPNOSUPP back for current users - overlayfs, encryptfs and fs/ioctl.c.
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ...
> > > @@ -292,6 +294,8 @@ int ioctl_setflags(struct file *file, unsigned int __user *argp)
> > >   			fileattr_fill_flags(&fa, flags);
> > >   			err = vfs_fileattr_set(idmap, dentry, &fa);
> > >   			mnt_drop_write_file(file);
> > > +			if (err == -EOPNOTSUPP)
> > > +				err = -ENOIOCTLCMD;
> > 
> > This breaks borg code (unit tests already) as it expects EOPNOTSUPP, not
> > ENOIOCTLCMD/ENOTTY:
> > https://github.com/borgbackup/borg/blob/1c6ef7a200c7f72f8d1204d727fea32168616ceb/src/borg/platform/linux.pyx#L147
> > 
> > I.e. setflags now returns ENOIOCTLCMD/ENOTTY for cases where 6.16 used to
> > return EOPNOTSUPP.
> > 
> > This minimal testcase program doing ioctl(fd2, FS_IOC_SETFLAGS,
> > &FS_NODUMP_FL):
> > https://github.com/jirislaby/collected_sources/tree/master/ioctl_setflags
> > 
> > dumps in 6.16:
> > sf: ioctl: Operation not supported
> > 
> > with the above patch:
> > sf: ioctl: Inappropriate ioctl for device
> > 
> > Is this expected?
> 
> No, that's a bug and a clear userspace regression so we need to fix it. I
> think we need to revert this commit and instead convert ENOIOCTLCMD from
> vfs_fileattr_get/set() to EOPNOTSUPP in appropriate places. Andrey?

I will prepare a patch soon

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 

-- 
- Andrey

