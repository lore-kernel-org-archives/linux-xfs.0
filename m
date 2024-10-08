Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765BF1DF98C
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 14:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728396871; cv=none; b=fi/e2zgALLQyOSQk7iqzhoF+nF9SANPBSbac/DlwL4nI6UYkkkfpATIJ+yOhWhIoUQvuTYrx41s73v+5cUTnBEEYM9xpEWUR7NNZlp3odJ8sNnckz0ZflkkppePkTZ2JZlDEZVJciBKxMTODVkpHXh8yq2QIQwFn4f968spu8gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728396871; c=relaxed/simple;
	bh=5aoQfcWfquO8q33TtZ1UTCdHm8yAW/7J4xonT60sqmE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XUa+2mM8dOwE2ivYgEDoMCb4s6qaoGb0GchydGa6zLKrwzvRiVmSYlK+CdCgvIjylnipgjWSmOsulS5WhYbF3MfuwYnEL/L7TFOZ2fvy2LZxvvKa7Wt8D+SgorFMORNhbG27yhUOptAjuIatYpSJzGsIoC1OE1pI9CzUokUcVh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=W/H8XNDF; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="W/H8XNDF"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a83562f9be9so619075366b.0
        for <linux-xfs@vger.kernel.org>; Tue, 08 Oct 2024 07:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1728396868; x=1729001668; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YBVGFNELeNzrNE/pUTBOb0mu55heBoVv/TX9AMKEIYw=;
        b=W/H8XNDFivUW9VLnSktT+XzOQXUH3KE0rFITwhcgz4btk/AWlmh/OdsClCUOhNcIXh
         W8zoHvo3Zr5sTMs/BuZFX3HGv/oqz6buC4/Qv9ylna96il+m/MjNkPlPiDrga3DgBJ5U
         bfsQs6p5jHvrLnUnP0XiWOMda6XCWr/LvSiEwRJgEHKXoz3isJgoWzRmBjBVKBQOdhMl
         0t/pD1r+4ic95bt1qmkneU6jZujZV8e0O13lqEnvF7UTLA96A49rX3dvudq2CEaxz35q
         D9JFCI/I4r0CUW8ka1ylAmLpSsHK31R6wOxGcBTUpV76wivYVk3HcfYT8M4VaRv5UnJx
         2Jtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728396868; x=1729001668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBVGFNELeNzrNE/pUTBOb0mu55heBoVv/TX9AMKEIYw=;
        b=kLzNOcGWYrwcOMSqdGYJoqOwZvZDnyhnR51TMyKIXDS6QAApA+Z3PXNba9Yrf5mirO
         IEmiye7KtG1UFOlMfN6aZTNRmpYe+si7IQULsHSlCAXnzozNcCWCnkVVVQvPU+2ZpU+F
         SbURi/XLH51X6xs9wmOXsUNIrybWsXXFMhV4WxFIQhGHXPqT1YnVBTslfGB0Eo5Dn0UA
         81U7ab+dm+hpiVXzMgT5+TrYS/N8BwSiviRlXmbQ++mfpA+yY2DTHzzZ3/sxG3kOP3C4
         Hw4PQoeP9Q3Fj+9cwv0TsKQ3drJwIbuk3tY7HT6NoNPty+slgjQTk6ILegYGLW8O1LqC
         x8Lw==
X-Forwarded-Encrypted: i=1; AJvYcCV1VHHZkMwYvyFprwuY6j2t+LUr2hSf6CynMqIQG1FNivjjayE+lfU2JBLcTvqIjko9353TwFM5bjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCdV1Pqgn7Br1bgb9cmWOZmEEmHu0FTh4oHH5jCYS4CZmof1zn
	oJvBYpgVxVGyLUQtA+NUURqIUHsFucNZun1/Xot1XgtPwjY74M4q2YPuuzPgaR4LR7F1eD3sNV7
	IgiB49BeX5TEceGy062RGxjZdBu4iFs3FsEANrQ==
X-Google-Smtp-Source: AGHT+IHk7euKn0dAZXT3q629EL9K9j/synWTQJVFme/t1o1SfzpypUdoyToXvWJFg+KpMfYuEfL1GEA/mnXYkTqoe0k=
X-Received: by 2002:a17:907:7fab:b0:a99:4649:af69 with SMTP id
 a640c23a62f3a-a994649b64bmr886505266b.15.1728396867688; Tue, 08 Oct 2024
 07:14:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241002130004.69010-1-yizhou.tang@shopee.com>
 <20241002130004.69010-2-yizhou.tang@shopee.com> <20241003130127.45kinxoh77xm5qfb@quack3>
 <CACuPKxmwZgNx242x5HgTUCpu6v6QC3XtFY2ZDOE-mcu=ARK=Ag@mail.gmail.com> <20241007162311.77r5rra2tdhzszek@quack3>
In-Reply-To: <20241007162311.77r5rra2tdhzszek@quack3>
From: Tang Yizhou <yizhou.tang@shopee.com>
Date: Tue, 8 Oct 2024 22:14:16 +0800
Message-ID: <CACuPKx=-wmNOHbHFEqYEwnw6X7uzaZ+JU7pHqG+FCsAgKjePnQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/page-writeback.c: Rename BANDWIDTH_INTERVAL to UPDATE_INTERVAL
To: Jan Kara <jack@suse.cz>
Cc: willy@infradead.org, akpm@linux-foundation.org, chandan.babu@oracle.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 8, 2024 at 12:23=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sun 06-10-24 20:41:11, Tang Yizhou wrote:
> > On Thu, Oct 3, 2024 at 9:01=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> > >
> > > On Wed 02-10-24 21:00:02, Tang Yizhou wrote:
> > > > From: Tang Yizhou <yizhou.tang@shopee.com>
> > > >
> > > > The name of the BANDWIDTH_INTERVAL macro is misleading, as it is no=
t
> > > > only used in the bandwidth update functions wb_update_bandwidth() a=
nd
> > > > __wb_update_bandwidth(), but also in the dirty limit update functio=
n
> > > > domain_update_dirty_limit().
> > > >
> > > > Rename BANDWIDTH_INTERVAL to UPDATE_INTERVAL to make things clear.
> > > >
> > > > This patche doesn't introduce any behavioral changes.
> > > >
> > > > Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
> > >
> > > Umm, I agree BANDWIDTH_INTERVAL may be confusing but UPDATE_INTERVAL =
does
> > > not seem much better to be honest. I actually have hard time coming u=
p with
> > > a more descriptive name so what if we settled on updating the comment=
 only
> > > instead of renaming to something not much better?
> > >
> > >                                                                 Honza
> >
> > Thank you for your review. I agree that UPDATE_INTERVAL is not a good
> > name. How about
> > renaming it to BW_DIRTYLIMIT_INTERVAL?
>
> Maybe WB_STAT_INTERVAL? Because it is interval in which we maintain
> statistics about writeback behavior.
>

I don't think this is a good name, as it suggests a relation to enum
wb_stat_item, but bandwidth and dirty limit are not in wb_stat_item.

Yi

>                                                                 Honza
>
> > > > ---
> > > >  mm/page-writeback.c | 16 ++++++++--------
> > > >  1 file changed, 8 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > > > index fcd4c1439cb9..a848e7f0719d 100644
> > > > --- a/mm/page-writeback.c
> > > > +++ b/mm/page-writeback.c
> > > > @@ -54,9 +54,9 @@
> > > >  #define DIRTY_POLL_THRESH    (128 >> (PAGE_SHIFT - 10))
> > > >
> > > >  /*
> > > > - * Estimate write bandwidth at 200ms intervals.
> > > > + * Estimate write bandwidth or update dirty limit at 200ms interva=
ls.
> > > >   */
> > > > -#define BANDWIDTH_INTERVAL   max(HZ/5, 1)
> > > > +#define UPDATE_INTERVAL              max(HZ/5, 1)
> > > >
> > > >  #define RATELIMIT_CALC_SHIFT 10
> > > >
> > > > @@ -1331,11 +1331,11 @@ static void domain_update_dirty_limit(struc=
t dirty_throttle_control *dtc,
> > > >       /*
> > > >        * check locklessly first to optimize away locking for the mo=
st time
> > > >        */
> > > > -     if (time_before(now, dom->dirty_limit_tstamp + BANDWIDTH_INTE=
RVAL))
> > > > +     if (time_before(now, dom->dirty_limit_tstamp + UPDATE_INTERVA=
L))
> > > >               return;
> > > >
> > > >       spin_lock(&dom->lock);
> > > > -     if (time_after_eq(now, dom->dirty_limit_tstamp + BANDWIDTH_IN=
TERVAL)) {
> > > > +     if (time_after_eq(now, dom->dirty_limit_tstamp + UPDATE_INTER=
VAL)) {
> > > >               update_dirty_limit(dtc);
> > > >               dom->dirty_limit_tstamp =3D now;
> > > >       }
> > > > @@ -1928,7 +1928,7 @@ static int balance_dirty_pages(struct bdi_wri=
teback *wb,
> > > >               wb->dirty_exceeded =3D gdtc->dirty_exceeded ||
> > > >                                    (mdtc && mdtc->dirty_exceeded);
> > > >               if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stam=
p) +
> > > > -                                        BANDWIDTH_INTERVAL))
> > > > +                                        UPDATE_INTERVAL))
> > > >                       __wb_update_bandwidth(gdtc, mdtc, true);
> > > >
> > > >               /* throttle according to the chosen dtc */
> > > > @@ -2705,7 +2705,7 @@ int do_writepages(struct address_space *mappi=
ng, struct writeback_control *wbc)
> > > >        * writeback bandwidth is updated once in a while.
> > > >        */
> > > >       if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
> > > > -                                BANDWIDTH_INTERVAL))
> > > > +                                UPDATE_INTERVAL))
> > > >               wb_update_bandwidth(wb);
> > > >       return ret;
> > > >  }
> > > > @@ -3057,14 +3057,14 @@ static void wb_inode_writeback_end(struct b=
di_writeback *wb)
> > > >       atomic_dec(&wb->writeback_inodes);
> > > >       /*
> > > >        * Make sure estimate of writeback throughput gets updated af=
ter
> > > > -      * writeback completed. We delay the update by BANDWIDTH_INTE=
RVAL
> > > > +      * writeback completed. We delay the update by UPDATE_INTERVA=
L
> > > >        * (which is the interval other bandwidth updates use for bat=
ching) so
> > > >        * that if multiple inodes end writeback at a similar time, t=
hey get
> > > >        * batched into one bandwidth update.
> > > >        */
> > > >       spin_lock_irqsave(&wb->work_lock, flags);
> > > >       if (test_bit(WB_registered, &wb->state))
> > > > -             queue_delayed_work(bdi_wq, &wb->bw_dwork, BANDWIDTH_I=
NTERVAL);
> > > > +             queue_delayed_work(bdi_wq, &wb->bw_dwork, UPDATE_INTE=
RVAL);
> > > >       spin_unlock_irqrestore(&wb->work_lock, flags);
> > > >  }
> > > >
> > > > --
> > > > 2.25.1
> > > >
> > > >
> > > --
> > > Jan Kara <jack@suse.com>
> > > SUSE Labs, CR
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
