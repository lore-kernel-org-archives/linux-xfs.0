Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7757BCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46E3D2085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:10:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ra/3/by2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfKAWKf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:10:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50206 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:10:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1M9vEr136068;
        Fri, 1 Nov 2019 22:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=/MQFCI3dROR5jgiSSxuFOMw21zyIzui7MUJ55FOFi64=;
 b=Ra/3/by2pjKuroYoyT/W+bPKR7KS+RF6vYTAK37Z3Cps51LTjKN4uU+OgZ4qviXzQ6jF
 uBwBsnY2naGqvKxs2YynBFrZyDROcq7+Iz2lMRbAkx7WayLkrK3wk/QlCBWtAZV54uV6
 105luG4ChP8lCRX2k5nS1zBtynDRbzP99GvbeyYAKrwMEL+cfk6iFkYeiERWJiTXJFpM
 zFg7u/DvYzY3ZIbwJ69EGf0AcVWei0r/BRQ///nsXRpinXsjkI5JgGw7ZaM67TcN80y6
 rE5jXUNL/6GTqHH75SH39s8iu2AgSR4aFc8w4ytM4o02Jh5BAXDfa1tAPIIF84yq1MET Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vxwhg49b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 22:10:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1M7TIX079136;
        Fri, 1 Nov 2019 22:10:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w0utgv0d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 22:10:32 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA1MAVmD030873;
        Fri, 1 Nov 2019 22:10:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 15:10:30 -0700
Date:   Fri, 1 Nov 2019 15:10:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_scrub: create a new category for unfixable errors
Message-ID: <20191101221030.GL15222@magnolia>
References: <157177012894.1460394.4672572733673534420.stgit@magnolia>
 <157177017442.1460394.7425325906254151917.stgit@magnolia>
 <83c8754e-acbf-4046-0ace-09bd4ebfa823@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83c8754e-acbf-4046-0ace-09bd4ebfa823@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010204
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 04:32:28PM -0500, Eric Sandeen wrote:
> On 10/22/19 1:49 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There's nothing that xfs_scrub (or XFS) can do about media errors for
> > data file blocks -- the data are gone.  Create a new category for these
> > unfixable errors so that we don't advise the user to take further action
> > that won't fix the problem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> are "unfixable errors" /exclusively/ file data media errors?

The intent behind this new classification is for things that we can't
ever fix or rebuild in the filesystem.  However, at least for now, file
data loss is the only source of unfixable errors.

> > diff --git a/scrub/phase4.c b/scrub/phase4.c
> > index 1cf3f6b7..a276bc32 100644
> > --- a/scrub/phase4.c
> > +++ b/scrub/phase4.c
> > @@ -99,7 +99,10 @@ xfs_process_action_items(
> >  	workqueue_destroy(&wq);
> >  
> >  	pthread_mutex_lock(&ctx->lock);
> > -	if (moveon && ctx->corruptions_found == 0 && want_fstrim) {
> > +	if (moveon &&
> > +	    ctx->corruptions_found == 0 &&
> > +	    ctx->unfixable_errors == 0 &&
> > +	    want_fstrim) {
> >  		fstrim(ctx);
> >  		progress_add(1);
> >  	}
> 
> 
> why would a file data media error preclude fstrim?

If there's even the slightest hint of things still being wrong with the
filesystem or the underlying storage, we should avoid writing to the
storage (e.g. FITRIM) because that could screw things up even more.

Note that this fstrim happens at the end of phase 4, so that means that
if we have any corruptions or unfixable errors at this point, they're in
the metadata, our attempts to fix them have failed, and so we absolutely
should not go writing more things to the disk.

> > diff --git a/scrub/phase5.c b/scrub/phase5.c
> > index dc0ee5e8..e0c4a3df 100644
> > --- a/scrub/phase5.c
> > +++ b/scrub/phase5.c
> > @@ -336,7 +336,7 @@ xfs_scan_connections(
> >  	bool			moveon = true;
> >  	bool			ret;
> >  
> > -	if (ctx->corruptions_found) {
> > +	if (ctx->corruptions_found || ctx->unfixable_errors) {
> >  		str_info(ctx, ctx->mntpoint,
> >  _("Filesystem has errors, skipping connectivity checks."));
> 
> why would a file data media error stop the connectivity check?

It won't, because the media scan happens during phase 6.

> unless "unfixable" may be other types, in which case it makes sense.

They will, presumably.  For an unfixable error to stop the connectivity
checks (phase 5), the unfixable error would have to be observed during
phases 1-4.  Those first four phases exclusively look for (and repair)
internal fs metadata, so if we reach phase 5 with an unfixable error
that means the fs metadata are trashed and xfs_scrub is going to fail
anyway.

Note that I haven't actually tried to write a directory repair function
yet.  The last time I asked viro about it he wondered what in the hell I
was going to do about the dentry cache and doubted that it could be
done... so either I have to prove him wrong, or maybe directories /will/
become the first source of unfixable errors for phase 1-4.

So yes, the 'unfixable' category is supposed to be broad enough to cover
more than just file data loss, though for now it's only used for that.

--D

> But the commit log indicates it's just for a file data media error.
> 
> What's the intent?
>
> -Eric
