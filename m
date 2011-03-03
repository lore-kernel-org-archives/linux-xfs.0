Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2357aFk067401 for <xfs@oss.sgi.com>; Wed, 2 Mar 2011 23:07:36 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06DE830D6F6
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2011 21:10:26 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZmNJrGKNcNsLhDW6 for <xfs@oss.sgi.com>;
	Wed, 02 Mar 2011 21:10:26 -0800 (PST)
Date: Thu, 3 Mar 2011 16:10:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4, 01/16] xfsprogs: metadump: some names aren't all
	that special
Message-ID: <20110303051023.GI15097@dastard>
References: <201102182121.p1ILL1T8029031@stout.americas.sgi.com>
	<20110224011837.GO3166@dastard> <1298657617.1990.6984.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1298657617.1990.6984.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 25, 2011 at 12:13:37PM -0600, Alex Elder wrote:
> Move the check for short names out of is_special_dirent() and into
> generate_obfuscated_name().  That way the check is more directly
> associated with the algorithm that requires it.
> 
> Similarly, move the check for inode == 0, since that case has to do
> with storing extended attributes (not files) in the name table.
> 
> As a result, is_special_dirent() is really only focused on whether a
> given file is in the lost+found directory.  Rename the function to
> reflect its more specific purpose.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> Updates (v3):
> - The previous version did not properly skip the "lost+found"
>   directory itself; this one does.
> - Created a new definition representing the name of the orphanage
>   directory.  Encapsulate recognizing that directory into a new
>   macro, is_lost_found().
> - Removed casts that eliminate a compile warning in calls to
>   libxfs_da_hashname(); will do them separately later if needed.
> Updates (v4):
> - Renamed is_lost_found() to be is_orphanage_dir(), and turned
>   it into an inline static function.
> - Added parentheses around targets of the sizeof operation.
> - Added a small bit of clarifying commentary in spots where
>   it was suggested.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
