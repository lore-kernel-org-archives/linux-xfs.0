Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 70AA07D39
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 18:53:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DC962AC002
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 16:53:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vkX89aoch03Yn8eE for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2016 16:53:55 -0700 (PDT)
Date: Thu, 28 Apr 2016 09:53:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_buf_iodone_callbacks to force shutdown & resubmit
	buf in case of permanent failure
Message-ID: <20160427235315.GL26977@dastard>
References: <a71e1aed74b2922e8ed6fb40404899e7@mail.gmail.com>
	<20160426224612.GE26977@dastard>
	<cbaec1d0ddb8505a9d35084291d33f37@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cbaec1d0ddb8505a9d35084291d33f37@mail.gmail.com>
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
To: Shyam Kaushik <shyam@zadarastorage.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Wed, Apr 27, 2016 at 10:29:29AM +0530, Shyam Kaushik wrote:
> Hi Dave,
> 
> I am not sure how to do lock release in this code path. Is it possible
> that you can take over this bug/patch? Thanks.

To tell the truth, I haven't even thought about how to fix it yet.
I suspect that the callbacks will need to be run, but with a new
parameter passed to xfs_iflush_done to say "still dirty, unlock
only" so that it simply unlocks and removes each object from the
buffer callback list.

I've got other things that need my attention right now (e.g agfl
size problem), so it's going to be next week before I get to this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
