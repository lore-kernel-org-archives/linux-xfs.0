Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EF8C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 18:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4648E20825
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 18:42:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e4JS+P6J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgJ2SmD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 14:42:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56578 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJ2SmD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 14:42:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TITkCV071273;
        Thu, 29 Oct 2020 18:42:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=E6aPN8RHQ5/uHQcXh6d2e3TvuCSxwTT3C1jmt6Xw/WY=;
 b=e4JS+P6JOoswFwmTLtVLfJwBAhkEII3qhxkJbgMlAfTNvS9vAckiDXui67Z017A6us4q
 5tJkdZ7vMtiFwmOeqPspQTBXrZdOFUFh6leNeF4qNkJxBc+eulnDee8pV1zNdIr5hLQ9
 /TQD6rrwCHGc8qiH2EbJXv7O/M35avRrqw1Mphs6CI3E2FYT0MfPCEqi+VErPXnOCIfP
 RTgIdD5W20X5mxZKoG1/6qvZzmq8Hr0rkKXCFqIdvDpussSFCS7h0ijy/a1m5gTghRWL
 yLxOe7summOByEb9gVFJlQ2NLntTMe/nlkJ2yAbXd1POtIrHwWtMMKSk9+VPl2BBSNkt 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7m6ed5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 18:42:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TIUW2a104219;
        Thu, 29 Oct 2020 18:42:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwuq3wwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 18:42:00 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TIfwAr020054;
        Thu, 29 Oct 2020 18:41:58 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 11:41:58 -0700
Date:   Thu, 29 Oct 2020 11:41:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: add an ls command
Message-ID: <20201029184157.GY1061252@magnolia>
References: <160375514873.880118.10145241423813965771.stgit@magnolia>
 <160375516100.880118.14555322605178437533.stgit@magnolia>
 <20201028012703.GA7391@dread.disaster.area>
 <20201028225046.GF1061252@magnolia>
 <20201028232056.GB7391@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028232056.GB7391@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 10:20:56AM +1100, Dave Chinner wrote:
> On Wed, Oct 28, 2020 at 03:50:46PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 28, 2020 at 12:27:03PM +1100, Dave Chinner wrote:
> > > On Mon, Oct 26, 2020 at 04:32:41PM -0700, Darrick J. Wong wrote:
> > > > +	hash = libxfs_dir2_hashname(mp, &xname);
> > > > +
> > > > +	dbprintf("%-18llu %-14s 0x%08llx %3d %s", ino, dstr, hash, xname.len,
> > > > +			display_name);
> > > > +	if (!good)
> > > > +		dbprintf(_(" (corrupt)"));
> > > > +	dbprintf("\n");
> > > 
> > > Can we get this to emit the directory offset of the entry as well?
> > 
> > Er... I think so.  Do you want to report the u32 value that gets loaded
> > in ctx->pos?  Or the actual byte offset within the directory?
> 
> I'd suggest that it should be the same as the telldir cookie that is
> returned by the kernel for the given entry.

Done.

> > > > +	} else if (direct || !S_ISDIR(VFS_I(dp)->i_mode)) {
> > > > +		/* List the directory entry associated with a single file. */
> > > > +		char		inum[32];
> > > > +
> > > > +		if (!tag) {
> > > > +			snprintf(inum, sizeof(inum), "<%llu>",
> > > > +					(unsigned long long)iocur_top->ino);
> > > > +			tag = inum;
> > > > +		} else {
> > > > +			char	*p = strrchr(tag, '/');
> > > > +
> > > > +			if (p)
> > > > +				tag = p + 1;
> > > > +		}
> > > > +
> > > > +		dir_emit(mp, tag, -1, iocur_top->ino,
> > > > +				libxfs_mode_to_ftype(VFS_I(dp)->i_mode));
> > > 
> > > I'm not sure what this is supposed to do - we turn the current inode
> > > if it's not a directory into a -directory entry- without actually
> > > know it's name? And we can pass in an inode that isn't a directory
> > > and do the same? This doesn't make a huge amount of sense to me - it
> > > tries to display the inode number as a dirent?
> > 
> > I added this (somewhat confusing) ability so that fstests could resolve
> > a path to an inode number without having to dig any farther into the
> > disk format.
> > 
> > IOWs, you can do:
> > 
> > ino=$(_scratch_xfs_db -c 'ls -d /usr/bin/bash')
> >
> > to get the inode number directly.  Without this, you'd have to do
> > something horrible like this...
> 
> You mean:
> 
> $ ls -i /bin/bash | cut -f 1 -d " "
> 175492
> $
> 
> i.e. if you want to provide the inode number rather than just the
> path, then let's use the same names as a real ls  implementation :)

Done.  The option is now -i instead of -d.

> > To map a path to an inode number.  I thought it made a lot more sense to
> > do that in C (even if it makes the xfs_db CLI a little weird) than
> > implement a bunch of string parsing after the fact.
> 
> I also suspect it would be simpler to separate it out into two
> functions rather than the way it is implemented now....

Done.

--D

> > Maybe I should just simplify it to "display the inode number of whatever
> > the path resolves to" instead of constructing an artificial directory
> > entry.
> 
> *nod*
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
