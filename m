Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDF0C05027
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Feb 2023 18:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbjBNSrR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 13:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbjBNSrG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 13:47:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1436E2F78C;
        Tue, 14 Feb 2023 10:46:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2967617F0;
        Tue, 14 Feb 2023 18:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F77EC433EF;
        Tue, 14 Feb 2023 18:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676400403;
        bh=5zLMb5SAQKmnDz8LNTdkwuFko4Duzsjb8oJVRYQGgo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R4J/0ZqXhww9sv9GHcml6gzXLWJrTLqLeqxJTrGrURvBtn6Vm0hDOsIVSzMJPdeg8
         wKFtgvTCcszheSosEs/TNRdRyXItLJOSLWty4CqUDnLZngXdmSU4fhSrFPr5UFuY85
         IAZc8jhNQwuSimfZNoszarwC3+Tg1cscJm+hvPI60XzGfSEIowLFuMBn78jvkUZbGL
         fsRTa7n31F23+QxLPAKKa61uQWVKAoBEaLjoVK1OLEzr7yQ9LUQj4+NNk7ucO1zvo6
         +Sm4Klinf7brq007OSZi2sQOeIjhhQm0nPFsikPKfBqYw39O2LWbJVaR/jLdUtrlrt
         PLxybAbgxRLOw==
Date:   Tue, 14 Feb 2023 10:46:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, leah.rumancik@gmail.com
Subject: Re: [PATCH 1/8] check: generate section reports between tests
Message-ID: <Y+vXEjKI08PXe95J@magnolia>
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
 <167149446946.332657.17186597494532662986.stgit@magnolia>
 <f447b1ab-ce5d-a736-6427-d1a3f33d20cf@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f447b1ab-ce5d-a736-6427-d1a3f33d20cf@gmx.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2022 at 09:14:07AM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/12/20 08:01, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Generate the section report between tests so that the summary report
> > always reflects the outcome of the most recent test.  Two usecases are
> > envisioned here -- if a cluster-based test runner anticipates that the
> > testrun could crash the VM, they can set REPORT_DIR to (say) an NFS
> > mount to preserve the intermediate results.  If the VM does indeed
> > crash, the scheduler can examine the state of the crashed VM and move
> > the tests to another VM.  The second usecase is a reporting agent that
> > runs in the VM to upload live results to a test dashboard.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >   check |   10 ++++++++++
> >   1 file changed, 10 insertions(+)
> > 
> > 
> > diff --git a/check b/check
> > index 1ff0f44af1..70a0b537b1 100755
> > --- a/check
> > +++ b/check
> > @@ -842,6 +842,16 @@ function run_section()
> >   		fi
> >   		seqres="$REPORT_DIR/$seqnum"
> > +		# Generate the entire section report with whatever test results
> > +		# we have so far.  Leave the $sect_time parameter empty so that
> > +		# it's a little more obvious that this test run is incomplete.
> > +		if $do_report; then
> > +			local sect_now=`_wallclock`
> > +			_make_section_report "$section" "${#try[*]}" \
> > +					     "${#bad[*]}" "${#notrun[*]}" \
> > +					     "" &> /dev/null
> > +		fi
> > +
> 
> In fact that's exactly what I just wanted to do next...
> 
> However one problem I can't work around is the timestamp.
> 
> Currently our timestamp is the finish time, with this change our timestamp
> is the start time.

Er... what do you mean exactly by start and finish time?  The most
recent test?  The entire run?

From check:

	if [ -w /dev/kmsg ]; then
		export date_time=`date +"%F %T"`
		echo "run fstests $seqnum at $date_time" > /dev/kmsg
		...
	fi

From common/report:

	if [ -z "$date_time" ]; then
		date_time=$(date +"%F %T")
	fi

	...timestamp="${date_time/ /T}">

The "date_time" variable can be set by ./check just prior to starting
each test, but only if /dev/kmsg is a writable file.  If it's set, then
the timestamp in the xml file reflects the start time of the most recent
test.

If date_time is not set, then the timestamp in the xml file records the
point in time when the report is generated... which I suppose is a good
enough estimate if we failed to record date_time when the test was
started.

> I'm not sure if there is any strong definition on the timestamp, but
> personally speaking, timestamp for the start time makes more sense to me.
> But there may be some users relying on the timestamp to be the ending time?

The junit xml schema says that the timestamp should be "when the test
was executed".  I think ./check ought to be setting date_time regardless
of /dev/kmsg.  ATM my test dashboard computes the difference between now
and the timestamp= attribute of the last report received to decide if it
should flag a test VM as possibly stalled.

Though to undercut everything I just wrote, the junit xml schema defines
testsuite and testcase as distinct entities and then refers to "the
test".

Given that fstests doesn't strictly follow that schema anyway, I guess
we can define the timestamp as we want, or add more timestamp
attributes?

<testsuite suite_timestamp="..." timestamp="..." report_timestamp="..."...>

--D

> Thanks,
> Qu
> 
> >   		mkdir -p $RESULT_DIR
> >   		rm -f ${RESULT_DIR}/require_scratch*
> >   		rm -f ${RESULT_DIR}/require_test*
> > 
