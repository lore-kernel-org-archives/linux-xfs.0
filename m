Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD19C2BA17
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 14:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 853082074D
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 14:53:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EefP7sqO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388742AbgDBOxx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 10:53:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41168 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388808AbgDBOxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 10:53:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032EdeeL124841;
        Thu, 2 Apr 2020 14:53:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nvBC+OsLhz55VqU897WoZhX20kTbIOpgHvaXPmom2E4=;
 b=EefP7sqOwy/icnyrZgNE+p7kSU2Ut62nV+TA6l1rwoXL0lYUIacBDtCM+MpuBSCV/aCo
 5vyxEBQhPEu1hm2FQXRv4HVu5J23GIXyLLx0asmribh3FsCoFB1Qe9abQLJKQ2rbu72w
 mdVC3AiJgKcRK0musI5h23azpDP8RZGd08Uia8glr6l/DI1czVwD8B4N0U6dfGKvwJZv
 kIZRC/1VFChQeuSoYjr3PvmvmFbP6gHjAdkmEFQKPWTMhU17w2exVuYQ0Jkn61sjECCJ
 QM3S4TAuwCmuX/ny83O89jTSmdtYcTVOmOG0OazSQMVs90JoIRlwRYDhesa5wbUHKSWl KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 303cevbxff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 14:53:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032EcHlI072406;
        Thu, 2 Apr 2020 14:53:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302ga2jsmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 14:53:45 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 032ErjKb013833;
        Thu, 2 Apr 2020 14:53:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 07:53:45 -0700
Date:   Thu, 2 Apr 2020 07:53:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reflink should force the log out if mounted with
 wsync
Message-ID: <20200402145344.GE80283@magnolia>
References: <20200402041705.GD80283@magnolia>
 <20200402075108.GB17191@infradead.org>
 <20200402084930.GA26523@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402084930.GA26523@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 02, 2020 at 01:49:30AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 02, 2020 at 12:51:08AM -0700, Christoph Hellwig wrote:
> > On Wed, Apr 01, 2020 at 09:17:05PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Reflink should force the log out to disk if the filesystem was mounted
> > > with wsync, the same as most other operations in xfs.
> > 
> > Looks reasonable.  That being said I really hate the way we handle
> > this - I've been wanting to rework the wsync/dirsync code to just mark
> > as transaction as dirsync or wsync and then let xfs_trans_commit handle
> > checking if the file system is mounted with the option to clean this
> > mess up.  Let me see if I could resurrect that quickly.
> 
> Resurrected and under testing now.  While forward porting your patch
> I noticed it could be much simpler even without the refactor by just
> using xfs_trans_set_sync.  The downside of that is that the log force
> is under the inode locks, but so are the log forces for all other wysnc
> induced log forces.  So I think you should just submit this in the
> simplified version matching the rest of the wsync users as a fix. If
> we want to optimize it later on that should be done as a separate patch
> and for all wsync/dirsync users.

Can you please send in a Reviewed-by so I can get this moving? :)

--D

