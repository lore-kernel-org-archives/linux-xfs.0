Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Aug 2006 22:47:48 -0700 (PDT)
Received: from smtp.osdl.org (smtp.osdl.org [65.172.181.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7O5lWDW025919
	for <xfs@oss.sgi.com>; Wed, 23 Aug 2006 22:47:32 -0700
Date: Wed, 23 Aug 2006 21:38:17 -0700
From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/2] Add new spin_lock for i_flags of xfs_inode [try #2]
Message-Id: <20060823213817.16cdfe8a.akpm@osdl.org>
In-Reply-To: <20060823201251m-saito@mail.aom.tnes.nec.co.jp>
References: <20060823201251m-saito@mail.aom.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Masayuki Saito <m-saito@tnes.nec.co.jp>
Cc: Nathan Scott <nathans@sgi.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Wed, 23 Aug 2006 20:12:51 +0900
Masayuki Saito <m-saito@tnes.nec.co.jp> wrote:

> It is the problem that i_flags of xfs_inode has no consistent
> locking protection.
> 
> For the reason, I define a new spin_lock(i_flags_lock) for i_flags
> of xfs_inode.  And I add this spin_lock for appropriate places.

You could simply use inode.i_lock for this.  i_lock is a general-purpose
per-inode lock.  Its mandate is "use it for whatever you like, but it must
always be `innermost'"
