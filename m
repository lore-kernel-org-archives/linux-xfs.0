Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B703DC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 01:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8640520872
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 01:13:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KfbsXeOM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgESBNo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 21:13:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgESBNo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 21:13:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J1BPvs034741;
        Tue, 19 May 2020 01:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=rGgUdgyM2jpGe7QzhGti7QO0jdj32RaWfexNQRI7VQg=;
 b=KfbsXeOMHTJY4hdxVKaqNTIHeYrWn5/gI0TjhIuVJebzb0fCDd+SLdlH5OGiXlBwju3Y
 mCfDqY4B5AXLQ/ATCvpT9rcCzgJbZaE+5CHJsS7YT4PMXyVlgb+6TnyxCiW54zD1mkno
 Aja0iCfxZdl+mO7NeUYIhzUA0Hiv5tweDQlrtPWos7l5OBc735TP4Zi9xaYOOiddgP1t
 RtFiC1Godka5HkivhxkXh7vkQ0LjAHUk4yqN93PgYDZ7EP0PUxiywY2WPsx9R+p+xxD2
 Kul4gpAI9JTj41NLnAIudOqxG+W11HSW40JyiB1syyB/WyQVObg0o/qRvisHpJARRpyT +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tna4gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 01:13:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J1Cw2X119877;
        Tue, 19 May 2020 01:13:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t32mbr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 01:13:39 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04J1DcdM027264;
        Tue, 19 May 2020 01:13:38 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 18:13:37 -0700
Date:   Mon, 18 May 2020 18:13:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Leonardo Vaz <lvaz@redhat.com>
Subject: Re: [PATCH] xfs_repair: fix progress reporting
Message-ID: <20200519011335.GD17635@magnolia>
References: <c4df68a7-706b-0216-b2a0-a177789f380f@redhat.com>
 <20200519005809.GG17627@magnolia>
 <8cf1d221-e5af-0db0-bad5-1d86d859d624@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cf1d221-e5af-0db0-bad5-1d86d859d624@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 08:03:09PM -0500, Eric Sandeen wrote:
> On 5/18/20 7:58 PM, Darrick J. Wong wrote:
> > On Mon, May 18, 2020 at 05:35:33PM -0500, Eric Sandeen wrote:
> >> Long ago, a young developer tried to fix a segfault in xfs_repair where
> >> a short progress reporting interval could cause a timer to go off and try
> >> to print a progress mesage before any had been properly set up because
> >> we were still busy zeroing the log, and a NULL pointer dereference
> >> ensued.
> >>
> >> That young developer got it wrong, and completely broke progress
> >> reporting, because the change caused us to exit early from the pthread
> >> start routine, and not initialize the progress timer at all.
> >>
> >> That developer is now slightly older and wiser, and finally realizes that
> >> the simple and correct solution here is to initialize the message format
> >> to the first one in the list, so that we will be ready to go with a
> >> progress message no matter when the first timer goes off.
> >>
> >> Reported-by: Leonardo Vaz <lvaz@redhat.com>
> >> Fixes: 7f2d6b811755 ("xfs_repair: avoid segfault if reporting progre...")
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> It might be nice to add progress reporting for the log zeroing, but that
> >> requires renumbering all these macros, and we don't/can't actually get
> >> any fine-grained progress at all, so probably not worth it.
> >>
> >> diff --git a/repair/progress.c b/repair/progress.c
> >> index 5ee08229..d7baa606 100644
> >> --- a/repair/progress.c
> >> +++ b/repair/progress.c
> >> @@ -125,7 +125,11 @@ init_progress_rpt (void)
> >>  	 */
> >>  
> >>  	pthread_mutex_init(&global_msgs.mutex, NULL);
> >> -	global_msgs.format = NULL;
> >> +	/*
> >> +	 * Ensure the format string is not NULL in case the first timer
> >> +	 * goes off before any stage calls set_progress_msg() to set it.
> >> +	 */
> >> +	global_msgs.format = &progress_rpt_reports[0];
> > 
> > Hmm so does that mean the first progress report could be for "scanning
> > freespace"?
> 
> Yes.  But unless "zeroing the log" takes more than the report interval,
> which by default is 15 minutes, it won't be wrong.
> 
> > Or could you append a new entry to progress_rpt_reports for "getting my
> > shit together and moving out of my parents basement" and initialize it
> > to that?
> 
> Oh I guess it could be appended and wouldn't have to be out of order but
> honestly I don't think it's worth it, even a big slow log shouldn't take
> long enough to need a progress report.

Zeroing a 2048MB log in 900s = 2.28MB/s

So I guess that's unlikely... but it still feels like leaving some kind
of weird logic bomb lurking where if we decrease the interval or someone
throws us a slow cloudy block store, we'll start issuing weird progress
messsages about some other part of xfs_repair which hasn't even started
yet.  <shrug>

--D

> -Eric
> 
> > --D
> > 
> >>  	global_msgs.count = glob_agcount;
> >>  	global_msgs.interval = report_interval;
> >>  	global_msgs.done   = prog_rpt_done;
> >> @@ -171,10 +175,6 @@ progress_rpt_thread (void *p)
> >>  	msg_block_t *msgp = (msg_block_t *)p;
> >>  	uint64_t percent;
> >>  
> >> -	/* It's possible to get here very early w/ no progress msg set */
> >> -	if (!msgp->format)
> >> -		return NULL;
> >> -
> >>  	if ((msgbuf = (char *)malloc(DURATION_BUF_SIZE)) == NULL)
> >>  		do_error (_("progress_rpt: cannot malloc progress msg buffer\n"));
> >>  
> >>
> > 
