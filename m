Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB8DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 01:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 816E264E6F
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 01:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhBXBaD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 20:30:03 -0500
Received: from sandeen.net ([63.231.237.45]:34804 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234235AbhBXBSl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Feb 2021 20:18:41 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E89C2611F0F;
        Tue, 23 Feb 2021 18:25:51 -0600 (CST)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
References: <161404928523.425731.7157248967184496592.stgit@magnolia>
 <161404929091.425731.465351236842105610.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/5] man: mark all deprecated V4 format options
Message-ID: <14656568-caf9-c931-2387-e06f171d1ead@sandeen.net>
Date:   Tue, 23 Feb 2021 18:26:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <161404929091.425731.465351236842105610.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/22/21 9:01 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update the manual pages for the most popular tools to note which options
> are only useful with the V4 XFS format, and that the V4 format is
> deprecated and will be removed no later than September 2030.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  man/man8/mkfs.xfs.8  |   16 ++++++++++++++++
>  man/man8/xfs_admin.8 |   10 ++++++++++
>  2 files changed, 26 insertions(+)
> 
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index fac82d74..df25abaa 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -223,6 +223,11 @@ of calculating and checking the CRCs is not noticeable in normal operation.
>  By default,
>  .B mkfs.xfs
>  will enable metadata CRCs.
> +.IP
> +Formatting a filesystem without CRCs selects the V4 format, which is deprecated
> +and will be removed from upstream in September 2030.

Can I add:

+ Several other options, noted below, are only tunable on V4 formats, and will
+ be removed along with the V4 format itself.

> +Distributors may choose to withdraw support for the V4 format earlier than
> +this date.
>  .TP
>  .BI finobt= value
>  This option enables the use of a separate free inode btree index in each
> @@ -592,6 +597,8 @@ This option can be used to turn off inode alignment when the
>  filesystem needs to be mountable by a version of IRIX
>  that does not have the inode alignment feature
>  (any release of IRIX before 6.2, and IRIX 6.2 without XFS patches).
> +.IP
> +This option only applies to the deprecated V4 format.

and can I change this (and other mkfs option notes) to:

+ This option is only tunable on the deprecated V4 format.

because we actually do accept i.e. "-i attr=2" on a V5 format today.

so, "you can't tune it on v5, and it goes away when v4 does" seems to
capture what you want the user to know.

>  .TP
>  .BI attr= value
>  This is used to specify the version of extended attribute inline
> @@ -602,6 +609,8 @@ between attribute and extent data.
>  The previous version 1, which has fixed regions for attribute and
>  extent data, is kept for backwards compatibility with kernels older
>  than version 2.6.16.
> +.IP
> +This option only applies to the deprecated V4 format.
>  .TP
>  .BI projid32bit[= value ]
>  This is used to enable 32bit quota project identifiers. The
> @@ -609,6 +618,8 @@ This is used to enable 32bit quota project identifiers. The
>  is either 0 or 1, with 1 signifying that 32bit projid are to be enabled.
>  If the value is omitted, 1 is assumed.  (This default changed
>  in release version 3.2.0.)
> +.IP
> +This option only applies to the deprecated V4 format.
>  .TP
>  .BI sparse[= value ]
>  Enable sparse inode chunk allocation. The
> @@ -690,6 +701,7 @@ stripe-aligned log writes (see the sunit and su options, below).
>  The previous version 1, which is limited to 32k log buffers and does
>  not support stripe-aligned writes, is kept for backwards compatibility
>  with very old 2.4 kernels.
> +This option only applies to the deprecated V4 format.
>  .TP
>  .BI sunit= value
>  This specifies the alignment to be used for log writes. The
> @@ -744,6 +756,8 @@ is 1 (on) so you must specify
>  .B lazy-count=0
>  if you want to disable this feature for older kernels which don't support
>  it.
> +.IP
> +This option only applies to the deprecated V4 format.
>  .RE
>  .PP
>  .PD 0
> @@ -803,6 +817,8 @@ will be stored in the directory structure.  The default value is 1.
>  When CRCs are enabled (the default), the ftype functionality is always
>  enabled, and cannot be turned off.
>  .IP
> +This option only applies to the deprecated V4 format.
> +.IP
>  .RE
>  .TP
>  .BI \-p " protofile"
> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index cccbb224..5ef99316 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
> @@ -54,6 +54,8 @@ for a detailed description of the XFS log.
>  Enables unwritten extent support on a filesystem that does not
>  already have this enabled (for legacy filesystems, it can't be
>  disabled anymore at mkfs time).
> +.IP
> +This option only applies to the deprecated V4 format.
>  .TP
>  .B \-f
>  Specifies that the filesystem image to be processed is stored in a
> @@ -67,12 +69,16 @@ option).
>  .B \-j
>  Enables version 2 log format (journal format supporting larger
>  log buffers).
> +.IP
> +This option only applies to the deprecated V4 format.
>  .TP
>  .B \-l
>  Print the current filesystem label.
>  .TP
>  .B \-p
>  Enable 32bit project identifier support (PROJID32BIT feature).
> +.IP
> +This option only applies to the deprecated V4 format.
>  .TP
>  .B \-u
>  Print the current filesystem UUID (Universally Unique IDentifier).
> @@ -83,6 +89,8 @@ Enable (1) or disable (0) lazy-counters in the filesystem.
>  Lazy-counters may not be disabled on Version 5 superblock filesystems
>  (i.e. those with metadata CRCs enabled).
>  .IP
> +In other words, this option only applies to the deprecated V4 format.
> +.IP
>  This operation may take quite a bit of time on large filesystems as the
>  entire filesystem needs to be scanned when this option is changed.
>  .IP
> @@ -92,6 +100,8 @@ information is kept in other parts of the filesystem to be able to
>  maintain the counter values without needing to keep them in the
>  superblock. This gives significant improvements in performance on some
>  configurations and metadata intensive workloads.
> +.IP
> +This option only applies to the deprecated V4 format.

I think you're restated it here in the same section; I can just drop this extra
one if you concur.

>  .TP
>  .BI \-L " label"
>  Set the filesystem label to
> 
