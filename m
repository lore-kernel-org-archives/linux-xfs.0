Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDF7136669
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 16:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717432135; cv=none; b=rQnDQmLKiytTqGcUAPIu0odL9LvQQAifMNAn+Z6z5pYRPjazRHXXT3Iv4a/aOJOzue8rNYe99OAUKyshwmbPZRTWkxlYCQkb5itht9LdIGpfO38I0ewCT0DGNPAU+WIeqejqOU/TQi6jKD0dX/O5PyvR/Zd3CEkpW/XzIZgV/lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717432135; c=relaxed/simple;
	bh=KuFznChqzOd1gUXmPzJgm+0RIRoEbVhgMV4ie+CXRDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rmVv38tgjz8KcNPjxvuPW0CwkX+wFjUKXXIxTSM5xRLAQq/PqH7xstFh4oZeAVzqP5bokC5LN2EfrdIZjUQvq/pBOqQDUSvloAm5xnh4oV9E3hTzOYhjNr/xDVr24O7EKUk7baGXmSN4vmKEM0o86wIhMT7ZwlMRmCCsxiUC4/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GFsj5BAP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GFsj5BAP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717432132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gr69zdD82WTBY2Lr4lSLLRvR4NuQqJ9ZmIp1I94u60E=;
	b=GFsj5BAPU5vopxS3VMEKgoRw6mjA+ringtiSstew00t3MUkoBV8+iwbosRnjC0jFVLzJ0q
	1AJJo2BaWzwstkQXc5dU6lQTVVyuXn8j2mvRFugZyz/HqeNx2aQbma+u6CPGDJdiwqb1i1
	GooRT4AtO8jzjsjD8ZTmHQJccLI++m0=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-cUybf7NNMVe4iQixCAddpg-1; Mon, 03 Jun 2024 12:28:51 -0400
X-MC-Unique: cUybf7NNMVe4iQixCAddpg-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ea892f8441so33647731fa.1
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2024 09:28:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717432129; x=1718036929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gr69zdD82WTBY2Lr4lSLLRvR4NuQqJ9ZmIp1I94u60E=;
        b=SK5j3tQKzZbpqmI7wAdRCFodWi2uLPhVLdGzAaqdEoLWC2Z+bG6Lrvvxfb37AzcUU7
         hrS0QDPiY1tKAlc5VkoQrecYdwNWguIFW/Y8ndfC0LxGox40RdoMGRzeWTxcpZ8u77hj
         hazPyL4HQeqYZBRMNcbWs5drL5nQp/ajzDRiR8RYAKPZxGGIAPApgAI1LCMaf9yLCClf
         VcuCA7Sc3gI6xawnBjO6LiqpVkz6U16CQWKu3C94VKDlArfO55ppP1vsQGSLiHvet2vd
         EkqrmmAGN3xdabkvNc0qkvXn1n74mCL198ZFU3O+Go1U522Xm9o7vhClBpMlcRO454Z9
         YWGA==
X-Forwarded-Encrypted: i=1; AJvYcCW2pq+fc/xasbImgk/jKb5zOONyU72GEjqGyM3ZKSSr3OmT8qt32FvQJC41qvWkg8kTK4U3hrhPabNni2kQ3+xEP+U9gDouGaPf
X-Gm-Message-State: AOJu0YwiBrX953Bs1lojGcqPljFQlMQsKsrthAdtZks+7TqEnIX9a3P0
	FTfPlcEpwgN2ZZJtVWDsPyHeXPGMLrdgq0b1pjQaWh4DdFqnhkyCe2fJBLvqE4EqhEIazb8+BdY
	g1yUT7rpX64uyQRTG0FQL7BcmSXNJE3zm4ihKQuEDc+dr1253Y9Gly8R6
X-Received: by 2002:a2e:b818:0:b0:2e9:820a:abfe with SMTP id 38308e7fff4ca-2ea950c0482mr63163321fa.4.1717432129469;
        Mon, 03 Jun 2024 09:28:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9AAn+3csNvZgBBdGUydEYiz3VwZmVYLYrOLbsB8PEiOImAA15s6ck87JSRtgm/RKJJzRffA==
X-Received: by 2002:a2e:b818:0:b0:2e9:820a:abfe with SMTP id 38308e7fff4ca-2ea950c0482mr63163001fa.4.1717432128823;
        Mon, 03 Jun 2024 09:28:48 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a31c6d4b6sm5542876a12.74.2024.06.03.09.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 09:28:48 -0700 (PDT)
Date: Mon, 3 Jun 2024 18:28:47 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v2 2/4] fs: add FS_IOC_FSSETXATTRAT and
 FS_IOC_FSGETXATTRAT
Message-ID: <vbiskxttukwzhjoiic6toscqc6b2qekuwumfpzqp5vkxf6l6ia@pby5fjhlobrb>
References: <20240520164624.665269-2-aalbersh@redhat.com>
 <20240520164624.665269-4-aalbersh@redhat.com>
 <20240522100007.zqpa5fxsele5m7wo@quack3>
 <snhvkg3lm2lbdgswfzyjzmlmtcwcb725madazkdx4kd6ofqmw6@hiunsuigmq6f>
 <20240523074828.7ut55rhhbawsqrn4@quack3>
 <xne47dpalyqpstasgoepi4repm44b6g6rsntk2ln3aqhn4putw@4cen74g6453o>
 <20240524161101.yyqacjob42qjcbnb@quack3>
 <20240531145204.GJ52987@frogsfrogsfrogs>
 <20240603104259.gii7lfz2fg7lyrcw@quack3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603104259.gii7lfz2fg7lyrcw@quack3>

On 2024-06-03 12:42:59, Jan Kara wrote:
> On Fri 31-05-24 07:52:04, Darrick J. Wong wrote:
> > On Fri, May 24, 2024 at 06:11:01PM +0200, Jan Kara wrote:
> > > On Thu 23-05-24 13:16:48, Andrey Albershteyn wrote:
> > > > On 2024-05-23 09:48:28, Jan Kara wrote:
> > > > > Hi!
> > > > > 
> > > > > On Wed 22-05-24 12:45:09, Andrey Albershteyn wrote:
> > > > > > On 2024-05-22 12:00:07, Jan Kara wrote:
> > > > > > > Hello!
> > > > > > > 
> > > > > > > On Mon 20-05-24 18:46:21, Andrey Albershteyn wrote:
> > > > > > > > XFS has project quotas which could be attached to a directory. All
> > > > > > > > new inodes in these directories inherit project ID set on parent
> > > > > > > > directory.
> > > > > > > > 
> > > > > > > > The project is created from userspace by opening and calling
> > > > > > > > FS_IOC_FSSETXATTR on each inode. This is not possible for special
> > > > > > > > files such as FIFO, SOCK, BLK etc. as opening them returns a special
> > > > > > > > inode from VFS. Therefore, some inodes are left with empty project
> > > > > > > > ID. Those inodes then are not shown in the quota accounting but
> > > > > > > > still exist in the directory.
> > > > > > > > 
> > > > > > > > This patch adds two new ioctls which allows userspace, such as
> > > > > > > > xfs_quota, to set project ID on special files by using parent
> > > > > > > > directory to open FS inode. This will let xfs_quota set ID on all
> > > > > > > > inodes and also reset it when project is removed. Also, as
> > > > > > > > vfs_fileattr_set() is now will called on special files too, let's
> > > > > > > > forbid any other attributes except projid and nextents (symlink can
> > > > > > > > have one).
> > > > > > > > 
> > > > > > > > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > > > > > > 
> > > > > > > I'd like to understand one thing. Is it practically useful to set project
> > > > > > > IDs for special inodes? There is no significant disk space usage associated
> > > > > > > with them so wrt quotas we are speaking only about the inode itself. So is
> > > > > > > the concern that user could escape inode project quota accounting and
> > > > > > > perform some DoS? Or why do we bother with two new somewhat hairy ioctls
> > > > > > > for something that seems as a small corner case to me?
> > > > > > 
> > > > > > So there's few things:
> > > > > > - Quota accounting is missing only some special files. Special files
> > > > > >   created after quota project is setup inherit ID from the project
> > > > > >   directory.
> > > > > > - For special files created after the project is setup there's no
> > > > > >   way to make them project-less. Therefore, creating a new project
> > > > > >   over those will fail due to project ID miss match.
> > > > > > - It wasn't possible to hardlink/rename project-less special files
> > > > > >   inside a project due to ID miss match. The linking is fixed, and
> > > > > >   renaming is worked around in first patch.
> > > > > > 
> > > > > > The initial report I got was about second and last point, an
> > > > > > application was failing to create a new project after "restart" and
> > > > > > wasn't able to link special files created beforehand.
> > > > > 
> > > > > I see. OK, but wouldn't it then be an easier fix to make sure we *never*
> > > > > inherit project id for special inodes? And make sure inodes with unset
> > > > > project ID don't fail to be linked, renamed, etc...
> > > > 
> > > > But then, in set up project, you can cross-link between projects and
> > > > escape quota this way. During linking/renaming if source inode has
> > > > ID but target one doesn't, we won't be able to tell that this link
> > > > is within the project.
> > > 
> > > Well, I didn't want to charge these special inodes to project quota at all
> > > so "escaping quota" was pretty much what I suggested to do. But my point
> > > was that since the only thing that's really charged for these inodes is the
> > > inodes itself then does this small inaccuracy really matter in practice?
> > > Are we afraid the user is going to fill the filesystem with symlinks?
> > 
> > I thought the worry here is that you can't fully reassign the project
> > id for a directory tree unless you have an *at() version of the ioctl
> > to handle the special files that you can't open directly?
> > 
> > So you start with a directory tree that's (say) 2% symlinks and project
> > id 5.  Later you want to set project id 7 on that subtree, but after the
> > incomplete change, projid 7 is charged for 98% of the tree, and 2% are
> > still stuck on projid 5.  This is a mess, and if enforcement is enabled
> > you've just broken it in a way that can't be fixed aside from recreating
> > those files.
> 
> So the idea I'm trying to propose (and apparently I'm failing to explain it
> properly) is:
> 
> When creating special inode, set i_projid = 0 regardless of directory
> settings.
> 
> When creating hardlink or doing rename, if i_projid of dentry is 0, we
> allow the operation.
> 
> Teach fsck to set i_projid to 0 when inode is special.
> 
> As a result, AFAICT no problem with hardlinks, renames or similar. No need
> for special new ioctl or syscall. The downside is special inodes escape
> project quota accounting. Do we care?

I see. But is it fine to allow fill filesystem with special inodes?
Don't know if it can be used somehow but this is exception from
isoft/ihard limits then.

I don't see issues with this approach also, if others don't have
other points or other uses for those new syscalls, I can go with
this approach.

-- 
- Andrey

