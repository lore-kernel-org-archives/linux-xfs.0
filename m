Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E75FC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 20:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbiA1UyW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 15:54:22 -0500
Received: from sandeen.net ([63.231.237.45]:41398 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239235AbiA1UyW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jan 2022 15:54:22 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 63C0178FD;
        Fri, 28 Jan 2022 14:54:08 -0600 (CST)
Message-ID: <a5dd2106-1f40-f987-a87d-2737d3e16034@sandeen.net>
Date:   Fri, 28 Jan 2022 14:54:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Allison Henderson <allison.henderson@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCHSET 00/45] xfsprogs: sync libxfs with 5.15
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:17 PM, Darrick J. Wong wrote:
> Hi all,
> 
> Backport libxfs changes for 5.15.  The xfs_buf changes and the reworking
> of the function predicates made things kind of messy, so I'm sending my
> version of this to the list for evaluation so that Eric doesn't have to
> stumble around wondering what I was smoking... ;)
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.

(whoops, this didn't get sent yesterday...?)

Thanks Darrick. I'm throwing in the towel on my usual approach of doing the
sync myself and comparing notes. I'm going to just treat this as a straight-up
review, primarily focusing on the not-kernel-crossports, and just pull in
your work because I clearly amd not getting this one done in a timely manner.

Thank you for this effort :)

-Eric
