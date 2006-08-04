Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Aug 2006 07:12:13 -0700 (PDT)
Received: from brmea-mail-2.sun.com (brmea-mail-2.Sun.COM [192.18.98.43])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k74EAgDW029242
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 07:10:42 -0700
Received: from centralmail3brm.Central.Sun.COM ([129.147.62.199])
	by brmea-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id k74EADoI018171
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 08:10:13 -0600 (MDT)
Received: from kickball-mn.Central.Sun.COM (kickball-mn.Central.Sun.COM [10.1.170.217])
	by centralmail3brm.Central.Sun.COM (8.13.6+Sun/8.13.6/ENSMAIL,v2.2) with ESMTP id k74E6e72018470
	for <xfs@oss.sgi.com>; Fri, 4 Aug 2006 08:06:40 -0600 (MDT)
Date: Fri, 4 Aug 2006 09:10:12 -0500
From: Dean Roehrich <dean.roehrich@sun.com>
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
Message-ID: <20060804141012.GA26@kickball-mn.Central.Sun.COM>
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44D2CA85.3040208@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

On Fri, Aug 04, 2006 at 02:18:13PM +1000, Vlad Apostolov wrote:
> Hi Russel,
> 
> I don't understand in details the build changes but they seam to be fine.

Vlad, why do they seem fine?

> In summary if the build system can find the DMAPI lib installed it will
> use hsmapi_noop.c otherwise hsmapi.c.
> The return code of HsmInitFileContext() stub probably should be non zero.
> 
> It is looking good.

So this is determined at build time...so when you're using a version of
xfsdump/xfsrestore how do you know you're _not_ using one that is DMAPI-aware
_before_ you get into trouble with an invalid dump?

Assuming that issue is addressed, here's another:  The libdm is a shared
object, so why not take advantage of that and load it with dlopen?  Then the
issue is determined at runtime rather than build time.  This is easy, and even
DMF does it this way.

Dean
