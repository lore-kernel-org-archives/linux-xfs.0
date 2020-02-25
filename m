Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F4FC35E09
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E60C82176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:14:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SeEEHSCI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbgBYPOf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 10:14:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730753AbgBYPOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 10:14:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PF7lB3042816;
        Tue, 25 Feb 2020 15:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=1lqvcC0883CsMc3zcShtRB3ikFxpvADmec9UNRUoElo=;
 b=SeEEHSCIcS6WahYuHLdkIBRyPlHWVqurdf7n1yHXMvGhiTDrQFlEmBbPGcxPCEL/mk2n
 x3f0nLAI2r8DMCv0YC7hKqLKQvkddwJm0V2HGy7HH7YOkAi2Wb/QJMXHVw04j4a98WAL
 tIuHyh2TjRdxsIpirgaHyoZzbwg7VCe0mrB25OTzcraR4FTlEkdv465HGXw7UsTBZ0zz
 IlLF1NB4YB1B2bcK39ZYzVRbiaPCXhqTWxnjRArYAuuQf9mZWQ9UQFyAL1mU+aLQvoE0
 gf3AosnGyCzg4tDykFcY/COIlqWL1IvAHjiwRnZUgZybYmLmRHODXBmUAzAWDLsatIWo 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yd093j6eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 15:14:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PFESxV166699;
        Tue, 25 Feb 2020 15:14:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yd0vug6qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 15:14:30 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PFESHJ023155;
        Tue, 25 Feb 2020 15:14:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 07:14:27 -0800
Date:   Tue, 25 Feb 2020 07:14:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs_repair: check that metadata updates have been
 committed
Message-ID: <20200225151426.GC6748@magnolia>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
 <158258946575.451075.126426300036283442.stgit@magnolia>
 <20200225150817.GC26938@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225150817.GC26938@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 mlxlogscore=999 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 10:08:17AM -0500, Brian Foster wrote:
> On Mon, Feb 24, 2020 at 04:11:05PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure that any metadata that we repaired or regenerated has been
> > written to disk.  If that fails, exit with 1 to signal that there are
> > still errors in the filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/xfs_repair.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index eb1ce546..ccb13f4a 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -703,6 +703,7 @@ main(int argc, char **argv)
> >  	struct xfs_sb	psb;
> >  	int		rval;
> >  	struct xfs_ino_geometry	*igeo;
> > +	int		error;
> >  
> >  	progname = basename(argv[0]);
> >  	setlocale(LC_ALL, "");
> > @@ -1104,7 +1105,11 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
> >  	 */
> >  	libxfs_bcache_flush();
> >  	format_log_max_lsn(mp);
> > -	libxfs_umount(mp);
> > +
> > +	/* Report failure if anything failed to get written to our fs. */
> > +	error = -libxfs_umount(mp);
> > +	if (error)
> > +		exit(1);
> 
> I wonder a bit whether repair should really exit like this vs. report
> the error as it does for most others, but I could go either way. I'll
> defer to Eric:

I suppose I could do:

	error = -libxfs_umount();
	if (error)
		do_error(_("fs unmount failed (err=%d), re-run repair!\n"),
				error);

Though then you'd end up with:

	# xfs_repair /dev/fd0
	...
	Refusing to write corrupted metadata to the data device!
	fs unmount failed (err=117), re-run repair!
	# echo $?
	1

Which seems a little redundant.  But let's see what Eric thinks.

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Anyway, thanks for reviewing!

--D

> >  
> >  	if (x.rtdev)
> >  		libxfs_device_close(x.rtdev);
> > 
> 
