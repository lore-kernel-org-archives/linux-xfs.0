Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C830C33CAF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 18:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52FD0207FF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 18:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZG2RzDuC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgAMSYT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:24:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgAMSYT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 13:24:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DIMrwa158280;
        Mon, 13 Jan 2020 18:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=6U3cUdwaEeXkipZCl/bjwXamk02gSV36eh2EN+g59e4=;
 b=ZG2RzDuCwnfrWW5lGh+GrnBTB8Ey/AwMT8tm6AG7c6HPg+9DmRhEJeCYVEDi/um7v0l6
 uCDBG8WoLtQ7cmTVmgxwvqocoRDld4i4U4Vrm31WAkr3/UQk7YU1IA7Sg87Oh7i0NEoy
 yQkNQ9b7lHuHgL5WlQPBu6njhHGz658tCyc/+tZfXbXbNobI/FoS9Fp510J4IAJ98Zjx
 1B+9loT95fayqlMNKFnTRkzk+jEztJoBBgxvY+ogTlc7sYJyDl+dPx6wYQ/5eeMkg3ne
 7U9FOHbLnZ5lDXa0EjhWsf9NcTwo4D1H5w9yRhaGuwd3kY8gpvPQ8eLi+dSsFmFoiJXh Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xf73tgrup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 18:24:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DINpU7011946;
        Mon, 13 Jan 2020 18:24:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xfqu4yhuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 18:24:14 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00DINvZE014281;
        Mon, 13 Jan 2020 18:23:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 10:23:57 -0800
Date:   Mon, 13 Jan 2020 10:23:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfstests: xfs mount option sanity test
Message-ID: <20200113182356.GJ8247@magnolia>
References: <20191030103410.2239-1-zlang@redhat.com>
 <20200113180036.GH8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113180036.GH8247@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001130148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001130148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 13, 2020 at 10:00:36AM -0800, Darrick J. Wong wrote:
> On Wed, Oct 30, 2019 at 06:34:10PM +0800, Zorro Lang wrote:
> > XFS is changing to suit the new mount API, so add this case to make
> > sure the changing won't bring in regression issue on xfs mount option
> > parse phase, and won't change some default behaviors either.
> 
> This testcase examines the intersection of some mkfs options and a large
> number of mount options, but it doesn't log any breadcrumbs of which
> scenario it's testing at any given time.  When something goes wrong,
> it's /very/ difficult to map that back to the do_mkfs/do_test call.
> 
> (FWIW I added this test as xfs/997 and attached the diff I needed to

HAH I lied.  Here's the patch.

--D

From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: [PATCH] xfs/997: fix problems with test

Fix problems with Zorro Lang's new mount options test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/997     |   19 ++++++-----
 tests/xfs/997.out |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+), 8 deletions(-)

diff --git a/tests/xfs/997 b/tests/xfs/997
index a662f6f7..9d59b4f4 100755
--- a/tests/xfs/997
+++ b/tests/xfs/997
@@ -65,7 +65,8 @@ mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
 MKFS_OPTIONS=""
 do_mkfs()
 {
-	$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >$seqres.full 2>$tmp.mkfs
+	echo "FORMAT: $@" | tee -a $seqres.full
+	$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >>$seqres.full 2>$tmp.mkfs
 	if [ "${PIPESTATUS[0]}" -ne 0 ]; then
 		_fail "Fails on _mkfs_dev $* $LOOP_DEV"
 	fi
@@ -99,12 +100,12 @@ _do_test()
 	local info
 
 	# mount test
-	_mount $LOOP_DEV $LOOP_MNT $opts 2>/dev/null
+	_mount $LOOP_DEV $LOOP_MNT $opts 2>>$seqres.full
 	rc=$?
 	if [ $rc -eq 0 ];then
 		if [ "${mounted}" = "fail" ];then
 			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
-			echo "ERROR: expect ${mounted}, but pass"
+			echo "ERROR: expect mount to fail, but it succeeded"
 			return 1
 		fi
 		is_dev_mounted
@@ -114,9 +115,9 @@ _do_test()
 			return 1
 		fi
 	else
-		if [ "${mount_ret}" = "pass" ];then
+		if [ "${mounted}" = "pass" ];then
 			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
-			echo "ERROR: expect ${mounted}, but fail"
+			echo "ERROR: expect mount to succeed, but it failed"
 			return 1
 		fi
 		is_dev_mounted
@@ -133,18 +134,18 @@ _do_test()
 	fi
 	# Check the mount options after fs mounted.
 	info=`get_mount_info`
-	echo $info | grep -q "${key}"
+	echo "${info}" | grep -q "${key}"
 	rc=$?
 	if [ $rc -eq 0 ];then
 		if [ "$found" != "true" ];then
 			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
-			echo "ERROR: expect there's not $key in $info, but not found"
+			echo "ERROR: expected to find \"$key\" in mount info \"$info\""
 			return 1
 		fi
 	else
 		if [ "$found" != "false" ];then
 			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
-			echo "ERROR: expect there's $key in $info, but found"
+			echo "ERROR: did not expect to find \"$key\" in \"$info\""
 			return 1
 		fi
 	fi
@@ -154,6 +155,8 @@ _do_test()
 
 do_test()
 {
+	echo "TEST: $@" | tee -a $seqres.full
+
 	# force unmount before testing
 	force_unmount
 	_do_test "$@"
diff --git a/tests/xfs/997.out b/tests/xfs/997.out
index f2fc684f..c6624925 100644
--- a/tests/xfs/997.out
+++ b/tests/xfs/997.out
@@ -3,4 +3,98 @@ QA output created by 997
 ** create loop log device
 ** create loop mount point
 ** start xfs mount testing ...
+FORMAT: 
+TEST:  pass allocsize false
+TEST: -o allocsize=4k pass allocsize=4k true
+TEST: -o allocsize=1048576k pass allocsize=1048576k true
+TEST: -o allocsize=2048 fail
+TEST: -o allocsize=2g fail
+FORMAT: -m crc=1
+TEST:  pass attr2 true
+TEST: -o attr2 pass attr2 true
+TEST: -o noattr2 fail
+FORMAT: -m crc=0
+TEST:  pass attr2 true
+TEST: -o attr2 pass attr2 true
+TEST: -o noattr2 pass attr2 false
+FORMAT: 
+TEST:  pass discard false
+TEST: -o discard pass discard true
+TEST: -o nodiscard pass discard false
+TEST:  pass grpid false
+TEST: -o grpid pass grpid true
+TEST: -o bsdgroups pass grpid true
+TEST: -o nogrpid pass grpid false
+TEST: -o sysvgroups pass grpid false
+TEST:  pass filestreams false
+TEST: -o filestreams pass filestreams true
+TEST:  pass ikeep false
+TEST: -o ikeep pass ikeep true
+TEST: -o noikeep pass ikeep false
+TEST:  pass inode64 true
+TEST: -o inode32 pass inode32 true
+TEST: -o inode64 pass inode64 true
+TEST:  pass largeio false
+TEST: -o largeio pass largeio true
+TEST: -o nolargeio pass largeio false
+TEST: -o logbufs=8 pass logbufs=8 true
+TEST: -o logbufs=2 pass logbufs=2 true
+TEST: -o logbufs=1 fail
+TEST: -o logbufs=9 fail
+TEST: -o logbufs=99999999999999 fail
+FORMAT: -m crc=1 -l version=2
+TEST: -o logbsize=16384 pass logbsize=16k true
+TEST: -o logbsize=16k pass logbsize=16k true
+TEST: -o logbsize=32k pass logbsize=32k true
+TEST: -o logbsize=64k pass logbsize=64k true
+TEST: -o logbsize=128k pass logbsize=128k true
+TEST: -o logbsize=256k pass logbsize=256k true
+TEST: -o logbsize=8k fail
+TEST: -o logbsize=512k fail
+FORMAT: -m crc=0 -l version=1
+TEST: -o logbsize=16384 pass logbsize=16k true
+TEST: -o logbsize=16k pass logbsize=16k true
+TEST: -o logbsize=32k pass logbsize=32k true
+TEST: -o logbsize=64k fail
+FORMAT: 
+TEST:  pass logdev false
+TEST: -o logdev=/dev/loop1 fail
+FORMAT: -l logdev=/dev/loop1
+TEST: -o logdev=/dev/loop1 pass logdev=/dev/loop1 true
+TEST:  fail
+FORMAT: 
+TEST:  pass noalign false
+TEST: -o noalign pass noalign true
+TEST:  pass norecovery false
+TEST: -o norecovery,ro pass norecovery true
+TEST: -o norecovery fail
+TEST:  pass nouuid false
+TEST: -o nouuid pass nouuid true
+TEST:  pass noquota true
+TEST: -o noquota pass noquota true
+TEST:  pass usrquota false
+TEST: -o uquota pass usrquota true
+TEST: -o usrquota pass usrquota true
+TEST: -o quota pass usrquota true
+TEST: -o uqnoenforce pass usrquota true
+TEST: -o qnoenforce pass usrquota true
+TEST:  pass grpquota false
+TEST: -o gquota pass grpquota true
+TEST: -o grpquota pass grpquota true
+TEST: -o gqnoenforce pass gqnoenforce true
+TEST:  pass prjquota false
+TEST: -o pquota pass prjquota true
+TEST: -o prjquota pass prjquota true
+TEST: -o pqnoenforce pass pqnoenforce true
+FORMAT: -d sunit=128,swidth=128
+TEST: -o sunit=8,swidth=8 pass sunit=8,swidth=8 true
+TEST: -o sunit=8,swidth=64 pass sunit=8,swidth=64 true
+TEST: -o sunit=128,swidth=128 pass sunit=128,swidth=128 true
+TEST: -o sunit=256,swidth=256 pass sunit=256,swidth=256 true
+TEST: -o sunit=2,swidth=2 fail
+FORMAT: 
+TEST:  pass swalloc false
+TEST: -o swalloc pass swalloc true
+TEST:  pass wsync false
+TEST: -o wsync pass wsync true
 ** end of testing
