Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E8C837F3F
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 14:00:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7AA60AC006
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 12:00:16 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zAmp6Cl5jEfy1TWc for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2015 12:00:13 -0800 (PST)
Date: Fri, 6 Mar 2015 07:00:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: debian xfsprogs package
Message-ID: <20150305200010.GB4251@dastard>
References: <54F888CD.3070200@bofanez.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F888CD.3070200@bofanez.org>
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
To: peteman <peteman@bofanez.org>
Cc: xfs@oss.sgi.com

On Thu, Mar 05, 2015 at 08:48:13AM -0800, peteman wrote:
> the debian xfsprogs package places xfs_check in /usr/sbin. This
> causes problems when fscking the /usr partition....

xfs_check was deprecated quite some time ago, and was removed
from the upstream repository almost a year ago, as per the xfs-check
man page:

$ dpkg --list xfsprogs |tail -1
ii  xfsprogs       3.2.0        amd64        Utilities for managing the XFS filesystem
$ man xfs_check
....
Note that xfs_check is deprecated and scheduled for removal in June 2014. Please use xfs_repair -n instead.

And the commit in the upstream repo:

commit bfc541e77b9af46a2e3764df595620ec9824a456
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue May 20 18:30:23 2014 +1000

    xfsprogs: remove xfs_check
    
    This removes xfs_check and all references to it in
    manpages.  The DIAGNOSTICS section from xfs_check(8)
    has been moved to xfs_db(8).
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

And so it was removed in the 3.2.1 release. debian testing is
shipping 3.2.1 already...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
