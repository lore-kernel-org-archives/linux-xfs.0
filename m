Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,LOTS_OF_MONEY,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B92C56201
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 953A921556
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IuEgRxBI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829269AbgJ0TB4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:01:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48326 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1829254AbgJ0TBz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:01:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsVZC111581;
        Tue, 27 Oct 2020 19:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=t5UazSSz2wuYkLNo8xgTVj0d1ZP8hjcWEUpP1QXDbk8=;
 b=IuEgRxBIr4eQOcGxy9/rf/eWG+VPzfifbk7k3YaaufqLZpiYbKLKclmolFJtjm9TLjBg
 fAE7wJOXQhInRgSqNWwz0SrfHQdyqp7/TpKjj/XQspDkusjR+jq9B3SHksN/zZMtCcyx
 mIxvZpOeseZQO1tXSd42T35aTQpLMlPFhKXDBlCV2Ofeg0l6+KGt2Cvtysu1N4dVYDr4
 alMk8z5LmqC/2uIkrL2ceI9ipdqPklAaAQedqUJmqAjXSEN+oK44U7KimMH78PrBAjia
 aj0NN26VtnmduwBJri1j+beF9Lwl+TUP0ZBtTyhNrhfPZkOerUQDv18QkbswuV3DWFEm Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm41exc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:01:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIu2DO133014;
        Tue, 27 Oct 2020 19:01:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34cx5xg7rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:01:51 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RJ1pXH005898;
        Tue, 27 Oct 2020 19:01:51 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:01:51 -0700
Subject: [PATCH 3/9] xfs/341: fix test when rextsize > 1
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:01:48 -0700
Message-ID: <160382530837.1202316.5888266175366678239.stgit@magnolia>
In-Reply-To: <160382528936.1202316.2338876126552815991.stgit@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix this test so that it works when the rt extent size is larger than
single block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/341 |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/341 b/tests/xfs/341
index 37ff2bd9..e1fbe588 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -41,6 +41,8 @@ cat $tmp.mkfs > "$seqres.full" 2>&1
 _scratch_mount
 blksz="$(_get_block_size $SCRATCH_MNT)"
 
+rtextsz_blks=$((rtextsz / blksz))
+
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
 i_ptrs=$(( (isize - 176) / 56 ))
@@ -52,14 +54,14 @@ len=$((blocks * rtextsz))
 echo "Create some files"
 $XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
 $XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f2 >> $seqres.full
-$here/src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
-$here/src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
+$here/src/punch-alternating -i $((2 * rtextsz_blks)) -s $rtextsz_blks $SCRATCH_MNT/f1 >> "$seqres.full"
+$here/src/punch-alternating -i $((2 * rtextsz_blks)) -s $rtextsz_blks $SCRATCH_MNT/f2 >> "$seqres.full"
 echo garbage > $SCRATCH_MNT/f3
 ino=$(stat -c '%i' $SCRATCH_MNT/f3)
 _scratch_unmount
 
 echo "Corrupt fs"
-fsbno=$(_scratch_xfs_db -c "inode $ino" -c 'bmap' | \
+fsbno=$(_scratch_xfs_db -c "inode $ino" -c 'bmap' | grep 'flag 0' | head -n 1 | \
 	sed -e 's/^.*startblock \([0-9]*\) .*$/\1/g')
 
 _scratch_xfs_db -x -c 'sb 0' -c 'addr rrmapino' \

