Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1F5C2D0DC
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 09:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 558BE21734
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 09:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgABJQk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 04:16:40 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:51495 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgABJQk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 04:16:40 -0500
Received: from mail-qk1-f169.google.com ([209.85.222.169]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MkYsS-1jS1dI3AVS-00m3Fa; Thu, 02 Jan 2020 10:16:38 +0100
Received: by mail-qk1-f169.google.com with SMTP id x1so30899538qkl.12;
        Thu, 02 Jan 2020 01:16:38 -0800 (PST)
X-Gm-Message-State: APjAAAVE+QGBgSsRMYZdQs3GkXukEqfChK4/SNI6JC7Pyim5mPbnqp64
        6Ig4gIIelL0mldKHY49XArAdnmWqfM7inAR3vz8=
X-Google-Smtp-Source: APXvYqzMxAfesvRBpiHh6fMW9hbkTamYEsxggVtcBYfvoLFG1XW+BpjsplaAZxvnXIkYQDC1Hncybh1OmV1yUVGvmqA=
X-Received: by 2002:a05:620a:cef:: with SMTP id c15mr50280055qkj.352.1577956597546;
 Thu, 02 Jan 2020 01:16:37 -0800 (PST)
MIME-Version: 1.0
References: <20191218163954.296726-1-arnd@arndb.de> <20191218163954.296726-2-arnd@arndb.de>
 <20191224084514.GC1739@infradead.org>
In-Reply-To: <20191224084514.GC1739@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 2 Jan 2020 10:16:21 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2ANKoV1DhJMUuAr0qKW7HgRvz9LM2yLkSVWP9Rn-LUhA@mail.gmail.com>
Message-ID: <CAK8P3a2ANKoV1DhJMUuAr0qKW7HgRvz9LM2yLkSVWP9Rn-LUhA@mail.gmail.com>
Subject: Re: [PATCH 2/3] xfs: disallow broken ioctls without compat-32-bit-time
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:8KdMv8fjCvWywy7uq+aXkHWXOq4F2qLM4ZJM7SojuBoJ6JbM70e
 UpI1ZP0enlB4QrVPFQFEsFwt7UPgjc6moR1swgX/S4p1sFynGZl8du/pdOAOPG67alNaiUB
 akEwabmA9Jz80bg/U+sOSHFLl/XTTIbEhzN00IuRdo1a1TzqryZ5yYp9cudTks8pct2oz7A
 JvbJmIbncwdDNXnwUGq/w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:T6fbHrRGgNs=:w60Y7IiRHBBsAikCNZQU3S
 xL5DHroytE978MsWi+3If2C7aK/R693I79kzvV3fzJViNASASp9BmQ/Hz4rcXfUvaCjKf4zH9
 okmOn5XNJtFXbyJFdH3O1HIAvFJUsxbGuMaAIkdlfU2CqcE9lXjnR8PfhcTU0JrcoJNjt28vj
 Fwg1XWpuoqUIiTINVSxAmUs3cewAxHGrEyMgqUkgN3XIiF6PujkUKjLsd67RwBfezN6TzDK5G
 XAkKoA3D7xyN63fBEQm5vJwsY40pyabiHSu+0Kcd2MQIWiEtHO/rxzoRGa068HQ7VoJKx210Y
 XFPYCWeimhUhSx9J3q/Op7MswRT7/f799/iponz1tEnXZXwkOn6GEyaMgeLXwPLjopCXLyOik
 t7z+mqqoIyscxsdBjf/+/0oqQoDd5DnojHS4+nHf2igN06LusrlN5g2Z3n69j81si6Bkri5fx
 2ieUZgMWJ+//49OgQH5h/Mbdocq2PFAv4d/BLSZA7j1xw9GMnXomN+KXLi7/nqrcbDFH0MUJJ
 qLFbGkD1tAgamxzBC30bfH3Or/zlKrmMdPOLC5wJFJBmlFrBdkXACq1utwOAfxuVrxkWtZapF
 ZsK9V8Mkg4prZAY5EpJfmI66JMMrizY7i2sHa7M/32ltSXIWn24yXRl5se0DSPGwB5eb8HV3V
 5Fjrt9+obUunUCldTA92Q6BVp1e/hbKAi3PIbNP08X3QvS/9ofY1UPIVBJ07E9YMptDy0f6T0
 uZhFW+FcP+qL+Ht8Hp6gKEbPlYJ/IbR1Wy/+J7r4YAzwD8zCj0DZl6ULWnFtUhHwVdT65inXE
 a6NMZL3t1U0ZzNCCPd7+qHZRvN/qG4X76g7uF4tJzHqy1ThYCgPAx1Wia6O/Hzg3CWGZJ5G45
 QW/B+6g3gxIPKDQh2Mpw==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 24, 2019 at 9:45 AM Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Dec 18, 2019 at 05:39:29PM +0100, Arnd Bergmann wrote:
> > +/* disallow y2038-unsafe ioctls with CONFIG_COMPAT_32BIT_TIME=n */
> > +static bool xfs_have_compat_bstat_time32(unsigned int cmd)
> > +{
> > +     if (IS_ENABLED(CONFIG_COMPAT_32BIT_TIME))
> > +             return true;
> > +
> > +     if (IS_ENABLED(CONFIG_64BIT) && !in_compat_syscall())
> > +             return true;
> > +
> > +     if (cmd == XFS_IOC_FSBULKSTAT_SINGLE ||
> > +         cmd == XFS_IOC_FSBULKSTAT ||
> > +         cmd == XFS_IOC_SWAPEXT)
> > +             return false;
> > +
> > +     return true;
>
> I think the check for the individual command belongs into the callers,
> which laves us with:
>
> static inline bool have_time32(void)
> {
>         return IS_ENABLED(CONFIG_COMPAT_32BIT_TIME) ||
>                 (IS_ENABLED(CONFIG_64BIT) && !in_compat_syscall());
> }
>
> and that looks like it should be in a generic helper somewhere.

Yes, makes sense.

I was going for something XFS specific here because XFS is unique in the
kernel in completely deprecating a set of ioctl commands (replacing
the old interface with a v5) rather than allowing the user space to be
compiled with 64-bit time_t.

If we add a global helper for this, I'd be tempted to also stick a
WARN_RATELIMIT() in there to give users a better indication of
what broke after disabling CONFIG_COMPAT_32BIT_TIME.

The same warning would make sense in the system calls, but then
we have to decide which combinations we want to allow being
configured at runtime or compile-time.

a) unmodified behavior
b) just warn but allow
c) no warning but disallow
d) warn and disallow

> >       if (XFS_FORCED_SHUTDOWN(mp))
> >               return -EIO;
> >
> > @@ -1815,6 +1836,11 @@ xfs_ioc_swapext(
> >       struct fd       f, tmp;
> >       int             error = 0;
> >
> > +     if (!xfs_have_compat_bstat_time32(XFS_IOC_SWAPEXT)) {
> > +             error = -EINVAL;
> > +             goto out;
> > +     }
>
> And for this one we just have one cmd anyway.  But I actually still
> disagree with the old_time check for this one entirely, as voiced on
> one of the last iterations.  For swapext the time stamp really is
> only used as a generation counter, so overflows are entirely harmless.

Sorry I missed that comment earlier. I've had a fresh look now, but
I think we still need to deprecate XFS_IOC_SWAPEXT and add a
v5 version of it, since the comparison will fail as soon as the range
of the inode timestamps is extended beyond 2038, otherwise the
comparison will always be false, or require comparing the truncated
time values which would add yet another representation.

       Arnd
