Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8QKJ6JS249706 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 15:19:06 -0500
Message-ID: <50636384.1010803@sgi.com>
Date: Wed, 26 Sep 2012 15:20:20 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/6] xfs: make inode64 as the default allocation mode
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
	<1348147961-7520-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1348147961-7520-3-git-send-email-cmaiolino@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 09/20/12 08:32, Carlos Maiolino wrote:
> since 64-bit inodes can be accessed while using inode32, and these can also be
> used on 32-bit kernels, there is no reason to still keep inode32 as the default
> mount option.
> If the filesystem cannot handle 64bit inode numbers (i.e CONFIG_LBDAF is not
> enabled and BITS_PER_LONG == 32), XFS_MOUNT_SMALL_INUMS will still be set by
> default, so inode64 is not an unconditional default value.
>
> Signed-off-by: Carlos Maiolino<cmaiolino@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
