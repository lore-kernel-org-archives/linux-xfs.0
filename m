Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 00:23:20 -0700 (PDT)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.235])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7U7ND4p003883
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 00:23:16 -0700
Received: by nz-out-0506.google.com with SMTP id x3so306234nzd
        for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 00:23:14 -0700 (PDT)
Message-ID: <bd9320b30708292327u26f30c75j8e34b9fa1584371f@mail.gmail.com>
Date: Wed, 29 Aug 2007 23:27:58 -0700
From: mike <mike503@gmail.com>
Subject: Re: [zfs-discuss] ZFS, XFS, and EXT4 compared
In-Reply-To: <1188454611.23311.13.camel@toonses.gghcwest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Cc: zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

On 8/29/07, Jeffrey W. Baker <jwbaker@acm.org> wrote:
> I have a lot of people whispering "zfs" in my virtual ear these days,
> and at the same time I have an irrational attachment to xfs based
> entirely on its lack of the 32000 subdirectory limit.  I'm not afraid of
> ext4's newness, since really a lot of that stuff has been in Lustre for
> years.  So a-benchmarking I went.  Results at the bottom:
>
> http://tastic.brillig.org/~jwb/zfs-xfs-ext4.html
>
> Short version: ext4 is awesome.  zfs has absurdly fast metadata
> operations but falls apart on sequential transfer.  xfs has great
> sequential transfer but really bad metadata ops, like 3 minutes to tar
> up the kernel.
>
> It would be nice if mke2fs would copy xfs's code for optimal layout on a
> software raid.  The mkfs defaults and the mdadm defaults interact badly.

this is cool to see. however, performance wouldn't be my reason for
moving to zfs. the inline checksumming and all that is what i want. if
someone could get nearly incorruptable filesystems (or just a linux
version of zfs... btrfs looks promising) this would be even better.

sadly ext4+swraid isn't as good, i might have tried that since waiting
the right hardware support for zfs for me seems to be unknown at this
point.
