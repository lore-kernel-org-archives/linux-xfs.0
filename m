Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB783C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83DBC206EE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:25:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hOpxwj1i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgAABZO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:25:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60322 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgAABZO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:25:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011P1l8097908;
        Wed, 1 Jan 2020 01:25:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=17OaAkiG5/e3+L61kIrXiteAO8dYOPUEgVPBEWkbmCY=;
 b=hOpxwj1ihbq+re28oumGfkvJGDvdmOTDuIbfs2AlOtXt+BsW2VT6BJdwTPvM8Y40jyv4
 sD+Fu7auv6A+n1ZWmZuvbprhKTStssl2ZhMLs1T9Eve7HVFYhVftem1RM2NsiLqqBlTw
 czRsTspm4EhIsAjSm1/Q0H7N0En1JLOcTRmI6Sf0r3fzFoHMjAusZR6X1TELXaKeCbmx
 E3GrkQ8xMa15/kj/UMe7RhHeM8qvibIugFhL2YVAnrEIEKpMgMFi4nXSXqXzGMAns/L3
 Pqup088muy1AzfITtYommtJdipJbWyx9dSEJv0/WF2JYDSHilAz7Tz2qBRHTBUy5kMPW 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjyaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:25:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011NRCi012894;
        Wed, 1 Jan 2020 01:25:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2x8bsrg94p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:25:10 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011P9Dm002323;
        Wed, 1 Jan 2020 01:25:09 GMT
MIME-Version: 1.0
Message-ID: <6b5080eb-cb85-4504-a13b-bf9d90e4ad0d@default>
Date:   Tue, 31 Dec 2019 17:25:08 -0800 (PST)
From:   Darrick Wong <darrick.wong@oracle.com>
To:     <linux-xfs@vger.kernel.org>
Cc:     <djwong@kernel.org>
Subject: 2019 NYE Patchbomb Guide!
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

It's still the last day of 2019 in the US/Pacific timezone, which means
it's time for me to patchbomb every new feature that's been sitting
around in my development trees!  As you know, all of my development
branches are kept freshly rebased on the latest Linus kernel so that I
can send them all at a moment's notice.  Once a year I like to dump
everything into the public archives to increase XFS' bus factor.

To make things easier for everyone, I'm sending this short note to help
readers figure out how each of the major branches depend on each other.
The branch mentioned on any line within one of the small lists depends
on the branches mentioned in the previous lines.  Separation between
lists indicate lack of a hard dependency between branches, except as
noted.  For the kernel, this looks like:

btree-bulk-loading=09=09("xfs: btree bulk loading")
repair-reap-fixes=09=09("xfs: fix online repair block reaping")
repair-bitmap-rework=09=09("xfs: rework online repair incore bitmap")
repair-prep-for-bulk-loading=09("xfs: prepare repair for bulk loading")

These four series have been out for review before; they're the prep work
needed to land the next four, which implement the easier parts of online
fsck:

repair-ag-btrees=09=09("xfs: online repair of AG btrees")
repair-inodes=09=09=09("xfs: online repair of inodes and extent maps")
repair-inode-data=09=09("xfs: online repair of inode data")
repair-quota=09=09=09("xfs: online repair of quota")

This next series ties corruption reporting to the health reporting
subsystem so that we can enable targeted spot repairs of filesystems in
the next phase of xfs_scrub development.  It isn't dependent upon any
previous series (though I think it still needs some more work).

corruption-health-reports=09("xfs: report corruption to the health trackers=
")

We now turn our attention to the longstanding problem that inode
inactivation can require on-disk metadata updates, which are very time
consuming.  This is the root cause of all the complaints on the mailing
list about kernel memory reclamation stalling behind XFS.  There's no
hard dependency between these series and any of the ones before it.

incore-inode-walk=09=09("xfs: refactor incore inode walking")
reclaim-space-harder=09=09("xfs: try harder to reclaim space when we run ou=
t")
eofblocks-consolidation=09=09("xfs: consolidate posteof and cowblocks clean=
up")
deferred-inactivation=09=09("xfs: deferred inode inactivation")

These next two series tackle some harder repair problems (namely the
ones that require full filesystem scans).  These scans depend upon being
able to shut down background operations temporarily; these two series
actually /do/ depend on the previous four series.

indirect-health-reporting=09("xfs: indirect health reporting")
repair-hard-problems=09=09("xfs: online repair of rmap/quota/summary counte=
rs")

These next two branches are grouped together because they involve
on-disk format changes.  One will reduce mount time on finobt=3D1
filesystems; the other aims to guarantee that XFS will continue to work
with timestamps through year 2485.  They have no hard dependencies on
the previous series.

inobt-counters=09=09=09("xfs: add a inode btree blocks counts to the AGI he=
ader")
bigtime=09=09=09=09("xfs: widen timestamps to deal with y2038")

These next two series introduce the metadata directory tree, which will
enable us to add new metadata type without filling up more of the
superblock.  They don't rely much on any of the previous series, but
they're not immediately applyable unless you've already applied the
other patches that touch the inode code.

inode-refactor=09=09=09("xfs: hoist inode operations to libxfs")
metadir=09=09=09=09("xfs: metadata inode directories")

This last series uses the metadata directory tree functionality to add
reverse mapping abilities to the realtime volume.  It's the precursor to
supporting reflink and COW on the realtime device.

realtime-rmap=09=09=09("xfs: realtime reverse-mapping support")

=3D=3D=3D=3D=3D=3D=3D=3D

For xfsprogs, the series look like this:

libfrog-fixes=09=09=09("libfrog: various small fixes")
random-fixes=09=09=09("xfsprogs: random fixes")

Thse two series apply cleanups to xfsprogs.

repair-find-rootdir=09=09("xfs_repair: do not trash valid root dirs")

This series attempts to fix xfs_repair so it doesn't toss the root
directory when someone applied an improper sunit change via mount
option.

btree-bulk-loading=09=09("libxfs: btree bulk loading")
repair-ag-btrees=09=09("libxfs: online repair of AG btrees")
repair-inodes=09=09=09("libxfs: online repair of inodes and extent maps")
repair-inode-data=09=09("libxfs: online repair of inode data")

This series refactors repair to use the btree bulk loading code from
above.

repair-bulk-load=09=09("xfs_repair: use btree bulk loading")

This series teaches repair to use rmap data to rebuild inode extent
mappings using the btree bulk loading code from above.

repair-rebuild-forks=09=09("xfs_repair: rebuild inode fork mappings")

The rest of these are partly ports of the kernel code and minimal
updates to the existing utilities to enable those new features.

corruption-health-reports=09("xfs: report corruption to the health trackers=
")
indirect-health-reporting=09("libxfs: indirect health reporting")
repair-hard-problems=09=09("libxfs: online repair of rmap/quota/summary cou=
nters")
inobt-counters=09=09=09("xfs: add a inode btree blocks counts to the AGI he=
ader")
bigtime=09=09=09=09("xfs: widen timestamps to deal with y2038")
inode-refactor=09=09=09("xfsprogs: hoist inode operations to libxfs")
metadir=09=09=09=09("xfsprogs: metadata inode directories")
realtime-rmap=09=09=09("xfsprogs: realtime reverse-mapping support")

Finally, here are a couple more packging cleanups and fixes for
mkfs protofile support that might get dropped later.

packaging-cleanups=09=09("xfsprogs: packaging cleanups")
bmap-utils=09=09=09("xfsprogs: bmap utility refactoring")

=3D=3D=3D=3D=3D=3D=3D=3D

For what it's worth, here are a few notable things sitting in my fstests
development tree.  I didn't send any of these to the list.

These three series are tests for things that have either gone in
recently or are nearly in.

scrub-media-error-reporting=09("xfs: test xfs_scrub media scan")
online-label-setting=09=09("xfs_admin: unify online/offline fs label settin=
g")
repair-find-rootdir=09=09("xfs_repair: do not trash valid root dirs")

And these three are for the new features mentioned above.

bigtime=09=09=09=09("xfs: widen timestamps to deal with y2038")
metadir=09=09=09=09("xfs: fixes for metadata directories")
fuzz-baseline=09=09=09("xfs: establish baseline for fuzz tests")

With that, I hope you all have a happy new year!  See you in 2020/4717!

--D
