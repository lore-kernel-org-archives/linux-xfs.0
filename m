Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF85C4BA12
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3BF22467D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mwUNC+9q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgBZPTk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 10:19:40 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36667 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbgBZPTk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 10:19:40 -0500
Received: by mail-oi1-f194.google.com with SMTP id c16so3388659oic.3;
        Wed, 26 Feb 2020 07:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HPLI71nQNjvEjndIWOMzn92Whnbzm/DTK7IrM4ZvySQ=;
        b=mwUNC+9qhtuZtmscaGI33pnOTIVI9BGvuTVR8FRYkPWCCqkR/TdRPwIPZ6yjvMo5nv
         DEpuv8q0Pj1KA8n9DcqKAoKAJbvFj4LM1GTp3H3sUm59xCHznnwDo/ot0pthb+4XdVMt
         1qYENsfS65SmlAqkwPTe2gcKX1+AzHHMEU1zIhmNiSe8b0dICSXivarkDe15AhnA+bE5
         SDtIm4LS+leYNfSTpCxggfRMb5U7MSjb0NXtUSsrYcukBz6j8JhKsvYmfIUcj3SGFLsV
         IP3GrRPBLxpQtagjWTPE8uhjK9A843d2ynYB/JuYgMxsEuXlZAXqu7gw0rrQjuekCCFv
         9B1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HPLI71nQNjvEjndIWOMzn92Whnbzm/DTK7IrM4ZvySQ=;
        b=JFKXMGuPphYu1W7Pxa7oFZju6dmPVf9MPzNB65STpekdKrGks9D7VxyZQgJNEg58We
         97FOvuYmuH2OrGywEZ8VHDrQN1r1chQ7UepCr8uGCXna/Cum3ovxhScyibEsdLdi2bSC
         9aw7MoZmKsk/h0CV5HminpyJeTt4EqzkUJxtLrtOgGdyGFXoXVJcrsnI/0m+Rr/ZVMpa
         vopb9P4N9s8eV+E22J8RSGwcDtvATVMofVX8uNdBTmQkg5I54gVzsLpBbsI4xX4y3Od4
         a4+rrLZSfA4H6b8UFyDyfISOqAeJTILU0hpzUuaWWWCflkvpnI/lwXnkrL3osyzE0MbR
         i4UA==
X-Gm-Message-State: APjAAAXK5FtsD9iSGtShCi5NRMAdGLuw2QEcSmHBxOGYku+7/UiY0d+t
        Z5oeaorY4+Zi275eOsA1Tyf9hVk0pZpyDyIBliw=
X-Google-Smtp-Source: APXvYqyTM5+Hs5hflJiSWJxm2Y+HsmeaGuG1Pg1ulrWF/HjbV7pwkNnM0MroT9wMdEGr09pCh7ohEED/KZ9DICzTrEM=
X-Received: by 2002:aca:f05:: with SMTP id 5mr3603942oip.140.1582730379191;
 Wed, 26 Feb 2020 07:19:39 -0800 (PST)
MIME-Version: 1.0
References: <20200220153234.152426-1-richard_c_haines@btinternet.com>
 <20200220155731.GU9506@magnolia> <20200220155938.GA1306@infradead.org>
 <2862d0b2-e0a9-149d-16e5-22c3f5f82e9e@tycho.nsa.gov> <20200220160820.GA14640@infradead.org>
 <CAHC9VhRXo=EZ4HbLa_W_waL4xtdE6M92em7aNh=wm_7hpozJ7g@mail.gmail.com>
 <5c1f2125a44006d7ff8bda6d9a1075d2177aeaf0.camel@btinternet.com>
 <20200225041327.GE6740@magnolia> <575bec416692e93b599520f34d625de8d46bfb07.camel@btinternet.com>
 <20200225213533.GW6740@magnolia>
In-Reply-To: <20200225213533.GW6740@magnolia>
From:   Stephen Smalley <stephen.smalley.work@gmail.com>
Date:   Wed, 26 Feb 2020 10:21:19 -0500
Message-ID: <CAEjxPJ4f44MX-MO3GiL+bBwq9nJbHArexTUeUe6HGPiGNyJP4g@mail.gmail.com>
Subject: Re: [PATCH 0/1] selinux: Add xfs quota command types
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Richard Haines <richard_c_haines@btinternet.com>,
        Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, linux-xfs@vger.kernel.org,
        selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 4:36 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> Hmm, maybe let's back up a step here.  What's the purpose of being able
> to set quota_on privileges on a file?  Is it so that sysadmins can
> designate a particular file as a "quota" file and thereby prevent the
> kernel from being tricked into loading some other file as the quota data
> file?

Yes.

> I ask this because AFAICT in ext4, the "usrjquota=<path>" mount options
> are for the old quota system wherein quotas are files that are managed
> separately from the filesystem.
>
> The new ext4 quota system links the quota inode pointers only from the
> superblock, and it calls dquot_load_quota_inode, which doesn't seem to
> have a security callout.  Seeing as there's no user-visible file for new
> style quotas, I don't see why you'd need a selinux hook either.
>
> I guess it could be generally useful to be able to be able to apply the
> same quota_on labels to root directories of filesystems that have new
> style quotas that one can apply to quota files on fses with old style
> quotas... but (a) I don't see that being the case right now, and (b) if
> you're trying to /add/ that functionality then yes it ought to be in
> fs/quota/... and yes xfs will have to play catch up once it's there.
>
> Is there already a precedent for setting quota_on labels to the root
> dir?  It's entirely possible that I'm simply unaware of what's going on
> in fs/quota/ because xfs mostly does its own things wrt quota.

Ok, in that case I'd say we don't need the hook to be called at all in
the cases where
the quota inode is private to the superblock and not directly exposed
to userspace.
So no change required to xfs or fs/quota and we can skip/ignore the test when
not using usrquota=...
