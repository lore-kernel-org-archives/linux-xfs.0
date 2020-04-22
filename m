Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F1BC55185
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C0DF20776
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:47:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tSI6g6b2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgDVXrl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 19:47:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgDVXrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 19:47:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MNldMg083589
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:47:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=SrBSd8+hHl4bIgf3TS8IvD9m+dyJox5JDoJjC8UNoR0=;
 b=tSI6g6b2RfGeBSusWdIwVJolDBGa+hYl+Up0mpJlolZwYgcSRVh6CnY1UvQo6wJ8KSOB
 PKQTzuYra3asnldwQ+2mQGs0zF4Yt2SU1mlbK8kSdT2cNnUDBqab5oUMWKUdUONnIX1b
 H66M4Fm9fiUWjMDon5g3xubbx+sm42V6YtKY8jFZ9mwoChPXU9/cPjDVHc0xP1RN4W1s
 PF625ydb42hPZvPNZ6gm/jTECPHHhfyR8ibKoI+p4GmFjCDdiKK1udJ3waYzymFxC6eQ
 501O8Nz1I+ObTv+IgJ6mtGWXW53PlB3ddTw3c+aFiX7pSpAW53x61dT4edBQjoW5jSN4 hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30grpgt6pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:47:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MNbdME193964
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:45:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30gb93pg6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:45:39 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03MNjccJ019275
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 23:45:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 16:45:38 -0700
Date:   Wed, 22 Apr 2020 16:45:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [XFS SUMMIT] Atomic File Updates
Message-ID: <20200422234536.GF6741@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

During lockdown, I've been working on teaching[1] XFS how to swap a range
of extents with a different range of extents in another file in such a
way that we're always guaranteed that the swap operation completes, no
matter how many extents have to be swapped.  This guarantee is durable
evne if the filesystem goes down midway through the operation, since log
recovery will finish the job.

In other words, we finally have a mechanism for userspace programs to
update files atomically without resorting (a) to a pile of fsync and
rename spaghetti or (b) creating an O_TMPFILE and using weird procfs
linkat tricks to wire that into the filesystem.  Better yet, other
programs with open file descriptors will see the new contents
immediately.

So the basic user story is that userspace opens a file and decides to
write to it.  The user program then creates an O_TMPFILE.  If the
program only wishes to update a subset of the file, it can FICLONE the
original file's contents, or it can rewrite the file from scratch.

When the update is finished, the program can fsync the temp file and
then call FISWAPRANGE to commit the changes to the original file.  The
program can supply a [cm]time to the kernel, which can use that to
detect that the original file has changed and that the update should not
be applied.

Note that this is /not/ the hardware-assisted directio atomic writes
that have also been suggested on fsdevel.  That interface (if the
storage vendors ever show up with hardware) only supports atomic writes
on a limited number of possibly discontiguous LBAs, whereas this
software mechanism will work on any size file with any number of blocks.

As a side benefit, this also gives XFS the ability to rebuild xattr and
directory data in a temporary file and cleanly swap the clean contents
over when the entire recreation step has finished.

I haven't yet put this out on fsdevel because I've been a bit busy
putting together XFS summit ideas. :/

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=atomic-file-updates
