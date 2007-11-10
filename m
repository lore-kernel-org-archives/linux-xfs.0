Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 10 Nov 2007 12:52:07 -0800 (PST)
Received: from mx1.suse.de (mx1.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAAKq1xu000587
	for <linux-xfs@oss.sgi.com>; Sat, 10 Nov 2007 12:52:03 -0800
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: acl and attr: Fix path walking code
Date: Sat, 10 Nov 2007 21:52:05 +0100
References: <200710281858.24428.agruen@suse.de> <4733F301.9020706@sgi.com>
In-Reply-To: <4733F301.9020706@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711102152.05619.agruen@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: linux-xfs@oss.sgi.com, Gerald Bringhurst <gbringhurst@novell.com>, Brandon Philips <bphilips@suse.de>

On Friday 09 November 2007 06:41:21 Timothy Shimmin wrote:
> I applied attr patch and tried it out on xfstests/062
> (which I believe was based on one of your tests).
>
> ==========================================================
> --- 062.out     2006-03-28 12:52:32.000000000 +1000
> +++ 062.out.bad 2007-11-09 15:38:09.000000000 +1100
> @@ -526,6 +526,10 @@
>   user.name=0xbabe
>   user.name3=0xdeface
>
> +# file: SCRATCH_MNT/lnk
> +trusted.name=0xbabe
> +trusted.name3=0xdeface
> +
>   # file: SCRATCH_MNT/dev/b
>   trusted.name=0xbabe
>   trusted.name3=0xdeface
> @@ -562,6 +566,10 @@
>   user.1=0x3233
>   user.x=0x797a
>
> +# file: SCRATCH_MNT/descend/and/ascend
> +trusted.9=0x3837
> +trusted.a=0x6263
> +
>
>   *** directory descent without following symlinks
>   # file: SCRATCH_MNT/reg
> ==========================================================
>
> So for the following of symlinks with getfattr -L
> i.e.
>    echo "*** directory descent with us following symlinks"
>    getfattr -h -L -R -m '.' -e hex $SCRATCH_MNT
>
> Looking at the 2nd difference...
> It now picks up descend/and/ascend which contains the symlink
> of descend/and --> here/up.
> So that makes sense, it is following a symlink which it
> didn't before and finding a dir, "up" in the linked dir.
> Good.
>
> Looking at 1st difference...
> It is now showing up "lnk" which is a symlink: lnk --> dir
> So why is it showing this up
> and yet it is not showing descend/and (which is a link to here/up)?
> So yes we are following symlinks but are we supposed
> to just do the symlinks themselves as well?

With -h, the utilities operate on the symlinks rather than the files that the 
symlinks point to. The test case sets attributes on SCRATCH_MNT/lnk, but not 
on descend/and.

The -h and -L options together don't make much sense actually.

> BTW, do we not allow user EAs on symlinks? (I've forgotten)

No we don't --- that's explained on attr(5).

Thanks for looking at this!

Andreas
