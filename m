Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263BAC432C0
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 00:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E23ED20675
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 00:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eTAvIVaR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfLDAMG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 19:12:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42836 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfLDAMG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 19:12:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3NU2qA167229;
        Wed, 4 Dec 2019 00:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=1rs+Cn7pLvm9Iyo9HoPo0/OaQhiJmVefVu3u8G34df4=;
 b=eTAvIVaRtDmY8fEnUeykv9oQbY8veFbxa/M31/Z7jTwTkndvAl2BfDu0yAKNSTcS35Mf
 NeFffC6oLnInyhN2bgVvawmLqVdF9Ogm8f9OYsFwk7Tm37YN41jPqfDwt1ZOJeS2nWJD
 YsgbnR806Ri1EeXlxBOz1NpCy6v5qj0W7XvClS0AUwF7lhc/Q9jotA139q8vLii15mwK
 hQWtT4kdmov2YFfI7SRfe85AjzUibH24JQyoAzYfXwiub2eUQaSBp5tumB3bnJVAXwuU
 tooCacFjOItmYBO/9JY4oO2099h6Z47NBX/eqmZ3v7XNAN1qW1IpbEuonhFpM1zBHdPs iA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wkfuub9sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 00:12:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3NTK3b007505;
        Wed, 4 Dec 2019 00:12:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wnvqx8vdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 00:12:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB40BvLw029214;
        Wed, 4 Dec 2019 00:11:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 16:11:56 -0800
Date:   Tue, 3 Dec 2019 16:11:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 4/4] xfs_repair: check plausiblitiy of root dir pointer
Message-ID: <20191204001156.GM7335@magnolia>
References: <157530815855.126767.7523979488668040754.stgit@magnolia>
 <157530818573.126767.13434243816626977089.stgit@magnolia>
 <20191203130306.GB18418@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203130306.GB18418@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 03, 2019 at 08:03:06AM -0500, Brian Foster wrote:
> On Mon, Dec 02, 2019 at 09:36:25AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If sb_rootino doesn't point to where we think mkfs was supposed to have
> > preallocated an inode chunk, check to see if the alleged root directory
> > actually looks like a root directory.  If so, we'll let it go because
> > someone could have changed sunit since formatting time.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/xfs_repair.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 49 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index 6798b88c..f6134cca 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -395,12 +395,60 @@ do_log(char const *msg, ...)
> >  	va_end(args);
> >  }
> >  
> > +/*
> > + * If sb_rootino points to a different inode than we were expecting, try
> > + * loading the alleged root inode to see if it's a plausibly a root directory.
> > + * If so, we'll readjust the computations.
> 
> "... readjust the calculated inode chunk range such that the root inode
> is the first inode in the chunk."
> 
> > + */
> > +static void
> > +check_misaligned_root(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_inode	*ip;
> > +	xfs_ino_t		ino;
> > +	int			error;
> > +
> > +	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip,
> > +			&xfs_default_ifork_ops);
> > +	if (error)
> > +		return;
> > +	if (!S_ISDIR(VFS_I(ip)->i_mode))
> > +		goto out_rele;
> > +
> > +	error = -libxfs_dir_lookup(NULL, ip, &xfs_name_dotdot, &ino, NULL);
> > +	if (error)
> > +		goto out_rele;
> > +
> > +	if (ino == mp->m_sb.sb_rootino) {
> > +		do_warn(
> > +_("sb root inode value %" PRIu64 " inconsistent with calculated value %u but looks like a root directory\n"),
> 
> Just a nit, but I think the error would be more informative if it just
> said something like:
> 
> "sb root inode %" PRIu64 " inconsistent with alignment (expected rootino %u)."

Fixed.  Thanks for reviewing all this!

> > +			mp->m_sb.sb_rootino, first_prealloc_ino);
> > +		last_prealloc_ino += (int)ino - first_prealloc_ino;
> > +		first_prealloc_ino = ino;
> 
> Why assume ino > first_prealloc_ino? How about we just assign
> last_prealloc_ino as done in _find_prealloc()?

I think I'll just blow all that away since the {last,first}_alloc_ino
stuff seems incorrect anyway.

--D

> Brian
> 
> > +	}
> > +
> > +out_rele:
> > +	libxfs_irele(ip);
> > +}
> > +
> >  static void
> > -calc_mkfs(xfs_mount_t *mp)
> > +calc_mkfs(
> > +	struct xfs_mount	*mp)
> >  {
> >  	libxfs_ialloc_find_prealloc(mp, &first_prealloc_ino,
> >  			&last_prealloc_ino);
> >  
> > +	/*
> > +	 * If the root inode isn't where we think it is, check its plausibility
> > +	 * as a root directory.  It's possible that somebody changed sunit since
> > +	 * the filesystem was created, which can change the value of the above
> > +	 * computation.  Try to avoid blowing up the filesystem if this is the
> > +	 * case.
> > +	 */
> > +	if (mp->m_sb.sb_rootino != NULLFSINO &&
> > +	    mp->m_sb.sb_rootino != first_prealloc_ino)
> > +		check_misaligned_root(mp);
> > +
> >  	/*
> >  	 * now the first 3 inodes in the system
> >  	 */
> > 
> 
