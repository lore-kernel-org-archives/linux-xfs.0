Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QGhOAU242197 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 11:43:24 -0500
Message-ID: <508ABE75.4030703@sgi.com>
Date: Fri, 26 Oct 2012 11:46:45 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstests: resolve symlinked devices to real paths
References: <4C0EA21B.8020703@sandeen.net>
In-Reply-To: <4C0EA21B.8020703@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On 06/08/2010 03:03 PM, Eric Sandeen wrote:
> If you try running xfstests on lvm volumes which are symlinks,
> it'll fail to run several tests because our _require_scratch
> framework ultimately uses lstat not stat, and does not think
> the lvm device (which is usually a symlink to a dm-X device)
> is a block device.  Sigh.
>
> Last try at this - just resolve any symlinked devicenames
> into their realpath(3) in common.config.
>
> This actually seems to work.
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>
> ---
>
>
> diff --git a/common.config b/common.config
> index 926846b..e5b2483 100644
> --- a/common.config
> +++ b/common.config

Looks good

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Eric,

This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests, 
master branch, commit ID d5ea873f.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
