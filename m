Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0F7F129E01
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 19:03:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E40D2304032
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 17:03:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jpdguMoar3O0uPQr for <xfs@oss.sgi.com>;
	Mon, 06 Apr 2015 17:03:35 -0700 (PDT)
Date: Tue, 7 Apr 2015 10:03:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 1/2] xfs_db: enable blockget for v5 filesystems
Message-ID: <20150407000303.GB15810@dastard>
References: <20150318232356.GC24608@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150318232356.GC24608@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 18, 2015 at 04:23:56PM -0700, Darrick J. Wong wrote:
> Plumb in the necessary magic number checks and other fixups required
> to handle v5 filesystems.  This requires Eric Sandeen's earlier patch
> rollup.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/check.c |   52 +++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 39 insertions(+), 13 deletions(-)
> 
> diff --git a/db/check.c b/db/check.c
> index 4fd9fd0..767022f 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -799,8 +799,6 @@ blockget_f(
>  	 * filters out, or we need to actually do the work to make check support
>  	 * crc enabled filesystems.
>  	 */
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		return 0;

This causes check to run from xfstests on v5 filesystems, which then
throws errors everywhere and fails every test. A more nuanced
enablement of blockget is required here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
