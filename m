Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 22:37:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3T5bGW2020722
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 22:37:19 -0700
Date: Tue, 29 Apr 2008 01:37:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: s/i_flags_lock/i_inner_lock/g
Message-ID: <20080429053757.GA30708@infradead.org>
References: <4816AEEB.8090907@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4816AEEB.8090907@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 29, 2008 at 03:15:23PM +1000, Timothy Shimmin wrote:
> Hi there,
>
> As part of future plans to cache incore versions of acls
> off the inode, we want to protect its modification by a spin lock.
> Dave suggested that we use the i_flags_lock but rename it to
> reflect its more general purpose on other fields, such as "i_inner_lock".
> This patch is then basically s/i_flags_lock/i_inner_lock/g.

Not too happpy about that, as I'd rather kill this lock in it's current
form and use atomic bitops on the flags.  I'd rather use i_lock in the
Linux inode for the ACLs.
