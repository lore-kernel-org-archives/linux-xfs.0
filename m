Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4C0C10DCE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 23:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FDB320409
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 23:26:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AQKsaebG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCXX0J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 19:26:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44386 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgCXX0J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 19:26:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ONN2Zj077641;
        Tue, 24 Mar 2020 23:26:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=m0enaMIfzbxL9mx58oTlEewx0UJnGgL1T622R53ZwfI=;
 b=AQKsaebG3NJHfGevUmYY5jML8T1tHEvmoJI15NMh5bWMlv3I8EhZ/BAmMBQKfiiGrrVV
 0nVsrHD5ruxPYVPZ5WsFTj1n3L1P3Wv7dWu6fxYoJ4z8QZoT65E1k9R75k9lfjy+a+x2
 9Gg9Nj5v4cYl4A09lkdv0xQxjHPAZl1Cqov1B+KuWOuV23X8BBS+qqiSrTECkicRDa6R
 R83C5tJGydu2NKF9G4tKgFmk/1Fq1GMI1MExBiaV3hlRabBgXlsE/lToWJyv22eGis5p
 inmRgCAiwTCgReuApYAsTF6t9F9sipr+DKQLPHhbYLkO56w+HygZOsnCOL37j2g2iXSa tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ywavm731c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 23:26:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ONMp8i145456;
        Tue, 24 Mar 2020 23:24:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yymbuq7h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 23:24:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02ONO32x005115;
        Tue, 24 Mar 2020 23:24:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 16:24:03 -0700
Date:   Tue, 24 Mar 2020 16:24:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_io: set exitcode on failure appropriately
Message-ID: <20200324232401.GT29339@magnolia>
References: <20200324001928.17894-1-david@fromorbit.com>
 <20200324001928.17894-6-david@fromorbit.com>
 <ca7c97de-f3ea-2bbb-98b6-26f8da1fca0c@sandeen.net>
 <20200324231255.GZ10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324231255.GZ10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240114
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 10:12:55AM +1100, Dave Chinner wrote:
> On Tue, Mar 24, 2020 at 03:57:26PM -0500, Eric Sandeen wrote:
> > On 3/23/20 7:19 PM, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Many operations don't set the exitcode when they fail, resulting
> > > in xfs_io exiting with a zero (no failure) exit code despite the
> > > command failing and returning an error. The command return code is
> > > really a boolean to tell the libxcmd command loop whether to
> > > continue processing or not, while exitcode is the actual xfs_io exit
> > > code returned to the parent on exit.
> > > 
> > > This patchset just makes the code do the right thing. It's not the
> > > nicest code, but it's a start at producing correct behaviour.
> > > 
> > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > 
> > I wonder if there somewhere we could formally document these conventions...
> > 
> > Like maybe at least near the "exitcode" global declaration?
> 
> I really think we need to rework the way we do the error handling
> in the command line parsing for these utilities. One of the things I
> found in doing this is that most of the code does return error codes
> to the main function, only then to drop it on the floor and turn it
> into "exitcode = 1; return 0;" pair.
> 
> So I'm pondering how to make this much simpler - returning error
> codes from the command functions would be a much better idea,
> then have a command flag to indicate whether we continue on error or
> terminate.
> 
> That moves all the exit code handling out of the commands and
> provides consistent error handling for all commands and
> infrastructure - 0 = success, failure returns negative errno - and
> so should enable much more reliable and consistent error handling
> across all the utilities....

It seems reasonable to me, though I wonder how fstests will react to
that.  Then again, a lot of xfs_io error handling seems to be done via
grep so maybe it wouldn't be that bad. :)

--D

> Thoughts?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
