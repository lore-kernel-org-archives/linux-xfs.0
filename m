Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718D84D8B7
	for <linux-xfs@vger.kernel.org>; Mon, 10 Jun 2024 08:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718007466; cv=none; b=LBDdLOSlc15n/Aw8DpMxj2o8iAvpmD4rClL+xcBaRV8fGw7FPna2IS4KPVanXYQUkPKQA90FoPUqnp/RKWMZwL3ElmzekSlPBCs+NkKM/dcsoySKfsRvpHmvqY7+A3J4+hR8Xl7JkUBpFZ7iP1v4bL/sJ/jw6ZwlJbxdJdjisIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718007466; c=relaxed/simple;
	bh=jPt+GB6fpFuzCc6VuO9dpgWKF0671nUV2vHlwsaYTQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lr0L/Te49t0b1ngMz2aSSVfP+9SSgLrTD1XR16eD3TBe3zdV/CSd8kmLsybnT825PspgKshWJ49oX05LfvhDXvpyfJ5TNspQgy+4s3hHKl9AToRLLppgumK9noENJ1BVfxxfDysphd8HY8mwznqyRp1W1imN5msm1JGhYwvSwJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P2oAKV5g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P2oAKV5g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718007463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+4ldJmhVTLf5QYzx2j7SmjNG2YdEi6jjaLpR5u0okM=;
	b=P2oAKV5gTCZBq6S8Q/HNa9dJGnkzE3udDJM8FhO7Zkjz8vjbdp8d3KMLxTQ6GBsNhCe0OJ
	94UbX2d/sYaIoAxFwqzfSmnRnNKf3h9sx/0jA0j0IznP7Cm3b/1IwlkQTp1jFQaHuA63yj
	zRYofX+p8Ke45ZNJ2snH3SXhPOV3trA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-r219gmJtPN2uHmnCJJtXQQ-1; Mon, 10 Jun 2024 04:17:37 -0400
X-MC-Unique: r219gmJtPN2uHmnCJJtXQQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35f21956382so766054f8f.0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jun 2024 01:17:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718007456; x=1718612256;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X+4ldJmhVTLf5QYzx2j7SmjNG2YdEi6jjaLpR5u0okM=;
        b=H3MLpt42bEH6Jy12a/RicGgY47ni80mWB412evj01g00ACiWNYrToGTHe9PJLFByYT
         9pgi31ouM2VNgwjQLKO5CsHgcYxhAsa2nuLB+gR2Bj6JySzz7IMFMJCHNd9lnb6U/qVO
         KIYbbk3pu5OmL7ehIdkvFFuBufKLEOmHii7QUmrXcn+sxBnzXKy0zCDY9VzSnSlT3AiN
         +JLPAiahWRJcGpv+EEhMioE0Ku7uW/0QLTBAZ/Tds6oWc8WD3CqD/wQ+OkuLOZAnV7QI
         1R0m/Qzz3p1GoHk+P4jC7nz/Di9O3F47fHIeoZxQR/GSqIAyKaoHNq25FBahSqXzV5Bx
         ovkg==
X-Forwarded-Encrypted: i=1; AJvYcCUuSisNpPeoUKqHCOEtfiuOKiik/fwAMZGCq3flGFf3hkE0SQf9C2fjb29NVSCcTxVtSH02vZ7nOsxg6AG6wynYuOAwnUDqF73l
X-Gm-Message-State: AOJu0YwiBIDHP7cp58Nzt7nscv04a2da97wiVwEGR5DsnEiSbRb1fdIp
	uRvpKlAkbKJ1Wf3eA73mMFyU+Eu/88+q0jB0psX5E6QDxa1ywowHU9RQRXv9rnxIbSduYZYRjbA
	KCjxnfEj0Pny6LNmp7flccXBITGAjI7GZBO/JcjfoH94A8C3l6HHDsA1jeUAaVLlW
X-Received: by 2002:adf:f850:0:b0:35f:1f3b:baec with SMTP id ffacd0b85a97d-35f1f3bbd4fmr1838418f8f.68.1718007455989;
        Mon, 10 Jun 2024 01:17:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwHWdSj3i9LL5qmD+fgUHDvMxJTGcDiPtU1mS0ymPr7PzHrwfo8gGi82GaXNacnv461EHHRQ==
X-Received: by 2002:adf:f850:0:b0:35f:1f3b:baec with SMTP id ffacd0b85a97d-35f1f3bbd4fmr1838400f8f.68.1718007455375;
        Mon, 10 Jun 2024 01:17:35 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35f23df9f3csm2201822f8f.76.2024.06.10.01.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 01:17:34 -0700 (PDT)
Date: Mon, 10 Jun 2024 10:17:34 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>
Subject: Re: Re: [PATCH v2 2/4] fs: add FS_IOC_FSSETXATTRAT and
 FS_IOC_FSGETXATTRAT
Message-ID: <tnj5nqca7ewg5igfvhwhmjigpg3nxeic4pdqecac3azjsvcdev@plebr5ozlvmb>
References: <xne47dpalyqpstasgoepi4repm44b6g6rsntk2ln3aqhn4putw@4cen74g6453o>
 <20240524161101.yyqacjob42qjcbnb@quack3>
 <20240531145204.GJ52987@frogsfrogsfrogs>
 <20240603104259.gii7lfz2fg7lyrcw@quack3>
 <vbiskxttukwzhjoiic6toscqc6b2qekuwumfpzqp5vkxf6l6ia@pby5fjhlobrb>
 <20240603174259.GB52987@frogsfrogsfrogs>
 <20240604085843.q6qtmtitgefioj5m@quack3>
 <20240605003756.GH52987@frogsfrogsfrogs>
 <CAOQ4uxiVVL+9DEn9iJuWRixVNFKJchJHBB8otH8PjuC+j8ii4g@mail.gmail.com>
 <ZmEemh4++vMEwLNg@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZmEemh4++vMEwLNg@dread.disaster.area>

On 2024-06-06 12:27:38, Dave Chinner wrote:
> On Wed, Jun 05, 2024 at 08:13:15AM +0300, Amir Goldstein wrote:
> > On Wed, Jun 5, 2024 at 3:38 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > > On Tue, Jun 04, 2024 at 10:58:43AM +0200, Jan Kara wrote:
> > > > On Mon 03-06-24 10:42:59, Darrick J. Wong wrote:
> > > > > I do -- allowing unpriviledged users to create symlinks that consume
> > > > > icount (and possibly bcount) in the root project breaks the entire
> > > > > enforcement mechanism.  That's not the way that project quota has worked
> > > > > on xfs and it would be quite rude to nullify the PROJINHERIT flag bit
> > > > > only for these special cases.
> > > >
> > > > OK, fair enough. I though someone will hate this. I'd just like to
> > > > understand one thing: Owner of the inode can change the project ID to 0
> > > > anyway so project quotas are more like a cooperative space tracking scheme
> > > > anyway. If you want to escape it, you can. So what are you exactly worried
> > > > about? Is it the container usecase where from within the user namespace you
> > > > cannot change project IDs?
> > >
> > > Yep.
> > >
> > > > Anyway I just wanted to have an explicit decision that the simple solution
> > > > is not good enough before we go the more complex route ;).
> > >
> > > Also, every now and then someone comes along and half-proposes making it
> > > so that non-root cannot change project ids anymore.  Maybe some day that
> > > will succeed.
> > >
> > 
> > I'd just like to point out that the purpose of the project quotas feature
> > as I understand it, is to apply quotas to subtrees, where container storage
> > is a very common private case of project subtree.
> 
> That is the most modern use case, yes.
> 
> [ And for a walk down history lane.... ]
> 
> > The purpose is NOT to create a "project" of random files in random
> > paths.
> 
> This is *exactly* the original use case that project quotas were
> designed for back on Irix in the early 1990s and is the original
> behaviour project quotas brought to Linux.
> 
> Project quota inheritance didn't come along until 2005:
> 
> commit 65f1866a3a8e512d43795c116bfef262e703b789
> Author: Nathan Scott <nathans@sgi.com>
> Date:   Fri Jun 3 06:04:22 2005 +0000
> 
>     Add support for project quota inheritance, a merge of Glens changes.
>     Merge of xfs-linux-melb:xfs-kern:22806a by kenmcd.
> 
> And full support for directory tree quotas using project IDs wasn't
> fully introduced until a year later in 2006:
> 
> commit 4aef4de4d04bcc36a1461c100eb940c162fd5ee6
> Author: Nathan Scott <nathans@sgi.com>
> Date:   Tue May 30 15:54:53 2006 +0000
> 
>     statvfs component of directory/project quota support, code originally by Glen.
>     Merge of xfs-linux-melb:xfs-kern:26105a by kenmcd.
> 
> These changes were largely done for an SGI NAS product that allowed
> us to create one great big XFS filesystem and then create
> arbitrarily sized, thin provisoned  "NFS volumes"  as directory
> quota controlled subdirs instantenously. The directory tree quota
> defined the size of the volume, and so we could also grow and shrink
> them instantenously, too. And we could remove them instantenously
> via background garbage collection after the export was removed and
> the user had been told it had been destroyed.
> 
> So that was the original use case for directory tree quotas on XFS -
> providing scalable, fast management of "thin" storage for a NAS
> product. Projects quotas had been used for accounting random
> colections of files for over a decade before this directory quota
> construct was created, and the "modern" container use cases for
> directory quotas didn't come along until almost a decade after this
> capability was added.

Thanks!

> 
> > My point is that changing the project id of a non-dir child to be different
> > from the project id of its parent is a pretty rare use case (I think?).
> 
> Not if you are using project quotas as they were originally intended
> to be used.
> 
> > If changing the projid of non-dir is needed for moving it to a
> > different subtree,
> > we could allow renameat2(2) of non-dir with no hardlinks to implicitly
> > change its
> > inherited project id or explicitly with a flag for a hardlink, e.g.:
> > renameat2(olddirfd, name, newdirfd, name, RENAME_NEW_PROJID).
> 
> Why?
> 
> The only reason XFS returns -EXDEV to rename across project IDs is
> because nobody wanted to spend the time to work out how to do the
> quota accounting of the metadata changed in the rename operation
> accurately. So for that rare case (not something that would happen
> on the NAS product) we returned -EXDEV to trigger the mv command to
> copy the file to the destination and then unlink the source instead,
> thereby handling all the quota accounting correctly.
> 
> IOWs, this whole "-EXDEV on rename across parent project quota
> boundaries" is an implementation detail and nothing more.
> Filesystems that implement project quotas and the directory tree
> sub-variant don't need to behave like this if they can accurately
> account for the quota ID changes during an atomic rename operation.
> If that's too hard, then the fallback is to return -EXDEV and let
> userspace do it the slow way which will always acocunt the resource
> usage correctly to the individual projects.
> 
> Hence I think we should just fix the XFS kernel behaviour to do the
> right thing in this special file case rather than return -EXDEV and
> then forget about the rest of it.

I see, I will look into that, this should solve the original issue.

But those special file's inodes still will not be accounted by the
quota during initial project setup (xfs_quota will skip them), would
it worth it adding new syscalls anyway?

-- 
- Andrey

> Sure, update xfs_repair to fix the
> special file project id issue if it trips over it, but other than
> that I don't think we need anything more. If fixing it requires new
> syscalls and tools, then that's much harder to backport to old
> kernels and distros than just backporting a couple of small XFS
> kernel patches...
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

