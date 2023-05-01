Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61E5C77B7C
	for <linux-xfs@archiver.kernel.org>; Mon,  1 May 2023 23:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjEAXJ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 May 2023 19:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjEAXJz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 19:09:55 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5621708
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 16:09:54 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b46186c03so3583719b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 01 May 2023 16:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682982594; x=1685574594;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=83jF3javm2IhjdBSEcSbFHrys2hkXAM+Tjaef7x803g=;
        b=TbW3e03tAnaEP3lge4FgChNtIhFuM5LTfJJcro7uKsVwFjalu0Cr8YLafJgd+5/OnI
         LdD/bUOkJt+N1U7R1RcuCeOsYDZ6IaLEvYDvMNkJvdsRLu17k/pD+Ry4EKZtnMTGdcpF
         HINNazbPzamWrIGImURXbo0bE0IFZXYyCqsc4pDaUF4G2Siw5IwvDJSZdosTkV1d97FM
         Tlt5XO0kVxZELIZ1S7jt7i4IRAyiR8fw1OLjf78Kar+VlK/vv1GGO0+6WF+39kQKJpAy
         /fVWf3buyBfAaRP/MeVC0eVy7sFqtXEkmicQeznSxNLTOVv5kLujx2EF/fqjaOpO0MVj
         utfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682982594; x=1685574594;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=83jF3javm2IhjdBSEcSbFHrys2hkXAM+Tjaef7x803g=;
        b=JqAfSxkNQiAWbxeDs5rx7gahLmKfwC1IUeas7nc2Hrww4oVGgh3LJS3ixAv0os/bfo
         YzphXUQu92L+DQco6e6RzUXmihytnoWxjivzwyM4sBgIef6GEGUbB79mggYcGuNdFSY+
         sqsRaocXDUjHf3MFmv3GaO6/Nqzomcdu/a68iwk5xF9zBTeoUpUdF50u6+xExqOIU9oE
         bJZTt3fAot0Qc0u3QDGHrtqKH0qR3j9DCWJkbJ3ZXL0L7BvaDS3oUiLi46liG2anz9Bb
         zaRV6xND5w0bCVhYIsVCdrgaQH/3mqvjpFj7nEa8unauFr7Ok5gI5/PhcPwEXgnuwHki
         6uoQ==
X-Gm-Message-State: AC+VfDw5pC4CVnMQlxKdi69xEEdIMsO0vep5p/Rld3yHYrQ/0cINIgCM
        IJdOb2WeM3y+KlLV/lOYO784XA==
X-Google-Smtp-Source: ACHHUZ6zmRI7kkraQDrX6l4fnFh+hFAnB1hmeK6dGRLOPmUOI34gA1k3084/+p7rODXvQByrE2HvFw==
X-Received: by 2002:a05:6a20:7291:b0:ef:1d4e:cf3e with SMTP id o17-20020a056a20729100b000ef1d4ecf3emr19761392pzk.50.1682982593924;
        Mon, 01 May 2023 16:09:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id w75-20020a62824e000000b0063b17b58822sm20446283pfd.74.2023.05.01.16.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 16:09:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ptceU-00AEb3-Mp; Tue, 02 May 2023 09:09:50 +1000
Date:   Tue, 2 May 2023 09:09:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        yebin10@huawei.com
Subject: Re: [PATCH 5/4] xfs: fix negative array access in xfs_getbmap
Message-ID: <20230501230950.GY3223426@dread.disaster.area>
References: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
 <20230501212434.GM59213@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230501212434.GM59213@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 01, 2023 at 02:24:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit 8ee81ed581ff, Ye Bin complained about an ASSERT in the bmapx
> code that trips if we encounter a delalloc extent after flushing the
> pagecache to disk.  The ioctl code does not hold MMAPLOCK so it's
> entirely possible that a racing write page fault can create a delalloc
> extent after the file has been flushed.  The proposed solution was to
> replace the assertion with an early return that avoids filling out the
> bmap recordset with a delalloc entry if the caller didn't ask for it.
> 
> At the time, I recall thinking that the forward logic sounded ok, but
> felt hesitant because I suspected that changing this code would cause
> something /else/ to burst loose due to some other subtlety.
> 
> syzbot of course found that subtlety.  If all the extent mappings found
> after the flush are delalloc mappings, we'll reach the end of the data
> fork without ever incrementing bmv->bmv_entries.  This is new, since
> before we'd have emitted the delalloc mappings even though the caller
> didn't ask for them.  Once we reach the end, we'll try to set
> BMV_OF_LAST on the -1st entry (because bmv_entries is zero) and go
> corrupt something else in memory.  Yay.
> 
> I really dislike all these stupid patches that fiddle around with debug
> code and break things that otherwise worked well enough.  Nobody was
> complaining that calling XFS_IOC_BMAPX without BMV_IF_DELALLOC would
> return BMV_OF_DELALLOC records, and now we've gone from "weird behavior
> that nobody cared about" to "bad behavior that must be addressed
> immediately".
> 
> Maybe I'll just ignore anything from Huawei from now on for my own sake.
> 
> Reported-by: syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-xfs/20230412024907.GP360889@frogsfrogsfrogs/
> Fixes: 8ee81ed581ff ("xfs: fix BUG_ON in xfs_getbmap()")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_bmap_util.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Ugh. Yet again we add weight to the approach of "if it ain't broke,
don't fix it" for maintaining code that has not changed for a long
time...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
