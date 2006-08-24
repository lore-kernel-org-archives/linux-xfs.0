Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 03:08:56 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7OA8YDW019876
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 03:08:38 -0700
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.7/8.13.4) with ESMTP id k7OA80UD025255
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 19:08:02 +0900 (JST)
Subject: Re: [PATCH 1/2] Add new spin_lock for i_flags of xfs_inode [try #2]
In-reply-to: <20060823213817.16cdfe8a.akpm@osdl.org>
Message-Id: <20060824190519m-saito@mail.aom.tnes.nec.co.jp>
References: <20060823213817.16cdfe8a.akpm@osdl.org>
Mime-Version: 1.0
From: Masayuki Saito <m-saito@tnes.nec.co.jp>
Date: Thu, 24 Aug 2006 19:05:19 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: Nathan Scott <nathans@sgi.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Thank you for your comment.

Andrew Morton <akpm@osdl.org> wrote:
>On Wed, 23 Aug 2006 20:12:51 +0900
>Masayuki Saito <m-saito@tnes.nec.co.jp> wrote:
>
>> It is the problem that i_flags of xfs_inode has no consistent
>> locking protection.
>> 
>> For the reason, I define a new spin_lock(i_flags_lock) for i_flags
>> of xfs_inode.  And I add this spin_lock for appropriate places.
>
>You could simply use inode.i_lock for this.  i_lock is a general-purpose
>per-inode lock.  Its mandate is "use it for whatever you like, but it must
>always be `innermost'"
>

I think that inode.i_lock isn't appropriate for this case.
Because there is the situation that no inode is attached to an xfs_inode.


Masayuki
