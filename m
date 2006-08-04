Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 09:46:31 -0700 (PDT)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k74Gk5DW030249
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 09:46:16 -0700
Message-ID: <44D379A6.9040200@sgi.com>
Date: Fri, 04 Aug 2006 11:45:26 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM> <44D36985.1090006@thebarn.com> <20060804155850.GA3338@kickball-mn.Central.Sun.COM>
In-Reply-To: <20060804155850.GA3338@kickball-mn.Central.Sun.COM>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dean Roehrich <dean.roehrich@sun.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

Dean Roehrich wrote:
> On Fri, Aug 04, 2006 at 10:36:37AM -0500, Russell Cattelan wrote:
> 
> 
>>I appears as if the Hsm routines are only used if the -a flag is given 
>>to xfsdump.
>>(dump DMF dualstate files as offline)
> 
> 
> If use of -a causes xfsdump to fail then that may be sufficient.

Then what? Each user (admittedly, this is a small number) has to rebuild
xfsdump locally, and then do so every time their package manager grabs
an updated xfsdump? That sounds like more of an inconvenience than
installing a couple packages on a build machine, especially considering
the xfsdump and libdm source are bundled together with all the other xfs
user space tools. (And isn't there logic in the xfs makefiles to use
the locally built libraries if the required libraries aren't installed?)

> 
> Also, use of -D should cause xfsrestore to fail.

That's not necessary - there are no libdm calls in xfsrestore,
regardless of whether or not the image being restore came from
xfsdump -a.

There are several solutions here:

1) Russell's proposal -- noop hsm routines if libdm doesn't exist on
build machine.

2) Require libdm on build machine, change xfsdump to dlopen libdm so
that libdm is optional at run-time.

3) Add make_handle() routine to libhandle. xfsdump's only dependencies
from libdm are dm_make_handle() and dm_handle_to_fsid() (the latter
of which is in libhandle as handle_to_fshandle(), I think).

4) Noop the existing hsm routines, and allow xfsdump to dlopen a
specified .so to override the default (noop) behavior. DMF could
then ship a .so implementing those functions.

Bill
