Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B96C2BB1D
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 15:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 780EB20746
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 15:52:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TzqY89UU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCMPwy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 11:52:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36700 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgCMPwy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 11:52:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02DFcqsY183115;
        Fri, 13 Mar 2020 15:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hsa92eJCA2FWhBP+aIfxdWoJVOlLhNOzSc/IxGIsXLc=;
 b=TzqY89UUL23IhZ0qXRg+7w4/QNGdecUudNkng8CKk4+H2RYOnaX+918dO63AlYCpN9mm
 S0+q/86JphyWYGKhONCdlED6/X9Bd4e5OalHXqBixgiy2pCAFvC0YjpGXWJZQTfAYPkV
 Zc+MGqrSRKiAxC1TAJHDxNWtLFdj4f8xTe/f1g3K6VQRIjwBtaHcUUgvLa322GUPeW2w
 gMXUPDMgK2UrYE1Du7foDAvFMMKRxIvrnSg/LaE6Pi5QNYF4lIwGlOl/701aXA5dRKNH
 Ca1DAqf0614kR1kQW8T5Q46Z21GaCeeb0gvlojrCacLEH/WVj27++d4XuL4dGmFhswFu DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yqtagcjwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Mar 2020 15:52:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02DFoQtA076552;
        Fri, 13 Mar 2020 15:52:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yqtacx9y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Mar 2020 15:52:49 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02DFqmpm031380;
        Fri, 13 Mar 2020 15:52:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Mar 2020 08:52:48 -0700
Date:   Fri, 13 Mar 2020 08:52:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use scnprintf() for avoiding potential buffer
 overflow
Message-ID: <20200313155248.GV1752567@magnolia>
References: <20200311093552.25354-1-tiwai@suse.de>
 <20200311220914.GF10776@dread.disaster.area>
 <s5hsgie5a5r.wl-tiwai@suse.de>
 <20200312222701.GK10776@dread.disaster.area>
 <20200312224342.GQ8045@magnolia>
 <20200313050000.GN10776@dread.disaster.area>
 <s5h4kus67u5.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h4kus67u5.wl-tiwai@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130081
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 13, 2020 at 08:18:42AM +0100, Takashi Iwai wrote:
> On Fri, 13 Mar 2020 06:00:00 +0100,
> Dave Chinner wrote:
> > 
> > On Thu, Mar 12, 2020 at 03:43:42PM -0700, Darrick J. Wong wrote:
> > > On Thu, Mar 12, 2020 at 03:27:01PM -0700, Dave Chinner wrote:
> > > > 
> > > > I'm annoyed that every time a fundamental failing or technical debt
> > > > is uncovered in the kernel, nobody takes responsibility to fix the
> > > > problem completely, for everyone, for ever.
> > > > 
> > > > As Thomas said recently: correctness first.
> > > > 
> > > > https://lwn.net/ml/linux-kernel/87v9nc63io.fsf@nanos.tec.linutronix.de/
> > > > 
> > > > This is not "good enough" - get rid of snprintf() altogether.
> > > 
> > > $ git grep snprintf | wc -l
> > > 8534
> > > 
> > > That's somebody's 20 year project... :/
> > 
> > Or half an hour with sed.
> > 
> > Indeed, not all of them are problematic:
> > 
> > $ git grep "= snprintf" |wc -l
> > 1744
> > $ git grep "return snprintf"|wc -l
> > 1306
> > 
> > Less than half of them use the return value.
> > 
> > Anything that calls snprintf() without checking the return
> > value (just to prevent formatting overruning the buffer) can be
> > converted by search and replace because the behaviour is the
> > same for both functions in this case.
> > 
> > Further, code written properly to catch a snprintf overrun will also
> > correctly pick up scnprintf filling the buffer. However, code that
> > overruns with snprintf()s return value is much more likely to work
> > correctly with scnprintf as the calculated buffer length won't
> > overrun into memory beyond the buffer.
> > 
> > And that's likely all of the snprintf() calls dealt with in half an
> > hour. Now snprintf can be removed.
> > 
> > What's more scary is this:
> > 
> > $ git grep "+= sprintf"  |wc -l
> > 1834
> > 
> > which is indicative of string formatting iterating over buffers with
> > no protection against the formatting overwriting the end of the
> > buffer.  Those are much more dangerous (i.e. potential buffer
> > overflows) than the snprintf problem being fixed here, and those
> > will need to be checked and fixed manually to use scnprintf().
> > That's where the really nasty technical debt lies, not snprintf...
> 
> Right, that's how I started looking through the whole tree and
> submitting patches like this.  I've submitted to per-subsystem patches
> and many of them have been already covered; after my tons of patches:
> 
>   % git grep '+= snprintf' | wc -l
>   147
>   
> The remaining codes are either doing right or it's a user-space code
> that have no scnprintf() available.  For other snprintf() usages can
> be converted to scnprintf() easily as you mentioned.
> 
> An open question is what we should do for the code that uses
> snprintf() in a right way.  snprintf() is useful to predict the
> non-fitted formatted string.  Some warns if such a situation happens.
> Replacing with scnprintf(), this would never hit, so you'll lose the
> way of message truncation there.
> 
> Maybe we may keep snprintf() but put a checkpatch warning for any new
> usage?
> 
> In anyway, if you prefer, I'll resubmit the patch to convert all
> snprintf() calls in xfs.

I already put the first patch in -next, so send a second patch to
convert the rest, please.

--D

> 
> thanks,
> 
> Takashi
