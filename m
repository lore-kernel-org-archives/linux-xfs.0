Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA9DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 19:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiFHTNl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 15:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbiFHTN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 15:13:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E523E72;
        Wed,  8 Jun 2022 12:13:24 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258HgICS010210;
        Wed, 8 Jun 2022 19:13:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=B9eu3Gppk93iL3sO6HkMh3ZMUeXL+5aSdT4YYlhXVSc=;
 b=plN62VaKWZxGZJAOEuuXgKTOXyzWmUucdvdn4O+VtvIyKog5yppWPo5Fk2lpEq9giRXo
 RH/0wVJ6Au2Ar72OP/I2QciJwDcthH0p6dbDNCAEvv02mT/EmOAaLqzZKQR36jJ4Bcbk
 fNUHXByB4AupteHXkYwvzgbMNDg3rAXReyloAsJJP9TOOPiZQ74JMgEHamyQpHMKK4mS
 /jgoxRyNfV/mTZLcQhOe4rvWB9dUfhwPFow9Jda82CN77AF4Ry10XwZo/kHsANNIfpfI
 VITsKMPXZDWmOjc9ThsloRIAzJb8LB6OcJT2CiPJrEuaV+9Cn+PY5rsfWNlYODWOGSK5 hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gk0d7ht90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 19:13:21 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258IdnlB040642;
        Wed, 8 Jun 2022 19:13:20 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gk0d7ht8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 19:13:20 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258IoZJ2009595;
        Wed, 8 Jun 2022 19:13:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3gfy18vp8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 19:13:18 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258JDFq216646498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 19:13:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52C275204E;
        Wed,  8 Jun 2022 19:13:15 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.174.83])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id DBF1D5204F;
        Wed,  8 Jun 2022 19:13:14 +0000 (GMT)
Date:   Wed, 8 Jun 2022 21:13:12 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n  o area'
 (offset 0, size 1)!
Message-ID: <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <bug-216073-27@https.bugzilla.kernel.org/>
 <20220606151312.6a9d098c85ed060d36519600@linux-foundation.org>
 <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608021922.n2izu7n4yoadknkx@zlang-mailbox>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vrBXhuEJjZ1CFOf-k1V2V41Lgub9cbJ2
X-Proofpoint-ORIG-GUID: veUc2VfaDJND0NMMS2XmMm1AM-poPNj0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=690 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206080074
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 10:19:22AM +0800, Zorro Lang wrote:
> One of the test environment details as [1]. The xfstests config as [2].
> It's easier to reproduce on 64k directory size xfs by running xfstests
> auto group.


Thanks for the details, Zorro!

Do you create test and scratch device with xfs_io, as README suggests?
If yes, what are sizes of the files?
Also, do you run always xfs/auto or xfs/294 hits for you reliably?

Thanks!
