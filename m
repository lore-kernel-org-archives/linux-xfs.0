Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 13:46:05 -0700 (PDT)
Received: from smtp120.sbc.mail.sp1.yahoo.com (smtp120.sbc.mail.sp1.yahoo.com [69.147.64.93])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6HKk0bm025453
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 13:46:01 -0700
Date: Tue, 17 Jul 2007 13:19:21 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Allocating inodes from a single block
Message-ID: <20070717201921.GA26309@tuatara.stupidest.org>
References: <469D0666.6040908@agami.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469D0666.6040908@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 17, 2007 at 11:11:50AM -0700, Michael Nishimoto wrote:

> Filesystem free space becomes fragmented over time.  It's possible
> for total free space to be a decent size and still not have a chunk
> large enough to allocate new inodes.

by default there is a restriction that indoes shouldn't consume more
that 25% of the total space

see the mkfs.xfs man-page for details, search for 'maxpct'

for existing filesystems you can use xfs_db to rewrite this value
