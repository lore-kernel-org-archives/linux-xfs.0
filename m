Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C1C997F74
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 00:04:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51E9EAC003
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 22:04:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1cJLFCBqCf3fGALO for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 22:04:23 -0700 (PDT)
Date: Thu, 26 Jun 2014 15:03:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: document log sysfs attributes in testing ABI
Message-ID: <20140626050345.GZ4453@dastard>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
	<1402060414-22075-7-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402060414-22075-7-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 06, 2014 at 09:13:34AM -0400, Brian Foster wrote:
> Create a sysfs-fs-xfs ABI documentation file for newly added sysfs
> attributes. This is created under the testing section.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine, but I'm not sure we ever want people to think these are
going to form part of the stable XFS ABI - they are encodings of
deeply internal functionality of XFS. We're not going to be tied to
an implementation because of diagnostic information we expose to
to sysfs, so users need to know that this is a volatile interface.

Hence I'd suggest adding a disclaimer indicating that these not ever
guaranteed to be stable and could change or be removed at any time
without warning. Say, for example, we add another description line
like this:

   Stability:		Volatile

We can then point out the entries that are we'll never guarantee are
stable, those that we are stabilising, and those that are considered
stable easily?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
