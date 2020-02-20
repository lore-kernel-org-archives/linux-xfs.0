Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D9EAC11D0C
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 17:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0379A24672
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 17:27:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gfgmlyTp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgBTR10 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 12:27:26 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38276 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728173AbgBTR10 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 12:27:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KHIL7O002889;
        Thu, 20 Feb 2020 17:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iMH00Z23erhtpgvaN3hHctCrK0hiMWN+sAj1E4xcUTg=;
 b=gfgmlyTpktwpIjxY9ifD54uAA5kx16XLuC6sjGPJc4UIgy86STCCZrKbjKG3rkvdJm3z
 eMSOkSPNRK1CpqMGzxUV9rMaTcd7JMF2sab5hpC3NVPJW6UNeBnbLbC2qlYhLrFWQKEb
 HnVN/0EIePKCw9psZoPaIKHkLNrAWXY4AX2EDO4OLcDIiCN8S+roYof1XYxOanj/Gfth
 UPnHGTVLrb8C/wgW++AkBSc3q25e5OlINPbSWYYTQYJmRLcCnnRKKfowGfV80XZ9gYCu
 K4FBpfv9ExmnhTBSs3VofGBsTgKZQ7mP2sNmySYVvUnhKJPxiGgWNH8+ZisQ1RIi2wcx ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y8ud1b9ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 17:27:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KHII6p107006;
        Thu, 20 Feb 2020 17:27:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2y8udd7j1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 17:27:10 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01KHRAlM014818;
        Thu, 20 Feb 2020 17:27:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Feb 2020 09:27:09 -0800
Date:   Thu, 20 Feb 2020 09:27:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20200220172708.GH9504@magnolia>
References: <20200214185942.1147742-1-preichl@redhat.com>
 <20200217133521.GD31012@infradead.org>
 <20200219044821.GK9506@magnolia>
 <20200219184019.GA10588@infradead.org>
 <b718e9e9-883b-0d72-507b-a47834397c5f@sandeen.net>
 <CAJc7PzU8JXoGDm3baSJo2jghOgzKEAHhAe9XvhLdE07JWe5WjQ@mail.gmail.com>
 <20200220163232.GA1651@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220163232.GA1651@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 08:32:32AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 20, 2020 at 05:30:35PM +0100, Pavel Reichl wrote:
> > OK, thanks for the comments.
> > 
> > Eric in the following code is WARN_ONCE() used as you suggested or did
> > you have something else in mind?
> > 
> > static inline bool
> > __xfs_rwsem_islocked(
> >         struct rw_semaphore     *rwsem,
> >         bool                    excl)
> > {
> >         if (!rwsem_is_locked(rwsem)) {
> >                 return false;
> >         }
> > 
> >         if (excl) {
> >                 if (debug_locks) {
> >                         return lockdep_is_held_type(rwsem, 1);
> >                 }
> >                 WARN_ONCE(1,
> >                         "xfs rwsem lock testing coverage has been reduced\n");
> >         }
> 
> Yikes, hell no.  This means every debug xfs build without lockdep
> will be full of warnings all the time.

Well... once per module load, but if you /were/ going to go down this
route I'd at least gate the warning on IS_ENABLED(CONFIG_LOCKDEP) so
that we only get this one-time warning when lockdep is enabled but dies
anyway, so that we'll know that we're running with half a brain.

--D
