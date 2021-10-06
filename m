Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC0EC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Oct 2021 16:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3FEF61130
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Oct 2021 16:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhJFQ4G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Oct 2021 12:56:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43798 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231484AbhJFQ4F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Oct 2021 12:56:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633539253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=emaDX49Mjpzx8jyoS5lszlDlEFVIuoDbqRz2iiJBLig=;
        b=i54ACOG3k5Oe/jjR3eHmzOAGAD2sonnf6Po8PMnKI3Mvzf25iiHBimFqXy4bWPc+OvYpgQ
        2qBn5hO3FI1Xm5GgHVZ3jxTEkxAozTSoBQaVH4jb5PcGpjKVenbeLR9IdTz2pVFwbhkcr6
        VpAvTrPPJyRzYUp2sjQxFKjtJNdggKw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-loafKZzDMdiiYl1nNeMx8A-1; Wed, 06 Oct 2021 12:54:12 -0400
X-MC-Unique: loafKZzDMdiiYl1nNeMx8A-1
Received: by mail-wr1-f69.google.com with SMTP id r21-20020adfa155000000b001608162e16dso2549631wrr.15
        for <linux-xfs@vger.kernel.org>; Wed, 06 Oct 2021 09:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=emaDX49Mjpzx8jyoS5lszlDlEFVIuoDbqRz2iiJBLig=;
        b=voEoyIiASM2VyILPl+bh+APzkDODItRhR31W/2ALhq66ijcHc/MURoNUPLhUGgDgX1
         1wbzOgOvlKi2/M1kXGkdBflJp9Z3pTtQfPlzHqW+h/hK2sj/2gxKQTKNuN3A10yfOlaU
         tbmnxeyfwcsNVk8DYkEZ2d3WCm/zsv8hvL0mLfXikmaA2Tve45a43+yvI9+JMdRS02a4
         14U73gSSarYlbkBEMa+xCtBsOD7ZHD0rfkVBBJy5E61xEP9qjCFIyoJVYOIjxDw+u814
         Fg5WLf2718FVS/Oy6cswmd4ZLwZyZ2FkpKq/3B8puBUM/O6BxAs8ZMGc8Dw3jWtPD8Du
         e3Zw==
X-Gm-Message-State: AOAM531HQ5n8KzQYQMJJlP+FinksqKtWUOHNSb6WFnOTNBBP2fxntyLT
        FoTNNwfPmpesDx4c3aJPQYM2hJmao4CmH1u4tOSVYuJ/qxy2vm5ABa5uJrm2Wyw3u+gSvmHFQWp
        0buTMd0Pe+nucNGbbNGAn
X-Received: by 2002:a05:6000:2c8:: with SMTP id o8mr4895077wry.430.1633539250572;
        Wed, 06 Oct 2021 09:54:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwePvo9RZUacx5X1Qok7Uch6aY5NR0mW8soSvwqspmpitsXHJhFXK2m5lveF1RmuS35ZnKYQ==
X-Received: by 2002:a05:6000:2c8:: with SMTP id o8mr4895046wry.430.1633539250227;
        Wed, 06 Oct 2021 09:54:10 -0700 (PDT)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id u1sm21907326wrn.66.2021.10.06.09.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 09:54:09 -0700 (PDT)
Date:   Wed, 6 Oct 2021 18:54:07 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Prevent mmap command to map beyond EOF
Message-ID: <20211006165407.bplbdyfb66hbumk5@andromeda.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org
References: <20211004141140.53607-1-cmaiolino@redhat.com>
 <20211005223653.GG24307@magnolia>
 <20211006113400.lcwukggcqwkrftkz@andromeda.lan>
 <20211006155419.GI24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006155419.GI24307@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > My biggest motivation was actually seeing xfs_io crashing due a sigbus
> > while running generic/172 and generic/173. And personally, I'd rather see an
> > error message like "attempt to mmap/mwrite beyond EOF" than seeing it crash.
> > Also, as you mentioned, programs are allowed to set up such kind of
> > configuration (IIUC what you mean, mixing mmap, extend, truncate, etc), so, I
> > believe such userspace programs should also ensure they are not attempting to
> > write to invalid memory.
> 
> This patch would /also/ prevent us from writing an fstest to check that
> a process /does/ get SIGBUS when writing to a mapping beyond EOF.  Huh,
> we don't have a test for that...

TBH, this kind of test in xfstests didn't pass through my mind, but, this is
mmap (and its mapped regions) behavior, I don't see why we would want to test
this in xfstests, but, well, I am neither a memory expert to say what it
should/shouldn't do (I'm just following the man page), nor I have any authority
to say what we can/can't do in xfstests :)

> 
> Also, where does generic/173 write to a mapping beyond EOF?  It sets up
> a file of blksz*nr_blks bytes, clones it, fills the fs to full, and then
> writes that number of bytes to the mmap region to trigger SIGBUS when
> the COW fails due to ENOSPC.

The whole command that ends up receiving a SIGBUS is:

xfs_io -i -f -c 'mmap -rw 0 41943040' -c 'mwrite -S 0x62 0 41943040'

I have a slightly suspicious this is happening because it's trying to access the
very last byte of the file, but I do need to check again the machine where I was
running g/173. At a later point, I just did some tests using an empty, 0
sized file. So I do not recall from the top of my head the behavior from g/173.
I can do it later, now I need to run to a doc appt.

> 
> --D
> 
> > > OTOH if your goal is to write a test to check the SIGBUS functionality,
> > > you could install a sigbus handler to report the signal to stderr, which
> > > would avoid bash writing junk about the sigbus to the terminal.
> > 
> > No, I'm just trying to avoid xfs_io crashing if we point it to invalid memory :)
> > 
> > Cheers.
> > 
> > > 
> > > --D
> > > 
> > > > 
> > > >  io/mmap.c | 7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > > 
> > > > diff --git a/io/mmap.c b/io/mmap.c
> > > > index 9816cf68..77c5f2b6 100644
> > > > --- a/io/mmap.c
> > > > +++ b/io/mmap.c
> > > > @@ -242,6 +242,13 @@ mmap_f(
> > > >  		return 0;
> > > >  	}
> > > >  
> > > > +	/* Check if we are mmapping beyond EOF */
> > > > +	if ((offset + length) > filesize()) {
> > > > +		printf(_("Attempting to mmap() beyond EOF\n"));
> > > > +		exitcode = 1;
> > > > +		return 0;
> > > > +	}
> > > > +
> > > >  	/*
> > > >  	 * mmap and munmap memory area of length2 region is helpful to
> > > >  	 * make a region of extendible free memory. It's generally used
> > > > -- 
> > > > 2.31.1
> > > > 
> > > 
> > 
> > -- 
> > Carlos
> > 
> 

-- 
Carlos

