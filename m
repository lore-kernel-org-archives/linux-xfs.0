Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 16FEF7F47
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 18:07:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EAC93304032
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 16:07:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id basuv150y9rNxQiE for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 16:07:30 -0700 (PDT)
Message-ID: <5564FCB4.6070603@sandeen.net>
Date: Tue, 26 May 2015 18:07:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] xfs_db: enable blockget for v5 filesystems
References: <20150526225126.26434.69010.stgit@birch.djwong.org>
	<20150526225153.26434.96347.stgit@birch.djwong.org>
In-Reply-To: <20150526225153.26434.96347.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc: xfs@oss.sgi.com

On 5/26/15 5:51 PM, Darrick J. Wong wrote:
> Plumb in the necessary magic number checks and other fixups required
> to handle v5 filesystems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

> @@ -799,8 +803,6 @@ blockget_f(
>  	 * filters out, or we need to actually do the work to make check support
>  	 * crc enabled filesystems.
>  	 */
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		return 0;

Hm, the comment above these lines says:

        /*
         * XXX: check does not support CRC enabled filesystems. Return
         * immediately, silently, with success but  without doing anything here
         * initially so that xfstests can run without modification on metadata
         * enabled filesystems.
         *
         * XXX: ultimately we need to dump an error message here that xfstests
         * filters out, or we need to actually do the work to make check support
         * crc enabled filesystems.
         */

but now we don't.  So I guess the comment should go too?

I guess check is deprecated now, so the comment is stale anyway...
  
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
