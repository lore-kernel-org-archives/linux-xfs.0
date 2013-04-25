Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D68A29DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 11:43:34 -0500 (CDT)
Message-ID: <51795D39.70000@sgi.com>
Date: Thu, 25 Apr 2013 11:43:37 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: xfs: fallback to vmalloc for large buffers in
	xfs_compat_attrlist_by_handle
References: <515CB2C1.1050109@tlinx.org> <20130404035237.GA12011@dastard>
	<515D0A09.5030808@sandeen.net> <51795612.3080806@sandeen.net>
In-Reply-To: <51795612.3080806@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 04/25/13 11:13, Eric Sandeen wrote:
> Shamelessly copied from dchinner's:
> ad650f5b xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get
>
> xfsdump uses a large buffer for extended attributes, which has a
> kmalloc'd shadow buffer in the kernel. This can fail after the
> system has been running for some time as it is a high order
> allocation. Add a fallback to vmalloc so that it doesn't require
> contiguous memory and so won't randomly fail while xfsdump is
> running.
>
> This was done for xfs_attrlist_by_handle but
> xfs_compat_attrlist_by_handle (the 32-bit version) needs the same
> attention.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

Looks shamelessly good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
