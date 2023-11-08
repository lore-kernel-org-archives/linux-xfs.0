Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6901FC4167B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 16:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjKHQji (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 11:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjKHQj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 11:39:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D5B2130;
        Wed,  8 Nov 2023 08:39:26 -0800 (PST)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8GBbpm020840;
        Wed, 8 Nov 2023 16:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=x8+A1KDoK1OXjewh7ZpwrkcFuwzkD66yQiRWuYB9axc=;
 b=MnMjQE4iErC32UlYns69fpL6pr0hS3xwujgwCElce2W2VK0nyGebyvVPj40M0z7B2Xxv
 m2LKgs4Il1bDLiAmXSEY43epuhMmQnb47mQAHgFdkN/wR4MdtLnvpkVyKImUrpvbEMiS
 nKd3nrx+YHl1AIrR5+ssQUF11Tfg8KMYNIsNVojLAsleowPSxR6fG792DxawwvKfzZkH
 vqj1LEd6VjcRIq4VJcCFVhNf705Jzz58JCjngCF4LC3dhUTGkQ2xtj08rq7dTOCqxKGc
 epzCpgLt7t6lH0xcZUZ+0+BiiSSaarTPPHJlPGtPTy8m72shxORz3jgLv48Ct6TCtGFM NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8dbu24ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Nov 2023 16:39:24 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8GaHSL017264;
        Wed, 8 Nov 2023 16:39:20 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8dbu22rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Nov 2023 16:39:20 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8GZBWK004112;
        Wed, 8 Nov 2023 16:38:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w20x2fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Nov 2023 16:38:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8GcrOl44696010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Nov 2023 16:38:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38C7320043;
        Wed,  8 Nov 2023 16:38:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0B1920040;
        Wed,  8 Nov 2023 16:38:52 +0000 (GMT)
Received: from li-97e414cc-2e07-11b2-a85c-b6096b19d8a2.ibm.com.com (unknown [9.179.0.128])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Nov 2023 16:38:52 +0000 (GMT)
From:   edward6@linux.ibm.com
To:     zlang@redhat.com
Cc:     fstests@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org, edward6@linux.ibm.com
Subject: Re: [Bug report] More xfs courruption issue found on s390x
Date:   Wed,  8 Nov 2023 17:38:12 +0100
Message-Id: <20231108163812.1440930-1-edward6@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231029043333.v6wkqsorxdk2dbch@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231029043333.v6wkqsorxdk2dbch@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Mld01iZ2cpwbRHbxeWzRIWfOYlJrjuDZ
X-Proofpoint-ORIG-GUID: LKe2XSIxjno0zC4KTPg1Ve8-iwjamrO1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_05,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=773 clxscore=1011
 suspectscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080137
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eduard Shishkin <edward6@linux.ibm.com>

On Sun, Oct 29, 2023 at 12:33:33PM +0800, Zorro Lang wrote:

[...]

> All these falures are on s390x only... and more xfs corruption
> failure by running fstests on s390x. I don't know if it's a s390x
> issue or a xfs issue on big endian machine (s390x), so cc s390x
> list.

Dear all,

It is a really great nuisance. We are looking into this from our
(s390x) side in turn. Unfortunately, I don't see any ways except code
review for now. If you have any ideas on how to optimize the process,
please, let us know. Right now, I think, we can help with additional
hardware resources.

Thanks,
Eduard.
