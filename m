Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 00:29:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T7SwDG017203
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 00:28:58 -0700
Date: Mon, 29 Sep 2008 03:30:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: compiler warning after applying btree patches
Message-ID: <20080929073033.GA30795@infradead.org>
References: <48E084D5.30205@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E084D5.30205@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 29, 2008 at 05:33:41PM +1000, Lachlan McIlroy wrote:
> Christoph,
>
> After applying the first round of btree patches we've now got this warning
> when building a non-debug xfs module.
>
>  CC      fs/xfs/xfs_btree.o
> fs/xfs/xfs_btree.c:191: warning: ?xfs_btree_check_ptr? defined but not used
>
> I took a quick look through your next round of btree patches but couldn't
> see a fix for it.  Did I miss something in the original patch set?  Is it
> fixed in a later patch?  If not here's a fix:

No, it's not used for now.  For some reason I missed the warning.

The patch looks good, can you also put it into xfs-cmds so the two
copies stay in sync?
