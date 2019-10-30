Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE014CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 15:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A19A620856
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 15:45:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nf3CxzQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfJ3Pp6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 11:45:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34144 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfJ3Pp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 11:45:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UFaKMv034612;
        Wed, 30 Oct 2019 15:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HMUMvR5rSGpx9tf5PjrzHfWQ6zOaZmBBpl12ivMHr/0=;
 b=Nf3CxzQXJoQtSglEm5KfYu28T6k4GOKGCIEfuIZJuSF/OFiFQ8FwvoFgvV2KRBI6msv/
 qpNYYL/ME+kTn4RNcLjyT94KRtf/9IT+LgScenY103lkjS4FjfrQK3XjycXpBVVVnwiZ
 0XNOFj3Caw69IDOhOzn+Xj9ha8u24Ar/eQ306gwoUazqnRGMIcHJ6JYv9rJO9xi4WrcZ
 8NC/Ey7GAG0HvWZZ629yhBtc7pPiUK94ext+YQTgQvoBoBqt1TJbqXIYLzzen0BECuE1
 IphyFiknuDFtWcDmADXjrbzMUUPx1bit0ARAoFjtG5ooHPLJ08DFJI5SnKcDq43H3XtF GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vxwhfd7uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 15:45:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UFeRL9081736;
        Wed, 30 Oct 2019 15:45:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vxwja6k54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 15:45:47 +0000
Received: from abhmp0023.oracle.com (abhmp0023.oracle.com [141.146.116.29])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9UFjifK002165;
        Wed, 30 Oct 2019 15:45:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Oct 2019 15:45:44 +0000
Date:   Wed, 30 Oct 2019 08:45:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Ian Kent <raven@themaw.net>
Cc:     kbuild@lists.01.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kbuild test robot <lkp@intel.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [djwong-xfs:mount-api-crash 91/104] fs/xfs/xfs_message.c:23:40:
 warning: address of array 'mp->m_super->s_id' will always evaluate to 'true'
Message-ID: <20191030154543.GF15221@magnolia>
References: <201910291437.fsxNAnIM%lkp@intel.com>
 <20191030033925.GA14630@ubuntu-m2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030033925.GA14630@ubuntu-m2-xlarge-x86>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910300144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 08:39:25PM -0700, Nathan Chancellor wrote:
> On Tue, Oct 29, 2019 at 02:45:40PM +0800, kbuild test robot wrote:
> > CC: kbuild-all@lists.01.org
> > CC: "Darrick J. Wong" <darrick.wong@oracle.com>
> > TO: Ian Kent <raven@themaw.net>
> > CC: "Darrick J. Wong" <darrick.wong@oracle.com>
> > CC: Christoph Hellwig <hch@lst.de>

FYI, It's customary to cc the patch author [and the xfs list]...

> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git mount-api-crash
> > head:   e35c37b1b9987c8d87d91dbeca6c24aade2a3390
> > commit: a5a36409da3a608c815b38b0ff2eb5bcfc1adec6 [91/104] xfs: use super s_id instead of struct xfs_mount
> > config: x86_64-rhel-7.6 (attached as .config)
> > compiler: clang version 10.0.0 (git://gitmirror/llvm_project 7cd595df96d5929488063d8ff5cc3b5d800386da)
> > reproduce:
> >         git checkout a5a36409da3a608c815b38b0ff2eb5bcfc1adec6
> >         # save the attached .config to linux build tree
> >         make ARCH=x86_64 
> > 
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> > 
> > All warnings (new ones prefixed by >>):
> > 
> > >> fs/xfs/xfs_message.c:23:40: warning: address of array 'mp->m_super->s_id' will always evaluate to 'true' [-Wpointer-bool-conversion]
> >            if (mp && mp->m_super && mp->m_super->s_id) {
> >                                  ~~ ~~~~~~~~~~~~~^~~~

...so, Ian, I guess this isn't necessary ^^^^^^^^^^^^^^^^
because it's a char array, not a pointer. :)

Good catch!

--D

> >    1 warning generated.
> > 
> > vim +23 fs/xfs/xfs_message.c
> > 
> >     13	
> >     14	/*
> >     15	 * XFS logging functions
> >     16	 */
> >     17	static void
> >     18	__xfs_printk(
> >     19		const char		*level,
> >     20		const struct xfs_mount	*mp,
> >     21		struct va_format	*vaf)
> >     22	{
> >   > 23		if (mp && mp->m_super && mp->m_super->s_id) {
> >     24			printk("%sXFS (%s): %pV\n", level, mp->m_super->s_id, vaf);
> >     25			return;
> >     26		}
> >     27		printk("%sXFS: %pV\n", level, vaf);
> >     28	}
> >     29	
> > 
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology Center
> > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> > 
> 
> Hi Darrick,
> 
> The 0day team has been doing clang builds for us and we've been
> forwarding the valid warnings along to developers. This appeared after
> the commit listed above. That check should be unnecessary, perhaps you
> meant to check for something else? Thanks for looking into this.
> 
> Cheers,
> Nathan
