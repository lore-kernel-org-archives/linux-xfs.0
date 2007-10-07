Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 15:19:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l97MJARQ024298
	for <linux-xfs@oss.sgi.com>; Sun, 7 Oct 2007 15:19:15 -0700
Date: Mon, 8 Oct 2007 08:19:03 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: mounting raid5 with different unit values
Message-ID: <20071007221902.GO23367404@sgi.com>
References: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Sun, Oct 07, 2007 at 09:15:23AM +0200, Raz wrote:
> Hello
> I am trying to mount xfs over raid5. I am trying to mount it with
> different values than
> the true ones. the mount fails with a general error of :
> mount -osunit=6144,swidth=18432 /dev/md1 /d1/
> mount: wrong fs type, bad option, bad superblock on /dev/md1,
>        or too many mounted file systems

Try looking in your syslog or dmesg for the error that occurred
during mount. THere's the possibility that it won't give you
an error because of a bug that was fixed more recently than
2.6.17 that suppressd errors incorrectly. You shoul dreally
try a more recent kernel ;)

Most likely, the new sunit/swidth are being rejected because
of alignent reasons (e.g. the AG size is not a multiple of
the new sunit you are setting).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
