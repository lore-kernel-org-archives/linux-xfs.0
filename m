Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E1CD7CA0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 22:10:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4E23304043
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 20:10:01 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HfQj4KLZ2zEUMWVk for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2016 20:09:55 -0700 (PDT)
Date: Mon, 22 Aug 2016 13:09:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv2 xfsprogs 00/14] Convert from off64_t to off_t
Message-ID: <20160822030953.GS19025@dastard>
References: <cover.1471107858.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Sat, Aug 13, 2016 at 07:04:18PM +0200, Felix Janda wrote:
> This patch series does several things related to large file support.
> 
> Patches 1-3 enable transparent LFS in the build system and make it
> mandatory.
> 
> Patches 4-9 and 12 replace *64 function and structure aliases.
> 
> Patches 10 and 11 disable fsr on Mac OS X and do cleanup to enable
> Patch 12. Further cleanup of the portability code is possible later.
> 
> Patch 13 makes tranparent LFS also mandatory for all users of libxfs.
> 
> Patch 14 finally replaces off64_t by off_t.

Felix, can you check how you are sending these patches? The last two
sets of patches you've sent have not threaded in the correct order
(they thread in a random order) which means I have to manually
reorder the patch set to get it to apply in the correct order via
git am....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
