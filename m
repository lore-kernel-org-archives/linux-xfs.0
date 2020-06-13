Return-Path: <SRS0=EwQn=72=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666FFC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Jun 2020 05:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3483020739
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Jun 2020 05:35:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nagGTds8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgFMFfo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Jun 2020 01:35:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60846 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgFMFfo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jun 2020 01:35:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05D5Wu1F019675;
        Sat, 13 Jun 2020 05:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+48gp5NsajP3MjUnlmxOcUkUR7Y/jITP8z7coyvT02E=;
 b=nagGTds8EPCSogutD7A7j8gZgejKu+EA2PviOcK+wBtPsOwl5aChUAmUcBlxbyNRmcqP
 sq0Q144lepz0SFoPmYCb89oN3omwotEvlwh0sq6ZWpxVLdGBC9Psj0RZeQ7BCs2ZjzKU
 XM05dM0LYO71lTN65ZeIsHSMv1I5Lg2I6cZUCy0MQJCtKmXWn7/xjt5rwMMxRxjKeYkd
 0jzNf1zOBFqFp3sleuMa4YlEiWsxiQ6X39QNmdnTbBOTJBnoubCLQHGHW0aC+EvpiqIQ
 6Noues76IeA1aVlMxCj94ITW/WdD0JJLR9b2Im0S6HVexxZs92HTjPKhgBu4jeADkOkH JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31mp7r086p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 13 Jun 2020 05:35:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05D5XHaV055511;
        Sat, 13 Jun 2020 05:35:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31mkwq8kc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Jun 2020 05:35:36 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05D5ZY8u030096;
        Sat, 13 Jun 2020 05:35:34 GMT
Received: from localhost (/10.159.130.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 13 Jun 2020 05:35:34 +0000
Date:   Fri, 12 Jun 2020 22:35:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] xfs: new code for 5.8 (now with fixed To line)
Message-ID: <20200613053533.GJ11245@magnolia>
References: <20200602162644.GE8204@magnolia>
 <CAHk-=wgeiqB0TH_V2uTd2CX2hks+3TW344j73ftJFjqUteTxXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgeiqB0TH_V2uTd2CX2hks+3TW344j73ftJFjqUteTxXA@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9650 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006130046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9650 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 clxscore=1015
 cotscore=-2147483648 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 suspectscore=1 mlxlogscore=999 bulkscore=0 mlxscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006130046
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:40:35PM -0700, Linus Torvalds wrote:
> On Tue, Jun 2, 2020 at 9:26 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > fs/xfs/xfs_log_recover.c                           | 2561 ++------------------
> >  102 files changed, 4244 insertions(+), 4817 deletions(-)
> 
> Interestingly, the changes to that xfs_log_recover.c file really seem
> to break the default git diff algorithm (the linear-space Myers'
> algorithm)
> 
> The default settings give me
> 
>  fs/xfs/xfs_log_recover.c                           | 2801 ++------------------
>  102 files changed, 4366 insertions(+), 4939 deletions(-)
> 
> which is not very close to yours. With the extra effort "--minimal" I get
> 
>  fs/xfs/xfs_log_recover.c                           | 2561 ++------------------
>  102 files changed, 4246 insertions(+), 4819 deletions(-)
> 
> but based on your output, I suspect you used "--patience", which gives that
> 
>  fs/xfs/xfs_log_recover.c                           | 2561 ++------------------
>  102 files changed, 4244 insertions(+), 4817 deletions(-)
> 
> output (the difference there wrt minimal came from
> fs/xfs/libxfs/xfs_symlink_remote.c).
> 
> I'm used to seeing small differences in the line counts due to
> different diff heuristics, but that 250 line difference for
> "--patience" is more than you usually get.
> 
> None of this matters, and I'm not at all suggesting you change any of
> your workflow.

<nod> One of the XFS developers suggested I experiment with --patience
to see if it would make the diff output a little less eager to minimize
the changed lines even at the expense of reviewability.  The outcome is
mostly identical, but there were a few places where using it really did
help to try to keep basic code blocks together.

--D

> I'm just commenting because I was going "why am I not getting a
> matching diffstat", and while I'm used to seeing small differences
> from diff algorithms, that 240 line-count change was really a lot more
> than I normally encounter.
> 
>                       Linus
> 
