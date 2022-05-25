Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9D1C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 08:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiEYIiW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 04:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234541AbiEYIiV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 04:38:21 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B28CA21E0B
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 01:38:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DDABF534622;
        Wed, 25 May 2022 18:38:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntmX0-00GABl-Re; Wed, 25 May 2022 18:38:14 +1000
Date:   Wed, 25 May 2022 18:38:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Allison Henderson <allison.henderson@oracle.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V14 00/16] Bail out if transaction can cause extent count
 to overflow
Message-ID: <20220525083814.GH1098723@dread.disaster.area>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
 <CAOQ4uxi8eNVCjqeSeVFRgrYC00gjdbuPyV4B2WPN0DmqjrfyFg@mail.gmail.com>
 <20220523224352.GT1098723@dread.disaster.area>
 <CAOQ4uxgJFVOs-p8kX+4n=TSCK-KbwjgDPaM4t81-x8gHO77FnQ@mail.gmail.com>
 <20220525073339.GF1098723@dread.disaster.area>
 <CAOQ4uxi=jZt_FnNktw8u5L90WUcEAtX4jymM126hLTVbw74f=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi=jZt_FnNktw8u5L90WUcEAtX4jymM126hLTVbw74f=g@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=628deaf9
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8 a=pGLkceISAAAA:8
        a=dJTZQx4RsjLq_d_WE8sA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 25, 2022 at 10:48:09AM +0300, Amir Goldstein wrote:
> On Wed, May 25, 2022 at 10:33 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Tue, May 24, 2022 at 08:36:50AM +0300, Amir Goldstein wrote:
> > > On Tue, May 24, 2022 at 1:43 AM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > On Mon, May 23, 2022 at 02:15:44PM +0300, Amir Goldstein wrote:
> > > > > On Sun, Jan 10, 2021 at 6:10 PM Chandan Babu R <chandanrlinux@gmail.com> wrote:
> > >
> > > I am not sure I follow this argument.
> > > Users can create large attributes, can they not?
> >
> > Sure. But *nobody does*, and there are good reasons we don't see
> > people doing this.
> >
> > The reality is that apps don't use xattrs heavily because
> > filesystems are traditionally very bad at storing even moderate
> > numbers of xattrs. XFS is the exception to the rule. Hence nobody is
> > trying to use a few million xattrs per inode right now, and it's
> > unlikely anyone will unless they specifically target XFS.  In which
> > case, they are going to want the large extent count stuff that just
> > got merged into the for-next tree, and this whole discussion is
> > moot....
> 
> With all the barriers to large extents count that you mentioned
> I wonder how large extent counters feature mitigates those,
> but that is irrelevant to the question at hand.

They don't. That's the point I'm trying to make - these patches
don't actually fix any problems with large data fork extent counts -
they just allow them to get bigger.

As I said earlier - the primary driver for these changes is not
growing the number of data extents or reflink - it's growing the
amount of data we can store in the attribute fork. We need to grow
that from 2^16 extents to 2^32 extents because we want to be able to
store hundreds of millions of xattrs per file for internal
filesystem purposes.

Extending the data fork to 2^48 extents at the same time just makes
sense from an on-disk format perspective, not because the current
code can scale effectively to 2^32 extents, but because we're
already changing all that code to support a different attr fork
extent size. We will probably need >2^32 extents in the next decade,
so we're making the change now while we are touching the code....

There are future mods planned that will make large extent counts
bearable, but we don't have any idea how to solve problems like
making reflink go from O(n) to O(log n) to make reflink of
billion extent files an every day occurrence....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
