Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:26478 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1032196AbdDZWu7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 18:50:59 -0400
Date: Thu, 27 Apr 2017 08:50:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: Assign proper defaults to rmapbt and reflink
 flags
Message-ID: <20170426225044.GL12369@dastard>
References: <0f7c888b-5c62-e874-53d1-9159f1a3beba@redhat.com>
 <20170426151059.GN5205@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170426151059.GN5205@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jan Tulak <jtulak@redhat.com>

On Wed, Apr 26, 2017 at 08:10:59AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 26, 2017 at 09:02:44AM -0500, Eric Sandeen wrote:
> > The "defaultval" field in the options structure was a bit confusing,
> > so when the rmapbt & reflink options got added, the desire was
> > to keep them off by default, and "defaultval = 0" got set.
> > 
> > However, the purpose of this field is to define the default value
> > when the flag is specified with no associated value, i.e.
> > 
> > -m rmapbt vs. -m rmapbt=0 or -m rmapbt=1
> > 
> > Today, the resulting behavior is unexpected, and different from any
> > other mkfs flags; specifying "-m rmapbt,reflink" results in a
> > filesystem /without/ those features.
> > 
> > Fix these to be consistent with every other boolean flag in the
> > mkfs options, so that specifying the flag with no value will
> > enable the feature.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Someone should document that 'defaultval' is not the way to say
> 'disabled by default' in whatever the mkfs option processing code
> turns into.

....
 *   defaultval MANDATORY
 *     The value used if user specifies the subopt, but no value.
 *     If the subopt accepts some values (-d file=[1|0]), then this
 *     sets what is used with simple specifying the subopt (-d file).
 *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
 *     value in any case.
 */
....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
