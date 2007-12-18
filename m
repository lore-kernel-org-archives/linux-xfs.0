Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 05:46:52 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBIDkhR5002469
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 05:46:47 -0800
Date: Wed, 19 Dec 2007 00:46:44 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs mknod regression
Message-ID: <20071218134644.GO4396912@sgi.com>
References: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bret Towe <magnade@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Dec 17, 2007 at 08:48:40PM -0800, Bret Towe wrote:
> I hit a bug in 2.6.24-rc looks to be in 2.6.23 also so not sure how
> long it's been there
> with an xfs filesystem pbuilder has an issue using device files it
> makes for chroot
> the mknod command looks to work fine the file is created
> however when attempting to use one of the created files you see
> something like the below
> 
> ghoststar dev # echo "hi" > null
> bash: null: No such device or address
> ghoststar dev # ls -l null
> crw-rw-rw- 1 root root 1, 3 2007-12-17 20:34 null
> ghoststar dev # ls -l /dev/null
> crw-rw-rw- 1 root root 1, 3 2007-10-05 17:29 /dev/null
> ghoststar dev # echo "hi" > /dev/null
> ghoststar dev #

Ok. Works on 2.6.22. doesn't work on latest xfsdev. I'll
look into it.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
