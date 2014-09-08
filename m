Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E9AD7F4E
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 22:16:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2DB938F8039
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 20:16:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CC3kgWbifR2mP6JX for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 20:16:47 -0700 (PDT)
Date: Mon, 8 Sep 2014 13:16:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs_repair: don't ASSERT on corrupt ftype
Message-ID: <20140908031644.GZ20518@dastard>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
	<1410108065-18156-5-git-send-email-sandeen@redhat.com>
	<20140908001044.GB30012@dastard> <540D001C.6020607@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540D001C.6020607@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Sun, Sep 07, 2014 at 08:02:20PM -0500, Eric Sandeen wrote:
> On 9/7/14 7:10 PM, Dave Chinner wrote:
> >On Sun, Sep 07, 2014 at 11:41:04AM -0500, Eric Sandeen wrote:
> 
> ...
> 
> >>diff --git a/include/xfs_da_format.h b/include/xfs_da_format.h
> >>index 89a1a21..11f1420 100644
> >>--- a/include/xfs_da_format.h
> >>+++ b/include/xfs_da_format.h
> >>@@ -561,7 +561,6 @@ xfs_dir3_dirent_get_ftype(
> >>  	if (xfs_sb_version_hasftype(&mp->m_sb)) {
> >>  		__uint8_t	type = dep->name[dep->namelen];
> >>
> >>-		ASSERT(type < XFS_DIR3_FT_MAX);
> >>  		if (type < XFS_DIR3_FT_MAX)
> >>  			return type;
> >
> >Needs to be fixed kernel-side first.
> 
> xfs_dir3_dirent_get_ftype doesn't exist in kernelspace :)
> 
> bleah, why do they have different names...  Ok, will send.

Because kernel has changed, and we need to do yet another large
kernel/user libxfs sync.

I haven't found time to do that yet. Unless you want to volunteer
for it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
