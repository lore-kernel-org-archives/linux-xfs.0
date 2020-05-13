Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F07C2D0F8
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 00:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D7C7206F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 00:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BpoWNqVG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbgEMA1w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 20:27:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39168 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgEMA1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 20:27:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04D0RYEs106845;
        Wed, 13 May 2020 00:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KInEPV0DqtMcDzP+xVlBsKJ+FusaskN9mEMqV6pX1HI=;
 b=BpoWNqVGIW+H27ImdU7jr+/w3bqEP8LQTNDEuBev9x5O676hIfSQF+16btvtifWmv3yP
 geJZSFx+L6d1bSSfew84kHD15LG53oexCUVUb/K08hs43xQWPOGImdQv5cj0LgeSwWH9
 gBDlVQ3JqRU+v9L9dPxJVc2k27/HvPfo8H1FiQaeC1rsNKDsSLBfpVIgjoiTW6IO/Qjr
 j+Rh/i6vNqszg7RoKSFxUOdzURA5stsx1oshwtmai8g1ct6uMBg5PZzfyQ374Wudb8xg
 0i4ikbXXMqURv3OFH+Nm8v+DqPIME8rpumeBEKsbt2AHPFFzRbqM6yBiZ672FgKaEavn Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3100xw9c0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 00:27:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04D0Nx8I016251;
        Wed, 13 May 2020 00:25:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3100ydd9ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 00:25:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04D0Pnhp002396;
        Wed, 13 May 2020 00:25:49 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 17:25:49 -0700
Date:   Tue, 12 May 2020 17:25:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: use ordered buffers to initialize dquot buffers
 during quotacheck
Message-ID: <20200513002548.GB1984748@magnolia>
References: <20200512210033.GL6714@magnolia>
 <20200513000628.GY2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513000628.GY2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=1 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 10:06:28AM +1000, Dave Chinner wrote:
> On Tue, May 12, 2020 at 02:00:33PM -0700, Darrick J. Wong wrote:
> > @@ -277,11 +279,34 @@ xfs_qm_init_dquot_blk(
> >  		}
> >  	}
> >  
> > -	xfs_trans_dquot_buf(tp, bp,
> > -			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
> > -			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :
> > -			     XFS_BLF_GDQUOT_BUF)));
> > -	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
> > +	if (type & XFS_DQ_USER) {
> > +		qflag = XFS_UQUOTA_CHKD;
> > +		blftype = XFS_BLF_UDQUOT_BUF;
> > +	} else if (type & XFS_DQ_PROJ) {
> > +		qflag = XFS_PQUOTA_CHKD;
> > +		blftype = XFS_BLF_PDQUOT_BUF;
> > +	} else {
> > +		qflag = XFS_GQUOTA_CHKD;
> > +		blftype = XFS_BLF_GDQUOT_BUF;
> > +	}
> > +
> > +	xfs_trans_dquot_buf(tp, bp, blftype);
> > +
> > +	/*
> > +	 * If the CHKD flag isn't set, we're running quotacheck and need to use
> > +	 * ordered buffers so that the logged initialization buffer does not
> > +	 * get replayed over the delwritten quotacheck buffer.  If we crash
> > +	 * before the end of quotacheck, the CHKD flags will not be set in the
> > +	 * superblock and we'll re-run quotacheck at next mount.
> > +	 *
> > +	 * Outside of quotacheck, dquot updates are logged via dquot items and
> > +	 * we must use the regular buffer logging mechanisms to ensure that the
> > +	 * initial buffer state is recovered before dquot items.
> > +	 */
> > +	if (mp->m_qflags & qflag)
> > +		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
> > +	else
> > +		xfs_trans_ordered_buf(tp, bp);
> >  }
> 
> That comment is ... difficult to understand. It conflates what we
> are currently doing with what might happen in future if we did
> something differently at the current time. IIUC, what you actually
> mean is this:
> 
> 	/*
> 	 * When quotacheck runs, we use delayed writes to update all the dquots
> 	 * on disk in an efficient manner instead of logging the individual
> 	 * dquot changes as they are made.
> 	 *
> 	 * Hence if we log the buffer that we allocate here, then crash
> 	 * post-quotacheck while the logged initialisation is still in the
> 	 * active region of the log, we can lose the information quotacheck
> 	 * wrote directly to the buffer. That is, log recovery will replay the
> 	 * dquot buffer initialisation over the top of whatever information
> 	 * quotacheck had written to the buffer.
> 	 *
> 	 * To avoid this problem, dquot allocation during quotacheck needs to
> 	 * avoid logging the initialised buffer, but we still need to have
> 	 * writeback of the buffer pin the tail of the log so that it is
> 	 * initialised on disk before we remove the allocation transaction from
> 	 * the active region of the log. Marking the buffer as ordered instead
> 	 * of logging it provides this behaviour.
> 	 */

That's certainly a /lot/ clearer. :)

> Also, does this mean quotacheck completion should force the log and push the AIL
> to ensure that all the allocations are completed and removed from the log before
> marking the quota as CHKD?

I need to think about this more, but I think the answer is that we don't
need to force/push the log because the delwri means we've persisted the
new dquot contents before we set CHKD, and if we crash before we set
CHKD, on the next mount attempt we'll re-run quotacheck, which can
reallocate or reinitialize the ondisk dquots.

But I dunno, maybe there's some other subtlety I haven't thought of...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
