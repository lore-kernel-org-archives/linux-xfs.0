Return-Path: <SRS0=drEG=3Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D46C2D0DB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B48C524676
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GqkxmQTC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgA0Q5f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jan 2020 11:57:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45608 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgA0Q5f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jan 2020 11:57:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00RGcJMX086230;
        Mon, 27 Jan 2020 16:57:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=o952mxisDkjRjXUnhDFKJxhcCE4N2WfBz2FmntS0G+A=;
 b=GqkxmQTCroc3IyIVOwWJC6B4P/kDxRVoDqIr2ZtXki80P2f/UfUCWRIaM0nYrA0nk5MI
 2P0YzNyNOzEuBK84945RGDeymIu0lgeDC1JxTZDZ1qxRMIt3LkeGzX0RgAlVH8qtxokj
 KnopGuQ8TvIu0HJFuZNNn6Uso1qNQWwl/COU8baDO5DCd6Z+ZYHx5zNU9jKsk4QLQiGL
 6uvQfd303Hqx5pD8r7EG+GjPKBs0l0XFucXFwgZqrhnuvqHzNdmKYOoVzv8GUiAECykl
 58KtjUhZMlZhyb889Sv2VRU5NQSsO/Z1FZKlqBoH/iVhVsyXweq3RAEcr9qsvSDgu9ZY LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xrd3u0pq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jan 2020 16:57:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00RGd2lu182921;
        Mon, 27 Jan 2020 16:57:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xrytqddr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jan 2020 16:57:30 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00RGvTnF009135;
        Mon, 27 Jan 2020 16:57:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jan 2020 08:57:29 -0800
Date:   Mon, 27 Jan 2020 08:57:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        zlang@redhat.com
Subject: Re: [PATCH v3] xfstests: xfs mount option sanity test
Message-ID: <20200127165728.GA3448165@magnolia>
References: <20200115081132.22710-1-zlang@redhat.com>
 <20200118172330.GE2149943@magnolia>
 <20200119072342.GH14282@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119072342.GH14282@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001270139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001270139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 19, 2020 at 03:23:42PM +0800, Zorro Lang wrote:
> On Sat, Jan 18, 2020 at 09:23:30AM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 15, 2020 at 04:11:32PM +0800, Zorro Lang wrote:
> > > XFS is changing to suit the new mount API, so add this case to make
> > > sure the changing won't bring in regression issue on xfs mount option
> > > parse phase, and won't change some default behaviors either.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > ---
> > > 
> > > Hi,
> > > 
> > > Thanks the suggestions from Darrick, v3 did below changes:
> > > 1) Add more debug info output in do_mkfs and do_test.
> > > 2) A new function filter_loop.
> > > 3) Update .out file content
> > > 
> > > I've simply run this case on RHEL-7, RHEL-8 and upstream 5.5-rc4 kernel,
> > > all passed.
> > 
> > Something else I noticed -- if for whatever reason the mount fails due
> > to log size checks, the kernel logs things like:
> > 
> > xfs: Bad value for 'logbufs'
> > XFS (loop0): Mounting V5 Filesystem
> > XFS (loop0): Log size 3273 blocks too small, minimum size is 3299 blocks
> > XFS (loop0): AAIEEE! Log failed size checks. Abort!
> > XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 706
> 
> Thanks Darrick, you always can find exceptions:) BTW, how to reproduce this
> error?

It's the same problem as last time -- I run upstream xfsprogs (with the
patch turning on rmap by default); and when this test runs apparently
there are logbufs options that increase the kernel's view of the minimum
log size to the point that we fail the mount time log size checks.

I observed that changing the LOOP_IMG creation code to make a 32G sparse
file results in an fs with a larger log area:

	$XFS_IO_PROG -f -c "truncate 32g" $LOOP_IMG

fixes all of these problems.  See diff below.

> Looks like I touched too many things in one case, cause I have a long way to
> make it "no exception" ;)
> 
> > 
> > Which is then picked up by the dmesg scanner in fstests.  Maybe we need
> > (a) _check_dmesg between each _do_test iteration, and/or (b) filter that
> > particular assertion so we don't fail the test?
> 
> I can add _check_dmesg between each _do_test iteration, but I have to exit
> directly if _check_dmesg returns 1, or we need a way to save each failed
> $seqres.dmesg (maybe just cat $seqres.dmesg ?)
> 
> About the dmesg filter, each _do_test can have its own filter if it need.
> For example, "logbufs" test filter "Assertion failed: 0, file: fs/xfs/xfs_log.c".
> But might that filter out useful kernel warning?
> 
> What do you think?

Eh, now that I've taken a second look at this, I don't think there's a
good way to filter this particular ASSERT vs. any other that could pop
up.

--D

diff --git a/tests/xfs/997 b/tests/xfs/997
index 6b7235dd..c5bb0e51 100755
--- a/tests/xfs/997
+++ b/tests/xfs/997
@@ -50,11 +50,11 @@ LOOP_SPARE_IMG=$TEST_DIR/$seq.logdev
 LOOP_MNT=$TEST_DIR/$seq.mnt
 
 echo "** create loop device"
-$XFS_IO_PROG -f -c "falloc 0 1g" $LOOP_IMG
+$XFS_IO_PROG -f -c "truncate 32g" $LOOP_IMG
 LOOP_DEV=`_create_loop_device $LOOP_IMG`
 
 echo "** create loop log device"
-$XFS_IO_PROG -f -c "falloc 0 512m" $LOOP_SPARE_IMG
+$XFS_IO_PROG -f -c "truncate 512m" $LOOP_SPARE_IMG
 LOOP_SPARE_DEV=`_create_loop_device $LOOP_SPARE_IMG`
 
 echo "** create loop mount point"
