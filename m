Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 16:11:25 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4HNBIKc009269
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 16:11:20 -0700
Received: from smtp1.betherenow.co.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 5CC231B95D94
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 16:12:06 -0700 (PDT)
Received: from smtp1.betherenow.co.uk (smtp1.betherenow.co.uk [87.194.0.68]) by cuda.sgi.com with SMTP id ngQzSXDaY5o25fFr for <xfs@oss.sgi.com>; Sat, 17 May 2008 16:12:06 -0700 (PDT)
From: Alistair John Strachan <alistair@devzero.co.uk>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
Date: Sun, 18 May 2008 00:12:04 +0100
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <200805172109.59244.alistair@devzero.co.uk> <alpine.LFD.1.10.0805171411250.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805171411250.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805180012.05011.alistair@devzero.co.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, xfs@oss.sgi.com, Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org

On Saturday 17 May 2008 22:17:37 Linus Torvalds wrote:
[snip]
> Jens, there's been a *lot* of breakage in the block layer. The DMA bounce
> buffer crap, and this looks like the atomic bit setting was broken too.
>
> Alistair, does the problem go away if you revert both the patch from Neil
> and the original patch that caused the need for that patch to begin with
> (ie commit 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e "block: make queue
> flags non-atomic").

I did a git revert on this and manually fixed up the conflicts; I also 
reverted Neil's patch.

Unfortunately (though the WARNING is still gone) it doesn't fix the hang.

> Jens, Nick, I think that whole series just needs to be undone.
>
> 		Linus

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
