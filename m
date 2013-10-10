Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F2EE47F57
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 22:26:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF8DD8F806F
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 20:26:41 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [143.182.124.21]) by
	cuda.sgi.com with ESMTP id z90KvjJVX0y1pqcL for
	<xfs@oss.sgi.com>; Wed, 09 Oct 2013 20:26:41 -0700 (PDT)
Date: Thu, 10 Oct 2013 11:26:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
	pointer dereference at 00000003
Message-ID: <20131010032637.GA12725@localhost>
References: <20131009073910.GA387@localhost>
	<20131010005900.GE2025@devil.localdomain>
	<20131010011640.GA5726@localhost> <20131010014117.GA6017@localhost>
	<20131010031515.GT4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131010031515.GT4446@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

Dave,

> I note that you have CONFIG_SLUB=y, which means that the cache slabs
> are shared with objects of other types. That means that the memory
> corruption problem is likely to be caused by one of the other
> filesystems that is probing the block device(s), not XFS.

Good to know that, it would easy to test then: just turn off every
other filesystems. I'll try it right away.

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
