Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 563107F8E
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 17:36:20 -0500 (CDT)
Date: Fri, 28 Jun 2013 17:36:16 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v10 07/11] xfs: Remove incore use of XFS_OQUOTA_ENFD
	and XFS_OQUOTA_CHKD
Message-ID: <20130628223616.GE20932@sgi.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-8-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372371914-11370-8-git-send-email-sekharan@us.ibm.com>
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
Cc: xfs@oss.sgi.com

On Thu, Jun 27, 2013 at 05:25:10PM -0500, Chandra Seetharaman wrote:
> Remove all incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
> start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts for GQUOTA and
> PQUOTA respectively.
> 
> On-disk copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
> 
> Read and write of the superblock does the conversion from *OQUOTA*
> to *[PG]QUOTA*.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
