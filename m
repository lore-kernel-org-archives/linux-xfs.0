Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47097 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731221AbeISUty (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 16:49:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id a108-v6so6173380wrc.13
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 08:11:31 -0700 (PDT)
MIME-Version: 1.0
References: <20180919125617.28048-1-jtulak@redhat.com> <20180919144405.GH20086@magnolia>
In-Reply-To: <20180919144405.GH20086@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 19 Sep 2018 17:11:19 +0200
Message-ID: <CACj3i72fGt799Z+vOAzxep93W-ksN=O_ZjSfMRji8SxvUFdN+Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] mkfs: discard only after all validations
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

On Wed, Sep 19, 2018 at 4:44 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:

snip

> > @@ -2419,8 +2418,16 @@ open_devices(
> >       xi->dsize &= sector_mask;
> >       xi->rtsize &= sector_mask;
> >       xi->logBBsize &= (uint64_t)-1 << (max(cfg->lsectorlog, 10) - BBSHIFT);
> > +}
> >
> > -
> > +static void
> > +discard_data(
>
> Perhaps discard_devices(), since this function can DISCARD more than
> just the data device.

Agreed.


>
> > +     struct libxfs_xinit     *xi,
> > +     bool                    discard)
> > +{
> > +     /*
> > +      * This function has to be called after libxfs has been initialized.
> > +      */
> >       if (!discard)
> >               return;
> >
>
> While we're on the topic, I notice that we skip discard for any device
> that's actually a file.  Seeing as fallocate(PUNCH_HOLE) works on files
> (and block devices), is there a reason why we avoid punching out fs
> image files?
>

>From what I remember, it went along this: If the user is trying to
mkfs an existing file, we don't want to destroy anything they did with
the file before (sparse file, allocations...).

> > @@ -3901,7 +3908,7 @@ main(
> >       /*
> >        * Open and validate the device configurations
> >        */
> > -     open_devices(&cfg, &xi, (discard && !dry_run));
> > +     open_devices(&cfg, &xi);
> >       validate_datadev(&cfg, &cli);
> >       validate_logdev(&cfg, &cli, &logfile);
> >       validate_rtdev(&cfg, &cli, &rtfile);
> > @@ -3952,6 +3959,11 @@ main(
> >                       exit(0);
> >       }
> >
> > +     /*
> > +      * All values have been validated, discard the old device layout.
> > +      */
> > +     discard_data(&xi, (discard && !dry_run));
>
> if (discard && !dry_run)
>         discard_devices(&xi);
>
> ?

Yes, this makes more sense.

Jan

--
Jan Tulak
jtulak@redhat.com / jan@tulak.me
