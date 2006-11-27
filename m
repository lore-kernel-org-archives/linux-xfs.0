Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Nov 2006 22:35:55 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAR6ZkaG001666
	for <linux-xfs@oss.sgi.com>; Sun, 26 Nov 2006 22:35:48 -0800
Date: Mon, 27 Nov 2006 05:58:59 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 956783 - xfs_dm_getall_dmattr() doesn't check if the user buffer is at valid address
Message-ID: <20061127055859.GC1374@infradead.org>
References: <45629AD8.8000800@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45629AD8.8000800@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

On Tue, Nov 21, 2006 at 05:21:12PM +1100, Vlad Apostolov wrote:
> No EFAULT error when dm_getall_dmattr() called with an invalid user 
> buffer address.

This fix is broken.  access_ok is not enough to verify the buffer,
it just does very few static check (basically the address space limit)

You need to use copy_{from,to}_user to access user pointers.  I had
an untested patch to fix this at my good old SGI time, but Dean wanted
to review and test it a lot more.  I'll try to dig up that patch if you care.
