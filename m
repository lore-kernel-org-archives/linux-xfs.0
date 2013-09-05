Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3528B7F51
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 10:41:04 -0500 (CDT)
Message-ID: <5228A60F.7010406@sgi.com>
Date: Thu, 05 Sep 2013 10:41:03 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/55] libxfs: fix byte swapping on constants
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-7-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The kernel code uses cpu_to_beXX() on constants in switch()
> statements for magic numbers in the btree code. Th ebyte swapping
> infratructure isn't hooked up to the proper byte swap macros to make
> this work, so fix it and then swap all the generic btree code over
> to match the kernel code.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Patch has not changed since last posting.

sync to include/uapi/linux/swab.h and switch/case statements in 
xfs_allocbt_verify() like kernel commit ee1a47ab.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
