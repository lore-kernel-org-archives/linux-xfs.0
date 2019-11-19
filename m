Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDA2C33C8C
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 05:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B98D4208C3
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 05:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i5hP1Qhh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfKSFgv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 00:36:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50812 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729221AbfKSFgu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 00:36:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ5YTM8126226;
        Tue, 19 Nov 2019 05:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=m8vbictraLb0d54W9uZrbLRprOdayVgKj/4RdO7lW20=;
 b=i5hP1QhhGQV57FVacf3Kt/RG8BIac2Fn3aw7mCmRRqTA3q+TbsBeADi+KWO3n/sIsGlg
 Bkb+vPAWyAvHJUeYG+gss6X5O3dmVn+B3NH9q7l96Sto0Lj0I3o8oUNcu1VaLg773Uvm
 de9eO5vrJHLlCrdM7nxxuNKHfeatVuo1PJqvqqdKEyS37djNFVImu9r31X5bB4PM7frp
 LimCOAWXt1z3f38cwAyL2V3Y6xErPCLThlDQywaNn6mCmisZBqgdknEx0yWDGoO6CHI7
 D+vLwuPefj9UvenvwEQqgmK5hdxvhjEUfRdbE1r0s03jhXGPgXO1CwKavt/rFwb+Ijnj tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wa92pmh04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 05:36:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ5YOv9120269;
        Tue, 19 Nov 2019 05:34:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wc09ws9sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 05:34:41 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAJ5Ye4C032358;
        Tue, 19 Nov 2019 05:34:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 21:34:40 -0800
Date:   Mon, 18 Nov 2019 21:34:39 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
Message-ID: <20191119053439.GF6219@magnolia>
References: <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
 <20191112211153.GO4614@dread.disaster.area>
 <20191113035611.GE6219@magnolia>
 <CAOQ4uxi9vzR4c3T0B4N=bM6DxCwj_TbqiOxyOQLrurknnyw+oA@mail.gmail.com>
 <20191113045840.GR6219@magnolia>
 <CAOQ4uxh0T-cddZ9gwPcY6O=Eg=2g855jYbjic=VwihYPz2ZeBw@mail.gmail.com>
 <20191113052032.GU6219@magnolia>
 <CAOQ4uxiTRWkeM6i6tyMe5dzSN8nsR=1XZEMEwwwVJAcJNVimGA@mail.gmail.com>
 <20191118082216.GU4614@dread.disaster.area>
 <CAOQ4uxgyf7gWy0TpE8+i1cw37yH+NKsBa=ffP0rw5uLW55LwLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgyf7gWy0TpE8+i1cw37yH+NKsBa=ffP0rw5uLW55LwLw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190051
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 18, 2019 at 11:30:58AM +0200, Amir Goldstein wrote:
> On Mon, Nov 18, 2019 at 10:22 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Mon, Nov 18, 2019 at 06:52:39AM +0200, Amir Goldstein wrote:
> > > > >
> > > > > I wonder if your version has struct xfs_dinode_v3 or it could avoid it.
> > > > > There is a benefit in terms of code complexity and test coverage
> > > > > to keep the only difference between inode versions in the on-disk
> > > > > parsers, while reading into the same struct, the same way as
> > > > > old inode versions are read into struct xfs_dinode.
> > > > >
> > > > > Oh well, I can wait for tomorrow to see the polished version :-)
> > > >
> > > > Well now we noticed that Arnd also changed the disk quota structure
> > > > format too, so that'll slow things down as we try to figure out how to
> > > > reconcile 34-bit inode seconds vs. 40-bit quota timer seconds.
> > > >
> > > > (Or whatever happens with that)
> > > >
> > >
> > > Sigh. FWIW, I liked Arnd's 40-bit inode time patch because it
> > > keeps the patch LoC for this conversion minimal.
> >
> > We can extend the quota warning range without changing the on-disk
> > structures, and with much less code than changing the on-disk
> > structures.
> >
> > We only need a ~500 year range for the warning expiry timestamp, and
> > we don't really care about fine grained resolution of the timer
> > expiry.
> >
> > We've already got a 70 year range with the signed second counter. So
> > let's just redefine the timeout value on disk to use units of 10s
> > instead of 1s when the bigtime superblock feature bit is set. ANd
> > now we have our >500 year range requirement.
> >
> > That shouldn't need much more than 5-10 lines of new code
> > translating the units when we read/write them from/to disk....
> >
> 
> Sounds good.
> 
> What is your take on the issue of keeping struct xfs_dinode
> and struct xfs_log_dinode common to v3..v4?
> 
> If we make struct xfs_timestamp_t/xfs_ictimestamp_t a union
> of {{t_sec32;t_nsec32}, {t_nsec64}} then xfs_log_dinode_to_disk()
> conversion code is conditional to di_version.
> If we store v4 on-disk as {t_nsec32_hi;t_nsec32_lo} then the
> conversion code from disk to log is unconditional to di_version.
> 
> Am I overthinking this?

Probably not.  I changed both disk and log inodes to a union of the old
timestamp struct and a t_nsec64 (as you put it) and it works fine.

The quota timers I've simply reduced the timer resolution from 1s to 4s
to get us an extra two bits, and added a full-size in-core dquot timer
so that we only lose resolution if the fs gets unmounted.  It's kind of
a dirty trick, though.

> Darrick,
> 
> I am assuming you are working on the patch.
> If you would like me to re-post my patch with the decided
> on-disk formats for inode and a quota patch let me know.

Still working on it.  In the meantime, I have a question for you and
Arnd: I've started writing more fstests.  How does userspace query the
kernel to find out the supported range of timestamps?  fstests currently
hardcodes it, but yuck.  XFS could find an ioctl/sysfs knob to export
that info, but it really belongs in statvfs or something.

--D

> Thanks,
> Amir.
