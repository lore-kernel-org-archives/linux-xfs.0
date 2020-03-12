Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD14EC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 23:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BD2C206F7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 23:44:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hSnIXkda"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgCLXoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 19:44:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39330 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgCLXoY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 19:44:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNi3uL012442;
        Thu, 12 Mar 2020 23:44:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6a99d91zPyGOIKxSAccRM4ZeimqjRPBAY9JCQDRrrUg=;
 b=hSnIXkdaxwxh30MGOzAiNYgGE0aZm+WDNC2BWEhXcTmmg7TV7U9LUHV0qhBcifeE4IPi
 UI7nSQfd8X5nc05V1EcctjpOCW0qDNB5IfGQ1EYpCG9vS/HWpA2Zr2wNpjuJ7KxTEjF5
 7krkQUJs4cRT/aRp2KxHx54E9qy+8bUn04LqordFEy0r5ThtBCh3x8vT/6+ZKZZ8wDUC
 4YYSlXcaejIS+aqgrb3iKTJek/Mbo5VPssuVjkQZfSjqGhHPtMJWLq+BC1BXMALPBEUe
 eV+/3V2IAFQJkQ+FFk0QtIrl8wR4A0BaA0BaIznho3mRNtUcNy7GBR/UwvrP1h+102Kh bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yqtag950t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:44:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNgIgn141485;
        Thu, 12 Mar 2020 23:44:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yqtabag58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:44:20 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02CNiJTN029927;
        Thu, 12 Mar 2020 23:44:19 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 16:44:18 -0700
Date:   Thu, 12 Mar 2020 16:44:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 6/7] xfs: make the btree cursor union members named
 structure
Message-ID: <20200312234418.GR8045@magnolia>
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
 <158398472029.1307855.3111787514328025615.stgit@magnolia>
 <20200312104929.GF60753@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312104929.GF60753@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 06:49:29AM -0400, Brian Foster wrote:
> On Wed, Mar 11, 2020 at 08:45:20PM -0700, Darrick J. Wong wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > we need to name the btree cursor private structures to be able
> > to pull them out of the deeply nested structure definition they are
> > in now.
> > 
> > Based on code extracted from a patchset by Darrick Wong.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.h |   36 +++++++++++++++++++++---------------
> >  1 file changed, 21 insertions(+), 15 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 12a2bc93371d..9884f543eb51 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -188,6 +188,24 @@ union xfs_btree_cur_private {
> >  	} abt;
> >  };
> >  
> > +/* Per-AG btree information. */
> > +struct xfs_btree_cur_ag {
> > +	struct xfs_buf			*agbp;
> > +	xfs_agnumber_t			agno;
> > +	union xfs_btree_cur_private	priv;
> > +};
> > +
> > +/* Btree-in-inode cursor information */
> > +struct xfs_btree_cur_ino {
> > +	struct xfs_inode	*ip;
> > +	int			allocated;
> > +	short			forksize;
> > +	char			whichfork;
> > +	char			flags;
> > +#define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)
> > +#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
> > +};
> > +
> 
> Are all of the per-field comments dropped intentionally? These are
> mostly self-explanatory, so either way:

I think the comments were not that valuable, and that I can perhaps
improve them:

/* We are converting a delalloc reservation */
#define	XFS_BTCUR_BMBT_WASDEL		(1 << 0)

/* For extent swap, ignore owner check in verifier */
#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)

Anyway, thanks for reviewing this series.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  /*
> >   * Btree cursor structure.
> >   * This collects all information needed by the btree code in one place.
> > @@ -209,21 +227,9 @@ typedef struct xfs_btree_cur
> >  	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
> >  	int		bc_statoff;	/* offset of btre stats array */
> >  	union {
> > -		struct {			/* needed for BNO, CNT, INO */
> > -			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
> > -			xfs_agnumber_t	agno;	/* ag number */
> > -			union xfs_btree_cur_private	priv;
> > -		} bc_ag;
> > -		struct {			/* needed for BMAP */
> > -			struct xfs_inode *ip;	/* pointer to our inode */
> > -			int		allocated;	/* count of alloced */
> > -			short		forksize;	/* fork's inode space */
> > -			char		whichfork;	/* data or attr fork */
> > -			char		flags;		/* flags */
> > -#define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)		/* was delayed */
> > -#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)		/* for ext swap */
> > -		} bc_ino;
> > -	};				/* per-btree type data */
> > +		struct xfs_btree_cur_ag	bc_ag;
> > +		struct xfs_btree_cur_ino bc_ino;
> > +	};
> >  } xfs_btree_cur_t;
> >  
> >  /* cursor flags */
> > 
> 
