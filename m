Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 22:58:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B5wqhh000511
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 22:58:53 -0700
Date: Fri, 11 Jul 2008 01:59:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Give a transaction to xfs_attr_set_int
Message-ID: <20080711055956.GA23951@infradead.org>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1215675545-2707-1-git-send-email-xaiki@sgi.com> <1215675545-2707-2-git-send-email-xaiki@sgi.com> <1215675545-2707-3-git-send-email-xaiki@sgi.com> <1215675545-2707-4-git-send-email-xaiki@sgi.com> <1215675545-2707-5-git-send-email-xaiki@sgi.com> <878ww9asag.fsf@cxhome.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878ww9asag.fsf@cxhome.ath.cx>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 11, 2008 at 03:44:39PM +1000, Niv Sardi wrote:
> 
> Ok, so following are 2 patches that will, export xfs_attr_set_int_trans,
> and use it where we would use it in Parent Pointers (and V4ACL to what I
> understand).
> 
> This exposes the bug that I refered to before, and that I'm not sure I
> understand fully.

Actually plain Posix ACLs and selinux need it too to guarantee atomicy.
See xfs_init_security() and whatever _ACL_INHERIT expans to in
fs/xfs/linux-2.6/xfs_iops.c.  These might be good testcases to get
started with this work.
