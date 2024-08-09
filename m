Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AF518E1F
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 14:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723213266; cv=none; b=EF4GC8HxWc/WcXUQ1xD8JbAb6be8ME3b6lU7RTa4piQ656g3I/GoJZZoIHlvVKZQoem+qhtd419VPp34sJoUnHDDsh0M3y1b56xoLFZ8cNDGyEIHbbqQrniYm8O/8/wFgjp7kl51ic4JEm7gVydqP4WYENDzP10iAkhoPv8OyB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723213266; c=relaxed/simple;
	bh=t3zXFkLE2UV99ifhdw4NnmAm7JcM7Z52AKyUdJWaX68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=py0Zu6f1um32T3KE6hPjKL7rrwuZz4QL0hTXl/jF/EHrAxGDMY4EMM1foLl9jZDmgyZ989WhZ/qHqnLpW9qdg6GcTLYLNhiBLN66xCbh6c0Vw3cY8S6bQMJcEnppeJSSzHBdCJZMXr8b3SF7u/Lf98y1YuUENqivkZ9dLArvwOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=NuXdeAFm; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="NuXdeAFm"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-44fdcd7a622so12472091cf.0
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 07:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723213263; x=1723818063; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CKZF3cvOhqay0zYcNhazoUd/3NN2G/SxrMaioqb1jXo=;
        b=NuXdeAFmhNaBkMeDlRZ0JO9f6J2ZLcIqlpwYAgEFiIWYR3PmjJWMXaLkU0W4OZxOSA
         t3rSRWOxPy0Mj+y0GqnnhiG81rnbuIiF8hBmlRBm7+tEIIaWAcYwcqDGlXdcJVVAyiSM
         fGsQ0woCISV9uVKABahFYJTtpwExUamubksFgRcWch4EFd7SPI5D8pdf5FNRGJmUXgjs
         UfsQ5enTMBdfXg6L+SMLHnTm5rl9riy9VZ3IBK4C8PLaFQC3kYgjdQgGz73eBqduMM9M
         HCokFB7Q4T8R3iagomEaa5tbrO+KoUfNuGGqu7E9Kz8QhzIzRkzCK3YNsoUQn7ffjXSf
         bJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723213263; x=1723818063;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CKZF3cvOhqay0zYcNhazoUd/3NN2G/SxrMaioqb1jXo=;
        b=FbhV9kCBK4yctXwpbo3XgHEqEdFlbdqDEewUovhR5btDlVO8ARyW5qAedKTqsrdSBg
         rc8ZQeIK4AE34wOSYuKp4Avp2/wXEAxR0vi919kn4baBD0gEfvElYMrLyPN6wFZPOJZH
         DCPsx8IsuFvequp1Gh6z3TW7EdRDuB1BNPkDsCEDfmCxs7CrU8ZvDhO4gbfi5U/5RCvC
         ygxAv6gksVfGBGvoz5A7IqBuy0rEIHS5vccwtTBN8bEHku7hrRyb3DexXg+HZPedSrm9
         Tt4trrb4D77eS3KYCKqsAhHgX3rwhgYpBlFrqUjXTyDxEHdBwvJcEd1TVgYGuZvEXw/N
         nHpg==
X-Forwarded-Encrypted: i=1; AJvYcCVuXG+hEGqtQwUu9NYQompKatNBq910OuZnsIYwWs6H3MDQt82P9iwO8eJIB3BH64L51gb2PSkA9XILZrb4z/YFeO2UhiisnGR0
X-Gm-Message-State: AOJu0YzA79ZmMXVH8urJhwysaJOG7KNd9iR9ja9YdGVpjqMm/jiuCyPb
	tVbcPS6w0+4jmzYvF0wCu0q92gE6Jm2l6b+SIGLVcWyqZJsGXyFPqsaXi7HvcMU=
X-Google-Smtp-Source: AGHT+IGsQWpdoc1n/6YJVYv3GSaZvzRHF1gOMGFjb7Lfg3bwAKe9cIyl3/U5GQlwRuGlZLav1oMtlw==
X-Received: by 2002:a05:622a:4acd:b0:451:d859:2042 with SMTP id d75a77b69052e-453126c9213mr20410961cf.56.1723213262616;
        Fri, 09 Aug 2024 07:21:02 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c87f697esm21753811cf.83.2024.08.09.07.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 07:21:02 -0700 (PDT)
Date: Fri, 9 Aug 2024 10:21:01 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	brauner@kernel.org, linux-xfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 14/16] bcachefs: add pre-content fsnotify hook to fault
Message-ID: <20240809142101.GE645452@perftesting>
References: <cover.1723144881.git.josef@toxicpanda.com>
 <bce66af61dd98d4f81032b97c73dce09658ae02d.1723144881.git.josef@toxicpanda.com>
 <CAOQ4uxiWJ60Srtep4FiDP_hUd8WU5Mn1kq-dxRz4BpyMc40J2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxiWJ60Srtep4FiDP_hUd8WU5Mn1kq-dxRz4BpyMc40J2g@mail.gmail.com>

On Fri, Aug 09, 2024 at 03:11:34PM +0200, Amir Goldstein wrote:
> On Thu, Aug 8, 2024 at 9:28 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > bcachefs has its own locking around filemap_fault, so we have to make
> > sure we do the fsnotify hook before the locking.  Add the check to emit
> > the event before the locking and return VM_FAULT_RETRY to retrigger the
> > fault once the event has been emitted.
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/bcachefs/fs-io-pagecache.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/fs/bcachefs/fs-io-pagecache.c b/fs/bcachefs/fs-io-pagecache.c
> > index a9cc5cad9cc9..359856df52d4 100644
> > --- a/fs/bcachefs/fs-io-pagecache.c
> > +++ b/fs/bcachefs/fs-io-pagecache.c
> > @@ -562,6 +562,7 @@ void bch2_set_folio_dirty(struct bch_fs *c,
> >  vm_fault_t bch2_page_fault(struct vm_fault *vmf)
> >  {
> >         struct file *file = vmf->vma->vm_file;
> > +       struct file *fpin = NULL;
> >         struct address_space *mapping = file->f_mapping;
> >         struct address_space *fdm = faults_disabled_mapping();
> >         struct bch_inode_info *inode = file_bch_inode(file);
> > @@ -570,6 +571,18 @@ vm_fault_t bch2_page_fault(struct vm_fault *vmf)
> >         if (fdm == mapping)
> >                 return VM_FAULT_SIGBUS;
> >
> > +       ret = filemap_maybe_emit_fsnotify_event(vmf, &fpin);
> > +       if (unlikely(ret)) {
> > +               if (fpin) {
> > +                       fput(fpin);
> > +                       ret |= VM_FAULT_RETRy;
> 
> Typo RETRy

Hmm I swear I had bcachefs turned on in my config, I'll fix this and also fix my
config.

> 
> > +               }
> > +               return ret;
> > +       } else if (fpin) {
> > +               fput(fpin);
> > +               return VM_FAULT_RETRY;
> > +       }
> > +
> 
> This chunk is almost duplicate in all call sites in filesystems.
> Could it maybe be enclosed in a helper.
> It is bad enough that we have to spray those in filesystem code,
> so at least give the copy&paste errors to the bare minimum?

You should have seen what I had to begin with ;).  I agree, I'll rework this to
reduce how much we're carrying around.  Thanks,

Josef
