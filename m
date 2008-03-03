Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 17:34:26 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m231Y68A004401
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 17:34:09 -0800
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46EF9F02C70
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2008 17:34:34 -0800 (PST)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id r1IJ0a6tCkeMoR5a for <xfs@oss.sgi.com>; Sun, 02 Mar 2008 17:34:34 -0800 (PST)
Date: Sun, 2 Mar 2008 20:15:59 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
Message-ID: <20080303011559.GB13879@josefsipek.net>
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com> <1204166101.13569.102.camel@edge.scott.net.au> <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net> <47C89303.7070902@thebarn.com> <1204500895.10190.3.camel@edge.scott.net.au> <47CB434B.4040005@sgi.com> <47CB4696.1030304@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CB4696.1030304@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, nscott@aconex.com, Russell Cattelan <cattelan@thebarn.com>, Eric Sandeen <sandeen@sandeen.net>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Mar 03, 2008 at 11:30:14AM +1100, Mark Goodwin wrote:
...
> Maybe I'm missing something, but if we export all the feature bits,
> both new and old, then (a) an old mkfs will continue to ignore them,
> and (b) future versions of mkfs will have all the information needed,
> but will need t be smart about how that information is used.

IMHO:

1) mkfs should make a filesystem, the defaults should be conservative (say
   using features that have been around >1 year)

2) xfs should export supported features to userspace

3) if you want to make sure that the fs you create will be mountable with
   your current kernel, write a small shell script or something along those
   lines that reads the features from some kernel interface, and based on
   those passes the right options to mkfs

4) if you just use mkfs and it creates a fs that's incompatible with your
   current kernel, the mount will fail - as it does today, but perhaps a
   less cryptic error message would be in order

Since installers are just gigantic wrappers around basic commands like mkfs,
#3 gets nicely covered.

Josef 'Jeff' Sipek.

-- 
The reasonable man adapts himself to the world; the unreasonable one
persists in trying to adapt the world to himself. Therefore all progress
depends on the unreasonable man.
		- George Bernard Shaw
