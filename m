Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321ACC433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 22:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbiBGWey (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 17:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbiBGWey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 17:34:54 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 817EFC061355
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 14:34:53 -0800 (PST)
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C11BC10C7968;
        Tue,  8 Feb 2022 09:34:52 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nHCay-009KV3-5o; Tue, 08 Feb 2022 09:34:52 +1100
Date:   Tue, 8 Feb 2022 09:34:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] metadump: handle corruption errors without aborting
Message-ID: <20220207223452.GH59729@dread.disaster.area>
References: <CAA43vkV_nDTJjXqtWw-jpc8KVWwa2jQ8-2bNbNJZBcsBSHV8dw@mail.gmail.com>
 <20220202024430.GZ59729@dread.disaster.area>
 <20220202074242.GA59729@dread.disaster.area>
 <CAA43vkXxyHmQdu-GqVukmeOqEh8g-xJDCDD6sx7t4f-MVn+BBA@mail.gmail.com>
 <CAA43vkX6au8gmO97otOT4LQOzspomodGSO__qPMmFozzMsrRQg@mail.gmail.com>
 <CAA43vkUFW3Y_0L7dFc+iAySdf4j3cX4M9Xoz+3eU4raoavmnew@mail.gmail.com>
 <20220202220559.GB59729@dread.disaster.area>
 <CAA43vkXsEydXtf8urxSBKo2WN4arbMDKw3+8mA7YSAJ9ZJwg9w@mail.gmail.com>
 <20220206223421.GD59729@dread.disaster.area>
 <CAA43vkWYtA2XfvvM3Z74NgyzimE3qztpK3VMjsATDBc4HvZ7gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA43vkWYtA2XfvvM3Z74NgyzimE3qztpK3VMjsATDBc4HvZ7gA@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62019e8c
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=8vcjtwjFO7ly4Dx5HFQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 07, 2022 at 04:42:28PM -0500, Sean Caron wrote:
> Hi Dave,
> 
> Your suggestion was right on. I ran xfs_metadump with the "-a"
> parameter and it was able to finish without any more showstoppers.

Thanks for the feedback - I'll have a look at tightening up the
constraints on the zeroing code so that it doesn't do stupid stuff
like this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
