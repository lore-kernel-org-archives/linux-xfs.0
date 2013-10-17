Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A4E917F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 23:07:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8767B304032
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 21:07:32 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	whr4LbuYyLOTDSB1 for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 21:07:30 -0700 (PDT)
Date: Thu, 17 Oct 2013 15:06:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair fatal error -- name create failed in lost+found,
	filesystem may be out of space
Message-ID: <20131017040654.GQ4446@dastard>
References: <CAGa4099etDS8eBGCQ_Se2oQxObO8ZSqHpGeXzeUCpCz3S7XnBw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGa4099etDS8eBGCQ_Se2oQxObO8ZSqHpGeXzeUCpCz3S7XnBw@mail.gmail.com>
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
To: Viet Nguyen <vietnguyen@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 16, 2013 at 08:57:20PM -0700, Viet Nguyen wrote:
> Hi,
> Me again. I've got get another corrupted drive and I'm getting a different
> error for xfs_repair:
> 
> fatal error -- name create failed in lost+found (117), filesystem may be
> out of space

Error 117 is telling you that the filesystem is corrupted. i.e.
attempting to make a new name for a lost inode has resulted in
detection of a new corruption or previously undetected or
uncorrected corruption in the filesystem.

Given the amount of damage your filesystem sustained, that's not
totally unexpected, especially if you are running 3.2.0-alpha.
Can you provide more details about the failure?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
