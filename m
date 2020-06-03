Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5E7C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07AF02072F
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:14:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CZ9uBaom"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgFCAOk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 20:14:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43070 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgFCAOj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 20:14:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0530CaUS181482;
        Wed, 3 Jun 2020 00:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=s/lX/xh9JpJU2lt13VxuxuAJwZ8Q4COTQxboAluRxVM=;
 b=CZ9uBaomnzm6ippNc3Ir6WnOvAROKGuVAOgBDunkd8s6OFKqq7zJs/2YRxk7xitrvo7v
 YAPwMmfqgP7Z/wB8u/wsKFCqZzjliKRpln0kkT3h3kozpwYtZaxQosezWQmm8F7L3DA9
 PUr76cicAkMV2KIVXLrjvBPVhV2wc/qL4N/Y93J0g9t/HNcSPttNAa6lAynU+ehVpze1
 1DftCGxuok45wDKyTDlGGpmxFGb9EDZeehBubGiUPRlPQxOUNjLVir+GEdxqFNJ+UWU8
 l417f9F9VG+D+3ACmKiWQUFJQhmh2VwhKuDF1Il7JAtuz9ToCi+zQ0cuLq6TNiqmgaBQ 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31bfem6gpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 00:14:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0530DPmY120849;
        Wed, 3 Jun 2020 00:14:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31c12q1eu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 00:14:37 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0530Ea6Y002860;
        Wed, 3 Jun 2020 00:14:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 17:14:36 -0700
Date:   Tue, 2 Jun 2020 17:14:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Bypass sb alignment checks when custom values
 are used
Message-ID: <20200603001435.GT8230@magnolia>
References: <20200601140153.200864-1-cmaiolino@redhat.com>
 <20200601140153.200864-3-cmaiolino@redhat.com>
 <20200601212115.GC2040@dread.disaster.area>
 <20200602091844.nsi63ixzm6zgxy76@eorzea>
 <20200602231235.GJ2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602231235.GJ2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=1 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 09:12:35AM +1000, Dave Chinner wrote:
> On Tue, Jun 02, 2020 at 11:18:44AM +0200, Carlos Maiolino wrote:
> > Hi Dave.
> > 
> > On Tue, Jun 02, 2020 at 07:21:15AM +1000, Dave Chinner wrote:
> > > On Mon, Jun 01, 2020 at 04:01:53PM +0200, Carlos Maiolino wrote:
> > > > index 4df87546bd40..72dae95a5e4a 100644
> > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > @@ -360,19 +360,27 @@ xfs_validate_sb_common(
> > > >  		}
> > > >  	}
> > > >  
> > > > -	if (sbp->sb_unit) {
> > > > -		if (!xfs_sb_version_hasdalign(sbp) ||
> > > > -		    sbp->sb_unit > sbp->sb_width ||
> > > > -		    (sbp->sb_width % sbp->sb_unit) != 0) {
> > > > -			xfs_notice(mp, "SB stripe unit sanity check failed");
> > > > +	/*
> > > > +	 * Ignore superblock alignment checks if sunit/swidth mount options
> > > > +	 * were used or alignment turned off.
> > > > +	 * The custom alignment validation will happen later on xfs_mountfs()
> > > > +	 */
> > > > +	if (!(mp->m_flags & XFS_MOUNT_ALIGN) &&
> > > > +	    !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > > 
> > > mp->m_dalign tells us at this point if a user specified sunit as a
> > > mount option.  That's how xfs_fc_validate_params() determines the user
> > > specified a custom sunit, so there is no need for a new mount flag
> > > here to indicate that mp->m_dalign was set by the user....
> > 
> > At a first glance, I thought about it too, but, there is nothing preventing an
> > user to mount a filesystem passing sunit=0,swidth=0. So, this means we can't
> > really rely on the m_dalign/m_swidth values to check an user passed in (or not)
> > alignment values. Unless we first deny users to pass 0 values into it.
> 
> Sure we can. We do this sort of "was the mount option set" detection
> with m_logbufs and m_logbsize by initialising them to -1. Hence if
> they are set by mount options, they'll have a valid, in-range value
> instead of "-1".
> 
> That said, if you want users passing in sunit=0,swidth=0 to
> correctly override existing on-disk values (i.e. effectively mean -o
> noalign), then you are going to need to modify
> xfs_update_alignment() and xfs_validate_new_dalign() to handle
> mp->m_dalign == 0 as a valid value instead of "sunit/swidth mount
> option not set, use existing superblock values".....
> 
> IOWs, there are deeper changes needed here than just setting a new
> flag to say "mount option was set" for it to function correctly and
> consistently as you intend. This is why I think we should just fix
> this situation automatically, and not require the user to manually
> override the bad values.
> 
> Thinking bigger picture, I'd like to see the mount options
> deprecated and new xfs_admin options added to change the values on a
> live, mounted filesystem. That way users who have issues like this
> don't need to unmount the filesystem to fix it, not to mention users
> who reshape online raid arrays and grow the filesystem can also
> change the filesystem geometry without needing to take the
> filesystem offline...

TBH I've always wondered, why not let root obtain the fs geometry,
modify whatever features it wants, and then push it back to the fs to
validate and update as necessary?  In theory you could even use this for
online filesystem upgrades, should we ever again allow users to do
that...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
