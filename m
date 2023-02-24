Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D790C61DA3
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Feb 2023 08:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjBXIEU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Feb 2023 03:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBXIET (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Feb 2023 03:04:19 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72056279B8
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2023 00:04:17 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31O6TrZ0005323;
        Fri, 24 Feb 2023 08:04:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=a5zh54UpJ8Iw8KHrc78+fBcD/rOZo9s3n3jzR/xZVQs=;
 b=OoUfeWWaA2+vcJykyqrg+r4ch6EhJBqYeeaVYEIGzdz8EV6qYZd7lU5xJ5RycBMw/gt8
 DMpX6YA0I1pX6Px4dRsWOJgXZ5TFNbf9eFTwcODcUcsykrky4Vmdcp50rK7KW+GXkLM2
 mOKWPZeaA6ZnCob6l5VOTHASgpCgZ1J0SVhRu80b3/9VJJoB6S1GdbrdG7ZjaX1L+9YN
 KEulTJYLoCAXXXlmpQ+cU5cHznxzrD3DxiBTY92flXDVfX1T5jJrlspEghX1s+IJBVnh
 TTxgYkCaaKh7FlPQ8jNYZ1QFcbwHONqhrGVqssFqa2631h1BDcK44srWFT0FG55nFzWn kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxr17sxsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 08:04:08 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31O7xBL2012226;
        Fri, 24 Feb 2023 08:04:08 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nxr17sxrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 08:04:08 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31O5Fsan015811;
        Fri, 24 Feb 2023 08:04:06 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3ntpa7ancb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 08:04:06 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31O845wu24969752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 08:04:05 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B623C58059;
        Fri, 24 Feb 2023 08:04:05 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8315E5805F;
        Fri, 24 Feb 2023 08:04:03 +0000 (GMT)
Received: from [9.43.73.248] (unknown [9.43.73.248])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Feb 2023 08:04:03 +0000 (GMT)
Message-ID: <d6530c9b-219c-1d37-6331-b2989506102c@linux.vnet.ibm.com>
Date:   Fri, 24 Feb 2023 13:34:01 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: xfs: system fails to boot up due to Internal error
 xfs_trans_cancel
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
References: <e5004868-4a03-93e5-5077-e7ed0e533996@linux.vnet.ibm.com>
 <Y++xDBwXDgkaFUi9@magnolia>
 <828a1562-3bf4-c1d8-d943-188ee6c3d4fa@linux.vnet.ibm.com>
 <Y/ZFtEbLTX38pReY@magnolia>
From:   shrikanth hegde <sshegde@linux.vnet.ibm.com>
In-Reply-To: <Y/ZFtEbLTX38pReY@magnolia>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZkRmx4q9O4EIQXGUQTX9oD8CRi97kuOg
X-Proofpoint-ORIG-GUID: FBMeEf-uU_nnnQMirEolJGvYtxVVqorG
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_04,2023-02-23_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240066
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


>>> ...that trips when rm tries to remove a file, which means that the call
>>> stack is
>>>
>>> xfs_remove -> xfs_iunlink -> xfs_iunlink_insert_inode ->
>>> xfs_iunlink_update_backref -> xfs_iunlink_lookup <kaboom>
>>>
>>> It looks as though "rm foo" unlinked foo from the directory and was
>>> trying to insert it at the head of one of the unlinked lists in the AGI
>>> buffer.  The AGI claims that the list points to an ondisk inode, so the
>>> iunlink code tries to find the incore inode to update the incore list,
>>> fails to find an incore inode, and this is the result...
>>
>> This seems to happen for rename as well. i.e xfs_rename. 
>> Does  rename path calls rm first, and then create?
> 
> Effectively, yes.  A "mv a b" will unlink b, and that calls the same
> internal unlink code as an unlink syscall.
> 
>>>>
>>>>
>>>> we did a git bisect between 5.17 and 6.0. Bisect points to commit 04755d2e5821 
>>>> as the bad commit.
>>>> Short description of commit:
>>>> commit 04755d2e5821b3afbaadd09fe5df58d04de36484 (refs/bisect/bad)
>>>> Author: Dave Chinner <dchinner@redhat.com>
>>>> Date:   Thu Jul 14 11:42:39 2022 +1000
>>>>
>>>>     xfs: refactor xlog_recover_process_iunlinks()
>>>
>>> ...which was in the middle of the series that reworked thev mount time
>>> iunlink clearing.  Oddly, I don't spot any obvious errors in /that/
>>> patch that didn't already exist.  But this does make me wonder, does
>>> xfs_repair -n have anything to say about unlinked or orphaned inodes?
>>>
>>> The runtime code expects that every ondisk inode in an iunlink chain has
>>> an incore inode that is linked (via i_{next,prev}_unlinked) to the other
>>> incore inodes in that same chain.  If this requirement is not met, then
>>> the WARNings you see will trip, and the fs shuts down.
>>>
>>> My hypothesis here is that one of the AGs has an unprocessed unlinked
>>> list.  At mount time, the ondisk log was clean, so mount time log
>>> recovery didn't invoke xlog_recover_process_iunlinks, and the list was
>>> not cleared.  The mount code does not construct the incore unlinked list
>>> from an existing ondisk iunlink list, hence the WARNing.  Prior to 5.17,
>>> we only manipulated the ondisk unlink list, and the code never noticed
>>> or cared if there were mystery inodes in the list that never went away.
>>>
>>> (Obviously, if something blew up earlier in dmesg, that would be
>>> relevant here.)
>>>
>>> It's possible that we could end up in this situation (clean log,
>>> unlinked inodes) if a previous log recovery was only partially
>>> successful at clearing the unlinked list, since all that code ignores
>>> errors.  If that happens, we ... succeed at mounting and clean the log.
>>>
>>> If you're willing to patch your kernels, it would be interesting
>>> to printk if the xfs_read_agi or the xlog_recover_iunlink_bucket calls
>>> in xlog_recover_iunlink_ag returns an error code.  It might be too late
>>
>> We can try. Please provide the Patch. 
>>
>>> to capture that, hence my suggestion of seeing if xfs_repair -n will
>>> tell us anything else.
>>>
>>
>> Could you please clarify? We should run xfs_repair -n from 5.17-rc2 kernel? 
> 
> Whatever xfs_repair is installed on the system should suffice to report
> an unlinked inode list and any other errors on the filesystem.  That
> evidence will guide us towards a kernel patch.
> 
> --D
> 

# xfs_info /
meta-data=/dev/mapper/rhel_ltc--lp1-root isize=512    agcount=4, agsize=4183040 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=16732160, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=8170, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# 
# 
# xfs_repair -n /
xfs_repair: can't determine device size
# 

>>
>>> I've long thought that the iunlink recovery ought to complain loudly and
>>> fail the mount if it can't clear all the unlinked files.  Given the new
>>> iunlink design, I think it's pretty much required now.  The uglier piece
>>> is that now we either (a) have to clear iunlinks at mount time
>>> unconditionally as Eric has been saying for years; or (b) construct the
>>> incore list at a convenient time so that the incore list always exists.
>>>
>>> Thanks for the detailed report!
>>>
>>> --D
>>>
>>>>
>>>> Git bisect log:
>>>> git bisect start
>>>> # good: [26291c54e111ff6ba87a164d85d4a4e134b7315c] Linux 5.17-rc2
>>>> git bisect good 26291c54e111ff6ba87a164d85d4a4e134b7315c
>>>> # bad: [4fe89d07dcc2804c8b562f6c7896a45643d34b2f] Linux 6.0
>>>> git bisect bad 4fe89d07dcc2804c8b562f6c7896a45643d34b2f
>>>> # good: [d7227785e384d4422b3ca189aa5bf19f462337cc] Merge tag 'sound-5.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
>>>> git bisect good d7227785e384d4422b3ca189aa5bf19f462337cc
>>>> # good: [526942b8134cc34d25d27f95dfff98b8ce2f6fcd] Merge tag 'ata-5.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata
>>>> git bisect good 526942b8134cc34d25d27f95dfff98b8ce2f6fcd
>>>> # good: [328141e51e6fc79d21168bfd4e356dddc2ec7491] Merge tag 'mmc-v5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc
>>>> git bisect good 328141e51e6fc79d21168bfd4e356dddc2ec7491
>>>> # bad: [eb555cb5b794f4e12a9897f3d46d5a72104cd4a7] Merge tag '5.20-rc-ksmbd-server-fixes' of git://git.samba.org/ksmbd
>>>> git bisect bad eb555cb5b794f4e12a9897f3d46d5a72104cd4a7
>>>> # bad: [f20c95b46b8fa3ad34b3ea2e134337f88591468b] Merge tag 'tpmdd-next-v5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd
>>>> git bisect bad f20c95b46b8fa3ad34b3ea2e134337f88591468b
>>>> # bad: [fad235ed4338749a66ddf32971d4042b9ef47f44] Merge tag 'arm-late-6.0' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
>>>> git bisect bad fad235ed4338749a66ddf32971d4042b9ef47f44
>>>> # good: [e495274793ea602415d050452088a496abcd9e6c] Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma
>>>> git bisect good e495274793ea602415d050452088a496abcd9e6c
>>>> # good: [9daee913dc8d15eb65e0ff560803ab1c28bb480b] Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
>>>> git bisect good 9daee913dc8d15eb65e0ff560803ab1c28bb480b
>>>> # bad: [29b1d469f3f6842ee4115f0b21f018fc44176468] Merge tag 'trace-rtla-v5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
>>>> git bisect bad 29b1d469f3f6842ee4115f0b21f018fc44176468
>>>> # good: [932b42c66cb5d0ca9800b128415b4ad6b1952b3e] xfs: replace XFS_IFORK_Q with a proper predicate function
>>>> git bisect good 932b42c66cb5d0ca9800b128415b4ad6b1952b3e
>>>> # bad: [35c5a09f5346e690df7ff2c9075853e340ee10b3] Merge tag 'xfs-buf-lockless-lookup-5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.20-mergeB
>>>> git bisect bad 35c5a09f5346e690df7ff2c9075853e340ee10b3
>>>> # bad: [fad743d7cd8bd92d03c09e71f29eace860f50415] xfs: add log item precommit operation
>>>> git bisect bad fad743d7cd8bd92d03c09e71f29eace860f50415
>>>> # bad: [04755d2e5821b3afbaadd09fe5df58d04de36484] xfs: refactor xlog_recover_process_iunlinks()
>>>> git bisect bad 04755d2e5821b3afbaadd09fe5df58d04de36484
>>>> # good: [a4454cd69c66bf3e3bbda352b049732f836fc6b2] xfs: factor the xfs_iunlink functions
>>>> git bisect good a4454cd69c66bf3e3bbda352b049732f836fc6b2
>>>> Bisecting: 0 revisions left to test after this (roughly 0 steps)
>>>> [4fcc94d653270fcc7800dbaf3b11f78cb462b293] xfs: track the iunlink list pointer in the xfs_inode
>>>>
>>>>
>>>> Please reach out, in case any more details are needed. sent with very limited
>>>> knowledge of xfs system. these logs are from 5.19 kernel.
>>>>
>>>> # xfs_info /home
>>>> meta-data=/dev/nvme0n1p1         isize=512    agcount=4, agsize=13107200 blks
>>>>          =                       sectsz=4096  attr=2, projid32bit=1
>>>>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>>>>          =                       reflink=1    bigtime=0 inobtcount=0
>>>> data     =                       bsize=4096   blocks=52428800, imaxpct=25
>>>>          =                       sunit=0      swidth=0 blks
>>>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>>>> log      =internal log           bsize=4096   blocks=25600, version=2
>>>>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>>
>>>> # xfs_info -V
>>>> xfs_info version 5.0.0
>>>>
>>>> # uname -a
>>>> 5.19.0-rc2
