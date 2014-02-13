Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 24EDD7F58
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 19:53:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD772AC014
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 17:53:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id L0CCAAwo7wCFaT4A for <xfs@oss.sgi.com>;
	Wed, 12 Feb 2014 17:53:56 -0800 (PST)
Message-ID: <52FC25B3.20409@sandeen.net>
Date: Wed, 12 Feb 2014 19:53:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Limits on agi->agi_level (and other btree depths?)
References: <52FC09AB.3030209@sandeen.net> <20140213010308.GH13997@dastard>
In-Reply-To: <20140213010308.GH13997@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 2/12/14, 7:03 PM, Dave Chinner wrote:
> On Wed, Feb 12, 2014 at 05:54:19PM -0600, Eric Sandeen wrote:

...

>> I guess XFS_BTREE_MAXLEVELS is just an arbitrary in-memory limit,
>> not a limit of the underlying disk structures, but as it stands,
>> we should be sure that we don't exceed it, right?
> 
> If you really want to enforce XFS_BTREE_MAXLEVELS, add checks
> into xfs_alloc_compute_maxlevels(), xfs_ialloc_compute_maxlevels()
> and xfs_bmap_compute_maxlevels() to constrain the limits in the
> struct xfs_mount and validate the on-disk values based on the
> values in the struct xfs_mount.

Thanks, I had forgotten those existed - that looks perfect.

>> I was going to put that limit into xfs_agi_verify, but realized
>> that I wasn't sure if we could actually exceed that depth in
>> normal operations.
>>
>> (cue dchinner working out that 9 levels is 59 bazillion jillion
>> items, and will never be hit?)
> 
> Yep, done that ;)

I knew you'd enjoy it.  ;)

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
