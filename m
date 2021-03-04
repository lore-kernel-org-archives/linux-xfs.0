Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAEDC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 02:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C784664F78
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 02:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbhCDCIo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 21:08:44 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:35752 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229379AbhCDCIb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 21:08:31 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id A26D7632DF;
        Thu,  4 Mar 2021 13:07:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lHdP2-00Drei-4y; Thu, 04 Mar 2021 13:07:48 +1100
Date:   Thu, 4 Mar 2021 13:07:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Geert Hendrickx <geert@hendrickx.be>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_admin -O feature upgrade feedback
Message-ID: <20210304020748.GQ4662@dread.disaster.area>
References: <YDy+OmsVCkTfiMPp@vera.ghen.be>
 <20210301191803.GE7269@magnolia>
 <YD4tWbfzmuXv1mKQ@bfoster>
 <YD7C0v5rKopCJvk2@vera.ghen.be>
 <YD937HTr5Lq/YErv@bfoster>
 <YD+NF63sGji+OBtc@vera.ghen.be>
 <20210303170019.GH7269@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303170019.GH7269@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=HMF4cdRJZewUdH1l25wA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 09:00:19AM -0800, Darrick J. Wong wrote:
> On Wed, Mar 03, 2021 at 02:20:23PM +0100, Geert Hendrickx wrote:
> > On Wed, Mar 03, 2021 at 06:50:04 -0500, Brian Foster wrote:
> > > Maybe a simple compromise is a verbose option for xfs_admin itself..?
> > > I.e., the normal use case operates as it does now, but the failure case
> > > would print something like:
> > > 
> > >   "Feature conversion failed. Retry with -v for detailed error output."
> 
> Ugh, no, by the time the sysadmin /reruns/ repair, the original output
> is lost.  Frankly I'd rather xfs_admin stop interfering with
> stdout/stderr and teach repair to suppress errors due to upgrades.

Yup, that's what the 'xfs_db -p <progname>' effectively does. It
tells xfs_db to act as if it was some other program and behave
differently....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
