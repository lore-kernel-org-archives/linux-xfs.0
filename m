Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 00:29:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m717TP56015704
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 00:29:25 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79D85EEAF81
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 00:30:37 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id FgzSmxucNgrc8tx0 for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 00:30:37 -0700 (PDT)
Date: Fri, 1 Aug 2008 17:30:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
Message-ID: <20080801073033.GF6201@disturbed>
References: <1217553598.3860.16.camel@luna.unix.geek.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217553598.3860.16.camel@luna.unix.geek.nz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jasper Bryant-Greene <jasper@amiton.co.nz>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de

[cc'd xfs@oss.sgi.com]

On Fri, Aug 01, 2008 at 01:19:58PM +1200, Jasper Bryant-Greene wrote:
> I mount a bunch of XFS filesystems with "noikeep,attr2,noatime", and a
> couple also with "ro".
> 
> Sometimes I want to remount one of the "ro" ones "rw", to make changes.
> This doesn't work anymore in 2.6.27-rc1-next-20080730. The last kernel I
> tried which it worked in was 2.6.26 release.
> 
> luna ~ # mount -o remount,rw /usr
> mount: /usr not mounted already, or bad option
> 
> luna ~ # dmesg | tail -n 1
> [18702.291344] XFS: mount option "noikeep" not supported for remount
> 
> Is this intended behaviour?

Side effect of this commit:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=0327f9d799ebb96f67c80dd732b1fdb09527365e

Christoph?

FWIW, noikeep is the default, so you don't need to specify it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
