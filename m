Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDEE80BF8
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 09:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715333876; cv=none; b=DmYGyXx8g7OzACwZsrEtMdr39ca5AXI8ePaPs5539PkMQOHVddN7eqaLubchrX5/CBtuHsBFboYFwGlo+WmJyP4eMYRRyjhghPWNthuS/YBMU5d/M6dhmHGcKE1tSm42t9NAVXPlfNgPjEcu4GhQA8BF5MIEJ2ofaoKFe8jycbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715333876; c=relaxed/simple;
	bh=wtLWI7M1lEkIfQZ5e+HsrK0LDIkkpQdiI8hpT3aR6mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ba0QA+8ZRscjdZyeu739OALCWEXzgYmXOmvTW+FHN4ahbLwRVCQxbas64pRPkP2TJ6nDBkpxPMkbUSk5BmDzmLnvpVoHVW1p7Wc0Zi0B155oXG1dJVp3OTBT+oRlN6tDxACA9/S1KXHnwX59Wl8TWO8wukLOa1jFL5duZgL0BJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YmpZoSqn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YmpZoSqn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715333874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gtcw2buwuTPLxDN/zUe4r3spSFq3goKEK30E5lh/7kE=;
	b=YmpZoSqncbC7+iy+yYzJeG8ah2Ni5RqSuxtIhgOeOYIcjSDcl+jAOsPSKgHA0/CK6kWpbU
	Hq2WSsmkpBPdEWbhMnVw7+C+Rvw+rPiPxClTC9yTLSmCcvrcxxw4u9y4ZmEpGsXLu0pMRj
	5WmhM8fCpkH1ptcUnZ5k2bjtTy7jPmo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-NmxH0_AfNk2aILhSRBPMbQ-1; Fri, 10 May 2024 05:37:51 -0400
X-MC-Unique: NmxH0_AfNk2aILhSRBPMbQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-34ffd710a31so1242516f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 02:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715333870; x=1715938670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gtcw2buwuTPLxDN/zUe4r3spSFq3goKEK30E5lh/7kE=;
        b=jQ7fw0Xth6Xgopc+jNCDLYPSMqDYAvM5P53FQNbfW5kmnSVc6k8vN84R387wkfutG/
         Y0q1SWsGpAq/i6ReBk8cxRzyonlj97nIdgfDvJQhaSeXOjqQr+iO2WT3CXVR2i978E7N
         JrwTJS71Cj4pcmadOvHi2HqmH2fuDk2yDQ8AEqKM9Pe4GNbEHHidTiYBVDg69xsqWgJn
         owiPWwpKXPhdsWnUD5e/5DAd7SqZpQNe+IK6XOR5FmIBGXUVdYvhrgvLLO5Enyk+yXDF
         B2yJj1I5SmerPj2Or/Zs4ZyyRM7XaLciX0CBPTmccNmDg+jWzjdVUq4kBsV4vsG0onJl
         j8Fw==
X-Forwarded-Encrypted: i=1; AJvYcCXg+j0a5WdIGtF0a2z4w8dTyrlnN2ReCtgmd9xqa2WUe1Dsme4zhYKe0S+2lDxVv7FCitFVYfajAvMroCLDGxIIuB32NcpHf1t5
X-Gm-Message-State: AOJu0Yxg/1ersP2nl0TUG5tCv7i+veHhXQsasi0l2zg0UUzdRUq6+Fv6
	D3uUcBI9mFpBRzRWeHTEd5c08xTafgzi7Vxk6Fu+QtDQZZopa+GP53sW28hzsiVK8Kc8RuJuxtp
	GW8pwD6FWEU8fC1l6P1XbN2RY81EYMfZvwhNbKAsY07t7DK30EAvaf9nxtYfPF9Su
X-Received: by 2002:a5d:4fd0:0:b0:346:6c8b:d80a with SMTP id ffacd0b85a97d-3504a7375bbmr1326618f8f.31.1715333869885;
        Fri, 10 May 2024 02:37:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmHLUn75fLv16kd/ZzzQMbmsbY/MTBJUT7RjV0eGhWTWZ391P9Vgr7Bikmx6VsOV3febXgPA==
X-Received: by 2002:a5d:4fd0:0:b0:346:6c8b:d80a with SMTP id ffacd0b85a97d-3504a7375bbmr1326595f8f.31.1715333869160;
        Fri, 10 May 2024 02:37:49 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502b8969e4sm4055139f8f.25.2024.05.10.02.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 02:37:48 -0700 (PDT)
Date: Fri, 10 May 2024 11:37:47 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: add XFS_IOC_SETFSXATTRAT and
 XFS_IOC_GETFSXATTRAT
Message-ID: <2y72o3ia6j55alsb2rl5z6yc4nfwkoxswwhqp7m52dsypkdkqh@4ei3nkqzuazp>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
 <20240509151459.3622910-6-aalbersh@redhat.com>
 <Zj1id6YGbEn4mUcg@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj1id6YGbEn4mUcg@dread.disaster.area>

On 2024-05-10 09:55:35, Dave Chinner wrote:
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
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> 
> This really should be a VFS layer file ioctl (like
> FS_IOC_FSSETXATTR). Path resolution needs to be done before we call
> into the destination filesystem as the path may cross mount points
> and take us outside the filesytem that the parent dir points to.
> 

I see, thanks! I haven't thought about cross mount points.

> IOWs, there should be no need to change anything in XFS to support
> FS_IOC_[GS]ETFSXATTRAT() as once the path has been resolved to a
> dentry at the VFS we can just call the existing
> vfs_fileattr_get()/vfs_fileattr_set() functions to get/set the
> xattr.
> 
> The changes to allow/deny setting attributes on special files
> then goes into fileattr_set_prepare(), and with that I don't think
> there's much that needs changing in XFS at all...
> 

Yeah, then this would probably will do it.

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

-- 
- Andrey

