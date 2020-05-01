Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D76FC4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 15:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3941F216FD
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 15:53:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VHoBaoms"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgEAPxj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 11:53:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34802 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728495AbgEAPxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 11:53:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041FlkU9005235;
        Fri, 1 May 2020 15:53:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5fWckKJWAR99oYakuw8ymhY3Pv39aMRb6zllx+N1I14=;
 b=VHoBaomstsfTsO5TE3y6H6BCD6ByOXCM3m8BEAgWntByfOWCxi8lt7KKDpLmRP2xpjYu
 NmwpGLyz1frlM9tLdIvMFTkP6MdM0IS9bO1Rm1dzDzdreCOBuH55stGqZSNV7gGpeXm9
 JwuoK3Mz0BdWeSuV6OtfNftaenhR3uToLqHXOX/XAii8ZIXqhy7U7zVIipzMmufvwnTN
 VlptKonEhWREskmH/NNYpr12h+ApiahpsKOFEHAAJFu84VDYPnUc4tlvJt1NBUbyoe+F
 C6kG6FFikwKTDPpGah3S8JoGnxkZcRdjd12eX5b82SHWH5LhUZZsmnKE2aLQQG9e7rch lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30r7f5tuk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 15:53:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041FbThv005355;
        Fri, 1 May 2020 15:53:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30r7fgy7np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 15:53:20 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 041FrHuP021031;
        Fri, 1 May 2020 15:53:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 May 2020 08:53:17 -0700
Date:   Fri, 1 May 2020 08:53:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: pass a commit_mode to xfs_trans_commit
Message-ID: <20200501155316.GS6742@magnolia>
References: <20200409073650.1590904-1-hch@lst.de>
 <20200501080703.GA17731@infradead.org>
 <20200501102403.GA37819@bfoster>
 <20200501104245.GA28237@lst.de>
 <20200501115132.GG40250@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501115132.GG40250@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 07:51:32AM -0400, Brian Foster wrote:
> On Fri, May 01, 2020 at 12:42:45PM +0200, Christoph Hellwig wrote:
> > On Fri, May 01, 2020 at 06:24:03AM -0400, Brian Foster wrote:
> > > I recall looking at this when it was first posted and my first reaction
> > > was that I didn't really like the interface. I decided to think about it
> > > to see if it grew on me and then just lost track (sorry). It's not so
> > > much passing a flag to commit as opposed to the flags not directly
> > > controlling behavior (i.e., one flag means sync if <something> is true,
> > > another flag means sync if <something else> is true, etc.) tends to
> > > confuse me. I don't feel terribly strongly about it if others prefer
> > > this pattern, but I still find the existing code more readable.
> > > 
> > > I vaguely recall thinking it might be nice if we could dump this into
> > > transaction state to avoid the aforementioned logic warts, but IIRC that
> > > might not have been possible for all users of this functionality..
> > 
> > Moving the flag out of the transaction structure was the main motivation
> > for this series - the fact that we need different arguments to
> > xfs_trans_commit is just a fallout from that.  The rationale is that
> > I found it highly confusing to figure out how and where we set the sync
> > flag vs having it obvious in the one place where we commit the
> > transaction.
> > 
> 
> Sorry, I was referring to moving your new [W|DIR]SYNC variants to
> somewhere like xfs_trans_res->tr_logflags in the comment above, not the
> existing XFS_TRANS_SYNC flag (which I would keep). Regardless, I didn't
> think that would work across the board from looking at it before.
> Perhaps it would work in some cases..
> 
> I agree that the current approach is confusing in that it's not always
> clear when to set the sync flag. I disagree that this patch makes it
> obvious and in one place because when I see this:
> 
> 	error = xfs_trans_commit(args->trans, XFS_TRANS_COMMIT_WSYNC);
> 
> ... it makes me think the flag has an immediate effect (like COMMIT_SYNC
> does) and subsequently raises the same questions around the existing
> code of when or when not to use which flag in the context of the
> individual transaction. *shrug* Just my .02.

Similarly, this fell off my radar screen once the three of us started
lobbing log refactoring patchsets at each other. :)

AFAICT the goal of the WSYNC/DIRSYNC logic is basically to annotate the
transaction to say "sysadmin wants all (write|namespace) operations to
commit synchronously", so at first I was a little surprised that this
added a flags argument to xfs_trans_commit instead of adding a couple of
flags to capture the "I'm a write op" or  "I'm a namespace op" to
xfs_trans_alloc.

/Then/ I realized that xfs_trans_alloc lets you set t_flags directly
with almost no validation and died a little inside.  Then it occurred
to me that maybe this is deliberately done just prior to the final
commit so that the intermediate transaction rolls are not committed
synchronously, just one big log force at the end.

/And then/ I noticed that in the places where we set SYNC just prior to
xfs_trans_commit, each deferred op that gets run via xfs_trans_commit's
call to xfs_defer_finish_noroll blocks waiting for xfs_log_force_lsn,
when we could probably get away with only forcing the log at the very
end of the transaction chain.

So, uh, my question is, would it make more sense to (a) create a
separate trans_alloc flags namespace so that (b) we can add the
wsync/dirsync annotations from the outset, while keeping in mind that
(c) we could possibly let the intermediate transaction rolls commit in
the usual asynchronous fashion so long as the last one forces the log?

--D

> Brian
> 
