Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF32EC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 18:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CBD221D93
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 18:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbhADSr2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:47:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40698 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbhADSr2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 13:47:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104IigJ8048304;
        Mon, 4 Jan 2021 18:46:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fXvJo8SxpWZWd1yzulBRLJFQxmA7GCwzWYM6vqG+l8I=;
 b=T4ltaSeZV+LjkIgSP8nBQlGrhJ0B2PHkBN9jHA0CWSWePmtTBIT9Aq5BCTM1zKaYPRgs
 G04N9+z26RaBtQ1ra0OGdqVYSb5sALPfvQPQ5UR4tpDAD4xF7razo7IO3R0t61viTy9J
 9o5glBimBavNoVp9jTPEPEsvIysgYLckD/GSvXlnyNaSC8kd9AvASm8nlMSSTRm5lFlZ
 1EIoV/8XwV3ErSVkU7vW68PrJTv96VaD0c6gw0dCnWFhX+h76qwksNTt2NU8v25FvcrQ
 wdRcTPIscRg7St4NJdT9wDC+1ZyyP/lDtHzw1UY/RLF1vhCGVdBN1gnHCKtteU/5HLmm lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35tebanre5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 04 Jan 2021 18:46:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104IShRw092376;
        Mon, 4 Jan 2021 18:44:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35uxnrjvnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jan 2021 18:44:44 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 104IihFq000575;
        Mon, 4 Jan 2021 18:44:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 10:44:43 -0800
Date:   Mon, 4 Jan 2021 10:44:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "L.A. Walsh" <xfs@tlinx.org>, xfs-oss <linux-xfs@vger.kernel.org>
Subject: Re: suggested patch to allow user to access their own file...
Message-ID: <20210104184442.GM6918@magnolia>
References: <5FEB204B.9090109@tlinx.org>
 <20210104170815.GB254939@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104170815.GB254939@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 clxscore=1011 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 04, 2021 at 12:08:15PM -0500, Brian Foster wrote:
> On Tue, Dec 29, 2020 at 04:25:47AM -0800, L.A. Walsh wrote:
> > xfs_io checks for CAP_SYS_ADMIN in order to open a
> > file_by_inode -- however, if the file one is opening
> > is owned by the user performing the call, the call should
> > not fail.
> > 
> > (i.e. it opens the user's own file).
> > 
> > patch against 5.10.2 is attached.
> > 
> > It gets rid of some unnecessary error messages if you
> > run xfs_restore to restore one of your own files.

No S-o-B on the patch so I was hesitant to reply, but since Brian did,
I'll reply to that.  This message brought to you by the letters Z, F,
and S.

> The current logic seems to go a ways back. Can you or somebody elaborate
> on whether there's any risks with loosening the permissions as such?

This would open a huge security hole because users can use it to bypass
directory access checks.

Let's say I have a file /home/djwong/bin/pwnme that can be read or
written by the evil bitcom miner in my open Firefox process.  (Hey,
browsers can flash USB device firmware now, ~/bin is the least of my
problems!)

Then let's say the BOFH decides I'm too much of a security risk and
issues:

$ sudo chmod 0000 /home/djwong/bin; sudo chown root:root /home/djwong/bin

(Our overworked BOFH forgot -r and only changed ~/bin.)

Now I cannot access pwnme anymore, because I've been cut off from ~/bin.

With the below patch applied I can now bypass that restriction because I
still own ~/bin/pwnme and therefore can (now) open it by file handle.

We /could/ relax the check so that the caller only has to have one of
CAP_{SYS_ADMIN,DAC_READ_SEARCH,DAC_OVERRIDE} and let the sysadmin decide
if they want to bless xfsrestore with any of those capabilities...

--D

> E.g., any reason we might not want to allow regular users to perform
> handle lookups, etc.? If not, should some of the other _by_handle() ops
> get similar treatment?
> 
> > --- fs/xfs/xfs_ioctl.c	2020-12-22 21:11:02.000000000 -0800
> > +++ fs/xfs/xfs_ioctl.c	2020-12-29 04:14:48.681102804 -0800
> > @@ -194,15 +194,21 @@
> >  	struct dentry		*dentry;
> >  	fmode_t			fmode;
> >  	struct path		path;
> > +	bool conditional_perm = 0;
> 
> Variable name alignment and I believe we try to use true/false for
> boolean values.
> 
> >  
> > -	if (!capable(CAP_SYS_ADMIN))
> > -		return -EPERM;
> > +	if (!capable(CAP_SYS_ADMIN)) conditional_perm=1;
> 
> This should remain two lines..
> 
> >  
> >  	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
> >  	if (IS_ERR(dentry))
> >  		return PTR_ERR(dentry);
> >  	inode = d_inode(dentry);
> >  
> > +	/* only allow user access to their own file */
> > +	if (conditional_perm && !inode_owner_or_capable(inode)) {
> > +		error = -EPERM;
> > +		goto out_dput;
> > +	}
> > +
> 
> ... but then again, is there any reason we couldn't just move the
> capable() check down to this hunk and avoid the new variable?
> 
> Brian
> 
> >  	/* Restrict xfs_open_by_handle to directories & regular files. */
> >  	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
> >  		error = -EPERM;
> 
