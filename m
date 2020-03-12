Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2B4C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 22:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D81C1206FA
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 22:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y4CKVwtU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCLWoT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 18:44:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54072 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgCLWoT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 18:44:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CMdImj117919;
        Thu, 12 Mar 2020 22:44:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gGh8BPZm5F59cMNDBjRUiaB7lMs57Ar/B986e+W5muY=;
 b=Y4CKVwtUTF7P2jMzFL7tPt/JECJje14oyut/MRlWtzlvciy9l+LfsLhMTd+Tlbboht8U
 tmTzRVsAIPYBQup8FURhMVI2eVR1r41PsG3Ov6XsjOkowGd5MmoQBPgyXUGb4/hDkR1f
 QidMa/KpC5Ku1utdSK79k2O5ATQqzoI+9/aiapF3VO8Mk6JIe5lGiB+idMQ3TEuIY1Mq
 cfFjbC9QyJsD5QAS5slg9aPs2t05OQsijBSZf1JQguishtmnVOk/r/qs/n5pciA+KoX8
 MnC2L4ESm+gvNqW9/rrb9wxaFUzy7sugSWPGu6i5vLs2pImgVa/mu5rRWqWKamI0H9uI DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yqtag90sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 22:44:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CMWFiQ039010;
        Thu, 12 Mar 2020 22:44:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yqtab7e16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 22:44:14 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02CMiCl6017327;
        Thu, 12 Mar 2020 22:44:12 GMT
Received: from localhost (/10.145.179.117) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Thu, 12 Mar 2020 15:43:42 -0700
USER-AGENT: Mutt/1.9.4 (2018-02-28)
MIME-Version: 1.0
Message-ID: <20200312224342.GQ8045@magnolia>
Date:   Thu, 12 Mar 2020 15:43:42 -0700 (PDT)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Takashi Iwai <tiwai@suse.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use scnprintf() for avoiding potential buffer
 overflow
References: <20200311093552.25354-1-tiwai@suse.de>
 <20200311220914.GF10776@dread.disaster.area> <s5hsgie5a5r.wl-tiwai@suse.de>
 <20200312222701.GK10776@dread.disaster.area>
In-Reply-To: <20200312222701.GK10776@dread.disaster.area>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:27:01PM -0700, Dave Chinner wrote:
> On Thu, Mar 12, 2020 at 08:01:36AM +0100, Takashi Iwai wrote:
> > On Wed, 11 Mar 2020 23:09:14 +0100,
> > Dave Chinner wrote:
> > > 
> > > On Wed, Mar 11, 2020 at 10:35:52AM +0100, Takashi Iwai wrote:
> > > > Since snprintf() returns the would-be-output size instead of the
> > > > actual output size, the succeeding calls may go beyond the given
> > > > buffer limit.  Fix it by replacing with scnprintf().
> > > > 
> > > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > > ---
> > > >  fs/xfs/xfs_stats.c | 10 +++++-----
> > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > 
> > > what about all the other calls to snprintf() in fs/xfs/xfs_sysfs.c
> > > and fs/xfs/xfs_error.c that return the "would be written" length to
> > > their callers? i.e. we can return a length longer than the buffer
> > > provided to the callers...
> > > 
> > > Aren't they all broken, too?
> > 
> > The one in xfs_error.c is a oneshot call for a sysfs output with
> > PAGE_SIZE limit, so it's obviously safe.
> 
> Until the sysfs code changes. Then it's a landmine that explodes.

It's a pity we didn't make cursor management automatic and required for
sysfs/procfs/configfs/debugfs files...

...but in the meantime, Takashi-san, would you mind fixing the other
snprintfs in xfs, so at least the problems get fixed for the whole
subsystem?

> > OTOH, using snprintf() makes
> > no sense as it doesn't return the right value if it really exceeds, so
> > it should be either simplified to sprintf() or use scnprintf() to
> > align both the truncation and the return value.
> 
> Right, we have technical debt here, and lots of it. scnprintf() is
> the right thing to use here.
> 
> > > A quick survey of random snprintf() calls shows there's an abundance
> > > of callers that do not check the return value of snprintf for
> > > overflow when outputting stuff to proc/sysfs files. This seems like
> > > a case of "snprintf() considered harmful, s/snprintf/scnprintf/
> > > kernel wide, remove snprintf()"...
> > 
> > Yeah, snprintf() is a hard-to-use function if you evaluate the return
> > value.  I've submitted many similar patches like this matching a
> > pattern like
> > 	pos += snprintf(buf + pos, limit - pos, ...)
> > which is a higher risk of breakage than a single shot call.
> > 
> > We may consider flagging snprintf() to be harmful, but I guess it
> > wasn't done at the time scnprintf() was introduced just because there
> > are too many callers of snprintf().  And some code actually needs the
> > size that would be output for catching the overflow explicitly (hence
> > warning or resizing after that).
> 
> So, after seeing the technical debt the kernel has accumulated, it's
> been given a "somebody else's problem to solve" label, rather than
> putting in the effort to fix it.
> 
> Basically you are saying "we know our software sucks and we don't
> care enough to fix it", yes?
> 
> > Practically seen, the recent kernel snprintf() already protects the
> > negative length with WARN().
> 
> That's a truly awful way of handling out of bounds accesses: not
> only are we saying we know our software sucks, we're telling the
> user and making it their problem. It's a cop-out.
> 
> > But it's error-prone and would hit other
> > issue if you access to the buffer position by other than snprintf(),
> > so please see my patch just as a precaution.
> 
> Obviously, but slapping band-aids around like this not a fix for
> all the other existing (and future) buggy snprintf code.
> 
> I'm annoyed that every time a fundamental failing or technical debt
> is uncovered in the kernel, nobody takes responsibility to fix the
> problem completely, for everyone, for ever.
> 
> As Thomas said recently: correctness first.
> 
> https://lwn.net/ml/linux-kernel/87v9nc63io.fsf@nanos.tec.linutronix.de/
> 
> This is not "good enough" - get rid of snprintf() altogether.

$ git grep snprintf | wc -l
8534

That's somebody's 20 year project... :/

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
