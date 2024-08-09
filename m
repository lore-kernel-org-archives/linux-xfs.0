Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D52183CD5
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723213151; cv=none; b=rKmTO+CnOpKPNoAM7H4lLA8TjuAYItbDsmo1oj9COqd0hpC9iC6wV6C8w3/W4UnSZt35NM/wVheKtFvoRru0bFNcfyTrXQrX7KxLLmRc2brz0yULzzXniMZj1dLnbtBqmqfdAoXgzkxd7U9KqCjW+J7mYMHFMq8AF2EsZdUynYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723213151; c=relaxed/simple;
	bh=NeoFK0anLuC0E6HLN+p0AcuRfNRVaUd0EijMDz+f+7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7/j7f/AlONT4sfFPDhlRfuhsPF34++pudZIt7iI0gJgjFk6XsAdE+8FNd8ZS4LL1UERgxxWbMYqnQfPhCoOJnPRxsFOtplRjIgrfHmCGmr4jC5n9X4GK/xIRQxPXGdv9Ob2erCt7yVWJ3QoWPMpkN/4HRmkGlXDFzIfbuppRso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=wNaChya1; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="wNaChya1"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-79ef72bb8c8so87928585a.2
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 07:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723213149; x=1723817949; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O5L2Ze254Vx9tD9b2lLp1cqn0rrQxZcwOBmP3YiNFE4=;
        b=wNaChya1NswosCe6DxNoUAq6od04xjA1i2twzyIttavGyFBWLPU2GQR5nL3g8O/RAU
         zqwT21KeZlvBOl4Mqtq8D7QhlR8kOR1Px1OYGUedKNZ41DfJSdJ/vS3+GFJI8ddpQelb
         AQk0av+o6UjxY61f+/FRygHgkqzy7IU60FMTgE+RtJzVjYIS98KHM9MRboLke+e0r3BK
         /u7uLP7h9O90INnbKS4iYJlh29Zj5CgL3910iNrRxCzPGj85dB+eeyb3BcnKiHNttTyV
         vkSVsDgGqlzaVUYm+tqntOyd+CtCE15MPR2FdwU1FKPlC9LjapsZimJX72jCH/dGj2Rm
         8YOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723213149; x=1723817949;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O5L2Ze254Vx9tD9b2lLp1cqn0rrQxZcwOBmP3YiNFE4=;
        b=p2QOpvsb44RdLbMNS6DCRHLeTnQSr08t4bicGgE3Iw7P/WUGGijLShwoLhudIB5rIi
         qGel27lg9BfnSKblSq+D5kQ8siw++ungbmxnW53202szoDfx1jchQGNjBNPWCcDFQ29X
         uaoehvrwhOQ1w6dYjI4k813rv8h7VnrIEOXKCiZQed2qJGe9W6CICsoo5AJMa0yeMKu/
         ks/7+4XLZ+X/CyfHY3A6TpB8xxY7s/XTe1f76ff9k2J7MArne3RJf30zLKjuZ+TAGHs3
         5eqtRWXG8U9QHkLengWniA23hw4FamqV+d1+yULOJXl3A7FB/+ApxGWVMQgUbz+O5urq
         GE3A==
X-Forwarded-Encrypted: i=1; AJvYcCVcI3ATWxKmb9PHuZtrdtbxyyvs1Q59hLu2R0jS6i0vYCBiXqsAJQMMV4WNJKv++6dQ9o6NK63QGWFrH7f3TkME+HA20LCtWV1d
X-Gm-Message-State: AOJu0Yx+OHk3+qh+rXuAI7zjrV81/nhJ9MPJm2e3l2FK7t//EYRHOcdB
	/TZQeqFK+hQd3uv5i2TrnzdDBH9EIrzpgk5CPGufrYPYmBKt9HY5wbky3B0ijqg=
X-Google-Smtp-Source: AGHT+IEHcsBi55PERCnEeiqGMU1DAJy4+XEP+O/1/bmYEbY1dbyH2M7XWYBiPqJB2gUhRrs0CmXLRg==
X-Received: by 2002:a05:620a:2983:b0:79f:504:dead with SMTP id af79cd13be357-7a4c17bbc36mr179568785a.27.1723213149023;
        Fri, 09 Aug 2024 07:19:09 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a3786cc6a3sm265893085a.123.2024.08.09.07.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 07:19:08 -0700 (PDT)
Date: Fri, 9 Aug 2024 10:19:07 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	brauner@kernel.org, linux-xfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 13/16] fsnotify: generate pre-content permission event
 on page fault
Message-ID: <20240809141907.GD645452@perftesting>
References: <cover.1723144881.git.josef@toxicpanda.com>
 <b8c3f0d9ed6d23f9a636919e28293cdbbe22e0db.1723144881.git.josef@toxicpanda.com>
 <CAOQ4uxivX+mxfpOUTAsxHVoCGb9YHdi-qHswN9O4EJ53sKUVfw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxivX+mxfpOUTAsxHVoCGb9YHdi-qHswN9O4EJ53sKUVfw@mail.gmail.com>

On Fri, Aug 09, 2024 at 12:34:34PM +0200, Amir Goldstein wrote:
> On Thu, Aug 8, 2024 at 9:28 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > FS_PRE_ACCESS or FS_PRE_MODIFY will be generated on page fault depending
> > on the faulting method.
> >
> > This pre-content event is meant to be used by hierarchical storage
> > managers that want to fill in the file content on first read access.
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  include/linux/mm.h |  2 +
> >  mm/filemap.c       | 97 ++++++++++++++++++++++++++++++++++++++++++----
> >  2 files changed, 92 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index ab3d78116043..c33f3b7f7261 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3503,6 +3503,8 @@ extern vm_fault_t filemap_fault(struct vm_fault *vmf);
> >  extern vm_fault_t filemap_map_pages(struct vm_fault *vmf,
> >                 pgoff_t start_pgoff, pgoff_t end_pgoff);
> >  extern vm_fault_t filemap_page_mkwrite(struct vm_fault *vmf);
> > +extern vm_fault_t filemap_maybe_emit_fsnotify_event(struct vm_fault *vmf,
> > +                                                   struct file **fpin);
> >
> >  extern unsigned long stack_guard_gap;
> >  /* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 8b1684b62177..3d232166b051 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -46,6 +46,7 @@
> >  #include <linux/pipe_fs_i.h>
> >  #include <linux/splice.h>
> >  #include <linux/rcupdate_wait.h>
> > +#include <linux/fsnotify.h>
> >  #include <asm/pgalloc.h>
> >  #include <asm/tlbflush.h>
> >  #include "internal.h"
> > @@ -3112,13 +3113,13 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
> >   * that.  If we didn't pin a file then we return NULL.  The file that is
> >   * returned needs to be fput()'ed when we're done with it.
> >   */
> > -static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
> > +static struct file *do_sync_mmap_readahead(struct vm_fault *vmf,
> > +                                          struct file *fpin)
> >  {
> >         struct file *file = vmf->vma->vm_file;
> >         struct file_ra_state *ra = &file->f_ra;
> >         struct address_space *mapping = file->f_mapping;
> >         DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
> > -       struct file *fpin = NULL;
> >         unsigned long vm_flags = vmf->vma->vm_flags;
> >         unsigned int mmap_miss;
> >
> > @@ -3190,12 +3191,12 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
> >   * was pinned if we have to drop the mmap_lock in order to do IO.
> >   */
> >  static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
> > -                                           struct folio *folio)
> > +                                           struct folio *folio,
> > +                                           struct file *fpin)
> >  {
> >         struct file *file = vmf->vma->vm_file;
> >         struct file_ra_state *ra = &file->f_ra;
> >         DEFINE_READAHEAD(ractl, file, ra, file->f_mapping, vmf->pgoff);
> > -       struct file *fpin = NULL;
> >         unsigned int mmap_miss;
> >
> >         /* See comment in do_sync_mmap_readahead. */
> > @@ -3260,6 +3261,72 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
> >         return ret;
> >  }
> >
> > +/**
> > + * filemap_maybe_emit_fsnotify_event - maybe emit a pre-content event.
> > + * @vmf:       struct vm_fault containing details of the fault.
> > + * @fpin:      pointer to the struct file pointer that may be pinned.
> > + *
> > + * If we have pre-content watches on this file we will need to emit an event for
> > + * this range.  We will handle dropping the lock and emitting the event.
> > + *
> > + * If FAULT_FLAG_RETRY_NOWAIT is set then we'll return VM_FAULT_RETRY.
> > + *
> > + * If no event was emitted then *fpin will be NULL and we will return 0.
> > + *
> > + * If any error occurred we will return VM_FAULT_SIGBUS, *fpin could still be
> > + * set and will need to have fput() called on it.
> > + *
> > + * If we emitted the event then we will return 0 and *fpin will be set, this
> > + * must have fput() called on it, and the caller must call VM_FAULT_RETRY after
> > + * any other operations it does in order to re-fault the page and make sure the
> > + * appropriate locking is maintained.
> > + *
> > + * Return: the appropriate vm_fault_t return code, 0 on success.
> > + */
> > +vm_fault_t filemap_maybe_emit_fsnotify_event(struct vm_fault *vmf,
> > +                                            struct file **fpin)
> > +{
> > +       struct file *file = vmf->vma->vm_file;
> > +       loff_t pos = vmf->pgoff << PAGE_SHIFT;
> > +       int mask = (vmf->flags & FAULT_FLAG_WRITE) ? MAY_WRITE : MAY_READ;
> 
> You missed my comment about using MAY_ACCESS here
> and alter fsnotify hook, so legacy FAN_ACCESS_PERM event
> won't be generated from page fault.

I did miss that, I'll fix it up in v3, thanks!

Josef
