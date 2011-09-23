Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NFQxlJ116301 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 10:26:59 -0500
Subject: Re: [PATCH] xfsdump: handle dump files with checksum bug
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1316781902-19803-1-git-send-email-wkendall@sgi.com>
References: <1316781902-19803-1-git-send-email-wkendall@sgi.com>
Date: Fri, 23 Sep 2011 10:26:55 -0500
Message-ID: <1316791615.2879.50.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, 2011-09-23 at 07:45 -0500, Bill Kendall wrote:
> xfsdump previously contained a bug in the code which generated
> a checksum on the header for extended attributes. This bug
> was recently fixed, but a new xfsrestore will fail if it
> encounters an old dump file which had checksums enabled. (This
> is unlikely since checksums have just recently been enabled in
> the build, and the above-mentioned bug was fixed at the same time.)
> 
> This patch uses a new flag in an extattrhdr_t to indicate a
> checksum is present. If this is set, the checksum is validated.
> If instead the old checksum flag is set, a warning is issued saying
> the header could not be validated, and xfsrestore will assume the
> header is valid.
> 
> Note that with this change a new dump cannot be restored with an
> old restore which has checksums enabled. But as I mentioned, old
> restores do not have checksums enabled.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

This looks fine to me.  I have two comments for you to
consider though.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> @@ -8197,16 +8198,28 @@ read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
>  	      ahdrp->ah_checksum );
>  
>  	if ( ahcs ) {
> -		if ( ! ( ahdrp->ah_flags & EXTATTRHDR_FLAGS_CHECKSUM )) {
> +		if ( ahdrp->ah_flags & EXTATTRHDR_FLAGS_CHECKSUM ) {
> +			if ( !is_checksum_valid( ahdrp, EXTATTRHDR_SZ )) {
> +				mlog( MLOG_NORMAL | MLOG_WARNING, _(
> +					"bad extattr header checksum\n") );
> +				return RV_CORRUPT;
> +			}
> +		} else if ( ahdrp->ah_flags & EXTATTRHDR_FLAGS_OLD_CHECKSUM ) {
> +			/* possibly a corrupt header, but most likely an old
> +			 * header, which cannot be verified due to a bug in how
> +			 * its checksum was calculated.
> +			 */
> +			if ( !warned ) {

The definition of "warned" could be moved inside this
block so it's clearer this is the only place it is
needed.

> +				mlog( MLOG_NORMAL | MLOG_WARNING, _(
> +					"extattr header checksum "
> +					"could not be verified\n") );

Is there any way to slightly change this message so
that someone who saw it would feel like "I got this
warning but it's really OK"?  If I were a user and
got this message I would be a little afraid that 
it meant something was really wrong with what got
restored--possibly the whole thing, or just on
some unnamed file, never to be found.

Maybe "old-style extattr header checksums being
ignored".  (I'm sure you can come up with better,
I just like to offer *something* when I suggest
a change.)

> +				warned = BOOL_TRUE;
> +			}
> +		} else {
>  			mlog( MLOG_NORMAL | MLOG_WARNING, _(

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
