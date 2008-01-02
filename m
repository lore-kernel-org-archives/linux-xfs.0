Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jan 2008 09:47:57 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m02HlnEc030673
	for <xfs@oss.sgi.com>; Wed, 2 Jan 2008 09:47:52 -0800
Received: from smtp117.sbc.mail.sp1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 93B0B1226F2E
	for <xfs@oss.sgi.com>; Wed,  2 Jan 2008 09:48:05 -0800 (PST)
Received: from smtp117.sbc.mail.sp1.yahoo.com (smtp117.sbc.mail.sp1.yahoo.com [69.147.64.90]) by cuda.sgi.com with SMTP id XU2xxIODbJ2xMKEC for <xfs@oss.sgi.com>; Wed, 02 Jan 2008 09:48:05 -0800 (PST)
Date: Wed, 2 Jan 2008 09:48:05 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: How to damage a XFS-Filesystem?
Message-ID: <20080102174805.GA32592@puku.stupidest.org>
References: <477B8EAB.8000703@welcomes-you.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477B8EAB.8000703@welcomes-you.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Carsten Aulbert <carsten@welcomes-you.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 02, 2008 at 02:16:27PM +0100, Carsten Aulbert wrote:

> A file server with a 10 TB large xfs file system running on a RAID6
> SATA array, the server has 16 GB of memory. I want to test how long
> it would take to run xfs_repair on it and if the amount of memory is
> enough for that.

It depends on how fast the IO is and also how many files there are.

If you have a small number of really large files it's fairly fast, if
you have a large number of really small files (ie. email maildir) then
it tends to be much slower.

> (2) Damage the file sytem
> (3) Run xfs_repair

xfs_repair will run without having to damage the filesystem (though
if/when damaged it will probably be a little slower).

> Otherwise: How can a damage a xfs file system to make the job harder
> for xfs_repair.

Google for fsfuzzer.

> I guess a simple dd if=/dev/random of=/dev/sdb1 with some offsets
> will not be very effective, right?

If it misses the metadata, xfs_repair won't even notice.  If you whack
large chunks of metadata you might see considerable data loss.
