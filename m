Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7BF2E7BC9
	for <linux-xfs@vger.kernel.org>; Thu, 11 Dec 2025 22:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765492193; cv=none; b=JuQIy4XemxZv70jLv1kCT6Hf82se3QlWk84Wuph9rlxWLPZ2OVei/WZlnKh3WgU92zThQJ8cMhJHSNY4UEIYMUQCo4JcLDTflRBoToe4nFQZqAp2SVLwS/VDZYPVKrITocQ4T9RY/qgRRfeTG5hSjG3Fy06lc+Jr8qKXeXU9EGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765492193; c=relaxed/simple;
	bh=OXXw/H1GKc6o37sW4mJQvxxa+HrNSmgnTm1bGhLbWaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGBCzDn/8AIOBskgEk42u7uYnIYPxPg/TWUby5fCvRavnRIWVU6iV7rpi8p9FNkAnjAKbfvShEP/b/bAGpeGA5eJXUU+Tbj5mU0IF1BxtQ5y4qG+hBzpHh/wAatSqfE5hwl2avQzHwTrRoLFFd+2ZyfTsoWstLxWMZDXdy4XdRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=LtOXT6RE; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="LtOXT6RE"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7c6d1ebb0c4so473023a34.1
        for <linux-xfs@vger.kernel.org>; Thu, 11 Dec 2025 14:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1765492190; x=1766096990; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kKnIdtm3pPod0xxvLT1ihslA6jGApo/slzwgiyZO2hE=;
        b=LtOXT6REZfsu1Fmr6wm28PS/iIB49use4bPHqjrPPYC2xyMRAg2UwHDAgnBVv6C+9b
         cDvwKVNHs1A2/8SR2oXuMNhZ6GC6i5U2BUq9Y7YjNAAW3sdKokRt1XOG6aXWe428/g3u
         SqVjnNRuGWjmI745qkmhF/jaBeZ2FaSWy39BEm4hHSxzcn2XCrjz3ENJjOq/0gBCW/4L
         MzgPRGiBqTw6UWFFQJY9UebihswTkRZWtZS9+VdPTdFpIvsNDzUiPuDJKP0klUjIXPSx
         eK1Csy3oXqMt58bLU7kvoEzN1jj2iN7UZ1QGK6whvaTDGISHDRwdT0PMQhkKAmZJdyRn
         C/6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765492190; x=1766096990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kKnIdtm3pPod0xxvLT1ihslA6jGApo/slzwgiyZO2hE=;
        b=gbkcX3igQG9jm4LvKf+i/DcvUZBrQmuVBvWD8GCmr/DIeA6oXsmF61XsSg/eF+rPEV
         91gEDrsphpGhOSHJkKIS2ltPn2rBMiXjq8axahJ3Wauf4m1B3bRUopzFSnkENMwUIXj8
         T5qs9ahv5tC9oj/eP/B5pF/DC5kbpQeCKTcB+PX3Zv7zBScvJ9yFeQeH/nh17Z71iko6
         h8ADaCT9zW2bMsn8RlOJ32fSLFjgbNmCWW0dDzsbUpfCITjw93vG8gcl7k1f4tvOwjUT
         N5OY3NwhEhmTx8614CjkwUcNMxXCTGOTCpH8i4DZvuE77sZnqugfs5CowVN1QKMZr/RZ
         WsRg==
X-Forwarded-Encrypted: i=1; AJvYcCW5wu8MO2h5rvNUefeY51zgRoGnDkEgskD246Tqmi31FZH1yQJ3BQZqm0ChSCujlMj//DaE9p4mD40=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMSFQL7BpuNsNw4FsMaSWSNKAjMc7ohCqyC6bBbE6GsbR1iBFg
	r8fHSYlfRsw7MCrrudNK2kl9UXk1CtvgUm5RWmFgooPBKifuIWqevhvGD2IU7j7qZQw=
X-Gm-Gg: AY/fxX5MxC+fTRJI/fmJJmm6zJATrnUh/KdtD4rLR0XcwFe1hRLYpoPjuKP0BfRta52
	0lUoKibFc40E1Tcqs2/sVcNYD+sJ4UN6qiDTR72Kwff1R+0SWeaXXKiioqEvF1v3OUWJDz1to8P
	OM2ciYyvmNKYiH55pqQNRA9PHwMbS0qy6GjFUBHbsxo1e6zyGVMr91lL7wDucdB48at9XTONbVF
	W2xTwRQNOqPVnxYiw6FFNX2pW+c8mKnlGvz///4eh1HVoLBOsNnvZZssi/hNYDIDSk2UcMdbaMm
	gW7uFEdLhJqAPoint8sN32edA1KKvxE1Cn/x1HdQysVsubjzcLZe+P+b0drkUvezdLZY6Yvu8PC
	AjOqTcGs4N0gtAhitE9m2AMa491o+LAjlbm3dcf5YuSR7HoG47FV9b9wY7Nr3XLaJBuM=
X-Google-Smtp-Source: AGHT+IGywbe0BB3deFRAIXxlLuosG5PBVaz326jAfocDpJ8kRogIfj//FG80YFsTf+7RwCSyXE0kyA==
X-Received: by 2002:a05:6830:2648:b0:7c7:2e9d:aee1 with SMTP id 46e09a7af769-7cae8362956mr7043a34.19.1765492190551;
        Thu, 11 Dec 2025 14:29:50 -0800 (PST)
Received: from CMGLRV3 ([2a09:bac5:947d:1b37::2b6:8])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cadb010476sm2303448a34.0.2025.12.11.14.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 14:29:50 -0800 (PST)
Date: Thu, 11 Dec 2025 16:29:48 -0600
From: Frederick Lawler <fred@cloudflare.com>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	Roberto Sassu <roberto.sassu@huawei.com>,
	kernel-team@cloudflare.com
Subject: Re: xfs/ima: Regression caching i_version
Message-ID: <aTtF3BPUcd9crhAm@CMGLRV3>
References: <aTspr4_h9IU4EyrR@CMGLRV3>
 <2b193b5ccd696420196ae9059f83dcc8b3f06473.camel@kernel.org>
 <aTszzVJkIqBpYLst@CMGLRV3>
 <fab68913274be1cb2a629372eafd52205a51b74e.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fab68913274be1cb2a629372eafd52205a51b74e.camel@kernel.org>

On Fri, Dec 12, 2025 at 06:41:00AM +0900, Jeff Layton wrote:
> On Thu, 2025-12-11 at 15:12 -0600, Frederick Lawler wrote:
> > On Fri, Dec 12, 2025 at 05:55:45AM +0900, Jeff Layton wrote:
> > > On Thu, 2025-12-11 at 14:29 -0600, Frederick Lawler wrote:
> > > > Hi Jeff,
> > > > 
> > > > While testing 6.18, I think I found a regression with
> > > > commit 1cf7e834a6fb ("xfs: switch to multigrain timestamps") since 6.13
> > > > where IMA is no longer able to properly cache i_version when we overlay
> > > > tmpfs on top of XFS. Each measurement diff check in function
> > > > process_measurement() reports that the i_version is
> > > > always set to zero for iint->real_inode.version.
> > > > 
> > > > The function ima_collect_measurement() is looking to extract the version
> > > > from the cookie on next measurement to cache i_version.
> > > > 
> > > > I'm unclear from the commit description what the right approach here is:
> > > > update in IMA land by checking for time changes, or do
> > > > something else such as adding the cookie back.
> > > > 
> > > > 
> > > 
> > > What we probably want to do is switch to using the ctime to manufacture
> > > a change attribute when STATX_CHANGE_ATTRIBUTE is not set in the statx
> > > reply.
> > > 
> > > IIRC, IMA doesn't need to persist these values across reboot, so
> > > something like this (completely untested) might work, but it may be
> > > better to lift nfsd4_change_attribute() into a common header and use
> > > the same mechanism for both:
> > 
> > I agree lifting nfsd4_change_attribute(), if anything else, a consistent
> > place to fetch the i_version from. Am I correct in my understanding that
> > the XOR on the times will cancel out and result in just the i_version?
> 
> No. I was just using the XOR to mix the tv_sec and tv_nsec fields
> together in a way that (hopefully) wouldn't generate collisions. It's
> quite not as robust as what nfsd4_change_attribute() does, but might be
> sane enough for IMA.
> 
> > IMA is calling into inode_eq_iversion() to perform the comparison
> > between the cached value and inode.i_version.
> 
> That just looks at the i_version field directly without going through -
> >getattr, so that would need to be switched over as well. Could
> integrity_inode_attrs_changed() use vfs_getattr_nosec() and compare the
> result?

That makes sense to me. I'll look through it a bit more, roll a patch, and
see what the IMA folks have to say (unless they comment here first).

Thanks Jeff

> 
> 
> > > 
> > > diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> > > index c35ea613c9f8..5a71845f579e 100644
> > > --- a/security/integrity/ima/ima_api.c
> > > +++ b/security/integrity/ima/ima_api.c
> > > @@ -272,10 +272,14 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
> > >          * to an initial measurement/appraisal/audit, but was modified to
> > >          * assume the file changed.
> > >          */
> > > -       result = vfs_getattr_nosec(&file->f_path, &stat, STATX_CHANGE_COOKIE,
> > > +       result = vfs_getattr_nosec(&file->f_path, &stat, STATX_CHANGE_COOKIE | STATX_CTIME,
> > >                                    AT_STATX_SYNC_AS_STAT);
> > > -       if (!result && (stat.result_mask & STATX_CHANGE_COOKIE))
> > > -               i_version = stat.change_cookie;
> > > +       if (!result) {
> > > +               if (stat.result_mask & STATX_CHANGE_COOKIE)
> > > +                       i_version = stat.change_cookie;
> > > +               else if (stat.result_mask & STATX_CTIME)
> > > +                       i_version = stat.ctime.tv_sec ^ stat.ctime.tv_nsec;
> > > +       }
> > >         hash.hdr.algo = algo;
> > >         hash.hdr.length = hash_digest_size[algo];
> > >  
> 
> -- 
> Jeff Layton <jlayton@kernel.org>
