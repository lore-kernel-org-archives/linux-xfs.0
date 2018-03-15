Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:53275 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751466AbeCOWTm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 18:19:42 -0400
Date: Fri, 16 Mar 2018 09:19:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
Message-ID: <20180315221939.GJ18129@dastard>
References: <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net>
 <20180305223148.GG18129@dastard>
 <421d1afd-5af1-aef9-e6bb-3addcdeeff3f@sandeen.net>
 <CACj3i73y_ZWvgdv3aKTKaKGuo+6uhcfy1465T3CD2uQDLE3=xQ@mail.gmail.com>
 <20180306213915.GJ18129@dastard>
 <CACj3i71SHP90DOAhpS3kWyY_6gnx9OzTqgHy7=uxAZH0cfUKMw@mail.gmail.com>
 <e7a132d5-33de-736f-840a-8de45910846c@sandeen.net>
 <CACj3i73Zb04iHUSS7LNnvegGMe1xaTXwxBjCPnNQg9JmEwQQtQ@mail.gmail.com>
 <c1da5bba-3abb-7b14-d5e9-2d326af542bc@sandeen.net>
 <CACj3i711KdeV8ak5f67FLFzKGZFvRHQSO2VjA0Cxv2V0+hWrsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i711KdeV8ak5f67FLFzKGZFvRHQSO2VjA0Cxv2V0+hWrsA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 15, 2018 at 12:16:44PM +0100, Jan Tulak wrote:
> On Wed, Mar 14, 2018 at 4:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > On 3/14/18 9:30 AM, Jan Tulak wrote:
> >> On Fri, Mar 9, 2018 at 12:28 AM, Eric Sandeen <sandeen@sandeen.net>
> >> wrote:
> >>>
> >>> If it's critical to report whether errors were fixed, it would be
> >>> trivial to add a new option to xfs_repair which causes it to test
> >>> fs_is_dirty for runs without "-n", and exit with a different
> >>> value.
> >>
> >> I have toyed with it a bit and this seems to be the best option. A
> >> flag that changes the exit code on a successful run. Is exit code 3
> >> ok? According to man page, only 1 and 2 are currently used and the
> >> "everything is ok now, but an issue was there" should not be mixed
> >> with the existing ones. I also thought about a flag that would
> >> change all exit codes to fsck ones, but that seems too complicated
> >> and completely unnecessary.
> >
> > Hm, I guess we'll have to.
> 
> We can either map xfs_repair to fsck in the fsck.xfs script, or change
> xfs_repair to use the fsck exit codes. I'm for the first variant (just
> add a one new exit code for xfs_repair and remap it for fsck codes in
> the script) rather than complicate xfs_repair with two sets of exit
> codes.

Agreed, any fsck specific exit code mapping should be in the fsck
script. Let's try to keep xfs_repair isolated from all the fsck
interface bogosities....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
