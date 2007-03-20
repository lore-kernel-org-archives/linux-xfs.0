Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Mar 2007 20:26:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2K3Q56p031541
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 20:26:09 -0700
Date: Tue, 20 Mar 2007 14:26:00 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: But wait, theres more... [Fwd: Bug#415123: -R option can't append to a plain file]
Message-ID: <17CB3A8C59A80064581C0A32@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <1174252993.5051.233.camel@edge>
References: <1174252993.5051.233.camel@edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com, wkendall@sgi.com
Cc: xfs@oss.sgi.com

Hi,

I'll leave this to Bill. Just a couple of comments.

I don't know if you can call it a "bug", more of a restriction.
There is a layer provided for the I/O using drive_*.c -
i.e drive_scsitape.c, drive_minrmt.c, drive_simple.c (which show up
as a "drive strategy" on output).
As part of the ds_instantiate() interface one typically sets up the d_capabilities
that this drive strategy supports and for files (drive_simple), DRIVE_CAP_APPEND is
not given. What the ramifications for drive_simple (file strategy) are,
I wouldn't know without looking at the code and playing with it.
But I'd call it an RFE :)

--Tim

--On 19 March 2007 8:23:13 AM +1100 Nathan Scott <nscott@aconex.com> wrote:

> And a free set of steak knives if you fix this bug...  ;-)
>
> -------- Forwarded Message --------
> From: Peter Chubb <peterc@gelato.unsw.edu.au>
> Reply-To: Peter Chubb <peterc@gelato.unsw.edu.au>,
> 415123@bugs.debian.org
> To: submit@bugs.debian.org
> Subject: Bug#415123: -R option can't append to a plain file
> Date: Fri, 16 Mar 2007 19:54:37 +1100
>
> Package: xfsdump
> Version: 2.2.38-1
>
> If I use xfsdump to dump to a plain file, interrupt it, then restart
> with the -R option, xfsdump complains:
>
> xfsdump: ERROR: media contains valid xfsdump but does not support append
>
> which is misleading: of *course* you can append to a regular file if
> there's space on the filesystem.
>
> --
> Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
> http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
>
> --
> Nathan
>
