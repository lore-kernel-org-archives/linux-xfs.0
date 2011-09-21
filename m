Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LHRPMC161800 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 12:27:26 -0500
Subject: Re: [PATCH v3] xfsdump: enable dump header checksums
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1316625223-19970-1-git-send-email-wkendall@sgi.com>
References: <1316625223-19970-1-git-send-email-wkendall@sgi.com>
Date: Wed, 21 Sep 2011 12:27:20 -0500
Message-ID: <1316626040.5872.0.camel@doink>
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

On Wed, 2011-09-21 at 12:13 -0500, Bill Kendall wrote:
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
> ---
> Changes since v2:
>     - Add an ASSERT in the checksum routines to enforce the
>       multiple of 4 requirement, rather than checking at
>       init (which may not catch all checksum users).
>     - Remove unnecessary cast from void * to u_int32_t *.
>     - Calculate endp different to avoid having to cast to
>       void * or char *.
> 
>  common/content_inode.h |   27 ++++++++++++++++
>  dump/content.c         |   78 +++++++----------------------------------------
>  restore/Makefile       |    2 +-
>  restore/content.c      |   40 ++----------------------
>  4 files changed, 44 insertions(+), 103 deletions(-)

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
