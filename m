Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECB8C4321E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 09:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiK3JfO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 04:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbiK3Jeo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 04:34:44 -0500
Received: from mail1.bemta37.messagelabs.com (mail1.bemta37.messagelabs.com [85.158.142.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F22569A81
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 01:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1669800767; i=@fujitsu.com;
        bh=t2ouAroiSbpJEGLSCAA4TU0PgB4pWY0A2Dx9bCHPW2M=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=RmAw8yZ5sRVSIAy0OiOHz0k36ivr4SWQkpOn9Y9l0sQSLjJtdKGWzYYRfpoiFIdKK
         GYgo20+lZ73o+yf3xCxa0EDoYkVafks5t0rC4V9efjflGgwnfpZIGJSG2S96grNx3j
         mUV/B2H46sf/kZQg+s+0rd0h+yMu93SItT9RePA9CZ4Y/trSzMUT+ek+U7Tz/fW4UQ
         4mwBwDejvwF3ZdSZMn8CVqCJenn5j0kfIihjF/L4JQR6mJstyPOY0VRyyOMln9B/9C
         pdI+pRxY18F428T9aCEA1gsXR0u8R0aRF1PfNphZeH8M4G3opqatJOqBrObkkRXZXe
         ugqdGQQf6++BQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRWlGSWpSXmKPExsViZ8ORpGun3J5
  ssOybmcWWY/cYLS4/4bPY9WcHuwOzx6lFEh6bVnWyeXzeJBfAHMWamZeUX5HAmvF16gnWgiWc
  FZOOPmVrYLzG3sXIxSEksJFRYvqyPVDOEiaJ+029UM42Romr+1pZuhg5OXgF7CSmP29iBrFZB
  FQlJi25BhUXlDg58wmYLSqQJHF1w11WEFtYwFXi44vtbCC2iICmxJFv15i6GDk4mAXMJG7/qY
  OY38Qo8XnCSbB6NgFHiXmzNoLVcwq4S7zbPYcRxGYWsJBY/OYgO4QtL7H97RywGyQEFCXalvx
  jh7ArJGbNamOCsNUkrp7bxDyBUWgWkvNmIRk1C8moBYzMqxjNi1OLylKLdI0M9JKKMtMzSnIT
  M3P0Eqt0E/VSS3Xz8otKMnQN9RLLi/VSi4v1iitzk3NS9PJSSzYxAmMipTgpcQdj37I/eocYJ
  TmYlER5K6Tak4X4kvJTKjMSizPii0pzUosPMcpwcChJ8HYpAuUEi1LTUyvSMnOA8QmTluDgUR
  Lh3Q3SyltckJhbnJkOkTrFqCglzpumBJQQAElklObBtcFSwiVGWSlhXkYGBgYhnoLUotzMElT
  5V4ziHIxKwryKIFN4MvNK4Ka/AlrMBLQ4UqwNZHFJIkJKqoHJ+d98L+X+Lad69a9X/D/RsSHZ
  52r16QkTOYqWd7TtZoiVZPdc5rVtB4/z+dpVs4M12zb8nc5+pTCheJKjabOv8KJzDtG/Hv1ga
  71s3H5IxvK+TTFPfOr3CxVPnoUmCYrezYo4nfclsPB6w7FznFdDrj+6tmiLn8+fppdTWnlqpR
  /qTpYtv9r8tijrKptouKuV7sfYGgn2+98dHK+kWcx4f9FJXK86nGO30neXc61ezx4UXMqNk33
  /2CT33fJD+wV3RJ50K5mYURaouOCdd/5FieiLc3VuHki29Zm0s+fVtY1Tnlq4tLlJtMeqvpjY
  MC1yyablr/g+8HzUYHSfL+2hH6jcvPPATaktPO1nT+9VYinOSDTUYi4qTgQAZxvKTYQDAAA=
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-16.tower-745.messagelabs.com!1669800766!145933!1
X-Originating-IP: [62.60.8.98]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.101.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 32454 invoked from network); 30 Nov 2022 09:32:46 -0000
Received: from unknown (HELO n03ukasimr03.n03.fujitsu.local) (62.60.8.98)
  by server-16.tower-745.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Nov 2022 09:32:46 -0000
Received: from n03ukasimr03.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTP id 5B06C1AE;
        Wed, 30 Nov 2022 09:32:46 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTPS id 4F63E1AC;
        Wed, 30 Nov 2022 09:32:46 +0000 (GMT)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Wed, 30 Nov 2022 09:32:44 +0000
Message-ID: <4335f6d8-dc19-d258-325c-38353ab470a0@fujitsu.com>
Date:   Wed, 30 Nov 2022 17:32:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/2] xfs: estimate post-merge refcounts correctly
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <david@fromorbit.com>
References: <166975928548.3768925.15141817742859398250.stgit@magnolia>
 <166975929675.3768925.10238207487640742011.stgit@magnolia>
From:   =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>
In-Reply-To: <166975929675.3768925.10238207487640742011.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/11/30 6:01, Darrick J. Wong wrote:
> From: Darrick J. Wong<djwong@kernel.org>
> 
> Upon enabling fsdax + reflink for XFS, xfs/179 began to report refcount
> metadata corruptions after being run.  Specifically, xfs_repair noticed
> single-block refcount records that could be combined but had not been.
Hi Darrick,

I am investigating the issue as well. Thanks a lot for your quick fix.
I have confirmed that xfs/179 with the fix patch can works well in DAX mode.
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>

> 
> The root cause of this is improper MAXREFCOUNT edge case handling in
> xfs_refcount_merge_extents.  When we're trying to find candidates for a
> refcount btree record merge, we compute the refcount attribute of the
> merged record, but we fail to account for the fact that once a record
> hits rc_refcount == MAXREFCOUNT, it is pinned that way forever.  Hence

One question:
Is it reansonable/expected to pin rc_refcount forever when a record hits 
rc_refcount == MAXREFCOUNT?

> the computed refcount is wrong, and we fail to merge the extents.
> 
> Fix this by adjusting the merge predicates to compute the adjusted
> refcount correctly.

Best Regards,
Xiao Yang
