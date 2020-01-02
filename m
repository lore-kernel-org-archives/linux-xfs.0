Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943EBC2D0C2
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 20:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7156B20866
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 20:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgABUfH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 15:35:07 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:33271 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgABUfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 15:35:07 -0500
Received: from mail-qt1-f176.google.com ([209.85.160.176]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1Mzyi6-1jgiL93ap4-00x5fJ; Thu, 02 Jan 2020 21:35:06 +0100
Received: by mail-qt1-f176.google.com with SMTP id j5so35466548qtq.9;
        Thu, 02 Jan 2020 12:35:05 -0800 (PST)
X-Gm-Message-State: APjAAAWi2YEBn/3O66RVKGQs+oTyANGKsJ05S3USuqCxap/C5397A5UG
        MOF8MBvVlNv2r5dV6Z8VNegCGwnQ1WemE1t+UZc=
X-Google-Smtp-Source: APXvYqwzPm01oOZoHqsFGvAVmjyfZc/M+MP8OPR7YqbUBgpaMCiaqvYr++FdRQyTaxiPBovi16+WrkyX+FMNqNEaXL4=
X-Received: by 2002:ac8:47d3:: with SMTP id d19mr60361134qtr.142.1577997304675;
 Thu, 02 Jan 2020 12:35:04 -0800 (PST)
MIME-Version: 1.0
References: <20191218163954.296726-1-arnd@arndb.de> <20191218163954.296726-2-arnd@arndb.de>
 <20191224084514.GC1739@infradead.org> <CAK8P3a2ANKoV1DhJMUuAr0qKW7HgRvz9LM2yLkSVWP9Rn-LUhA@mail.gmail.com>
In-Reply-To: <CAK8P3a2ANKoV1DhJMUuAr0qKW7HgRvz9LM2yLkSVWP9Rn-LUhA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 2 Jan 2020 21:34:48 +0100
X-Gmail-Original-Message-ID: <CAK8P3a30VpwVCSt0kTXZK7r5__80uBGbNOnDh1YhkAkcoBcQrg@mail.gmail.com>
Message-ID: <CAK8P3a30VpwVCSt0kTXZK7r5__80uBGbNOnDh1YhkAkcoBcQrg@mail.gmail.com>
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
X-Provags-ID: V03:K1:RdZKI/3QSNSIcKVGv40ROmeCrM8uOAiarrWQc4R5jcTLbnH+eiV
 oOxtV4NLkAyQ6Kb0mQZPDK2zKnWK+WJD0t01mA4jeZm+AVBZAm/myQIC+/qunQMQiW/Mxq0
 SlXSLmyh9kig/yi3nSOZ7DIndSWoLLOGsOC9RtBS3/AgwfEiRzQJEDoKVNWxpNBU7+3jFue
 PBHd9i4Y2mkSv8nE7P3cQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ozi7y3Pe8lY=:aqJgDGtFNRJ/Kl0XS/x+pL
 Gx+1ofjguaWgaV3xrJE2F3Sg3koI44xUqJy/zqTXLL7HYK6Hz1MYyy3Wc3TrfS6MXjdcORtkm
 FMXpUCNfzNgLSLfkPjyqHAyI52mAKpg5f/OlsJg48tYU4KBQFNhdmzMokmd74ZNUCuhKpxhpD
 UkqqUTJwaItQf5kX8zIJ9RnhxXi5GsovYP2clWf5/EBLCFEjVWDwKgllXNQmf+AgwKVrt6Hum
 GY1P0yn+sIqKcny6VPG0/mTnLccpgIMPHeIxISY+5OkPLN1wMQCWB3c+MaT6lF/B7h4BuM558
 BrDufelnIWn85FPtIE9IO1b6iZXv6JBtg0OXWXVlTYRMDKS3gaCBL0S3sY5ZBP+DWJXhMK5Sm
 n6ER1M5vCp1p3jFEmbkjxNtx14bqfsI1sf75CXtxO/dL+gtvbsfpNWlKIx073qNvab4FWeEE6
 MDx2eF5wFq5/ZoS/mFO8TvtWTTnA9DvwFP6M0UcEr2m//j9ZPCLeQDByRrfxyUlvlY4zlMWzB
 GKSMGSe72S412weOJLSj9AC7oS8yn1Ceujx8zaDd23DCfD3z5pHhlqngylPjZhu6jUw3YfP5W
 WihFQpW6jS4H3MY3l/j9k9SsYKJ3YrVXsRF+B223SeoVlAgtRTcINdEilrSV5nBfwE/BS+jOi
 X8oLZa8a6w4BUgsDe60+qnUIlaQggmdRculoBdv46OWDuzCqd5dGU1mo0R+YDPYdl2mMgmOPl
 hujKYlUMOPZINH6BvknpVh+Gd179hyKka2cZ+ZX/NREaVUk4bjH3U1KPn0Ab5YsJU4f/BBPaP
 Ml1OHp9NmWK+fASbOuSWQNEebSYciPQuPJz9LstBSWVvd5Jb7LoUMipGEEyATTuVwzK0At0Wg
 f1XzSQjk5aLgbdVRi4nw==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 2, 2020 at 10:16 AM Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Dec 24, 2019 at 9:45 AM Christoph Hellwig <hch@infradead.org> wrote:
> > On Wed, Dec 18, 2019 at 05:39:29PM +0100, Arnd Bergmann wrote:
> > > +/* disallow y2038-unsafe ioctls with CONFIG_COMPAT_32BIT_TIME=n */
> > > +static bool xfs_have_compat_bstat_time32(unsigned int cmd)
> > > +{
> > > +     if (IS_ENABLED(CONFIG_COMPAT_32BIT_TIME))
> > > +             return true;
> > > +
> > > +     if (IS_ENABLED(CONFIG_64BIT) && !in_compat_syscall())
> > > +             return true;
> > > +
> > > +     if (cmd == XFS_IOC_FSBULKSTAT_SINGLE ||
> > > +         cmd == XFS_IOC_FSBULKSTAT ||
> > > +         cmd == XFS_IOC_SWAPEXT)
> > > +             return false;
> > > +
> > > +     return true;
> >
> > I think the check for the individual command belongs into the callers,
> > which laves us with:
> >
> > static inline bool have_time32(void)
> > {
> >         return IS_ENABLED(CONFIG_COMPAT_32BIT_TIME) ||
> >                 (IS_ENABLED(CONFIG_64BIT) && !in_compat_syscall());
> > }
> >
> > and that looks like it should be in a generic helper somewhere.
>
> Yes, makes sense.
>
> I was going for something XFS specific here because XFS is unique in the
> kernel in completely deprecating a set of ioctl commands (replacing
> the old interface with a v5) rather than allowing the user space to be
> compiled with 64-bit time_t.

I tried adding the helper now but ran into a stupid problem: the best
place to put it would be linux/time32.h, but then I have to include
linux/compat.h from there, which in turn pulls in tons of other
headers in any file using linux/time.h.

I considered making it a macro instead, but that's also really ugly.

I now think we should just defer this change until after v5.6, once I
have separated linux/time.h from linux/time32.h.
In the meantime I'll resend the other two patches that I know we
need in v5.6 in order to get there, so Darrick can apply them to his
tree.

      Arnd
