Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5830C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 23:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92B842255F
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 23:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbhADXTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 18:19:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41112 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbhADXTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 18:19:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104N8pK7035383;
        Mon, 4 Jan 2021 23:17:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4404Ut49WjuXqGqgQMYbqydPrceWr9QYH/0gripgiaM=;
 b=kY9c2CrQ2ozgCgPLN/YvampVq1U/1z9zq8m7vHU43NtjFwusfjwpo6Gm3z3gVyc0BFvH
 113ErNNcwoaLntYltcA9tMyJHIYVSFhFFnYneWvHNXJDv0CwJl0ztYdKftMUZoqPu7Ax
 5lq7ULUKxoTGJdY1pTZIcW4BGjQqRjTh+qJ+kJo0/E7rjjNvnn5KwWsAiGipo573wy7C
 l0kSq7LE4OF/Srok9DCEcgKp6Fxf7FhhGNli7xSb51v1BWISz0mW1nE6oJ1rVd37k3fN
 cxLBcmjAEhveZvUaeK01D43hm36rL4YLJRyaFDFxsXDuoPMM9T+WDIv/zQ6N4DpzULcq JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35tgskpk3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 04 Jan 2021 23:17:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104NAiu3015181;
        Mon, 4 Jan 2021 23:15:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35v1f7x7tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jan 2021 23:15:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 104NF9oU022484;
        Mon, 4 Jan 2021 23:15:09 GMT
Received: from localhost (/10.159.152.204)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 15:15:09 -0800
Date:   Mon, 4 Jan 2021 15:15:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     L A Walsh <xfs@tlinx.org>
Cc:     bfoster@redhat.com, xfs-oss <xfs@e29208.dscx.akamaiedge.net>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: suggested patch to allow user to access their own file...
Message-ID: <20210104231508.GP6918@magnolia>
References: <5FEB204B.9090109@tlinx.org>
 <20210104170815.GB254939@bfoster>
 <20210104184442.GM6918@magnolia>
 <5FF3796E.5050409@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FF3796E.5050409@tlinx.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040140
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Cc: bfoster@redhat.com, xfs-oss <xfs@e29208.dscx.akamaiedge.net>

akamaiedge.net ??

Er, did my mailer do that, or did yours?

[re-adding linux-xfs to cc]

On Mon, Jan 04, 2021 at 12:24:14PM -0800, L A Walsh wrote:
> 
> 
> On 2021/01/04 10:44, Darrick J. Wong wrote:
> > This would open a huge security hole because users can use it to bypass
> > directory access checks.
> ---
> 	Can't say I entirely disagree.  Though given the prevalence of that
> behavior being "normal" on NT due to the "Bypass Traverse Checking" "right"
> being on by default in a standard Windows setup,

That might be true on Windows, but CAP_DAC_* isn't given out by default
on Linux.

> I would question it being a 'huge' security hole, though it would be
> an unwanted change in behavior.

I think people would consider it a hole of /some/ kind, since this patch
wouldn't even require the process to hold CAP_DAC_* privilege.

> 	If a user has a shell open to a directory that is made
> inaccessible in the way you describe, though, simply staying connected
> would seem to allow opening FD's that would be otherwise inaccessible.
> 
> 	Further, can't a user pass an open file descriptor through
> some type of IPC call for the other side to use?  I may be misremembering
> something similar, so I'd have to dig unless someone else remembers.

Yes, they can do both of those things, since the Unix DAC only checks
access at open time.

> 	Though, in the following case:
> > 
> >  have a file /home/djwong/bin/pwnme, r/w by EBM (evil Bitcom minor).
> > then someone issues chmod 0000 on a dir above it...
> > Now I cannot access pwnme anymore, because I've been cut off from ~/bin.
> ----
> 	Oh...but if they hard linked it to someone else's open dir,
> they still could.  It seems if you want to secure the object, you really
> need to alter the perms on object, not on what might be 1 of
> several paths to it.  It might be bind-mounted elsewhere as well.

I /did/ say that the BOFH omitted -r... ;)

> 	Additionally you aren't dealing with removing more permissive
> ACL's...  That said, you're still right in that it opens a new
> potential security hole that anyone from MS would be used to/expecting
> (that's not to be taken as a justification to do it, just as context
> for expectations and level of the security hole.
> 
> 	Conversely, while users may have ownership rights in their
> home dir, they may not have write permissions above that -- possibly
> not even read permissions if that 'nt-right' is ever supported.
> 
> 	I'm guessing it's not easy to check if they might have path
> permissions to get there, though the intervening files could be accessible
> through a group ACL, that the user is a member of. Might
> be good to keep such files only executable by owner.
> 
> 	So I'd beg off on supporting that change now, without some
> other way of checking accessibility (which could be np-hard given
> the number of ways its possible to get around a simple directory blockade).
> 
> 	Given the wide use of linux as a file server, I'm wondering
> how one might support the extra 'right's from windows in some context.
> 
> 	Certainly, if the above scenario was used within a Linux-subsystem running
> on windows, the resulting access modes could
> be complicated.
> 
> 	This is way beyond this question (here, don't patch unless you
> check other CAPs), but wouldn't it make sense to have the ability
> to apply an LSM-model (or set of rules) only to some specific domain
> (in this case path traversal/access over diverse file systems that
> have different rules and capabilities)?

Yeah.  As far as I can tell, CAP_DAC_OVERRIDE actually /does/ give you
the security permissions that you want.  The sysadmin can then decide
who gets to have that permission, so you /could/ propose doing that.

> 	If it isn't possible already, I'm sure it soon will be
> the case that users will be on systems that have different file
> systems mounted.  If an xfs file system is mounted under an NT
> file system and the user is running Windows, wouldn't NT-rights
> (like ignoring traversal issues) apply by default, as NT would
> be in charge of enforcing security as it walked through a locally
> mounted XFS file system?

When would NT be walking through a locally mounted XFS filesystem?

--D
