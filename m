Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E31C4742C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 14:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1100E22240
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 14:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgKMOKl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 09:10:41 -0500
Received: from sandeen.net ([63.231.237.45]:57442 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgKMOKl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Nov 2020 09:10:41 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B0C94876;
        Fri, 13 Nov 2020 08:10:21 -0600 (CST)
To:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
References: <20201113125127.966243-1-hsiangkao@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] xfsrestore: fix rootdir due to xfsdump bulkstat
 misuse
Message-ID: <e1e4f0a9-01bf-1ae4-5673-77738b3abd1b@sandeen.net>
Date:   Fri, 13 Nov 2020 08:10:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201113125127.966243-1-hsiangkao@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/13/20 6:51 AM, Gao Xiang wrote:
> If rootino is wrong and misspecified to a subdir inode #,
> the following assertion could be triggered:
>   assert(ino != persp->p_rootino || hardh == persp->p_rooth);
> 
> This patch adds a '-x' option (another awkward thing is that
> the codebase doesn't support long options) to address
> problamatic images by searching for the real dir, the reason
> that I don't enable it by default is that I'm not very confident
> with the xfsrestore codebase and xfsdump bulkstat issue will
> also be fixed immediately as well, so this function might be
> optional and only useful for pre-exist corrupted dumps.
> 
> In details, my understanding of the original logic is
>  1) xfsrestore will create a rootdir node_t (p_rooth);
>  2) it will build the tree hierarchy from inomap and adopt
>     the parent if needed (so inodes whose parent ino hasn't
>     been detected will be in the orphan dir, p_orphh);
>  3) during this period, if ino == rootino and
>     hardh != persp->p_rooth (IOWs, another node_t with
>     the same ino # is created), that'd be definitely wrong.
> 
> So the proposal fix is that
>  - considering the xfsdump root ino # is a subdir inode, it'll
>    trigger ino == rootino && hardh != persp->p_rooth condition;
>  - so we log this node_t as persp->p_rooth rather than the
>    initial rootdir node_t created in 1);
>  - we also know that this node is actually a subdir, and after
>    the whole inomap is scanned (IOWs, the tree is built),
>    the real root dir will have the orphan dir parent p_orphh;
>  - therefore, we walk up by the parent until some node_t has
>    the p_orphh, so that's it.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Thank you for looking into this - I think you now understand xfsdump &
xfsrestore better than anyone else on the planet.  ;)

One question - what happens if the wrong "root inode" is not a directory?
I think that it is possible from the old "get the first active inode" heuristic
to find any type of file and save it as the root inode.

I think that your approach still works in this case, but wanted to double check
and see what you think.

Thanks,
-Eric

