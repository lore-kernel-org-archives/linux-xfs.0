Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8ANTpxf249358 for <xfs@oss.sgi.com>; Thu, 10 Sep 2009 18:29:51 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F020644124D
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2009 16:31:02 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.212.112.196]) by
	cuda.sgi.com with ESMTP id BYGmBviBejdXlZrp for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2009 16:31:02 -0700 (PDT)
Date: Thu, 10 Sep 2009 19:31:01 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] xfs_df: a df(1)-like command to list per-ag block and
	inode usage
Message-ID: <20090910233101.GE2343@josefsipek.net>
References: <1252622786-7653-1-git-send-email-jeffpc@josefsipek.net>
	<20090910232139.GA27678@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090910232139.GA27678@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Sep 10, 2009 at 07:21:39PM -0400, Christoph Hellwig wrote:
> On Thu, Sep 10, 2009 at 06:46:26PM -0400, Josef 'Jeff' Sipek wrote:
> > +++ b/db/xfs_df.sh
> > @@ -0,0 +1,144 @@
> > +#!/bin/sh
> > +#
> > +# Copyright (c) 2007-2009 Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> > +#
> > +# This program is free software; you can redistribute it and/or modify it
> > +# under the terms of the GNU General Public License version 2 as published
> > +# by the Free Software Foundation.
> > +#
> > +
> > +status=0
> > +DB_OPTS="-p xfs_df -r"
> > +USAGE="Usage: xfs_df [-i] <device>|<mount>"
> > +
> > +while test $# -gt 1; do
> > +	case "$1" in
> > +		-i)
> > +			print_inodes=t
> > +			;;
> > +		*)
> > +			break
> > +			;;
> > +	esac
> > +	shift
> > +done
> > +
> > +dev="$1"
> 
> Can you use the same boilerplate code as the other wrappers for
> xfs_db parsing the options and showing the usage to make things more
> consistant?

You mean using getopts? Yeah, I was going to, but decided against it since
there's only one option -i, and the other arg is a device name. I'll fix it
up.

> Also any new tools in xfsprogs should really come with a manpage.

Oh, right...documentation :)

> > +case "$print_inodes" in
> > +	t)
> > +		echo "AG     Inodes    IUsed    IFree    Use%"
> > +
> > +		tot_ino=0
> > +		tot_use=0
> > +		tot_fre=0
> > +
> > +		for ag in `seq 0 $maxagno`; do
> > +			count=`db_wrapper -c "agi $ag" -c "p count"`
> > +			freecount=`db_wrapper -c "agi $ag" -c "p freecount"`
> > +
> > +			used=`expr $count - $freecount`
> > +
> > +			if [ $count -gt 0 ]; then
> > +				pused=`expr $used \* 100`
> > +				pused=`expr $pused / $count`
> > +			else
> > +				pused=0
> > +			fi
> 
> Wouldn't it be much easier to implement all this in C as a new xfs_db
> subcommand?

Ideally, db could do some basic expressions, e.g.,

xfs_db> agi 0
xfs_db> print (count-freecount)/count
expr = 0.12345

I tried looking at db code to make it have a quiet mode (so a print will not
display the 'field = ' part), but I got a bit lost. It's quite possible that
making a df command in db would be simple, I'd have to look at the code
more (it'd certainly run faster).

Josef 'Jeff' Sipek.

-- 
What is the difference between Mechanical Engineers and Civil Engineers?
Mechanical Engineers build weapons, Civil Engineers build targets.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
