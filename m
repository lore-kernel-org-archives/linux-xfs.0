Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14F8C35670
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 09:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B632D208C4
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 09:51:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lgrCR5Ye"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgBWJvl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 04:51:41 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:39241 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWJvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 04:51:40 -0500
Received: by mail-io1-f68.google.com with SMTP id c16so7195609ioh.6
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 01:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9+/PFZvtdACybAM7pJfqkoVh8IiiZ4pPQofnd7nD5dA=;
        b=lgrCR5YeTMeo0Kn9mjpOJN5Zf4n2mbWwoIMfohnhwc0YZh/HvYlafy/Dt0BQJAtt/y
         CM7gxA2hzrfapBQmvTO1q0f7TB/6s6ALR4AfQBU93dy6tzgdorka0uLoItCpWMKSBKnE
         jcGxh1Evav4z3Qh8eUhklTbMMB+EFPC8xUy10bOao9znvQZMnaJoPcDi55qTzDrmTDsp
         roZQxmvar9Qo2OWEqO++6y5WC8FgwL9MIUBKBqjgb280ayep3Vxtfn5fwHzJkPn+YLiE
         /6QHg099xxNBhpQNzkOl/NbIoGkrqsCyz4gOTWuetBlRWbrbJnqtIdPwLapwTOvzGwFC
         4NsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9+/PFZvtdACybAM7pJfqkoVh8IiiZ4pPQofnd7nD5dA=;
        b=MEH26hCbYSkMj8c7Hyj5SNRtz0+21ciWpmXZit26GZ6eaHyAV3eP1P0dUm60vpPtSM
         ji1TvebB5uYQ2SsNJ9DDKI5+UXugCrpDMyTbfFY0A4t1cgiPCIRDeIYJ5cMNMW2ldVoE
         BxPi8D38xWkUMlWFQgTpfY4rcsgAWPvd6bERoVMc6u69caQngLRKA2xbfU4H1DMppmJx
         TdL6T58kB6Dprm+lGZmeuQ/thTgoj6u6h8BXinXpv3A/ZWSuHV2rwxa2i+OZDcvYbdPB
         5b7p+HQBazMjHkd95dnECo7hhTTOoda1buBjxle5Cbm3azhJ9j3+dwjrvlZX7FUOqDEY
         Q9hQ==
X-Gm-Message-State: APjAAAWCYqzWl+4ZR2WID2+T3+9wW5w/w0AAYMRJ3MTbWm5b/ss1MAZL
        WqHMMiPj1753LZvNzX+IR/0tWYkcer9WUsLllNEDwA==
X-Google-Smtp-Source: APXvYqzGsiBuCrGNWABahuYneJc+6sTsuvbmsbqfACwH5t82tRKpf41+5QqCN/WaIIqsQ6knnvZryigkGI5CwU3IvuE=
X-Received: by 2002:a5d:9c88:: with SMTP id p8mr44542678iop.9.1582451500259;
 Sun, 23 Feb 2020 01:51:40 -0800 (PST)
MIME-Version: 1.0
References: <20200223073044.14215-1-chandanrlinux@gmail.com> <20200223073044.14215-7-chandanrlinux@gmail.com>
In-Reply-To: <20200223073044.14215-7-chandanrlinux@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 11:51:29 +0200
Message-ID: <CAOQ4uxhgXpDgpjBA+T0h4dwWEcPN7reFx4ywmMOK7=bJXpZQTQ@mail.gmail.com>
Subject: Re: [PATCH V4 7/7] xfs: Fix log reservation calculation for xattr
 insert operation
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, chandan@linux.ibm.com,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 9:28 AM Chandan Rajendra
<chandanrlinux@gmail.com> wrote:
>
> Log space reservation for xattr insert operation can be divided into two
> parts,
> 1. Mount time
>    - Inode
>    - Superblock for accounting space allocations
>    - AGF for accounting space used by count, block number, rmap and refcnt
>      btrees.
>
> 2. The remaining log space can only be calculated at run time because,
>    - A local xattr can be large enough to cause a double split of the dabtree.
>    - The value of the xattr can be large enough to be stored in remote
>      blocks. The contents of the remote blocks are not logged.
>
>    The log space reservation could be,
>    - 2 * XFS_DA_NODE_MAXDEPTH number of blocks. Additional XFS_DA_NODE_MAXDEPTH
>      number of blocks are required if xattr is large enough to cause another
>      split of the dabtree path from root to leaf block.
>    - BMBT blocks for storing (2 * XFS_DA_NODE_MAXDEPTH) record
>      entries. Additional XFS_DA_NODE_MAXDEPTH number of blocks are required in
>      case of a double split of the dabtree path from root to leaf blocks.
>    - Space for logging blocks of count, block number, rmap and refcnt btrees.
>
> Presently, mount time log reservation includes block count required for a
> single split of the dabtree. The dabtree block count is also taken into
> account by xfs_attr_calc_size().
>
> Also, AGF log space reservation isn't accounted for.
>
> Due to the reasons mentioned above, log reservation calculation for xattr
> insert operation gives an incorrect value.
>
> Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
> an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.
>
> To fix these issues, this commit changes xfs_attr_calc_size() to also
> calculate the number of dabtree blocks that need to be logged.
>
> xfs_attr_set() uses the following values computed by xfs_attr_calc_size()
> 1. The number of dabtree blocks that need to be logged.
> 2. The number of remote blocks that need to be allocated.
> 3. The number of dabtree blocks that need to be allocated.
> 4. The number of bmbt blocks that need to be allocated.
> 5. The total number of blocks that need to be allocated.
>
> ... to compute number of bytes that need to be reserved in the log.
>
> This commit also modifies xfs_log_calc_max_attrsetm_res() to invoke
> xfs_attr_calc_size() to obtain the number of blocks to be logged which it uses
> to figure out the total number of bytes to be logged.
>
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>

Hi Chandan,

It would have been useful to get this sort of overview in a cover
letter instead of
having to find it in the last patch.

I suppose it is a coincident that this work ended up in our mailboxes together
with Allison's delayed attr work, but it is interesting to know if the two works
affect each other in any way.

Thanks,
Amir.
