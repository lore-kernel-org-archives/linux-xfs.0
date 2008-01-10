Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jan 2008 23:20:16 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0A7JmGx018064
	for <xfs@oss.sgi.com>; Wed, 9 Jan 2008 23:19:49 -0800
Received: from ug-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16DD6502CEF
	for <xfs@oss.sgi.com>; Wed,  9 Jan 2008 23:20:02 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.172]) by cuda.sgi.com with ESMTP id s81zRQvzVH4ifvcH for <xfs@oss.sgi.com>; Wed, 09 Jan 2008 23:20:02 -0800 (PST)
Received: by ug-out-1314.google.com with SMTP id o29so209182ugd.20
        for <xfs@oss.sgi.com>; Wed, 09 Jan 2008 23:20:01 -0800 (PST)
Message-ID: <96c268400801092320i70a4f0d4i70050aad4b6125b2@mail.gmail.com>
Date: Thu, 10 Jan 2008 10:20:00 +0300
From: "Maxim Gordienko" <mgordienko@gmail.com>
Subject: Re: xfs_repair core dump
In-Reply-To: <op.t4o3y7s33jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <96c268400801061801i62853e5xdda1b93cc864dda5@mail.gmail.com>
	 <op.t4lfpunc3jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <96c268400801080105h68a75233ia82e05d8debaabe6@mail.gmail.com>
	 <op.t4o3y7s33jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com

On Jan 10, 2008 6:58 AM, Barry Naujok <bnaujok@sgi.com> wrote:
> On Tue, 08 Jan 2008 20:05:07 +1100, Maxim Gordienko <mgordienko@gmail.com>
> wrote:
>
> > On Jan 8, 2008 7:21 AM, Barry Naujok <bnaujok@sgi.com> wrote:
> >> On Mon, 07 Jan 2008 13:01:00 +1100, Maxim Gordienko
> >> <mgordienko@gmail.com>
> >> wrote:
> >>
> >> > Hello!
> >> >
> >> > I'm trying to repair damaged xfs partition, but xfs_repair crashes
> >> > with core dump
> >> > distribution is fully updated ubuntu 7.10, xfsprogs are 2.9.0.
> >> > Have tried xfs_repair from other dists like knoppix or gparted livecd,
> >> > compiled from source last stable (2.9.4-1)
> >> > same result. Could you please help? Thank you.
>
> Ok, I think I have it!
>
> Can you try the attached patch to 2.9.4 source. It should "repair" your
> disk. There are a lot of inodes that have problems and quite a few
> will end up in lost+found.
>
> Regards,
> Barry.

Thank you Barry! works like a charm! about 5k files end up in
lost+found, long way to recover them.
Hope to see this patch in next release of xfsprogs (actually, hope
never use xfs_repair again)
Thank you again!
