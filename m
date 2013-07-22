Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B67F97F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 14:08:47 -0500 (CDT)
Date: Mon, 22 Jul 2013 14:08:44 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Subject: [PATCH v2] xfs: Initialize all quota inodes to be
	NULLFSINO
Message-ID: <20130722190844.GC3111@sgi.com>
References: <1374273175.8941.2079.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374273175.8941.2079.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Fri, Jul 19, 2013 at 05:32:55PM -0500, Chandra Seetharaman wrote:
> Change from previous version:
>  - Added the additional comments that Dave wanted.
> 
> -------------
> mkfs doesn't initialize the quota inodes to NULLFSINO as it does for the
> other internal inodes. This leads to two in-core values (0 and NULLFSINO)
> to be checked against, to make sure if a quota inode is valid.
> 
> Solve that problem by initializing the in-core values of all quotaino
> values to NULLFSINO if they are 0 in the disk.
> 
> Note that these values are not written back to on-disk superblock unless
> some quota is enabled on the filesystem. Even in that case sb_pquotino is
> written to disk only if the on-disk superblock supports pquotino
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
