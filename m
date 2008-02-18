Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 15:49:06 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1INmwgO006138
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 15:49:02 -0800
Date: Mon, 18 Feb 2008 15:49:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc3
In-Reply-To: <20080218062736.3322E58C4C11@chook.melbourne.sgi.com>
Message-ID: <alpine.LFD.1.00.0802181547560.7833@woody.linux-foundation.org>
References: <20080218062736.3322E58C4C11@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org



On Mon, 18 Feb 2008, Lachlan McIlroy wrote:
> 
> This will update the following files:
> 
>  fs/xfs/Kbuild             |    6 --
>  fs/xfs/Makefile           |  118 ++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/Makefile-linux-2.6 |  117 --------------------------------------------
>  3 files changed, 117 insertions(+), 124 deletions(-)
>  delete mode 100644 fs/xfs/Kbuild

Hmm. This didn't actually remove the old Makefile-linux-2.6 file, so it 
exists as a zero-length file still.

Was that intentional?

		Linus
