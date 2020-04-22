Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3BF9C55186
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF28A2077D
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 23:48:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sDHjFfVu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgDVXsp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 19:48:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42962 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgDVXsp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 19:48:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MNksll083158;
        Wed, 22 Apr 2020 23:48:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8zNf/ETfo5yWBAwg272mbgcIGtxdyaWyP7rMle+43N4=;
 b=sDHjFfVuTvhRa5+TW5EwtNoTO+LH8PZxb8ESIoDd8ZMlo4HprBGmqhj51/rFYWDVQIP4
 caxCkdbgbZ3yFeYnjjBa/aDo9IZMDBJW57hmhiIbrYojdNZZk1w4Y1t0Drr7Z348pwE6
 VyFMt6ewMHj4Q29vOBNrHMReFqUjYy78fSZRdKzq5/LOSpHEWQ/FTwXM4B4PGfnmZK64
 3oNh+SeZ534Asxd+p6nAKByB80rgmD8EZhi+eayWevTR4ypoUpFwtknA6x+4B/c4RgQ5
 JXCXBhEy+jPvS5wf6AqL5raJg+SvBgTkK78aOKXDfnK04ARWr5IiD2/T25/JF4DIRxNa Yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30grpgt6r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 23:48:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MNldgv024787;
        Wed, 22 Apr 2020 23:48:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30gb3unpcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 23:48:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03MNmP8m020186;
        Wed, 22 Apr 2020 23:48:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 16:48:24 -0700
Date:   Wed, 22 Apr 2020 16:48:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Chandan Rajendra <chandan@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, djwong@kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [XFS SUMMIT] Virtual XFS Developer Meetings
Message-ID: <20200422234823.GJ6742@magnolia>
References: <20200422222516.GP6749@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422222516.GP6749@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9599 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 03:25:16PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> I propose that we hold our own virtual XFS developer summit.  Physical
> proximity is way too risky for the forseeable future, so let's make do
> with online discussions and conferencing.  LSFMM 2020 was officially
> cancelled a short time ago.
> 
> Unlike in-person events, we cannot pin everyone into a single time zone
> for an extended meeting, and we can't have a hallway BOF.  On the plus
> side, we can finally invite /everyone/ to the table!  Let's use this
> email thread to make a list of topics for future discussions.  I can
> think of a few topic categories to start:
> 
>  1. Development process problems that people would like to address.
>  2. Matching patch authors with patch reviewers.
>  3. Old features that we ought to retire.
>  4. New feature development roadmap.
>  5. Anything else that people think is important.
> 
> Once we have a list of specific topics matched with people who are
> interested in that topic, I think it best to start each of those
> conversations in separate threads on linux-xfs where everyone can see
> them.

Also, uh, please tag your subject lines with "[XFS SUMMIT]" (like I
didn't do) to make it easier to track the topic discussions.

--D

> If the participants feel that they'd get more out of an
> interactive session, we have plenty of options for doing that:
> 
> The first option of course is the IRC channel (#xfs on freenode) from
> which it is easy to paste the irc logs into linux-xfs for archiving and
> further public comment.
> 
> For actual video conferencing, we also have tools such as Jitsi,
> BigBlueButton, BlueJeans, and Zoom.  I'm willing to sit in on video
> meetings to take notes for linux-xfs and/or post the recordings online.
> As a side note for anyone wanting to take advantage of videochats --
> I'd prefer to keep this to one hourlong meeting per day.
> 
> Please remember this is not an edict passed on from high to shake up
> everything; it is merely this maintainer suggesting that we explore
> other tactics for building things together.  In the end, everything that
> goes into making decisions still must be communicated via linux-xfs, and
> patches still have to earn Reviewed-by tags.  We do, however, have
> flexibility in how we get there.
> 
> Here are some topics that have been mentioned to me at least in passing
> over the last few months.  I'll start the first five topics since
> they're the ones I was going to put on the agenda for an XFS meeting at
> LSFMM until that all blew away.
> 
>  - Refactoring the Review Process (me, Eric, Dave)
> 
>  - Deferred inode inactivation and nonblocking inode reclaim (me, Amir)
> 
>  - 64bit timestamps (me, Amir)
> 
>  - Atomic extent swaps (me)
> 
>  - Online fsck (me)
> 
>  - Deprecating the v4 format (Dave)
> 
>  - Parent Pointers (Amir)
> 
>  - Range Locks (Amir)
> 
>  - DAX bashing session (Dan)
> 
>  - Widening the inode fork extent counters (Chandan)
> 
>  - Dirty buffer region bitmap tracking (Chandan)
> 
>  - Add your pet item here! :)
> 
> Thoughts, suggestions, and flames appreciated!
> 
> --D
