Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 07:37:23 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kATFbGaG001344
	for <linux-xfs@oss.sgi.com>; Wed, 29 Nov 2006 07:37:17 -0800
Date: Wed, 29 Nov 2006 15:11:46 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 956783 - xfs_dm_getall_dmattr() doesn't check if the user buffer is at valid address
Message-ID: <20061129151146.GA4746@infradead.org>
References: <45629AD8.8000800@sgi.com> <20061127055859.GC1374@infradead.org> <456B7C1A.90209@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <456B7C1A.90209@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

On Tue, Nov 28, 2006 at 11:00:26AM +1100, Vlad Apostolov wrote:
> The fix is actually fine as it gives an early indication (even not complete)
> that the user pointer is bad. There is another problem you are pointing at 
> and it is the userspace pointer dereference later on without using 
> copy_to_user(). If you have any patch fixing this problem it would be great.

Unfortunately I haven't found my patch, I'm sorry.  I have on the other
hand found various old trivial XFS patches of mine that I'll submit.
