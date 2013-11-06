Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 48EBC29E23
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 06:50:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B93F8F8065
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 04:50:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id e7vEexlv2Jo1CTER for
	<xfs@oss.sgi.com>; Wed, 06 Nov 2013 04:50:32 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rA6CoVju023774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 6 Nov 2013 07:50:31 -0500
Received: from orion.maiolino.org (ovpn-113-27.phx2.redhat.com [10.3.113.27])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id rA6CoHtj000844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 6 Nov 2013 07:50:30 -0500
Date: Wed, 6 Nov 2013 10:50:17 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: fix the comment explaining xfs_trans_dqlockedjoin
Message-ID: <20131106125016.GB32637@orion.maiolino.org>
References: <20131106114536.GA18548@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106114536.GA18548@infradead.org>
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
To: xfs@oss.sgi.com

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Wed, Nov 06, 2013 at 03:45:36AM -0800, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index cd2a10e..4117286 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -295,8 +295,8 @@ xfs_trans_mod_dquot(
>  /*
>   * Given an array of dqtrx structures, lock all the dquots associated and join
>   * them to the transaction, provided they have been modified.  We know that the
> - * highest number of dquots of one type - usr, grp OR prj - involved in a
> - * transaction is 2 so we don't need to make this very generic.
> + * highest number of dquots of one type - usr, grp and prj - involved in a
> + * transaction is 3 so we don't need to make this very generic.
>   */
>  STATIC void
>  xfs_trans_dqlockedjoin(
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
