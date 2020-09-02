Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B221FC433E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A3B9206A5
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L/R7y8Y+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgIBRpi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:45:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53862 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgIBRpg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 13:45:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HddWq042578;
        Wed, 2 Sep 2020 17:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5MbtSMxLJbidQ1SNF6okT5hJlsToMHJdKpExLz71cSg=;
 b=L/R7y8Y+ft3cA2C4C+m7FymvzVcI4xftLDmNGMwiFhXk16J94tF0hUMPn/9ldN+7RPJA
 EgL1YBQ5oLT9rrY6ZX3/uulMx6IyuSPtzoPdZpnE+WSiAYJIr8vSLJgMeZwNjxyr/zP2
 BUgqtOHtvmYAUuMEO3YsmbPOJLQC/SC/JBayOnTRxxTwURmhRM7TiC2FUmqUwN6tVgPz
 VDuxhlAN7GhMdvyWzJnko3Zy2GNHuPlUD+cTfnWS5lLy6zLgdQUddW1wv1xR7e1vIJD0
 84zEKrP16KL81z6BBP95i3B0/zrSRYvuLDiK9KU7lZ73N7nL0JVATTFOZiNlFth56jBL bA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 339dmn2mwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 17:45:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082Heflr161173;
        Wed, 2 Sep 2020 17:45:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3380x7au02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 17:45:30 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 082HjScw009709;
        Wed, 2 Sep 2020 17:45:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 10:45:28 -0700
Date:   Wed, 2 Sep 2020 10:45:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Xiao Yang <yangx.jy@cn.fujitsu.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Add check for unsupported xflags
Message-ID: <20200902174527.GV6096@magnolia>
References: <20200831172250.GT6107@magnolia>
 <5F4DE4C1.6010403@cn.fujitsu.com>
 <20200901163551.GW6107@magnolia>
 <5F4F0647.5060305@cn.fujitsu.com>
 <20200902030946.GL6096@magnolia>
 <5F4F12E2.3080200@cn.fujitsu.com>
 <20200902041039.GM6096@magnolia>
 <5F4F2964.8050809@cn.fujitsu.com>
 <20200902170326.GP6096@magnolia>
 <20200902173828.GR878166@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902173828.GR878166@iweiny-DESK2.sc.intel.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=966 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=939 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=1
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 10:38:28AM -0700, Ira Weiny wrote:
> On Wed, Sep 02, 2020 at 10:03:26AM -0700, Darrick J. Wong wrote:
> > On Wed, Sep 02, 2020 at 01:11:00PM +0800, Xiao Yang wrote:
> > > Hi Darrick,
> > > 
> > > It is reasonable for your concern to add a check in VFS, but checking all
> > > defined xflags is too rough in VFS if one filesystem only supports few
> > > xflags. :-)
> > 
> > I was advocating for two levels of flags checks: one in the VFS for
> > undefined flags, and a second check in each filesystem for whichever
> > flag it wants to recognize.  I was not implying that the VFS checks
> > would be sufficient on their own.
> > 
> 
> I've not really followed this thread completely but wouldn't this proposed
> check in the VFS layer be redundant because the set of flags the filesystem
> accepts should always be a strict subset of the VFS flags?

Yes.  It's 100% CYA.  I wouldn't be that bent out of shape if the vfs
part never happens, but as we already have a vfs argument checker
function in addition to the per-fs validation I don't see why we would
leave a gap... ;)

--D

> Ira
