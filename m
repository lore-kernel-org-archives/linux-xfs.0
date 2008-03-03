Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 22:32:40 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m236WG38019256
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 22:32:18 -0800
Received: from nf-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 867AEDAEFF3
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2008 22:32:44 -0800 (PST)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.184]) by cuda.sgi.com with ESMTP id JEeYzmeeCHWsRvfn for <xfs@oss.sgi.com>; Sun, 02 Mar 2008 22:32:44 -0800 (PST)
Received: by nf-out-0910.google.com with SMTP id e27so3486885nfd.42
        for <xfs@oss.sgi.com>; Sun, 02 Mar 2008 22:32:43 -0800 (PST)
Date: Mon, 3 Mar 2008 07:32:37 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: XFS_WANT_CORRUPTED_GOTO report
Message-ID: <20080303063237.GB21775@teal.hq.k1024.org>
References: <20080302161507.GC12740@teal.hq.k1024.org> <47CB587E.8020602@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CB587E.8020602@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 03, 2008 at 12:46:38PM +1100, Lachlan McIlroy wrote:
>> After mount, the file in question is heavily fragmented (around 1600
>> segments). I'm not sure if this file caused the corruption, but I'm
>> almost certain, as no other traffic should have been at that time.
> The file being written to (that caused the panic) has unwritten extents
> and we were trying to convert the extents from unwritten to real after
> writing to them.  These XFS_WANT_CORRUPTED_GOTO bugs often occur with
> extent tree corruption so this is not surprising.  Could we get output
> from xfs_bmap -v on this file?
http://www.k1024.org/iusty/plains.bmap

>> I also have a metadump (run before recovery) and a full copy of the
>> filesystem if it's useful.
> Can we get a copy of that metadump?  I don't hold high hopes for it
> though - the filesystem can be inconsistent until the log is replayed
> but after the log was replayed the problem was gone.  I don't suppose
> you have a copy of the log?

The metadump is here http://www.k1024.org/iusty/plains.metadump.bz2
(~80MB), done with default options. Warning, the server is somewhat slow
:)

The copy of the log, done with xfs_logprint -t, is here
http://www.k1024.org/iusty/plains.logprint

The inode of the file in question is 96424401.

Let me know if I can give more information.

thanks,
iustin
