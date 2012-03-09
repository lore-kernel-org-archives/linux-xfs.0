Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29HRl5w002119 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 11:27:47 -0600
Date: Fri, 9 Mar 2012 11:27:53 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH V2] xfstests: clean up scsi_debug module handling
Message-ID: <20120309172753.GB7762@sgi.com>
References: <4F59461B.7040608@redhat.com> <4F59492F.6020007@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F59492F.6020007@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Hey Eric,

On Thu, Mar 08, 2012 at 06:05:03PM -0600, Eric Sandeen wrote:
> 2 little fixes to common scsi_debug handling.
> 
> * don't consider the scsi_debug module in use in
>   _require, unless it can't be rmmod'd
> * don't try to rmmod it in _put unless it is currently
>   loaded
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

This looks good to me.
Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
> 
> Argh.
> 
> diff --git a/common.scsi_debug b/common.scsi_debug
> index 9f9177c..a085a67 100644
> --- a/common.scsi_debug
> +++ b/common.scsi_debug
> @@ -26,7 +26,7 @@ _require_scsi_debug()
>  {
>  	# make sure we have the module and it's not already used
>  	modinfo scsi_debug 2>&1 > /dev/null || _notrun "scsi_debug module not found"
> -	lsmod | grep -wq scsi_debug && _notrun "scsi_debug module in use"
> +	lsmod | grep -wq scsi_debug && (rmmod scsi_debug || _notrun "scsi_debug module in use")
>  	# make sure it has the features we need
>  	# logical/physical sectors plus unmap support all went in together
>  	modinfo scsi_debug | grep -wq sector_size || _notrun "scsi_debug too old"
> @@ -58,5 +58,6 @@ _get_scsi_debug_dev()
>  _put_scsi_debug_dev()
>  {
>  	sleep 1
> +	lsmod | grep -wq scsi_debug || return
>  	rmmod scsi_debug || _fail "Could not remove scsi_debug module"
>  }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
