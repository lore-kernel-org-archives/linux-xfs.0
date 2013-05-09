Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C1AAE29DF8
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 22:15:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D2CFAC001
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 20:15:47 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AZKirUPjy5zp2Lkp for <xfs@oss.sgi.com>;
	Wed, 08 May 2013 20:15:45 -0700 (PDT)
Date: Thu, 9 May 2013 13:15:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfstests: generic/235 breaks /etc/mtab symlinks
	breaks xfs/189
Message-ID: <20130509031519.GM23072@dastard>
References: <1368062501-15046-1-git-send-email-david@fromorbit.com>
	<1368062501-15046-4-git-send-email-david@fromorbit.com>
	<518B0DF7.4050500@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518B0DF7.4050500@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, May 08, 2013 at 10:46:15PM -0400, Michael L. Semon wrote:
> /etc/mtab
> is not a symlink,
> on this PC here.
> 
> It is set that way,
> for N-I-L-F-S-2
> to track its GC.
> 
> Do I need to set
> mtab as link to /proc/mounts
> to use your new patch?

Symlink? File? Choice is
difficult. New test cares not.
Ignorance is bliss.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
