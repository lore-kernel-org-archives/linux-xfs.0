Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E33B47CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 18:09:05 -0500 (CDT)
Date: Wed, 24 Jul 2013 18:09:02 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: fix _mount_ops_filter() to support $TEST_DIR
	containing -o
Message-ID: <20130724230902.GW3111@sgi.com>
References: <1372801497-3941-1-git-send-email-koen.de.wit@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372801497-3941-1-git-send-email-koen.de.wit@oracle.com>
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
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 02, 2013 at 11:44:57PM +0200, Koen De Wit wrote:
> If multiple mount options are given with multiple -o parameters,
> _mount_ops_filter concatenates them by replacing all -o's with a comma
> (except for the first -o).
> 
> If $TEST_DIR contains "-o" (e.g. /mnt/test-os/) you get errors like this:
> 
>    # ./check generic/002
>      mount: mount point /mnt/test,s/ does not exist
>      common/rc: retrying test device mount with external set
>      mount: mount point /mnt/test,s/ does not exist
>      common/rc: could not mount /dev/sdc3 on /mnt/test-os/
> 
> Fix it by only replacing -o's that are preceded by at least one space.
> 
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
