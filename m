Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 632C17F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 16:03:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 43A2D8F8049
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 14:03:55 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	CK3WSDi1n4XbCo3k for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 14:03:50 -0800 (PST)
Date: Thu, 5 Mar 2015 09:03:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: add DAX file operations support
Message-ID: <20150304220348.GW18360@dastard>
References: <1425425427-16283-1-git-send-email-david@fromorbit.com>
	<1425425427-16283-4-git-send-email-david@fromorbit.com>
	<54F6D9E4.9050803@gmail.com> <20150304130100.GU18360@dastard>
	<54F71CBA.2@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F71CBA.2@gmail.com>
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
To: Boaz Harrosh <openosd@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Wed, Mar 04, 2015 at 04:54:50PM +0200, Boaz Harrosh wrote:
> On 03/04/2015 03:01 PM, Dave Chinner wrote:
> > On Wed, Mar 04, 2015 at 12:09:40PM +0200, Boaz Harrosh wrote:
> <>
> > 
> > So, we definitely need splice to/from DAX enabled inodes to be
> > rejected. I'll have a look at that...
> > 
> 
> default_file_splice_read uses kernel_readv which I think might actually
> work. Do you know what xfstest(s) exercise splice?

We have a rudimentary one only because I discovered a while back
none existed at all. i.e. splice is effectively untested by
xfstests. If you want to write some tests to execise it, that'd be
great....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
