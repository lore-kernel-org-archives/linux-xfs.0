Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8746E15FCE5
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 09:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715334636; cv=none; b=qWxIE2E0f64azs+GBJ05XlJUeRw+two9rdq0yfhf0f+icBd9Xoqey4bT+G3D5S/zyyP+xnfTlWVSX36A0jYfC04XovlfxINq/484veSHyaosTDCCtqAl6du/Zyvln3yUNrIrUi7ve0E3Kr9cOwjpqPu2ThHW+VNTS9mJWCahPx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715334636; c=relaxed/simple;
	bh=nWcbIDtrDFWTm6zdYKqPWS54PLr556mIkjXgM9KErwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utJf1YrbL/zeaKg+iJuw1pQNOoLyMysAQ2EKdLPZy8ooDRrMzhO0N5BrtFa2kO9/E1dMNf8mOqgIPkfUZSO4qKBwahL240LbRzX7vQtY5/YwKfjLfb7GRjMZFs6fONZTu+yfRPRtlA1y3SE7eU1wonAiSaBwCQ50szmI637y88M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CQdB3D/n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQdB3D/n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715334633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+tTiy8njFI1+gg1NyaM+NP8sNveSb3nbSIv5fWybeLY=;
	b=CQdB3D/nt8ykP7JtY0fdUvjfCUeBOlwSwtqcN2xk7ixj/ZYlStKbWcZBAtQ3DYwgKPswe4
	laf5uqkw1EpsxftfdcdpMAgOM+RQwNfe/x3iy4TysjLjrITkT4ICDd12XoKJC+zSjxUzvB
	Cp3tMRTU5Z3BI/2UjD6Q3EAo3L/K6fI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-PbDBpKRTPvCl3FdkGbcvKw-1; Fri, 10 May 2024 05:50:32 -0400
X-MC-Unique: PbDBpKRTPvCl3FdkGbcvKw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-572cd3a3687so730742a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 02:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715334630; x=1715939430;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tTiy8njFI1+gg1NyaM+NP8sNveSb3nbSIv5fWybeLY=;
        b=mNLP7usVbeGWmn/LQQylKrO2x6ZzI7cYsZtssWQg7NBS+fCc2c0xPuUVO/b5VAIZEE
         4nWgisUP7Loq2802opkKAS+CgN74d8ZQPuUs4oEpnmk0pPL6XEa0frtrXdHi05R5igDd
         kJCDVc3rQ34oXRVlPJh5cIZUwgb7r9UeeN1+KR3YlbPQ88f/xI5Vf9etveJTJvFsVrDk
         2RcgnyjfZRK79bTznSfeirdy2wzV2v8U5q/Qf4xl97U8cLK170f72yQ8hIP1wlVQhTUP
         IeqrjeN2f7q8a24nmnS7cBHiNbvDW2n5s6nCWtaiwM8PAxDj0yRZ74ksLJrwIfJ5xdPD
         s1BA==
X-Forwarded-Encrypted: i=1; AJvYcCUL9QrzgF+aY4+f3YB9Q79u0unfcNMAStOLiAIr0sRTIsDVR6QavZy+x8YrQQkbH6FK2Tl4/6s45BULXgy0eFj6s/A69NY5C7J7
X-Gm-Message-State: AOJu0YxGFCR1r9mn4sybJBAKoMNAlmGdN0P3Htt/NjN+1nOzEy9K+u9p
	8vRaBrgISY9AOyrdbYZ+obKDropKbScKd+x8Eyak82FTi848gBfqYMLvpY5N0e/Ww+0Z7bGsXZ2
	Zh0AjCokpCQYJzgZfKSU/mo6JT1lwaUGHg8/G8/wb0es35U6F11fVSg1ExkXLx8B8
X-Received: by 2002:a17:906:130b:b0:a59:efd0:b247 with SMTP id a640c23a62f3a-a5a2d5cb70amr184173866b.40.1715334630353;
        Fri, 10 May 2024 02:50:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmSVoW2bZ3z+XUP41t13IkY3b14/lzcTN4xgw0oJ/U20kE9r+zqMvuIUstecLtUXMGfc2o9g==
X-Received: by 2002:a17:906:130b:b0:a59:efd0:b247 with SMTP id a640c23a62f3a-a5a2d5cb70amr184172066b.40.1715334629666;
        Fri, 10 May 2024 02:50:29 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17892439sm165571466b.61.2024.05.10.02.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 02:50:29 -0700 (PDT)
Date: Fri, 10 May 2024 11:50:28 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: add XFS_IOC_SETFSXATTRAT and
 XFS_IOC_GETFSXATTRAT
Message-ID: <oxflz6mkbp3xxk3nmxkhb3wunqmaxtjyxvyjkog5xu2eknalcd@p2fwn55jdhdh>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
 <20240509151459.3622910-6-aalbersh@redhat.com>
 <Zj2pevC1NuYNCnn7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj2pevC1NuYNCnn7@infradead.org>

On 2024-05-09 21:58:34, Christoph Hellwig wrote:
> On Thu, May 09, 2024 at 05:15:00PM +0200, Andrey Albershteyn wrote:
> > XFS has project quotas which could be attached to a directory. All
> > new inodes in these directories inherit project ID.
> > 
> > The project is created from userspace by opening and calling
> > FS_IOC_FSSETXATTR on each inode. This is not possible for special
> > files such as FIFO, SOCK, BLK etc. as opening them return special
> > inode from VFS. Therefore, some inodes are left with empty project
> > ID.
> > 
> > This patch adds new XFS ioctl which allows userspace, such as
> > xfs_quota, to set project ID on special files. This will let
> > xfs_quota set ID on all inodes and also reset it when project is
> > removed.
> 
> Having these ioctls in XFS while the non-AT ones are in the VFS feels
> really odd.  What is the reason to make them XFS-specific?
> 

I just don't see other uses for these in other fs, and in xfs it's
just for project quota. So, I put them in XFS. But based on other
feedback I will move them to VFS.

-- 
- Andrey

