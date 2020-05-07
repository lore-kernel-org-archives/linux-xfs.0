Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B50FCC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 15:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 917FC20659
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 15:54:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XPS9+Hzn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEGPyV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 11:54:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgEGPyU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 11:54:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047Frf0A110241;
        Thu, 7 May 2020 15:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Wviyj8O6zurgUtEix4TJOeKhEjGoyXQDkzwLsjBKENY=;
 b=XPS9+Hzn3yzmhqqHOo2JSXQCue/xiFnr0pl3TOuswY8KRXdUAKGbvma+biTGMAnUIB3n
 OdJwh5btkAGW7GiQ2waS0HqgQLH08sWaWsA5U4iGGO8C7DYDqrGPJJ9+6Aroml/CPzM7
 RadP8ZAs2VvaYkkdPUwj/BXOv2//A6wHCdI3hSFyZFyaIAa/rX6qDm8+kfHAZ8aygcdh
 O7YJ1wr5520ZyM8JPCW/EZ1NcZDwyfQCQjXIYAIC30ppN8alYuU5anomDzdZ7Knk/Sx3
 t5KgfdOk06Ke//kJGIsVqbMDXr/cjA0PDnL+VVzJp8zsB/dGP8rXE1kS/OZPkki1tqR/ hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30vhvyhabt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 15:54:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047Fppp9161857;
        Thu, 7 May 2020 15:54:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30t1raxcw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 15:54:15 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 047FsDFY001738;
        Thu, 7 May 2020 15:54:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 08:54:13 -0700
Date:   Thu, 7 May 2020 08:54:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: libxfs 5.7 resync
Message-ID: <20200507155412.GI6714@magnolia>
References: <20200507121851.304002-1-hch@lst.de>
 <20200507154809.GH6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507154809.GH6714@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 08:48:09AM -0700, Darrick J. Wong wrote:
> On Thu, May 07, 2020 at 02:17:53PM +0200, Christoph Hellwig wrote:
> > Hi Eric,
> > 
> > as I've done a lot of API churn in 5.7 I though I'd volunteer resyncing
> > libxfs for this window.  This series contains all the patches that
> > need to be ported over.
> > 
> > There are a few issues, though:
> > 
> >  - with "xfs: remove the di_version field from struct icdinode"
> >    xfs_check fails after various tests with multiply claimed extents.
> >    This seems like some weird race, as neither repair nor manually
> >    running check finds anything.  I had to patch out running xfs_check
> >    to get useful xfstests runs
> >  - but xfs/017 manually runs check and also still sees this
> 
> /me wonders if that's due to the onstack xfs_inode in db/check.c...
> 
> >  - xfs/122 will need an update for the xfs_agl changes, I can send
> >    that
> >  - xfs/307 and xfs/308 now print new messages due to the ported over
> >    AGF verifier tightening
> 
> I sent patches to fstests to fix these last two.

DOH, you already RVBd that part of the series.  I don't think Eryu has
pushed out an fstests release in a couple of weeks....

https://lore.kernel.org/fstests/158768467175.3019327.8681440148230401150.stgit@magnolia/

--D

> > For now I'm a little lost on the xfs check issues and would like to
> > share the work.  Maybe someone has an idea, otherwise I need to keep
> > on digging more.
> 
> I guess you could compare your git tree with mine:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-5.7-sync
> 
> --D
