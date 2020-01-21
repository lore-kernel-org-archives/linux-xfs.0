Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0DF2C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 22:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC3DC2465A
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 22:31:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l5usyhrw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgAUWbS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 17:31:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgAUWbS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 17:31:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LMRwkd190353;
        Tue, 21 Jan 2020 22:31:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=l4szM0jELAj+V/8McYB4prZuwMuxzSoRlBO3tfCjro0=;
 b=l5usyhrwHtW3rQlUPAp9rav8/lhh4OoEYnThAViPUxDQFjiVRaVb+fNN6LSwV/lvCFcp
 9WinxUKBNdkSbQBF7I5Mqtpae4P5dAX4wxNrK7U9/1qoXivtIdXdTZwyiKdFyndazu8h
 PiWHRRoQPwjPlDSnarpDrpy/PlFdAO/NLsA8izuAfd7reyCq6fUqIUgoAtDziWk+vbLG
 7NfJ+lb0/XiWa/RBl6Vsrd6odfi8NWV4LBJzmkJNDsWWEFjPWAllUZwPT1oWbda9SepJ
 C/5zldp24lbBPlU0nC6vYfqyIjzPvQUJBDn4DiF63A09Hh3jv6tkfeRYwNV30A5jPKo3 XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xktnr81u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 22:31:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LMTOqK184667;
        Tue, 21 Jan 2020 22:31:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xnpfpvva6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 22:31:00 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LMV0tU001296;
        Tue, 21 Jan 2020 22:31:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 14:31:00 -0800
Date:   Tue, 21 Jan 2020 14:30:59 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 04/14] xfs: Add xfs_has_attr and subroutines
Message-ID: <20200121223059.GG8247@magnolia>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-5-allison.henderson@oracle.com>
 <20191224121830.GD18379@infradead.org>
 <2b29c0a0-03bb-8a21-8a8a-fd4754bff3ff@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b29c0a0-03bb-8a21-8a8a-fd4754bff3ff@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 24, 2019 at 09:21:49PM -0700, Allison Collins wrote:
> On 12/24/19 5:18 AM, Christoph Hellwig wrote:
> > On Wed, Dec 11, 2019 at 09:15:03PM -0700, Allison Collins wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > This patch adds a new functions to check for the existence of
> > > an attribute.  Subroutines are also added to handle the cases
> > > of leaf blocks, nodes or shortform.  Common code that appears
> > > in existing attr add and remove functions have been factored
> > > out to help reduce the appearance of duplicated code.  We will
> > > need these routines later for delayed attributes since delayed
> > > operations cannot return error codes.
> > 
> > Can you explain why we need the ahead of time check?  The first
> > operation should be able to still return an error, and doing
> > a separate check instead of letting the actual operation fail
> > gracefully is more expensive, and also creates a lot of additional
> > code.  As is I can't say I like the direction at all.
> > 
> 
> This one I can answer quickly: later when we get into delayed attributes,
> this will get called from xfs_defer_finish_noroll as part of a .finish_item
> call back.  If these callbacks return anything other than 0 or -EAGAIN, it
> causes a shutdown.

When does this happen, exactly?  Are you saying that during log
recovery, we can end up replaying a delayed attr log item that hits
ENOATTR/EEXIST somewhere and passes that out, which causes log recovery
to fail?

> Which is not what we would want for example: when the
> user tries to rename a non-existent attribute.  The error code needs to go
> back up.  So we check for things like that before starting a delayed
> operation.  Hope that helps.  Thanks!

...because as far as requests from user programs goes, we should be
doing all these precondition checks after allocating a transaction and
ILOCKing the inode, so that we can send the error code back to userspace
without cancelling a dirty transaction.

(I dunno, am I misunderstanding here?)

> Allison
