Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BA7187F61
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 08:17:18 -0500 (CDT)
Message-ID: <55CC98DD.6060700@sgi.com>
Date: Thu, 13 Aug 2015 08:17:17 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Fix xfs_attr_leafblock definition
References: <1439458000-28395-1-git-send-email-jack@suse.com>
In-Reply-To: <1439458000-28395-1-git-send-email-jack@suse.com>
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
To: Jan Kara <jack@suse.com>
Cc: xfs@oss.sgi.com

On 08/13/15 04:26, Jan Kara wrote:
> struct xfs_attr_leafblock contains 'entries' array which is declared
> with size 1 altough it can in fact contain much more entries. Since this
> array is followed by further struct members, gcc (at least in version
> 4.8.3) thinks that the array has the fixed size of 1 element and thus
> may optimize away all accesses beyond the end of array resulting in
> non-working code. This problem was only observed with userspace code in
> xfsprogs, however it's better to be safe in kernel as well and have
> matching kernel and xfsprogs definitions.
>
> Signed-off-by: Jan Kara<jack@suse.com>
> ---

I hit this bug in SLES12 and RHEL7 XFS kernel code. It is the gcc 4.8's 
new loop optimization routine. A person can bypass it with the option:
     -fno-aggressive-loop-optimizations
but this fixes the source of the problem.

Acked-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
