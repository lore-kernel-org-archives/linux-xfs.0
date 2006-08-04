Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 10:09:46 -0700 (PDT)
Received: from brmea-mail-4.sun.com (brmea-mail-4.Sun.COM [192.18.98.36])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k74H9ODW004772
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 10:09:25 -0700
Received: from centralmail4brm.central.Sun.COM ([129.147.62.198])
	by brmea-mail-4.sun.com (8.13.6+Sun/8.12.9) with ESMTP id k74H8uAE017554
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 11:08:56 -0600 (MDT)
Received: from kickball-mn.Central.Sun.COM (kickball-mn.Central.Sun.COM [10.1.170.217])
	by centralmail4brm.central.Sun.COM (8.13.6+Sun/8.13.6/ENSMAIL,v2.2) with ESMTP id k74H8uQw010738
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 11:08:56 -0600 (MDT)
Date: Fri, 4 Aug 2006 12:08:56 -0500
From: Dean Roehrich <dean.roehrich@sun.com>
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
Message-ID: <20060804170856.GA3652@kickball-mn.Central.Sun.COM>
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM> <44D36985.1090006@thebarn.com> <20060804155850.GA3338@kickball-mn.Central.Sun.COM> <44D379A6.9040200@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44D379A6.9040200@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bill Kendall <wkendall@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

On Fri, Aug 04, 2006 at 11:45:26AM -0500, Bill Kendall wrote:

> 3) Add make_handle() routine to libhandle. xfsdump's only dependencies
> from libdm are dm_make_handle() and dm_handle_to_fsid() (the latter
> of which is in libhandle as handle_to_fshandle(), I think).

If libhandle can satisfy everything then that would be a suitable solution.

If Russell wants this changed bad enough then I'm sure he'll get around to
submitting another patch for it someday...

:)

Dean
