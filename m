Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 08:59:40 -0700 (PDT)
Received: from brmea-mail-1.sun.com (brmea-mail-1.Sun.COM [192.18.98.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k74FxGDW015825
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 08:59:17 -0700
Received: from centralmail3brm.Central.Sun.COM ([129.147.62.199])
	by brmea-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id k74FwonQ029503
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 09:58:50 -0600 (MDT)
Received: from kickball-mn.Central.Sun.COM (kickball-mn.Central.Sun.COM [10.1.170.217])
	by centralmail3brm.Central.Sun.COM (8.13.6+Sun/8.13.6/ENSMAIL,v2.2) with ESMTP id k74FtHP9002832
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 09:55:17 -0600 (MDT)
Date: Fri, 4 Aug 2006 10:58:50 -0500
From: Dean Roehrich <dean.roehrich@sun.com>
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
Message-ID: <20060804155850.GA3338@kickball-mn.Central.Sun.COM>
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM> <44D36985.1090006@thebarn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44D36985.1090006@thebarn.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

On Fri, Aug 04, 2006 at 10:36:37AM -0500, Russell Cattelan wrote:

> I appears as if the Hsm routines are only used if the -a flag is given 
> to xfsdump.
> (dump DMF dualstate files as offline)

If use of -a causes xfsdump to fail then that may be sufficient.

Also, use of -D should cause xfsrestore to fail.

That might cover my concerns.


Dean
