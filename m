Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 11:09:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k74I90DW017761
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 11:09:03 -0700
Message-ID: <44D38D34.1010503@thebarn.com>
Date: Fri, 04 Aug 2006 13:08:52 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM> <44D36985.1090006@thebarn.com> <20060804155850.GA3338@kickball-mn.Central.Sun.COM> <44D379A6.9040200@sgi.com>
In-Reply-To: <44D379A6.9040200@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bill Kendall <wkendall@sgi.com>
Cc: Dean Roehrich <dean.roehrich@sun.com>, Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

Bill Kendall wrote:

[snip]
>
> 3) Add make_handle() routine to libhandle. xfsdump's only dependencies
> from libdm are dm_make_handle() and dm_handle_to_fsid() (the latter
> of which is in libhandle as handle_to_fshandle(), I think).
Hmm looking at dm_handle_to_fsid: it calls parse_handle which appears
be quite dmapi specific and would require much of dm_handle.c?

I suppose we could move dm_handle.c into  libhandle ?
But that seems to be going in the wrong direction in terms of
correct code compartmentalization.

Since dmapi is only available  on Suse , Propack and somebody doing
a custom kernel, I'm not convinced that xfs dump/restore should
support dmapi no matter what.
The only time a problem might arise is somebody not using the shipped 
version
of xfs dump/restore on a Suse or propack system, in which case they
should either know what they are doing or get what they deserve.

>
> 4) Noop the existing hsm routines, and allow xfsdump to dlopen a
> specified .so to override the default (noop) behavior. DMF could
> then ship a .so implementing those functions.
>
> Bill
>
