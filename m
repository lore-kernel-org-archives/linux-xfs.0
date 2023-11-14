Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA03C4167D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 11:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjKNLR5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 06:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjKNLR5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2023 06:17:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C8912C;
        Tue, 14 Nov 2023 03:17:53 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AEAfniK015941;
        Tue, 14 Nov 2023 11:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gWDSktdQe9krShHKNgxxHGGVW8Fgw0IN5fOXr76GNOw=;
 b=kbKr8fZ3DpgMBvlcN2CoDn+cvOfYORnRXoFGJTcjqRp6poxC0AAHNsKd+HRFUkUvfU7B
 b5KAKFVN3jLT90s5ikPYkKX8QkDHqr11HGvk5Opo3LMuZa+xt7BqPvBmDjZItT7WPRo7
 HZkN44LI8Z6TFTI9zKCgfLMitKux/kYfHPfRcr7HhBK3bZcbvTcCgHqtgFB4/UJOizWJ
 njXm9BJAhKop4M0lpktxi3Zyf+hsRsGa9HpFYZhd/WMhrVq0UYS3XeADrbuMgAElDVfg
 KiiJAYzeq6pUDy3UKKSToaP1k7cVHYaHnoLKFsgvt61/OMiUY/SqgMI3Nx4ztIfG/X3J aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uc70rspej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Nov 2023 11:17:39 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AEAfpkP016353;
        Tue, 14 Nov 2023 11:17:39 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uc70rspde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Nov 2023 11:17:39 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE8R8VE014707;
        Tue, 14 Nov 2023 11:17:37 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uamay7j75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Nov 2023 11:17:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AEBHZBm43975418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 11:17:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 915C420043;
        Tue, 14 Nov 2023 11:17:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55FCA20040;
        Tue, 14 Nov 2023 11:17:35 +0000 (GMT)
Received: from li-97e414cc-2e07-11b2-a85c-b6096b19d8a2.boeblingen.de.ibm.com (unknown [9.152.212.242])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 14 Nov 2023 11:17:35 +0000 (GMT)
From:   edward6@linux.ibm.com
To:     david@fromorbit.com
Cc:     carlos@maiolino.me, djwong@kernel.org, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, zlang@redhat.com,
        linux-s390@vger.kernel.org, Eduard Shishkin <edward6@linux.ibm.com>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c. Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Date:   Tue, 14 Nov 2023 12:17:21 +0100
Message-Id: <20231114111721.262282-1-edward6@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <ZU2PhTKqwNEbjK13@dread.disaster.area>
References: <ZU2PhTKqwNEbjK13@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6bUWru1HMXC98peFWiS1aS9DdOeef1Iw
X-Proofpoint-ORIG-GUID: Sr3_qyk0GbjHPZp9R1uxSATENGciedDy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=879
 priorityscore=1501 bulkscore=0 spamscore=0 adultscore=0 clxscore=1011
 suspectscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140087
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eduard Shishkin <edward6@linux.ibm.com>

[...]

> Can you test the patch below and see if it fixes the issue? Keep
> the first verifier patch I sent, then apply the patch below. You can
> drop the debug traceprintk patch - the patch below should fix it.


Thanks for fixing it!
Tested-by: Eduard Shishkin <edward6@linux.ibm.com>

[...]

> This manifests obviously on big endian platforms (e.g. s390) because
> the log dinode is in host order and the overlap is the LSBs of the
> extent count field. It is not noticed on little endian machines
> because the overlap is at the MSB end of the extent count field and
> we need to get more than 2^^48 extents in the inode before it
> manifests. i.e. the heat death of the universe will occur before we
> see the problem in little endian machines.


This sounds too bold. I can easily imagine mountable images similar to
filesystem meta-data dumps, but not generated by scanning real
partitions, instead created by a special tool e.g. for debugging
purposes. My point is that on little-endian architectures the
manifestation of such a "sleeping" bug is a much more realistic event
than it may seem at first glance.
