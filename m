Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 10 Nov 2007 13:36:56 -0800 (PST)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAALaoLv005890
	for <linux-xfs@oss.sgi.com>; Sat, 10 Nov 2007 13:36:51 -0800
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: acl and attr: Fix path walking code
Date: Sat, 10 Nov 2007 22:36:52 +0100
References: <200710281858.24428.agruen@suse.de> <47340ECC.4000205@sgi.com>
In-Reply-To: <47340ECC.4000205@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711102236.53298.agruen@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: linux-xfs@oss.sgi.com, Gerald Bringhurst <gbringhurst@novell.com>, Brandon Philips <bphilips@suse.de>

On Friday 09 November 2007 08:39:56 Timothy Shimmin wrote:
> You mention -L/-P is like chown.
> However, -P for getattr isn't about not walking symlinks
> to directories,
> it's about skipping symlinks altogether, right?

Hmm, -L and -P define which files and directories are visited, and -h defines 
whether we are looking at symlinks or the files they point to. The two 
concepts are orthogonal. -P is not about skipping symlinks, only about not 
recursing into them.

You can do this (as root), for example:

	$ ln -s dead link
	$ setfattr -h -n trusted.name -v value link
	$ getfattr -h -m- -d -P link
	# file: link
	trusted.name="value"

With "getfattr -R -P -h" you get a physical dump of all attributes ("a real, 
complete dump"), while with "getfattr -R -L" you get a logical dump that 
treats all symlinks as the files they point to. I somewhat doubt that -L 
with -h has real value.

Thanks,
Andreas
