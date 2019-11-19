Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A2AC432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 13:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3B0320409
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 13:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKSNiQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 08:38:16 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:47731 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSNiP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 08:38:15 -0500
Received: from mail-qt1-f179.google.com ([209.85.160.179]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MRCFw-1iC4un36km-00NDoL for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2019
 14:38:13 +0100
Received: by mail-qt1-f179.google.com with SMTP id r20so24530303qtp.13
        for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2019 05:38:13 -0800 (PST)
X-Gm-Message-State: APjAAAVvFQWjCL//CzznWeGV8FHfWgPZFEuEiSnI2jpsdUHKFdphu7Dj
        H7aIkZvSi1ZFKNCtLIIbL/2yGsNASBrLGbG3akk=
X-Google-Smtp-Source: APXvYqz4bXTI0bmIUD5AZL7fMHExdoVBF+Ez77gdFfD+6Nacm/840Qb9yOf9tRsPI8Q99vkCpTEjxh4/jcIFpZf2F6c=
X-Received: by 2002:aed:3e41:: with SMTP id m1mr32233635qtf.142.1574170692684;
 Tue, 19 Nov 2019 05:38:12 -0800 (PST)
MIME-Version: 1.0
References: <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
 <20191112211153.GO4614@dread.disaster.area> <20191113035611.GE6219@magnolia>
 <CAOQ4uxi9vzR4c3T0B4N=bM6DxCwj_TbqiOxyOQLrurknnyw+oA@mail.gmail.com>
 <20191113045840.GR6219@magnolia> <CAOQ4uxh0T-cddZ9gwPcY6O=Eg=2g855jYbjic=VwihYPz2ZeBw@mail.gmail.com>
 <20191113052032.GU6219@magnolia> <CAOQ4uxiTRWkeM6i6tyMe5dzSN8nsR=1XZEMEwwwVJAcJNVimGA@mail.gmail.com>
 <20191118082216.GU4614@dread.disaster.area> <CAOQ4uxgyf7gWy0TpE8+i1cw37yH+NKsBa=ffP0rw5uLW55LwLw@mail.gmail.com>
 <20191119053439.GF6219@magnolia>
In-Reply-To: <20191119053439.GF6219@magnolia>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 19 Nov 2019 14:37:55 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0RO=6wc-MrTzP72WULYATZTfT+Vx5XdMyG+_-aH32ZBQ@mail.gmail.com>
Message-ID: <CAK8P3a0RO=6wc-MrTzP72WULYATZTfT+Vx5XdMyG+_-aH32ZBQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Wghe4D3AFNTADopYnumkkR1iTxf36ZYDC0lOERSMkPAoEZQvtkd
 YbZ0RzceX38u2WdXxbGhKcHc7RD2nTHiRGRl8R9oNriczd6/Nr2mv//TTeMh1jBQL9QVln5
 DFpsdB5ir4FjrmqrfP3hx7Zq5tHM0f1pN4bIdfreypDkDqd3Bpv8wW15mYeSNqCgcRrMJs+
 ppUNaWizF7PRlk090n/Uw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9CFi8deYl/0=:xJqRbm8ywbeSnX7Fy3aTg7
 3K4kxIXLmfizeJsuGAk18rVTcsxvLmxEqnE8W9FUeVpy06votv14/8QpoHlaao36PLvwX4e/g
 Bd1/Ok7Ij/O4aXV5Fi2ioSl4E8LmmgWbcBrgFVvHpovlXBY39Ob7bhVQT3J2ND0L7KFC5KsxQ
 iiK2fQAlElFxnKshXL30vuKAxnRdluVBZOiDYtUqB8ynp6hXoemKB+XkCFBjND42wkPQzz+Ig
 vo+yhVdOIpx/pU07Td/h8J/IDsiLCN5VLwwgKoOzzf+X/ii+XwNzq8xlrqb3UaCtfKFemvc5Z
 dA7DVgydQxAsoELDJdQMONsUgVusx32+sYhX8kxIXGXAS/Y/r2jt9lVcntRwupByJlAyAZHBU
 ZlGjqpzofwUHhYX9ZYppgRvBJbqZO63rR1PARyBBCr1/CGzZIK0zqv7CoiSFEA/ucWNY3Q3bO
 S2A6MERL133MrHOr7geodUrrz62jfP90VcLIEoRsV4UFD/Z5AFvTmkkF5n060Bhfi7dv/kSRt
 EO19i5qmIZagITExWFDLt2QzFfEmPS1PHVHy08BuECnRNnpCLHsnTyOwToUWLEpuDe647xe1+
 7+2sDI7fLuAxN4Gn9RUlpSH3/05SsaDm56gKGD7vwBhrfGkgLLQNEfEe0uQZV7JeqJ3k8UV2Q
 caRE5FwPpISOFC5cEKiLlQc+f6SnZIDo2WMPUsrk8MVWcTf70GCOmWlabt0z6J0f0jJTDB6OZ
 gmG5y6DbN93A9G0tlgeh9TQabOCPpxjf/e/+t6BTv9P0eQkI/qNnEYFI/Y1CQKdLeg4m4mg/E
 r4EcQrmAd/PZOobMDF94UZJH5ElkhHnQzPEAS+FIrumKKQjis513dmvzdvehYJSKEk6/OuJLy
 d7WKpUvhr5juOp9WvQwA==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 19, 2019 at 6:36 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Mon, Nov 18, 2019 at 11:30:58AM +0200, Amir Goldstein wrote:
> > I am assuming you are working on the patch.
> > If you would like me to re-post my patch with the decided
> > on-disk formats for inode and a quota patch let me know.
>
> Still working on it.  In the meantime, I have a question for you and
> Arnd: I've started writing more fstests.  How does userspace query the
> kernel to find out the supported range of timestamps?  fstests currently
> hardcodes it, but yuck.  XFS could find an ioctl/sysfs knob to export
> that info, but it really belongs in statvfs or something.

David Howells has gone through 15 revisions of his fsinfo syscall,
the most recent post was this summer:

https://lwn.net/Articles/792628/
https://lore.kernel.org/lkml/156173661696.14042.17822154531324224780.stgit@warthog.procyon.org.uk/

I don't know whether he has a timeline for completing the work.

The last version was waiting on the new mount API, which has gone into
v5.2, so maybe the patches just need to be refreshed on top of v5.4.

We had previously discussed adding a generic ioctl in do_vfs_ioctl
or using up the last 128 bits of padding in struct statfs, but I think the
fsinfo() syscall would be best.

       Arnd
