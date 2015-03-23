Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 086F029DFB
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 23:29:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CCFA7304032
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 21:28:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NwtdtKwkavlQSLWz for <xfs@oss.sgi.com>;
	Sun, 22 Mar 2015 21:28:51 -0700 (PDT)
Date: Mon, 23 Mar 2015 15:28:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about GFP_KERNEL argument in radix_tree_preload
Message-ID: <20150323042847.GN28621@dastard>
References: <CADa969g-jGyYc1ts+JamuD0Ze-Mcp+X8am7rAfDeY0wXC4A6gg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADa969g-jGyYc1ts+JamuD0Ze-Mcp+X8am7rAfDeY0wXC4A6gg@mail.gmail.com>
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
To: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: taesoo@gatech.edu, "Kashyap, Sanidhya" <sanidhya@gatech.edu>, xfs@oss.sgi.com, csong@gatech.edu, blee@gatech.edu, changwoo@gatech.edu

On Sun, Mar 22, 2015 at 11:49:34PM -0400, Sanidhya Kashyap wrote:
> Hello David,
> 
> We have been doing some analysis on file systems and have a question
> regarding the GFP_KERNEL flag used in radix_tree_preload in
> xfs_mru_cache_insert.
> 
> We think that this should be GFP_NOFS as it is related to the block
> allocation and other file systems(eg btrfs,ext2) are also using
> GFP_NOFS for the same.
>
> It would be great if you can let us know your reason for using that
> flag and which one is the correct option?

<shrug>

That code was written by someone else and it was 7-8 years ago I
cleaned it up for Linux. Whatever reason there was is long since
lost.

If it's wrong (e.g. can be called inside a transaction), send a
patch to fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
