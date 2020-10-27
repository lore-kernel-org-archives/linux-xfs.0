Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE600C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 22:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA462223C
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 22:27:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GuU0BerF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374867AbgJ0W1h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 18:27:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374866AbgJ0W1g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 18:27:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RMOfhd106394;
        Tue, 27 Oct 2020 22:27:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kcb9W3zeaCIoNsWT49BqQUsoEERIAYXREJkj345T8R8=;
 b=GuU0BerFdVJGE2jr9qHdhbDLXj6OsITHaUkm4fXpp8pT12r6Hyv3ggbaTRgI9dlTOXqT
 KOsG25qCt/W5nW2BWXMJm1g5fyw9RN2j2Hq8yhJZMkML5Fzavru8FHc6EtXgUD8PhyWz
 Rf1boBQ1o0hkIgoqXdvQF/odr8P1U8/VXbHoIpr1jJB9clwnpfHAt/N/3Ds1zSNHvcz6
 wsP2F0vTW+tfkdVi6q1cgNJZ+5qhadbrK9nX2gGVNduwncXfo3f6umGGgr8renz4zBsb
 O+IA2sE1s2GceOV8slQ8rXyn9yiMQVR/VIWQWDW+T930GNV/Lpy8si1nS6i5s1XN0MHp jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm427te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 22:27:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RMPK9J016251;
        Tue, 27 Oct 2020 22:27:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34cx6wh2hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 22:27:31 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RMRVYr002962;
        Tue, 27 Oct 2020 22:27:31 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 15:27:30 -0700
Date:   Tue, 27 Oct 2020 15:27:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 0/7] various: test xfs things fixed in 5.10
Message-ID: <20201027222728.GB1061252@magnolia>
References: <160382535113.1203387.16777876271740782481.stgit@magnolia>
 <20201027213231.GG5691@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027213231.GG5691@mit.edu>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270129
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 05:32:31PM -0400, Theodore Y. Ts'o wrote:
> On Tue, Oct 27, 2020 at 12:02:31PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Here are a bunch of new tests for problems that were fixed in 5.10.
> > Er.... 5.10 and 5.9.  I have not been good at sending to fstests
> > upstream lately. :( :(
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> 
> Hey Darrick, on a slightly different topic, you had mentioned on last
> week's ext4 video chat that you had been working on some patches to
> allow specific blocks to be forced to return EIO, at specific times,
> to test how a file system handles errors when writing to data blocks,
> metadata blocks, journal, etc.
> 
> Are there early versions of those patches available for us to play
> with?  I'm interesting in using that infrastructure for adding some
> ext4 tests along those lines.

They're not even early versions; these have been in my fstests tree for
years but I haven't had time to get them upstreamed. :(

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/commit/?h=scrub-media-error-reporting_2020-10-27&id=2cc930d7f0034879218efc2292b7e4eb2aaa3fea

--D

> Thanks!!
> 
> 					- Ted
