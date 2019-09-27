Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DE2C4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 02:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFE0D20872
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 02:59:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UkrDmc5F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfI0C7J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 22:59:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53532 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfI0C7J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 22:59:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8R2wwsT083815;
        Fri, 27 Sep 2019 02:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=o7W2+nJPzmDSm610oXs5+Tsu30TXyM83NBgMAOrTeO8=;
 b=UkrDmc5FHh0Di8jxZOVBfuPB35E5iW8Bpumgk7k/D9+rIpX/rj9/E9XYBr3ljRL4dp4i
 nq/VE/BWHh2U5OTDFFswlQxGEXAmEOEa9xnAo5pMcNW8RwLi6KV+HiOz4SQ73kz/MvLG
 0mWgwGNHGy0ZBolUnbmyyv7B0N7uXlWs/cSuLomovuJ2x5yjM1KXHtY7UctpQc3draPy
 2pKwVkQuo6oC7us/3utbXFmud7QsPlMhfQqvrmqu88hoxEyB6vL6tmRohsEIFq+wJWOH
 TI+Z6dTO3RXxbji/sUwzcEoAf+Fd9CzSfox+RmPdWqmBC18TD5I0t9LqjJHm3yJ3elnj Aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v5b9u7cg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 02:59:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8R2x2pR125975;
        Fri, 27 Sep 2019 02:59:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v8yjy55uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 02:59:02 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8R2wwf8025859;
        Fri, 27 Sep 2019 02:58:59 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 19:58:58 -0700
Date:   Thu, 26 Sep 2019 19:58:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: calculate iext tree geometry in btheight
 command
Message-ID: <20190927025857.GK9916@magnolia>
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765991.303060.7541074919992777157.stgit@magnolia>
 <20190926214102.GK16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926214102.GK16973@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909270028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909270028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 27, 2019 at 07:41:02AM +1000, Dave Chinner wrote:
> On Wed, Sep 25, 2019 at 02:40:59PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > (Ab)use the btheight command to calculate the geometry of the incore
> > extent tree.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  db/btheight.c |   87 +++++++++++++++++++++++++++++++++++++++------------------
> >  1 file changed, 60 insertions(+), 27 deletions(-)
> > 
> > 
> > diff --git a/db/btheight.c b/db/btheight.c
> > index e2c9759f..be604ebc 100644
> > --- a/db/btheight.c
> > +++ b/db/btheight.c
> > @@ -22,18 +22,37 @@ static int rmap_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
> >  	return libxfs_rmapbt_maxrecs(blocklen, leaf);
> >  }
> >  
> > +static int iext_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
> > +{
> > +	blocklen -= 2 * sizeof(void *);
> > +
> > +	return blocklen / sizeof(struct xfs_bmbt_rec);
> > +}
> 
> This isn't correct for the iext nodes. They hold 16 key/ptr pairs,
> not 15.
> 
> I suspect you should be lifting the iext btree format definitions
> like this one:
> 
> enum {                                                                           
>         NODE_SIZE       = 256,                                                   
>         KEYS_PER_NODE   = NODE_SIZE / (sizeof(uint64_t) + sizeof(void *)),       
>         RECS_PER_LEAF   = (NODE_SIZE - (2 * sizeof(struct xfs_iext_leaf *))) /   
>                                 sizeof(struct xfs_iext_rec),                     
> };                                                                               
> 
> from libxfs/xfs_iext_tree.c to a libxfs header file and then using
> KEYS_PER_NODE and RECS_PER_LEAF here. See the patch below, lifted
> from a varaint of my range locking prototypes...
> 
> However, these are not on-disk values and so are subject to change,
> hence it may be that a warning might be needed when xfs_db is used
> to calculate the height of this tree.

Er... I don't mind lifting the iext values, but I don't see a patch?

--D

> > +static int disk_blocksize(struct xfs_mount *mp)
> > +{
> > +	return mp->m_sb.sb_blocksize;
> > +}
> > +
> > +static int iext_blocksize(struct xfs_mount *mp)
> > +{
> > +	return 256;
> > +}
> 
> NODE_SIZE....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
