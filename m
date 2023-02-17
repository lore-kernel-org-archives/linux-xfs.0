Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05A6C636D4
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Feb 2023 11:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjBQLbS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Feb 2023 06:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjBQLbQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2023 06:31:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64D265690
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 03:31:11 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31H8lDdB020201;
        Fri, 17 Feb 2023 11:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=vOpLW5YblEIJZO6pB4tXUS+vhga4HWhpHVp3K7T47iU=;
 b=jFXPwazT+YY/Rdgxv7YmXHrR+CJ4Qcqj3fyvD2hpyqDjc+1cEVOy9Np/m4ictoMVUipP
 sUBMZXbfa/Qx40Nq8XH0CtiZGQnxf2lSLIQBOXB7Zv54dMJ9dm+jfptJ4kGP4U8RL7Fu
 tFhnA3y0UFH/oo4Z1rKT8AHMTNmmcEEkHcvCAAEoFUGowFnm8Vq7jSecuSUQg7j6c3uY
 m00b0KhnraUhKJZDtDpjXUOqqxRuo6YL+bHRsE0wVO++zlWsiy60F4UOlNHKuIzpAWFQ
 0KF8bDpOMpK2hTaMdvvx8Bv0AOjx1bKV6lzNxIc2M0799Up4Se/hfT8PN+XG/MYGJcOD LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsv6f0rpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:31:08 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31HAmTa0015832;
        Fri, 17 Feb 2023 11:31:07 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsv6f0rh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:31:07 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31H907t8023595;
        Fri, 17 Feb 2023 11:30:44 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3np2n7y984-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:30:44 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31HBUhB210027712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Feb 2023 11:30:43 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 105A35805A;
        Fri, 17 Feb 2023 11:30:43 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCE405805D;
        Fri, 17 Feb 2023 11:30:40 +0000 (GMT)
Received: from [9.43.51.161] (unknown [9.43.51.161])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Feb 2023 11:30:40 +0000 (GMT)
Message-ID: <2e55fc8e-93dd-10f9-5e06-14169db781d4@linux.vnet.ibm.com>
Date:   Fri, 17 Feb 2023 17:00:39 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: xfs: system fails to boot up due to Internal error
 xfs_trans_cancel
Content-Language: en-US
To:     djwong@kernel.org, dchinner@redhat.com
Cc:     linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
References: <e5004868-4a03-93e5-5077-e7ed0e533996@linux.vnet.ibm.com>
From:   shrikanth hegde <sshegde@linux.vnet.ibm.com>
In-Reply-To: <e5004868-4a03-93e5-5077-e7ed0e533996@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Fn0YUqAqdnZkT3H_dWUVJMABkhOcAEyC
X-Proofpoint-ORIG-GUID: kOqu-p93kEfAbJyHIQuM-lSVYjGBqfQw
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_06,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=971 clxscore=1015 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170104
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/17/23 4:45 PM, shrikanth hegde wrote:
> We are observing panic on boot upon loading the latest stable tree(v6.2-rc4) in 
> one of our systems. System fails to come up. System was booting well 
> with v5.17, v5.19 kernel. We started seeing this issue when loading v6.0 kernel.
> 
> Panic Log is below.
> [  333.390539] ------------[ cut here ]------------
> [  333.390552] WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
> 
> we did a git bisect between 5.17 and 6.0. Bisect points to commit 04755d2e5821 
> as the bad commit.
> Short description of commit:
> commit 04755d2e5821b3afbaadd09fe5df58d04de36484 (refs/bisect/bad)
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Thu Jul 14 11:42:39 2022 +1000
> 
>     xfs: refactor xlog_recover_process_iunlinks()
> 
> 

Tried one of the recent patch sent by Dave.
https://lore.kernel.org/all/20230118224505.1964941-1-david@fromorbit.com/


If the full series is applied, it panics upon booting. i.e same problem persists.

If only "[6/42] xfs: don't assert fail on transaction cancel with deferred ops" 
is applied, then it doesnt panic at boot. It panics later, when doing a make. 
A bit better than not booting. But still panics later.  
