Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D39AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 01:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiCXBOh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 21:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiCXBOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 21:14:36 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8E6F92330
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 18:13:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DB2D9533E0E;
        Thu, 24 Mar 2022 12:13:04 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXC2B-0097WL-4z; Thu, 24 Mar 2022 12:13:03 +1100
Date:   Thu, 24 Mar 2022 12:13:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs: Temporary extra disk space consumption?
Message-ID: <20220324011303.GA1544202@dread.disaster.area>
References: <26806b4a-5953-e45e-3f89-cff2020309b6@I-love.SAKURA.ne.jp>
 <20220323191647.GT1544202@dread.disaster.area>
 <29f2af94-3f79-5044-aae1-9e10a30d4864@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29f2af94-3f79-5044-aae1-9e10a30d4864@I-love.SAKURA.ne.jp>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623bc5a1
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=AMg5gvNtf1YKd3qJLggA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 24, 2022 at 08:28:30AM +0900, Tetsuo Handa wrote:
> On 2022/03/24 4:16, Dave Chinner wrote:
> > On Wed, Mar 23, 2022 at 08:21:52PM +0900, Tetsuo Handa wrote:
> >> Hello.
> >>
> >> I found that running a sample program shown below on xfs filesystem
> >> results in consuming extra disk space until close() is called.
> >> Is this expected result?
> > 
> > Yes. It's an anti-fragmentation mechanism that is intended to
> > prevent ecessive fragmentation when many files are being written at
> > once.
> 
> OK, this is an xfs specific behavior.
> 
> > Looks like specualtive preallocation for sequential writes is
> > behaving exactly as designed....
> 
> Here is the result of "filefrag -v my_testfile" before close().
> 
> Filesystem type is: 58465342
> File size of my_testfile is 1073741824 (262144 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..   65519:   33363497..  33429016:  65520:
>    1:    65520..  229915:   62724762..  62889157: 164396:   33429017:
>    2:   229916..  262143:   63132138..  63164365:  32228:   62889158: eof
>    3:   262144..  294895:   63164366..  63197117:  32752:             unwritten,eof
> my_testfile: 3 extents found
> 
> Filesystem type is: 58465342
> File size of my_testfile is 1073741824 (262144 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..  131055:   62724762..  62855817: 131056:
>    1:   131056..  240361:   63813369..  63922674: 109306:   62855818:
>    2:   240362..  262143:   32448944..  32470725:  21782:   63922675: eof
>    3:   262144..  349194:   32470726..  32557776:  87051:             unwritten,eof
>    4:   349195..  524271:          0..    175076: 175077:   32557777: unknown,delalloc,eof
> my_testfile: 4 extents found
> 
> An interesting behavior I noticed is that, since "filefrag -v" opens this file
> for reading and then closes this file descriptor opened for reading, injecting
> close(open(filename, O_RDONLY)) like below causes consumption by speculative
> preallocation gone; close() of a file descriptor opened for writing is not
> required.

Yup. This has never had a measurable impact on real world workloads
for us to need to optimise that away. Besides, ->release() cannot
tell if the prealloc belongs to that fd or not, so even if we were
to gate it on O_RDONLY, closing any writeable fd on that inode would
trigger the same behaviour regardless of whether that was the fd
that hte data was written to....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
