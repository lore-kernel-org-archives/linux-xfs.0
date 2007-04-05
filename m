Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 09:23:28 -0700 (PDT)
Received: from mail.linbit.com (nudl.linbit.com [212.69.162.21])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l35GNJfB017294
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 09:23:21 -0700
Date: Thu, 5 Apr 2007 18:22:35 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: xfs_repair leaves empty but undeletable dirs in lost+found
Message-ID: <20070405162235.GA816@barkeeper1.linbit>
References: <20070404203601.GA11771@barkeeper1.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404203601.GA11771@barkeeper1.linbit>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Apr 04, 2007 at 10:36:01PM +0200, Lars Ellenberg wrote:
> NOTE that I used the default sarge xfsprogs version 2.6.20, not
>      the upstream 2.8.20. yet. I'll start an xfs_repair run with
>      2.8.20 right after this post, though...

done.
now, this used seriously more memory, and cpu,
and the box went thrashing.
after some experimenting,

xfs_repair -o bhash=512 

got it going without using excessive amounts of swap,
so it finally finished after about 12 hours
(2.6.20 needed 8:30, repeatable).

it did not change the situation, however.

I know I could clean these using xfs_db and an additional run of
xfs_repair, but I'm going to keep these around for some more time, in
case you want me to have a look at some internals still.

file system itself has gone life again, I hope it does not hurt having
those strange directories around.

maybe it is even "just" a problem on the kernel side,
not being able to convert so the expected "form" of directory?
sorry, I'm not too deep in the xfs internals, so I need some input from
the developers here...

Thanks,

-- 
: Lars Ellenberg                            Tel +43-1-8178292-0  :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
__
please use the "List-Reply" function of your email client.
