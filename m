Return-Path: <SRS0=NLen=BG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF338C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 02:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C71342070A
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 02:10:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SfnNWbGA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgG0CKt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jul 2020 22:10:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgG0CKt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jul 2020 22:10:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06R21ZRO178565;
        Mon, 27 Jul 2020 02:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Z40DlkNWoIvbrCgNaxp36A3K8lHXfT6Uy6G3v//Eb+o=;
 b=SfnNWbGAbFBMxgoMhWNb0RWnlRXlwnD/Sh5uiINiKHK/GX5MjqVRRcO3obslawQnWhHz
 D+GQEZifeTzG9D96oW5qVmDRIKYoG/mPW845FzSxNj/FkFocOZbM45m30MBhQ8m8eh05
 aJczRNYW8nK9FQlxK/kF9MyI3b1CegwPuXUoHfGL3gmjKYtPYTKdV5jLbBWWuOezVd3+
 S9mdsQ+jOvsUH36TzSwiz4gYaSn8v2I4zv5gxc625FM0T+uvwfeow73HjeI2nF86YLsN
 wEfIj/iJm+PUQ/7J2hmTpeJvEoOdq2bLGJ2kQ4u1SUW1udU02ZVSIIxIKAJJFXBrL0+X YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32gx46j64q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Jul 2020 02:10:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06R211Sa196073;
        Mon, 27 Jul 2020 02:10:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32hdpprqv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 02:10:37 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06R2AY8S004604;
        Mon, 27 Jul 2020 02:10:34 GMT
Received: from localhost (/10.159.225.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jul 2020 19:10:34 -0700
Date:   Sun, 26 Jul 2020 19:10:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, david@fromorbit.com,
        hch@infradead.org, mhocko@kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] xfs: introduce task->in_fstrans for transaction
 reservation recursion protection
Message-ID: <20200727021034.GZ3151642@magnolia>
References: <20200726145726.1484-1-laoar.shao@gmail.com>
 <20200726160400.GF23808@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726160400.GF23808@casper.infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=1 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 suspectscore=1 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 26, 2020 at 05:04:00PM +0100, Matthew Wilcox wrote:
> On Sun, Jul 26, 2020 at 10:57:26AM -0400, Yafang Shao wrote:
> > Bellow comment is quoted from Dave,
> 
> FYI, you mean "Below", not "Bellow".  Dave doesn't often bellow.
> 
> > As a result, we should reintroduce PF_FSTRANS. Because PF_FSTRANS is only
> > set by current, we can move it out of task->flags to avoid being out of PF_
> > flags. So a new flag in_fstrans is introduced.
> 
> I don't think we need a new flag for this.  I think you can just set
> current->journal_info to a non-NULL value.
> 
> > +++ b/fs/xfs/xfs_linux.h
> > @@ -111,6 +111,20 @@ typedef __u32			xfs_nlink_t;
> >  #define current_restore_flags_nested(sp, f)	\
> >  		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
> >  
> > +static inline unsigned int xfs_trans_context_start(void)
> > +{
> > +	unsigned int flags = current->in_fstrans;
> > +
> > +	current->in_fstrans = 1;
> > +
> > +	return flags;
> > +}
> > +
> > +static inline void xfs_trans_context_end(unsigned int flags)
> > +{
> > +	current->in_fstrans = flags ? 1 : 0;
> > +}
> 
> Does XFS support nested transactions?  If we're just using
> current->journal_info, we can pretend its an unsigned long and use it
> as a counter rather than handle the nesting the same way as the GFP flags.

Not currently.

--D
