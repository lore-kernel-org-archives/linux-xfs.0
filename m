Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Aug 2007 23:50:30 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7U6oN4p026343
	for <xfs@oss.sgi.com>; Wed, 29 Aug 2007 23:50:25 -0700
Received: by wa-out-1112.google.com with SMTP id k22so505167waf
        for <xfs@oss.sgi.com>; Wed, 29 Aug 2007 23:50:24 -0700 (PDT)
Message-ID: <c7dddeaa0708292325l4006775aq827b80117048638@mail.gmail.com>
Date: Thu, 30 Aug 2007 09:25:04 +0300
From: "Cyril Plisko" <cyril.plisko@mountall.com>
Subject: Re: [zfs-discuss] ZFS, XFS, and EXT4 compared
In-Reply-To: <1188454611.23311.13.camel@toonses.gghcwest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Cc: zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

Jeffrey,

it would be interesting to see your zpool layout info as well.
It can significantly influence the results obtained in the benchmarks.



On 8/30/07, Jeffrey W. Baker <jwbaker@acm.org> wrote:
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
>
> Postmark is somewhat bogus benchmark with some obvious quantization
> problems.
>
> Regards,
> jwb
>
> _______________________________________________
> zfs-discuss mailing list
> zfs-discuss@opensolaris.org
> http://mail.opensolaris.org/mailman/listinfo/zfs-discuss
>


-- 
Regards,
        Cyril
