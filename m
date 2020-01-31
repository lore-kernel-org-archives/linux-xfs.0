Return-Path: <SRS0=/Bg7=3U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076BDC2D0DB
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jan 2020 20:04:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7777206F0
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jan 2020 20:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgAaUEW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 15:04:22 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46105 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725954AbgAaUEW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Jan 2020 15:04:22 -0500
Received: from callcc.thunk.org (guestnat-104-133-9-100.corp.google.com [104.133.9.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00VK4CxZ015136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jan 2020 15:04:14 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A7F13420324; Fri, 31 Jan 2020 15:04:11 -0500 (EST)
Date:   Fri, 31 Jan 2020 15:04:11 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     lsf-pc@lists.linux-foundation.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-block@vger.kernel.org, martin.petersen@oracle.com,
        Allison Collins <allison.henderson@oracle.com>,
        bob.liu@oracle.com
Subject: Re: [LSF/MM/BPF TOPIC] selectively cramming things onto struct bio
Message-ID: <20200131200411.GF332835@mit.edu>
References: <20200131004447.GA6869@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131004447.GA6869@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 04:44:47PM -0800, Darrick J. Wong wrote:
> Hi everyone,
> 
> Several months ago, there was a discussion[1] about enhancing XFS to
> take a more active role in recoverying damaged blocks from a redundant
> storage device when the block device doesn't signal an error but the
> filesystem can tell that something is wrong.
> 
> Yes, we (XFS) would like to be able to exhaust all available storage
> redundancy before we resort to rebuilding lost metadata, and we'd like
> to do that without implementing our own RAID layer.
> 
> In the end, the largest stumbling block seems to be how to attach
> additional instructions to struct bio.  Jens rejected the idea of adding
> more pointers or more bytes to a struct bio since we'd be forcing
> everyone to pay the extra memory price for a feature that in the ideal
> situation will be used infrequently.

I'd be interested in this discussion as well; the issue came up when
adding support for hardware-based inline-crypto support.

							- Ted
