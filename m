Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AE3C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 22:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534BC20838
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 22:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LS9RrHOy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgJ2Wta (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 18:49:30 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:53804 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2Wta (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 18:49:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKTfuq010424;
        Thu, 29 Oct 2020 20:31:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KhqW/AJ6QXmnflST67gVIMl63wND8QKJ5heJL85mc5U=;
 b=LS9RrHOylYky3v4MdLWMAsog3m6p6xQcCZxOSCinQbE2PdtUu23gtmY188SoCEnFfOtl
 gHP3XnMgC0PGqzvG3yVtWbk9xk7I8/ztU1QBq0Yrd+EYv9h7IU9ewJOqoU89TZJ+CAn2
 9o996Ezyr6zmoXL8OCx5mbN8KfjlPLGpEaOiMz3IlB8/eJawmeUNdN3m9cNbDAP5rEh1
 TG8gSc1xKOemqlM4DnNCR3utovjvsAhQSgmrqU6EyBk3i9grdbLbSK6cPq5BU28PPPo4
 NDdgt6fHv484Tc1XpIxGTVtHdKl9UUFcb7XHo4tqhoUvhicxT5oCj6coycmuWkuCvm/n pQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sb72by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 20:31:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKUCZV138924;
        Thu, 29 Oct 2020 20:31:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34cx60x8uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 20:31:13 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TKVCOi011509;
        Thu, 29 Oct 2020 20:31:12 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 13:31:11 -0700
Date:   Thu, 29 Oct 2020 13:31:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: test inobtcount upgrade
Message-ID: <20201029203110.GB1061252@magnolia>
References: <160382541643.1203756.12015378093281554469.stgit@magnolia>
 <160382542877.1203756.11339393830951325848.stgit@magnolia>
 <20201029174023.GC1660404@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029174023.GC1660404@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 01:40:23PM -0400, Brian Foster wrote:
> On Tue, Oct 27, 2020 at 12:03:48PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure we can actually upgrade filesystems to support inobtcounts.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/xfs        |   16 ++++++++++++
> >  tests/xfs/910     |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/910.out |    3 ++
> >  tests/xfs/group   |    1 +
> >  4 files changed, 92 insertions(+)
> >  create mode 100755 tests/xfs/910
> >  create mode 100644 tests/xfs/910.out
> > 
> > 
> ...
> > diff --git a/tests/xfs/910 b/tests/xfs/910
> > new file mode 100755
> > index 00000000..1924d9ea
> > --- /dev/null
> > +++ b/tests/xfs/910
> > @@ -0,0 +1,72 @@
> ...
> > +
> > +# Now upgrade to inobtcount support
> > +_scratch_xfs_admin -O inobtcount >> $seqres.full
> > +_check_scratch_fs
> > +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' -c 'agi 0' -c 'p' >> $seqres.full
> > +
> > +# Mount again, look at our files
> > +_scratch_mount >> $seqres.full
> > +cat $SCRATCH_MNT/urk
> > +
> 
> I think we probably want some more explicit form of validation here.
> Perhaps dump the inobt block counters from the above xfs_db command to
> the golden output..? As it is, we can comment out the xfs_admin command
> and the test still passes.

Ok.

> > +# success, all done
> > +echo Silence is golden.
> 
> We can also probably drop this if we have some other form of output from
> the test.

Will do.  Thanks for reviewing!

> Brian
> 
> > +status=0
> > +exit
> > diff --git a/tests/xfs/910.out b/tests/xfs/910.out
> > new file mode 100644
> > index 00000000..83992f49
> > --- /dev/null
> > +++ b/tests/xfs/910.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 910
> > +moo
> > +Silence is golden.
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 4b0caea4..862df3be 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -524,6 +524,7 @@
> >  760 auto quick rw collapse punch insert zero prealloc
> >  761 auto quick realtime
> >  763 auto quick rw realtime
> > +910 auto quick inobtcount
> >  915 auto quick quota
> >  917 auto quick db
> >  918 auto quick db
> > 
> 
