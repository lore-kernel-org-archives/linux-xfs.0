Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72A6F29E09
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 11:13:14 -0500 (CDT)
Message-ID: <51795629.1000708@sgi.com>
Date: Thu, 25 Apr 2013 11:13:29 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3 V2] xfsprogs: Fix up usage() errors and omissions
References: <5175BB8F.5090604@sandeen.net> <5175BCBE.8040306@sandeen.net>
	<517948D2.7070706@sandeen.net>
In-Reply-To: <517948D2.7070706@sandeen.net>
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

On 04/25/2013 10:16 AM, Eric Sandeen wrote:
> Add missing options and remove invalid options in usage() output
> strings.
>
> * Add -V to several usage() strings
> * Remove deprecated/invalid -n and -s otions from xfs_fsr's usage
> * Remove invalid -I option from xfs_growfs's usage
> * Add -n (O_NONBLOCK) option to xfs_io's usage
> * Add -e (exit on error) option to xfs_logprint's usage
> * Remove invalid -b option from xfs_mdrestore's usage
> * Add -N (no-op), -K (no discard), and -f (force) to mkfs.xfs's usage
> * Add -x (expert) option to xfs_quota's usage
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> V2: address Rich's nitpicky review ;)  (i.e. fix good stuff)

Thanks again for V2.  Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
