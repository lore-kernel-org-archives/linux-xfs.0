Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFCEC77B61
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 02:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjD1CLv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 22:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjD1CLt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 22:11:49 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821D61FFB
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:11:48 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64115e652eeso9327733b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682647908; x=1685239908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0WnZ+vcp/jDBiLp8fBvapSBVbDzN4WDueOIp4WiXmsA=;
        b=NfvX5fCPqvMQkdAn2hhpJ8jbrDTx24D+QFDJ6oQTSqFLljw2KTp2kppXSKIQD75cZD
         S0KoyNQx/44x5IP6keEKPIZXFQImGqiZcRb2BTLnLke8pAWppcSwd/HaKkfCUSgI9GIW
         dyfpHK1X/+RB7dT/6/hGkokmc+W21JHteWL23r6m2indYmQAoRnrDm5RFMvEgDJCnoaf
         NZvDfk227IusLlbCAqwKYaFRp+h3/w1SVObJig0iNJQBqr74Wp021WHoHPdAkwHHUXAJ
         F0YOlvj3whU0eHD7VC4KES1mwKExWwjwMEZjmlSNtGmzeT8NKe5hXB9eZry8WhJ4iRAb
         HyOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682647908; x=1685239908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0WnZ+vcp/jDBiLp8fBvapSBVbDzN4WDueOIp4WiXmsA=;
        b=AG17jrA4Ksb4I5X6LQTpb1OD4S83aI/bqFswpwohlFOW37iq6dmbxRbCAQUq4PidtU
         bW/j3lRfNANanWszYpVPCVamkfqwiv9HSVboLhkAXN0DVM036QqoJxxrUyqdeywVFhbA
         P1Wb5wcpY0A5GhoeSm5jSHZtvs0x7fwSPq0PVovIXYMWKwzO+I6XtL63SW82CQKLVZ5u
         YH+3ih2hR4748FDrq+txKdlNF8WVeA1ixNFO5QH06yk+LyDZTWn+eSd/ddVlH/MXi6r8
         y+/YWqmbpS/WJK8yLkt5ft+ijgWSq27NAAroTzyEIe7anGwm9DhXNb5EBVYWZXqTqGM2
         4nEg==
X-Gm-Message-State: AC+VfDx3/T8VKUd/w28kLlHWaxNGLMTXngLnJS8A7nkGhvNXpIaZVz+4
        84/CUcqF7z3fBoPKx1hdwFBinO+FqqZzysgrJwg=
X-Google-Smtp-Source: ACHHUZ7yY7VwsJVD4zuCJ+y4ob+VOwRipW+R5kg7DG+nmk7Gi/QpKIMDfmjte6QQURzG6lu9OiWDdA==
X-Received: by 2002:a17:90a:e7d1:b0:24c:1688:8d8e with SMTP id kb17-20020a17090ae7d100b0024c16888d8emr3757312pjb.23.1682647908027;
        Thu, 27 Apr 2023 19:11:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id bj19-20020a17090b089300b002465a7fc0cfsm13609104pjb.44.2023.04.27.19.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 19:11:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1psDaL-008hvm-AS; Fri, 28 Apr 2023 12:11:45 +1000
Date:   Fri, 28 Apr 2023 12:11:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: flush dirty data and drain directios before
 scrubbing cow fork
Message-ID: <20230428021145.GP3223426@dread.disaster.area>
References: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
 <168263575120.1717721.12848317172206345585.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168263575120.1717721.12848317172206345585.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 03:49:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're scrubbing the COW fork, we need to take MMAPLOCK_EXCL to
> prevent page_mkwrite from modifying any inode state.  The ILOCK should
> suffice to avoid confusing online fsck, but let's take the same locks
> that we do everywhere else.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
