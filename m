Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BCCC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 15:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96CE1207F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 15:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tTazxQpE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgEMP3n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 11:29:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58202 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbgEMP3m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 11:29:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DFIYJB162888;
        Wed, 13 May 2020 15:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zcvvB9nC3z59/NXQwJa+c0RmnWFMPJIaLSuWpYoWDq8=;
 b=tTazxQpEmfHNkeQ/yEGH4iOYpHEuJaBlI9b33ri39MnQlZHx37Twio2BJmbI91SKpM/A
 EdqDY9QUVohJk6phfSxBjEZarl7D5rv62nPefURs+Hh7KkeOqbB+O0/Npk+CBupQHnQe
 gyodU7qrt3xoqacA2E7ZujhDbqZqbQlfH8htu6KqzirqIHPgMBs+Pn3EO5Bt99lLV9Cd
 fb2iveWrrxPCOw/pc3UZd7N0cC7HtJEkvRqBtCjbywYqV2WxKicYrt0yqJY4T7UTnDlK
 iJpZ1YyA2hJjBojy9LfmARPLW3IQBfjKKC6ZiJOkCK5BcIj7T/IyXQpep7JVe+94Emv8 qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3100yfvwca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 15:29:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DFI3xR138473;
        Wed, 13 May 2020 15:29:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3100yes95y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 15:29:37 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04DFTZ7I032109;
        Wed, 13 May 2020 15:29:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 May 2020 08:29:35 -0700
Date:   Wed, 13 May 2020 08:29:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: remove XFS_QMOPT_ENOSPC flag
Message-ID: <20200513152934.GX6714@magnolia>
References: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
 <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
 <20200508130154.GC27577@bfoster>
 <57c07fd1-9dd1-8a03-da29-2b1b99cfa2ed@sandeen.net>
 <20200508162129.GJ27577@bfoster>
 <20200512233443.GP6714@magnolia>
 <20200513110016.GA44225@bfoster>
 <5d9a041d-fb28-6629-8ca1-7f474f8c376b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d9a041d-fb28-6629-8ca1-7f474f8c376b@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=5 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=5 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005130137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 08:39:47AM -0500, Eric Sandeen wrote:
> On 5/13/20 6:00 AM, Brian Foster wrote:
> > On Tue, May 12, 2020 at 04:34:43PM -0700, Darrick J. Wong wrote:
> >> On Fri, May 08, 2020 at 12:21:29PM -0400, Brian Foster wrote:
> >>> On Fri, May 08, 2020 at 10:45:48AM -0500, Eric Sandeen wrote:
> >>>> On 5/8/20 8:01 AM, Brian Foster wrote:
> 
> ...
> 
> >>>> You're right that my patch changes these to ENOSPC.
> >>>>
> >>>>> Is the intent to change behavior such that -ENOSPC is
> >>>>> unconditional for project quota reservation failures?
> >>>>
> >>>> Now it's a conundrum.  I /think/ the current behavior is due to an oversight, but 
> >>>>
> >>>> a) I'm not certain, and
> >>>> b) can we change it now?
> >>>>
> >>>
> >>> Heh, I can't really tell what the intended/expected behavior is. For
> >>> whatever it's worth, it seems reasonable enough to me to change it based
> >>> on the fact that project quotas have been expected to return -ENOSPC in
> >>> at least some common cases for many years. It seems unlikely that users
> >>> would know or care about the change in behavior in the subset noted
> >>> above, but who knows. It might be good to get some other opinions. :P
> >>
> >> "I bet you a beer at the next conference (if they ever happen again)
> >> that nobody will notice"? :P
> >>
> > 
> > Apocalypse aside, free beer is free beer. ;)
> > 
> >> TBH while I find it a little odd that project quota gets to return
> >> ENOSPC instead of EDQUOT, I find it more odd that sometimes it doesn't.
> >> This at least gets us to consistent behavior (EDQUOT for user/group,
> >> ENOSPC for project) so for the series:
> >>
> > 
> > Works for me, but can we update the commit log to describe the behavior
> > change before this goes in? In fact, it might even make sense to retitle
> > the patch to something like "xfs: always return -ENOSPC on project quota
> > reservation failure" and let the flag removal be a side effect of that.
> 
> Yes that's a good plan. I'm also happy to just combine the 2 patches if
> that's better.  I'll sync up w/ Darrick to see if this can still happen.e
> 
> Thanks again for spotting the difference,

Yeah, that's fine.  I haven't even had a chance to find out if last
night's testing passed... :$

--D

> -Eric
> 
> > Brian
