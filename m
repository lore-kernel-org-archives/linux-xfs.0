Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55862 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbeEATQd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 15:16:33 -0400
Subject: Re: [PATCH 0/2] RFC: iomap-based swapfile activation
References: <20180501184807.123111-1-cyberax@amazon.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <10920cf1-b887-d13a-e028-685d83463bc9@sandeen.net>
Date: Tue, 1 May 2018 14:16:32 -0500
MIME-Version: 1.0
In-Reply-To: <20180501184807.123111-1-cyberax@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Aleksei Besogonov <cyberax@amazon.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com

On 5/1/18 1:48 PM, Aleksei Besogonov wrote:
> V2 of iomap-based swapfile support. 
> 
> Changes from V1: additional validations for file extents, based on
> a patch from Darrick Wong.

Aleksei - 

As Darrick pointed out earlier and as you acknowledge here, Darrick already
has a patchset for this in the works, started a couple days before your first
submission.

Generally we don't race to re-implement someone else's patch.  If you were unsure
whether Darrick planned to send a V2, it would have been good to ask.

Although I think Darrick does plan to resubmit his patches based on the feedback
provided so far, I'll go ahead & point out a couple things in your series for
future reference:

1) You need a Signed-off-by: line which essentially states that this is your
   own work, and that you may submit it for inclusion.
2) If you were building on someone else's patch with their blessing, you'd
   probably preceed your Signed-off-by: with theirs (but this is a bit
   unusual)
3) There's no reason to export iomap_apply for modules; no module uses it

I'll admit that I didn't look a lot more in depth.  ;)
 
At this point it's probably best to help this along by reviewing & testing
Darrick's (forthcoming?) V2 patchset.

It's not that we don't appreciate the help - it's great that you're motivated
to get this done - it's just that someone else already started the work, and
the normal process there is to review/comment on the first submitter's patches,
unless they have clearly abandoned the work.  This keeps the development
process and the mailing list more organized than if several people submit
competing patchsets in parallel.

Thanks,
-Eric
 
> Aleksei Besogonov (2):
>   fs: Add iomap_swap_activate
>   xfs: add support for iomap-based swapfile activation
> 
>  fs/iomap.c            | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_aops.c     |   8 ++++
>  include/linux/iomap.h |   5 +++
>  mm/swapfile.c         |   1 +
>  4 files changed, 120 insertions(+)
> 
