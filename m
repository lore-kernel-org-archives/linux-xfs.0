Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbfCXELl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Mar 2019 00:11:41 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2O48spP016534
        for <linux-xfs@vger.kernel.org>; Sun, 24 Mar 2019 00:11:40 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2re1q31sst-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Mar 2019 00:11:39 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 24 Mar 2019 04:11:24 -0000
From: Chandan Rajendra <chandan@linux.ibm.com>
Subject: Re: [PATCH] _require_prjquota: Disable tests only when using realtime fs
Date: Sun, 24 Mar 2019 09:42:24 +0530
In-Reply-To: <20190323114432.GV2824@desktop>
References: <20190320142112.31239-1-chandan@linux.ibm.com> <20190323114432.GV2824@desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2345183.pjMOytfh8P@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Saturday, March 23, 2019 5:14:32 PM IST Eryu Guan wrote:
> On Wed, Mar 20, 2019 at 07:51:12PM +0530, Chandan Rajendra wrote:
> > $USE_EXTERNAL needs to be set when using external log devices. In such a
> > setup, tests which have "_require_prjquota
> > $SCRATCH_DEV" (e.g. generic/383)  incorrectly end up being marked as
> > "not run" since the test "[ "$USE_EXTERNAL" = yes -a ! -z "$_dev" ]"
> > evaluates to true.
> > 
> > This commit fixes the bug by marking the test as "not run" only when
> > $USE_EXTERNAL is set and one of $TEST_RTDEV or $SCRATCH_RTDEV is set.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
> > ---
> >  common/quota | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/common/quota b/common/quota
> > index 9309e786..cb627f19 100644
> > --- a/common/quota
> > +++ b/common/quota
> > @@ -86,8 +86,9 @@ _require_prjquota()
> >      fi
> >      src/feature -P $_dev
> >      [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
> > -    if [ "$USE_EXTERNAL" = yes -a ! -z "$_dev" ]; then
> > -	_notrun "Project quotas not supported on realtime filesystem"
> > +    if [ "$USE_EXTERNAL" = yes -a \
> > +		 \( ! -z "$TEST_RTDEV" \-o ! -z "$SCRATCH_RTDEV" \) ]; then
> > +        _notrun "Project quotas not supported on realtime filesystem"
> 
> I changed this to
> 
>     if [ "$USE_EXTERNAL" = yes ]; then
>         if [ -n "$TEST_RTDEV" -o -n "$SCRATCH_RTDEV" ]; then
>             _notrun "Project quotas not supported on realtime filesystem"
>         fi
>     fi
> 
> which seems easier to read.
>

I agree that the above change makes the code more readable.

-- 
chandan
