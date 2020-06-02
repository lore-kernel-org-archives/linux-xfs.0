Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B706EC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 951CC206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D0NVJtEp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgFBE1K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFBE1K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:27:10 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD09AC061A0E
        for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2020 21:27:09 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y18so9413367iow.3
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jun 2020 21:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZpQSkvGr7eCjQ0hn61eqDB5628vI0yYPp4JRgF7TGJI=;
        b=D0NVJtEpKdpimj43M892SGFfktpuRhKBH3iZ9qf5LnZ/vL7bN+pQjf+tk/2DNgG8qa
         Bu5HkO3TdZoBihBTfugMXWNcWRTkAPwrEXloh1nIUVzTdCSoaQCGISPKsrmQhkb66qN5
         JbGeVj1+NQOMGc6/YHy2QI2aCVnlG2z0EZMkC0x74sUgDDGy20QZl/Cp9HKieoFYzgFW
         i5XZ7jAMfZjI+Gz1PCUBnkmoS33WwkXei8T2XHKeVsEbw7seUqrP+4nwQh8uyplqanu0
         ET/NBm9vUIv1Ckix3e/ga5PW7s00yX0H1alqnTEjPQU0u4G4pE93NqAxg27nJzXQLKWJ
         PCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZpQSkvGr7eCjQ0hn61eqDB5628vI0yYPp4JRgF7TGJI=;
        b=gFTHN7/HP01uHMXG+OK1sN2JOz9Tzr1m02K0uB3RIIyS3oDJ5FdSiqW137kOUO6ch2
         MIqXAdxOR9dNq3y3SNyUpcwSD/zOMGCGtEE/UFgqNM+4R/Vsrj77pGGkk1pcZe3ORH86
         MHDC61XOFdoNHKNpcJhoPPzXsuQOeqpkfkDXdBvYdfudycyC5yiXbhpdyGiqBf2RKKJj
         dJAmH45RBsNWgdgPWxSMdpjqAoixACKJc0eTNWqukcbja7BVpSEZNCb9SVPt5TcWWEIP
         GFKPsphyvfTiZcZcfHIKdNCtJccK4vZ2/+SIq7/JIT+b9qvgKZcssgJsQAKmhU3wCnz2
         d+/Q==
X-Gm-Message-State: AOAM531f9btqA6OKI8+Vkj9gOas7etdSc+/yMuEAOCyD0jxkhVxjj82s
        d6cuuH2LBobTcyA13BDr0Yx2Cn3xv3QHG7tlA4Lj2L1V
X-Google-Smtp-Source: ABdhPJzah5aIMk23Uly4BsQ5x6XlHg/c0ZBadNHWVcl0PqxGAknjK5G3yPD3itcsu352xVCCEMg52IgIsyghkB7CAGc=
X-Received: by 2002:a05:6602:2437:: with SMTP id g23mr21679681iob.5.1591072029035;
 Mon, 01 Jun 2020 21:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784113220.1364230.3763399684650880969.stgit@magnolia> <CAOQ4uxj9_6AHPkBmPUpqZ_-nnqgzkwPT4xik=Xi1XQ61JJcTFw@mail.gmail.com>
 <20200601231751.GD2162697@magnolia>
In-Reply-To: <20200601231751.GD2162697@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 2 Jun 2020 07:26:57 +0300
Message-ID: <CAOQ4uxgGNx7jz3v22s2xXYTuPUXNtQZ9UGg4aP50tYqzFBetvQ@mail.gmail.com>
Subject: Re: [PATCH 11/14] xfs: widen ondisk timestamps to deal with y2038 problem
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 2, 2020 at 2:17 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Sun, May 31, 2020 at 03:30:42PM +0300, Amir Goldstein wrote:
> > > @@ -265,17 +278,35 @@ xfs_inode_from_disk(
> > >         if (to->di_version == 3) {
> > >                 inode_set_iversion_queried(inode,
> > >                                            be64_to_cpu(from->di_changecount));
> > > -               xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
> > > +               xfs_inode_from_disk_timestamp(from, &to->di_crtime,
> > > +                               &from->di_crtime);
> > >                 to->di_flags2 = be64_to_cpu(from->di_flags2);
> > >                 to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
> > > +               /*
> > > +                * Convert this inode's timestamps to bigtime format the next
> > > +                * time we write it out to disk.
> > > +                */
> > > +               if (xfs_sb_version_hasbigtime(&mp->m_sb))
> > > +                       to->di_flags2 |= XFS_DIFLAG2_BIGTIME;
> > >         }
> >
> > This feels wrong.
> > incore inode has a union for timestamp.
> > This flag should indicate how the union should be interpreted
> > otherwise it is going to be very easy to stumble on that in future code.
>
> Hm?  I think you've gotten it backwards.
>
> The incore inode (struct xfs_icdinode) has a struct timespec64.
>
> The ondisk inode (struct xfs_dinode) has a union xfs_timestamp.
>
> xfs_inode_from_disk_timestamp uses the ondisk inode (from) to convert
> the ondisk timestamp (&from->di_crtime) to the incore inode
> (&to->di_crtime).
>
> In other words, we use the ondisk flag and union to load the ondisk
> timestamp into a format-agnostic incore structure.  Then we set BIGTIME
> in the incore inode (to->di_flags2).
>
> If and when we write the inode back out to disk, we'll see that BIGTIME
> is set in the incore inode, and convert the incore structure into the
> bigtime encoding on disk.
>
> > So either convert incore timestamp now or check hasbigtime when
> > we write to disk.
>
> That's more or less what this is doing.  We read the timestamp in from
> disk in whatever format it's in, and then set ourselves up to write it
> back out in bigtime format.
>

I stand corrected. xfs_ictimestamp got me confused.
Everything does look consistent.

Thanks,
Amir.
