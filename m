Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818A8C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C0BD206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:44:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GsVAeJTk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbgCLDoq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:44:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730913AbgCLDoq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:44:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3hBgZ181365;
        Thu, 12 Mar 2020 03:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Vb3kHeNi0kwWIivEGtMYErDnNIm1TM3xOjjaao0snwg=;
 b=GsVAeJTkIgiYzkky87xtmC/NfGHX+XUJOkVVJjfkRJdxrgPrW6iHrxaAwKjPww1SVNzj
 HoJsB67nScUVBlGakbc6PuSFskn57qwAp3asiIYho2H/fHMkssUfeRnAXyV/CNYnGmAP
 9tdGsYD1ZBK14+JRKQ6JBeao85qjYsW/1HoKl8Wb6exrVPolhalRB2PkmgT/BXB+MnW7
 yRBXlZ4oObA4ijXKimgFyiqT7IlOcr81WfqiT76AN/Rc97hT+RGmQfTgQAA0sR+RH8oN
 I3FsloakI75cOCw2edMx6NGmDUjEHER86Ec0/IOVfCNgyUCroaX96tq8QPHxVlwUBRSe sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ym31uq76r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:44:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3cACL055274;
        Thu, 12 Mar 2020 03:44:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yp8p5qwc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:44:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02C3igqp016629;
        Thu, 12 Mar 2020 03:44:42 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:44:42 -0700
Subject: [PATCH v2 0/7] xfs: make btree cursor private unions anonymous
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 11 Mar 2020 20:44:41 -0700
Message-ID: <158398468107.1307855.8287106235853942996.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Dave injured his finger and is having difficulty typing, so I fixed a few
things that I didn't like about the v1 patchset and am sending it back out
ahead of resending the btree bulk loading patchset.  The changes are pretty
mechanical and I was gonna apply them, but one more round never hurt anyone.

>From Dave's original cover letter:

"This is a "make things less verbose" cleanup from looking at the
changes Darrick is making to add a staging/fake cursor to the union
for bulk btree loading.

"The process is to create a @defines of the new name to the existing
union name, then replace all users of each union via a script. Then
the union is made anonymous and the members renamed to match the new
code. Then the #defines get removed.

"We do this for the bc_private union, then we name the ag and btree
structures and make them use anonymous unions internally via the
same process.

"That means we go from doubly nested private stuff like this:

"cur->bc_private.a.priv.abt.active

"To the much cleaner, less verbose and more readable:

"cur->bc_ag.abt.active

"Simples, yes?

"[The original] series can be found at:

"https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git/h?xfs-btree-cursor-cleanup

"Note: the code changes are all scripted, I have not done any
followup to do things like aggregate split lines back into single
lines as that is out of scope of the structure definition cleanup
I'm trying to acheive here. That can be done in future as we modify
the code that now has lines that can be merged....

"Signed-off-by: Dave Chinner <dchinner@redhat.com>"

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-private-unions
