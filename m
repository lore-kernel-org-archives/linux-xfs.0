Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 017877CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 02:07:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6EB8304039
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 00:07:28 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id qaFEZitjK3HvyJ5c (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Aug 2016 00:07:26 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 414F620461
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 09:07:24 +0200 (CEST)
Date: Mon, 22 Aug 2016 09:06:01 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCHv2 xfsprogs 00/14] Convert from off64_t to off_t
Message-ID: <20160822070601.GA1205@nyan>
References: <cover.1471107858.git.felix.janda@posteo.de>
	<20160822030953.GS19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160822030953.GS19025@dastard>
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
> On Sat, Aug 13, 2016 at 07:04:18PM +0200, Felix Janda wrote:
> > This patch series does several things related to large file support.
> > 
> > Patches 1-3 enable transparent LFS in the build system and make it
> > mandatory.
> > 
> > Patches 4-9 and 12 replace *64 function and structure aliases.
> > 
> > Patches 10 and 11 disable fsr on Mac OS X and do cleanup to enable
> > Patch 12. Further cleanup of the portability code is possible later.
> > 
> > Patch 13 makes tranparent LFS also mandatory for all users of libxfs.
> > 
> > Patch 14 finally replaces off64_t by off_t.
> 
> Felix, can you check how you are sending these patches? The last two
> sets of patches you've sent have not threaded in the correct order
> (they thread in a random order) which means I have to manually
> reorder the patch set to get it to apply in the correct order via
> git am....

I am sorry for that. Should I resend the patch series?

Cheers,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
