Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 21:35:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4F4Z0Q3010542
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 21:35:01 -0700
Date: Thu, 15 May 2008 00:35:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: VFS case-insenstive dcache code (was Re: [PATCH 0/4] XFS:
	ASCII case-insensitivity support)
Message-ID: <20080515043546.GA22054@infradead.org>
References: <20080514075244.738514733@chook.melbourne.sgi.com> <20080514084344.GA4333@infradead.org> <op.ua57wpji3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ua57wpji3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Anton Altaparmakov <aia21@cam.ac.uk>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, May 15, 2008 at 11:03:51AM +1000, Barry Naujok wrote:
> On Wed, 14 May 2008 18:43:44 +1000, Christoph Hellwig <hch@infradead.org> 
> wrote:
>
>> All patches looks good to me, but please add a comment describing the
>> conditional d_reash in the create case.
>
> I'm separating the "return name" patch into two patches: one for the dcache
> code which Anton wrote and one with the XFS specific code.
>
> So, how does one apply the Signed-off line and copyright for the dcache
> code (below - possibly mangled)?

In this from it should be From: and Signed-off-by: you as you factored
it out of the ntfs code.  Just mention it's originally Anton's ntfs
code in the description.  Of course getting Anton to sign off on it
and prepare a patch to use it in ntfs would be even better.
