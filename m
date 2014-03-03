Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 93A187F55
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 16:48:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CA898F8064
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 14:48:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XifBUJ1YVtjBP1dL for
	<xfs@oss.sgi.com>; Mon, 03 Mar 2014 14:48:33 -0800 (PST)
Message-ID: <531506BD.80209@redhat.com>
Date: Mon, 03 Mar 2014 16:48:29 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix use after free in inode_item_done()
References: <5314E912.9080708@redhat.com> <20140303223617.GL13647@dastard>
In-Reply-To: <20140303223617.GL13647@dastard>
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

On 3/3/14, 4:36 PM, Dave Chinner wrote:
> On Mon, Mar 03, 2014 at 02:41:54PM -0600, Eric Sandeen wrote:
>> Commit "3a19fb7 libxfs: stop caching inode structures"
>> introduced a use after free.
>>
>> libxfs_iput() already does the check for ip->i_itemp, and a
>> kmem_zone_free() if it's present, and then frees the ip pointer.
>> Re-checking ip->i_itemp after the libxfs_iput call will access
>> the freed ip pointer, as will setting ip_>i_itemp to NULL.
>>
>> Simply remove the offending code to fix this up.
> 
> which leaves the rest of the ili_done: code looking a little
> strange.
> 
> can you convert that now to be:
> 
> ili_done:
> 	if (iip->ili_lock_flags) {
> 		iip->ili_lock_flags = 0;
> 		return;
> 	}
> 	/* free the inode */
> 	libxfs_iput(ip, 0);
> }

yeah, I actually had that first.  Not sure why I didn't go with it ;)

(Still looks strange to my untrained eye; "if lock flags are set, unset them and don't free the inode, otherwise free it")

Anyway, I'll resend.  No need to educate me on these details, for now.  ;)

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
