Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFA6B7F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 08:51:52 -0500 (CDT)
Message-ID: <51FBB978.2040207@sgi.com>
Date: Fri, 02 Aug 2013 08:51:52 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/49] libxfs: fix byte swapping on constants
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-7-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:44, Dave Chinner wrote:
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

sync to include/uapi/linux/swab.h and (IMO backwards) switch/case 
statements in xfs_allocbt_verify() like kernel commit ee1a47ab.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
