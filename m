Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADD6C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89554206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OJBEnS0F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387652AbfIFDjA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:39:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45220 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731760AbfIFDi7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:38:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YFw0074394;
        Fri, 6 Sep 2019 03:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=xPMoN+ucKwebLiojth5UT154j/N56bXH0auyPyup7po=;
 b=OJBEnS0FSN6QuJbZ6y9VdPcK6H/Pfv8QkKjbF3Vr32iqmaMeWs040b6mOSgxt1KHiOID
 eehG16BGFkahc24pzg5GH56gVuzBFmmxn/MjQ4cUA1IXqu8DTOyod3/JEqMcqil3ZUGN
 yPIP7/5nvwOYq2EXxpc7X/kVwfmX5ypj5hhHbpUTpP2GF0uuyQiqQ/V/oVe54er+/gJa
 6x6kE6FkK7QSu1eeytv8z2X01Vqc/RSBpTSa8vOeQ6LrjkcQI2ZyPWsttvVNq7lohwkV
 OI/7a4WBM1dsGL9SaFdrL2Jptsy4oFsA4qfC9cRsSy/WvSwDAGSM/sepjpU0L043rNLJ kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uuf51g3dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:38:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863co5S001987;
        Fri, 6 Sep 2019 03:38:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2utpmc76pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:38:57 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863cuQ9020709;
        Fri, 6 Sep 2019 03:38:56 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:38:56 -0700
Subject: [PATCH 00/11] xfs_scrub: fix IO error reporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:38:55 -0700
Message-ID: <156774113533.2645432.14942831726168941966.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The scrub media error reporting could use some improvements -- first,
scrub can calculate the exact offset of media errors in file mappings,
so we should report more precise offsets.  Second, we only need to scan
the rmap once after assembling the io error bitmap to look for destroyed
metadata (instead of once per error!).  Third, we can filter out
unwritten and attr/cow fork extents from what we report since sector
remapping takes care of unwritten/cow extents and attr media errors
should be detected by phase 3.  Finally, we introduce a new category of
errors that are unfixable by scrub, and assign to this class all the
media errors since there's nothing XFS can do.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-media-error-reporting

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-media-error-reporting
