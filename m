Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FA0A7F3F
	for <xfs@oss.sgi.com>; Wed,  5 Nov 2014 00:07:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2D16304048
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 22:07:38 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2Nah4W9vuVaCQAop for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 22:07:35 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Xltke-0002co-ED
	for xfs@oss.sgi.com; Wed, 05 Nov 2014 17:07:28 +1100
Date: Wed, 5 Nov 2014 17:07:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6 v2] xfs: fix the bulkstat mess
Message-ID: <20141105060728.GE28565@dastard>
References: <1415145921-31507-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415145921-31507-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Wed, Nov 05, 2014 at 11:05:15AM +1100, Dave Chinner wrote:
> Hi folks, this is version 2 of the bulkstat fixup series first
> posted here:
> 
> http://oss.sgi.com/archives/xfs/2014-11/msg00057.html
> 
> Version 2 fixes the issues Brian found during review:
> - chunk formatter error leakage (patch 3)
> - moved main loop chunk formatter error handling from patch 4 to
>   patch 5
> - reworks last_agino updating in patch 6 to do post-formatting
>   updates and added comments.
> 
> Comeents and testing welcome.

I'm not 100% convinced that this fixes all the problems. I just
created, dumped and restored a 10 million inode filesystem (about
50GB of dump file) and I found 102 missing files in the dump with no
errors from xfsdump or xfsrestore.

The files are missing from just 4 directories out of about 1000
directories containing equal numbers of files, so its not a common
trigger whatever the issue is. I'll keep digging...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
