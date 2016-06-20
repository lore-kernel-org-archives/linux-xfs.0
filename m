Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A6FE17CA1
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 01:55:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C93A304039
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2016 23:55:31 -0700 (PDT)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id Hh0kbiHdqqocgDtJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 19 Jun 2016 23:55:29 -0700 (PDT)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 820D720AE6
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 08:55:27 +0200 (CEST)
Date: Mon, 20 Jun 2016 08:54:10 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 4/4] Move to more stdint types
Message-ID: <20160620065410.GB431@nyan>
References: <20160618145330.GD17768@nyan>
 <20160620021226.GI26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160620021226.GI26977@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> On Sat, Jun 18, 2016 at 04:53:30PM +0200, Felix Janda wrote:
> > The uint*_t and int*_t are defined by C99 and should be prefered
> > over the less portable __uint*_t and __int*_t variants. The
> > necessary <stdint.h> include is in platformdefs.h, which gets
> > included in most places via libxfs.h.
> > 
> > For now, only replace all __uint*_t types to uint*_t and likewise for
> > __int*_t outside the directories include/ and libxfs/.
> > 
> > Signed-off-by: Felix Janda <felix.janda@posteo.de>
> .....
> >  58 files changed, 502 insertions(+), 502 deletions(-)
> 
> Because of the amount of churn this will cause outstanding patchsets
> (e.g. the rmap/reflink work), this isn't the best time for us to be
> committing tree-wide cleanups like this. Once we get the major
> changes that are pending reviewed and committed I have no problems
> with making these changes, so perhaps you could regenerate the patch
> once those are merged?

Of course.

Thanks,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
