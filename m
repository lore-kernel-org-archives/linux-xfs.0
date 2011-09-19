Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JKCQAO012207 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 15:12:26 -0500
Subject: Re: [PATCH] xfsdump: enable dump header checksums
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1314654106-28548-1-git-send-email-wkendall@sgi.com>
References: <1314654106-28548-1-git-send-email-wkendall@sgi.com>
Date: Mon, 19 Sep 2011 15:12:21 -0500
Message-ID: <1316463141.2941.75.camel@doink>
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

On Mon, 2011-08-29 at 16:41 -0500, Bill Kendall wrote:
> Various structures in a dump file optionally contain a checksum, but
> the code to compute and validate the checksum has not been enabled.
> The checksum code has a negligible performance impact and so this
> patch enables the checksum code unconditionally. Also:
> 
> - make sure all header sizes are multiples of 4 bytes
>   (a requirement of the checksum routine)
> - zero structures to ensure internal padding has a known value
> - fix a bug in dump_extattr_buildrecord() which checksummed
>   the wrong header structure
> - add calc_checksum() and is_checksum_valid() routines to
>   cut down on duplicate code
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

I have a bunch of questions, and a few minor suggestions.
This is a really good thing to get back into dumps.  The
change looks OK to me, but I'd like to hear back from you
and maybe have you submit a new version with minor tweaks
before I commit this.

					-Alex

How did you select your checksum algorithm?  As long as you're
computing one, perhaps you should use one of the established
standard ones with well-understood properties (like CRC-32).

Oh, now I see it was there in the code already.  Thank you for
encapsulating that...

Was this used previously in Irix, and thus needs to be done in
a compatible way?  Maybe you could implement this but at a
future date implement EXTENTHDR_FLAGS_CRC32 as another flag
that could provide a better checksum.

The theory in doing this unconditionally is that we might as
well record it, even if the restore program chooses to ignore
it, right?

Interesting that struct direnthdr has no flags field.  It
looks like the flag that signals it is in use is in the
content_inode_hdr structure.  Any idea why the others
include a flag with each structure instance indicating
they are checksummed?

> ---
>  common/content_inode.h |   20 +++++++++++
>  dump/content.c         |   85 +++++++++++-------------------------------------
>  restore/Makefile       |    2 +-
>  restore/content.c      |   40 ++--------------------
>  4 files changed, 44 insertions(+), 103 deletions(-)
> 
> diff --git a/common/content_inode.h b/common/content_inode.h
> index 479fdfc..e119354 100644
> --- a/common/content_inode.h
> +++ b/common/content_inode.h
> @@ -347,4 +347,24 @@ typedef struct extattrhdr extattrhdr_t;
>  	/* a linux "secure" mode attribute
>  	 */
>  
> +/* Routines for calculating and validating checksums on xfsdump headers
> + */

I know it's fairly obvious on these simple functions, but it
might be nice to state in the header that the number of bytes
used in the checksum is a multiple of 4, and that endp marks
a point *beyond* the last byte used.

> +static inline u_int32_t
> +calc_checksum(void *startp, void *endp)
> +{
> +	u_int32_t sum;
> +	u_int32_t *sump = (u_int32_t *)startp;
> +	for (sum = 0; sump < (u_int32_t *)endp; sum += *sump++);

Put the semicolon on its own line to make it more obvious.

> +	return ~sum + 1;
> +}
> +
> +static inline bool_t
> +is_checksum_valid(void *startp, void *endp)
> +{
> +	u_int32_t sum;
> +	u_int32_t *sump = (u_int32_t *)startp;
> +	for (sum = 0; sump < (u_int32_t *)endp; sum += *sump++);

Here too.

> +	return sum == 0 ? BOOL_TRUE : BOOL_FALSE;
> +}
> +
>  #endif /* CONTENT_INODE_H */
> diff --git a/dump/content.c b/dump/content.c
> index 9905c88..2cf15ba 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -585,6 +585,13 @@ content_init( intgen_t argc,
>  		sizeof( content_inode_hdr_t ));
>  	ASSERT( sizeof( extattrhdr_t ) == EXTATTRHDR_SZ );
>  
> +	/* must be a multiple of 32-bits for checksums
> +	 */
> +	ASSERT( FILEHDR_SZ % sizeof( u_int32_t ) == 0 );
> +	ASSERT( EXTENTHDR_SZ  % sizeof( u_int32_t ) == 0 );
> +	ASSERT( DIRENTHDR_SZ % sizeof( u_int32_t ) == 0 );
> +	ASSERT( EXTATTRHDR_SZ % sizeof( u_int32_t ) == 0 );

If you take the mental leap to assume sizeof(u_int32_t) == 4,
then these checks can be made at compile time.  Others might
not like that mental leap, however.

#if (FILEHDR_SZ % 4)
# error "FILEHDR_SZ must be a multiple of 4 (for checksumming)"
#endif

> +
>  	/* calculate offsets of portions of the write hdr template
>  	 */
>  	dwhdrtemplatep = ( drive_hdr_t * )gwhdrtemplatep->gh_upper;

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
