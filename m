Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36069C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 18:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbiFVShH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 14:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235461AbiFVShG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 14:37:06 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F2B1EAD7;
        Wed, 22 Jun 2022 11:37:05 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id w187so3672801vsb.1;
        Wed, 22 Jun 2022 11:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fqVXnkXjCgBoEtp9jhmT6Dl8GzFuhytKpi83YIc6ySA=;
        b=GH+p/STs18vnX7AxQrUqG3I20JKa0ZojYDLsdiN+lmlIxvrNF/thevvI2P2fqZfRm6
         b9s+oLPacq4ufMiNq6F9O9QHP7ZwsUy3Epryf+e87HoHiBpA0S+eiOGVgK+LG4CCtFgW
         sWoHVaIJF91hMkrT8+BjdRjNzk/WROLC2IWSzsfjvexECOiSq5KlXujqBiWF2uTS85UW
         U1ZXGrZCdO/eyKdDvx52EGFq7nTIKevAY19fvTlrRzGYS/neynNxPlBQSDE48Lx325QR
         LF9bn1S7G7yxogbAHX48aI6Lse6HrhJq4clyCcHvsSFyvB/T2RIBKA3UT8KvWl2Z02cr
         MDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fqVXnkXjCgBoEtp9jhmT6Dl8GzFuhytKpi83YIc6ySA=;
        b=2dTcK3KwrDntEWpsUACJy9mblLwSSWJGjeSYm5Jf+5/7K8dc9xYHd21xgurjRbMWMp
         U3JObvVlklW3NgCtjzDUpZR9Eja+t3WtoCyZsrYGMjexWoHZbYrV2tAp+9Xfkfg6VC2v
         Y2yefsfo9KNB3iPEC5sb7kORjOx+0Yr3YF2B7MVN6jz1GImuvu5uZs+U1LWKFRvZosBJ
         zJxgF2TG2cRm+h4piRV9LkRxsztbo85g7zv1+PcX86a61S61PHpXIaljPIgai/xAkuqK
         +o+vClP12N2KrklLD6JbdCrmx2VS1sqNee4mNsBl1Vfosr1a4wXPPm3iXEZUDCUXc0vO
         UxDQ==
X-Gm-Message-State: AJIora+Es/3OVMEfs0xpO2GfZthQ48MNhvHVWaowxSlmKocbIfodLcN+
        b94dITMSM3r45U5rH44/dAqanLOqVqQIEaSFVpg=
X-Google-Smtp-Source: AGRyM1ubX6XfAZkVjfoqliln0xPhSs7yZaGh5Uh2+DzMxBGxMYgXp3mfm2fxaUL38sWcBPOrK/W+/RsUNAOZLjk+OCw=
X-Received: by 2002:a05:6102:34e5:b0:354:5832:5ce8 with SMTP id
 bi5-20020a05610234e500b0035458325ce8mr3198990vsb.36.1655923024377; Wed, 22
 Jun 2022 11:37:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220617100641.1653164-1-amir73il@gmail.com> <20220617100641.1653164-12-amir73il@gmail.com>
 <YrNGJXYi2jQtPxs0@magnolia>
In-Reply-To: <YrNGJXYi2jQtPxs0@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 22 Jun 2022 21:36:53 +0300
Message-ID: <CAOQ4uxgXobea42K=WVyOhxxq+S=TA3RvLbxypKO02D9TZEgioA@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 11/11] xfs: use setattr_copy to set vfs
 inode attributes
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 7:41 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Jun 17, 2022 at 01:06:41PM +0300, Amir Goldstein wrote:
> > From: "Darrick J. Wong" <djwong@kernel.org>
> >
> > commit e014f37db1a2d109afa750042ac4d69cf3e3d88e upstream.
> >
> > [remove userns argument of setattr_copy() for backport]
> >
> > Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
> > revocation isn't consistent with btrfs[1] or ext4.  Those two
> > filesystems use the VFS function setattr_copy to convey certain
> > attributes from struct iattr into the VFS inode structure.
> >
> > Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
> > decide if it should clear setgid and setuid on a file attribute update.
> > This is a second symptom of the problem that Filipe noticed.
> >
> > XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
> > xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
> > /not/ a simple copy function; it contains additional logic to clear the
> > setgid bit when setting the mode, and XFS' version no longer matches.
> >
> > The VFS implements its own setuid/setgid stripping logic, which
> > establishes consistent behavior.  It's a tad unfortunate that it's
> > scattered across notify_change, should_remove_suid, and setattr_copy but
> > XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
> > functions and get rid of the old functions.
> >
> > [1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
> > [2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/
> >
> > Fixes: 7fa294c8991c ("userns: Allow chown and setgid preservation")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Christian Brauner <brauner@kernel.org>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Same question as I posted to Leah's series -- have all the necessary VFS
> fixes and whatnot been backported to 5.10?  Such that all the new sgid
> inheritance tests actually pass with this patch applied? :)

The only patch I backorted to 5.10 is:
xfs: fix up non-directory creation in SGID directories

I will check which SGID tests ran on my series.

Personally, I would rather defer THIS patch to a later post to stable
(Leah's patch as well) until we have a better understanding of the state
of SGID issues.

Thanks,
Amir.
