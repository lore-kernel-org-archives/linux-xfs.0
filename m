Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D7C2874E4
	for <linux-xfs@vger.kernel.org>; Mon,  7 Jul 2025 12:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751889919; cv=none; b=dD111IFaB38vlz1eUYsMQKw8602MLi+iZKWJ+/VFwjNSYtXrZthUoQ1bW/EKFFUVXv+ZW7wlIGnk3ai1S2k7VvJ5VufOobbCpiz/LD9pOHDUJTXivbdVxSPe2OJGvuFCyxg7Ovy4g5TSMzN8uNYzly6Atd9RBl1oqS3PoNwHoyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751889919; c=relaxed/simple;
	bh=yShfZ6ILsOBhd6koGDWWiQzQZWiggGZJjghyucsosDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ahf/HPZ0ay2FxWaR3DI6TYLxVjJ15avrezIHkTmmxbeGYuB4aciemm2Ol8yNoQcvmcGIzuIZOrF+7WadPK/AzrtX6BTXZX4m2/0PX03evEr+B/QRfPfKDMenPbkWJMnXDkh6e0oJlKg59clK+AcuuDCoxaknHJJ6gK/hwBZKxdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GUuTeRz/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GUuTeRz/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751889916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2coxbyxFXdSQKENSeYoc+GW9sQUhtsiwwJEzAsI5vW4=;
	b=GUuTeRz/1jL60rqYhhwFuCF3D8ZgG0DR0ORAgKlB6BHDyYn2EAq/CrVF/ro22+Wg9rDp0x
	OftMwoOFpRg+AVDThCbZReh2GKWsjZ8yNBdsVLOr1W4sRhOKB9PbQkd+kvj7ywBEL+2Eak
	YmbSY70crQZigGsQDvZ/eP/q+OSEuQw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-JATdjZiFM0mimruDbYjPNg-1; Mon, 07 Jul 2025 08:05:13 -0400
X-MC-Unique: JATdjZiFM0mimruDbYjPNg-1
X-Mimecast-MFC-AGG-ID: JATdjZiFM0mimruDbYjPNg_1751889912
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a5281ba3a4so1221097f8f.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jul 2025 05:05:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751889912; x=1752494712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2coxbyxFXdSQKENSeYoc+GW9sQUhtsiwwJEzAsI5vW4=;
        b=BxTNRyotSM5FvO0hMx4X0r0jX99/wR48/crwm0RrIcQ8viB1Kwe73vEf1gLkrtf0jH
         Ta3zcJk1WxJsk2KiAy2GaeNIDmMy0Tv4I1C6WgjiDPfIjDV4lKEBh0zl0XgIgGxJPP1K
         6JtXNr8WpEqHatlE91jis/oE9fLqwLxNBJCy/ZgD93Io2UvCZJr+e+EsvgnQSVu+baPe
         zgzAJkTpRJDRlPtm1f8WpxbIipu21eicElgQwNjBXuck8s1X5EBnenrxPouTLpd4tOZ2
         4rTMvOdrecX7LfcrTneNoYiGnv9USrMeUcw0WCKK9IUF4MXMXND6XCXtbXXUjGn6EOQH
         2Fkw==
X-Forwarded-Encrypted: i=1; AJvYcCVsHzW8QRgIkCVi4DbZVf9S9G2b41NvI4Yx4lKYcqbLLoXtl2TVK6LAPN+uVD4sdMdEnwCrSbNfp5I=@vger.kernel.org
X-Gm-Message-State: AOJu0YznYXeZbW/cxSg8S82Zp4kUtM33QBdXZInZaVuZy2Xl+4WC8stl
	/Pkwir3Hi6bf1bxXEBCUTjK0dYDi+XPkzo2OTvMD91ypxu8f900J9KpGPuDaitg7jIJ5crwLAOL
	7OHr/QZxYqxmJhjbDSR/4oOgX56GPElKngwJklRp16g0eG8dVNbbv3+7jJJf7
X-Gm-Gg: ASbGncv/JnPp1kXsHssIGyrhHVZQ5TXc7uP8kPr4WxFi+CVQ2UdCpsZLO9a9h8Xf5cg
	GlpWCB/eSLYKIuptlLQ7CJOY8TF2Gay7Vrf0+6MyhMMm1f4gM6yStvS73w5G7NHlrU035NYHqCB
	86tLd1q/xl1oS8Fzt7CwBkn0aeSNAx/j3rQJp+6zLNQ480xwQjRn9sa80XJShRhIQ4ODR7lrWEf
	DUqruZ4dv+fkFCFAnTiErfxByzabbkESmhIL1XWnWPJSgnJ4k2PQE83PU1dx1SkIdV/n9w/xC1D
	zQm5xx8TGLhCyey7AWsU5yEFqXtgyzdLWUDAVuLBxw==
X-Received: by 2002:adf:e18c:0:b0:3a4:d274:1d9b with SMTP id ffacd0b85a97d-3b49aa306c7mr7357357f8f.25.1751889912201;
        Mon, 07 Jul 2025 05:05:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEi5xHzfaruNNWM5Xa5nbbHvwTT5Ypm3IkOF4wO8OCiHtSnJRFyxUTJ6ZrNFQU7wWPBnE0rg==
X-Received: by 2002:adf:e18c:0:b0:3a4:d274:1d9b with SMTP id ffacd0b85a97d-3b49aa306c7mr7357295f8f.25.1751889911645;
        Mon, 07 Jul 2025 05:05:11 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b4708d0959sm9902891f8f.27.2025.07.07.05.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 05:05:11 -0700 (PDT)
Date: Mon, 7 Jul 2025 14:05:10 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Jan Kara <jack@suse.cz>, 
	Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>, Paul Moore <paul@paul-moore.com>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	selinux@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v6 0/6] fs: introduce file_getattr and file_setattr
 syscalls
Message-ID: <uzx3pdg2hz44n7qej5rlxejdmb25jny6tbv43as7dos4dit5nv@fyyvminolae6>
References: <20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org>
 <20250701-quittung-garnieren-ceaf58dcb762@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701-quittung-garnieren-ceaf58dcb762@brauner>

On 2025-07-01 14:29:42, Christian Brauner wrote:
> On Mon, Jun 30, 2025 at 06:20:10PM +0200, Andrey Albershteyn wrote:
> > This patchset introduced two new syscalls file_getattr() and
> > file_setattr(). These syscalls are similar to FS_IOC_FSSETXATTR ioctl()
> > except they use *at() semantics. Therefore, there's no need to open the
> > file to get a fd.
> > 
> > These syscalls allow userspace to set filesystem inode attributes on
> > special files. One of the usage examples is XFS quota projects.
> > 
> > XFS has project quotas which could be attached to a directory. All
> > new inodes in these directories inherit project ID set on parent
> > directory.
> > 
> > The project is created from userspace by opening and calling
> > FS_IOC_FSSETXATTR on each inode. This is not possible for special
> > files such as FIFO, SOCK, BLK etc. Therefore, some inodes are left
> > with empty project ID. Those inodes then are not shown in the quota
> > accounting but still exist in the directory. This is not critical but in
> > the case when special files are created in the directory with already
> > existing project quota, these new inodes inherit extended attributes.
> > This creates a mix of special files with and without attributes.
> > Moreover, special files with attributes don't have a possibility to
> > become clear or change the attributes. This, in turn, prevents userspace
> > from re-creating quota project on these existing files.
> 
> Only small nits I'm going to comment on that I can fix myself.
> Otherwise looks great.
> 

Hi Christian,

Let me know if you would like a new revision with all the comments
included (and your patch on file_kattr rename) or you good with
applying them while commit

-- 
- Andrey

