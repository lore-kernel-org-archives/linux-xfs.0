Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D1737F5E
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 00:07:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F206A304053
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 22:07:17 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gK5PVNZL6jlwOok7 for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 22:07:15 -0800 (PST)
Date: Thu, 3 Dec 2015 17:07:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/11] xfsprogs: xfs_fsr: replace sprintf with snprintf
	to avoid buffer overflow
Message-ID: <20151203060701.GW26718@dastard>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-8-git-send-email-t.vivek@samsung.com>
	<565FD6A2.9040406@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565FD6A2.9040406@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Wed, Dec 02, 2015 at 11:44:02PM -0600, Eric Sandeen wrote:
> 
> it seems like the sprintfs in i.e. fsrall_cleanup() and tmp_init()
> might have the same problem, no?
> 
> And then what happens if it is truncated to SMBUFSZ; at that point
> I think this needs error handling, if the string got truncated.

Might be easier to simply increase the size of SMBUFSZ so that
overrun is not possible?

-Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
