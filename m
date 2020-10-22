Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE23BC388F7
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 15:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9426120770
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 15:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="puPFbUVn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508526AbgJVPxb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 11:53:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39156 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2508519AbgJVPxb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 11:53:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MFiNKa107870;
        Thu, 22 Oct 2020 15:53:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0sWgqLEsGqSJzwuFXtYXnDRKzEbT06Z/111utI9Mevs=;
 b=puPFbUVnZOiEezB9iZ2UOj0QTolqYkoj+FKerqXCYzxfQIIyxOhqcGaJDwCC96mz+IFk
 pir1vt2HV/36z/t9ehazHYXgR3/fUnPl2gBfGlvxacSrz8WSRfWNjcAzB+0ymNUj802V
 VfobPIRSAqWi1e1C7z8gQldwKXqE0G5sUsTBrqWF3OnT/aJyhIA8zhJzQdX+kplnlQgL
 efekg0TT+fAPnug4MLf6JvWqPpD27u9PXOBbnBxSQMbWYH0H5yozkM8NMlP6OGXuyAoK
 F+MUoz4yEANxa0S5ZVp9cdB++yQJPIigt+99uyNTxpocpxyM8zyuncd+r0h7RMALBr7S Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34ak16q118-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 15:53:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MFjha4062072;
        Thu, 22 Oct 2020 15:53:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 348ah0yv69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 15:53:27 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09MFrQJv019583;
        Thu, 22 Oct 2020 15:53:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 08:53:25 -0700
Date:   Thu, 22 Oct 2020 08:53:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] repair: don't duplicate names in phase 6
Message-ID: <20201022155324.GS9832@magnolia>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-6-david@fromorbit.com>
 <20201022062152.GQ9832@magnolia>
 <20201022082354.GU7391@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022082354.GU7391@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=1 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220105
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 07:23:54PM +1100, Dave Chinner wrote:
> On Wed, Oct 21, 2020 at 11:21:52PM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 22, 2020 at 04:15:35PM +1100, Dave Chinner wrote:
> ....
> > > @@ -1387,6 +1371,7 @@ dir2_kill_block(
> > >  		res_failed(error);
> > >  	libxfs_trans_ijoin(tp, ip, 0);
> > >  	libxfs_trans_bjoin(tp, bp);
> > > +	libxfs_trans_bhold(tp, bp);
> > 
> > Why hold on to the buffer?  We killed the block, why keep the reference
> > around so that someone else has to remember to drop it later?
> 
> Consistency in buffer handling. This "kill block" path nulled out
> the buffer in the bplist array (the reason it's passed as a **bpp
> to longform_dir2_entry_check_data(). This path releases the buffer
> through the trans_commit(), the alternate path here:
> 
> > > @@ -1558,10 +1541,8 @@ longform_dir2_entry_check_data(
> > >  			dir2_kill_block(mp, ip, da_bno, bp);
> > >  		} else {
> > >  			do_warn(_("would junk block\n"));
> > > -			libxfs_buf_relse(bp);
> > >  		}
> > >  		freetab->ents[db].v = NULLDATAOFF;
> > > -		*bpp = NULL;
> > >  		return;
> > >  	}
> 
> does an explicit release, and all other paths end up with the
> buffers being released way back where the bplist is defined.
> 
> If the directory is in block form, nulling out the buffer in the
> bplist here will result in dereferencing a null pointer later when
> the buffer is pulled from bplist[0] without checking.
> 
> So I changed longform_dir2_entry_check_data() to never release the
> buffer so that the caller knows that it has always got a valid
> buffer reference and the isblock path will always work correctly....

Hmmm, looking through the directory code, I see that it calls binval to
stale the buffer, so the kill_block caller won't be able to do much with
its incore reference.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Cheers,
> 
> Dave.
> 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
