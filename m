Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 31FA67F6D
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 02:29:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D0E7304039
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 00:29:48 -0700 (PDT)
Received: from mga14.intel.com (mga14.intel.com [143.182.124.37]) by
	cuda.sgi.com with ESMTP id Km1hr1HZeep9kiJX for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 00:29:47 -0700 (PDT)
Date: Thu, 10 Oct 2013 15:29:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
	pointer dereference at 00000003
Message-ID: <20131010072944.GA26888@localhost>
References: <20131009073910.GA387@localhost>
	<20131010005900.GE2025@devil.localdomain>
	<20131010062313.GA19097@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131010062313.GA19097@localhost>
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
To: Dave Chinner <dchinner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 10, 2013 at 02:23:13PM +0800, Fengguang Wu wrote:
> Dave,
> 
> Here are the first oops chunks that show up in the 3.12-rc4 kernel
> with only XFS build in. Attached is the kconfig and one full dmesg.
> 
> Hope there are more clues in them. I'll further test whether the
> problems disappear if further disabling XFS..

Yeah I just confirmed that disabling XFS quiets the error messages.

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
