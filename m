Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:32835 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752662AbeDEWtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 18:49:16 -0400
Date: Fri, 6 Apr 2018 08:49:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: factor out quota time limit initialization
Message-ID: <20180405224913.GH23861@dastard>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <2d87ba58-f713-6326-8683-29185155ee58@sandeen.net>
 <20180405071533.GE17256@infradead.org>
 <0ca4f6ed-00db-ba87-c0ea-43c6f15068fa@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ca4f6ed-00db-ba87-c0ea-43c6f15068fa@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Apr 05, 2018 at 07:36:58AM -0500, Eric Sandeen wrote:
> 
> 
> On 4/5/18 2:15 AM, Christoph Hellwig wrote:
> > On Wed, Apr 04, 2018 at 02:10:20PM -0500, Eric Sandeen wrote:
> >> Factor out the time limit initialization from
> >> xfs_qm_init_quotainfo so that we can delay it until
> >> after quotacheck - it requires reading the default disk
> >> quotas, which may need repair.
> >>
> >> No functional changes in this patch.
> > 
> > You have 75 characters per line for your changelog, use them!
> 
> Sorry, bad habit.  I never remember exactly how many and sometimes I just
> keep shortening...

If you use vim, set this up so you get automatic setting of the text
width (with highlighting) depending on the editor context you are
running:

" set default text width and shortcut to set custom widths
set     textwidth=80
map	#tw :set textwidth=<C-R>=col(".")<C-M>

" set the textwidth to 68 characters for commit messages
au	BufNewFile,BufRead guilt.msg.*,.gitsendemail.*,git.*,*/.git/* set tw=68

" set the textwidth to 68 characters for replies (email&usenet)
au	BufNewFile,BufRead .letter,mutt*,nn.*,snd.* set tw=68

" highlight textwidth
set	cc=+1


-Dave.
-- 
Dave Chinner
david@fromorbit.com
