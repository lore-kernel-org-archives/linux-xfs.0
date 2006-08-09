Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Aug 2006 18:09:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7918GDW005323
	for <xfs@oss.sgi.com>; Tue, 8 Aug 2006 18:08:27 -0700
Date: Wed, 9 Aug 2006 11:07:18 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [PATCH 1/2] Add new spin_lock for i_flags of xfs_inode
Message-ID: <20060809110718.B2508736@wobbly.melbourne.sgi.com>
References: <20060808205855m-saito@mail.aom.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060808205855m-saito@mail.aom.tnes.nec.co.jp>; from m-saito@tnes.nec.co.jp on Tue, Aug 08, 2006 at 08:58:55PM +0900
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Masayuki Saito <m-saito@tnes.nec.co.jp>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Tue, Aug 08, 2006 at 08:58:55PM +0900, Masayuki Saito wrote:
> It is the problem that i_flags of xfs_inode has no consistent
> locking protection.
> 
> For the reason, I define a new spin_lock(i_flags_lock) for i_flags
> of xfs_inode.  And I add this spin_lock for appropriate places.

Thanks Masayuki.  I've queued these two patches in my test
kernels, and if Dave has no more comments, I will get this
merged soon (probably 2.6.19 material, as its not had much
exposure yet afaik).

cheers.

-- 
Nathan
