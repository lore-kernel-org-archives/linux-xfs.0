Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE56F7F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:32:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CCDD230405F
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 14:32:32 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	h6ewOIEqWGDssEcd for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 14:32:31 -0700 (PDT)
Date: Thu, 16 May 2013 07:32:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: 311: fsck the dmflakey device instead of the
	real device V2
Message-ID: <20130515213225.GY24635@dastard>
References: <1368631217-15511-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368631217-15511-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com

On Wed, May 15, 2013 at 11:20:17AM -0400, Josef Bacik wrote:
> Dave pointed out that xfs was having issues with 311 because of caching issues.
> He suggested that I fsck the dm-flakey device to make sure we don't have this
> problem.  Make _check_scratch_fs take an optional argument to use as the device
> to fsck.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V1->V2: make _check_scratch_fs() take the optional argument of the device to
> check

Looks fine from here...

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
