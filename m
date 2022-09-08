Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7109EC6FA83
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Sep 2022 02:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiIHCAu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Sep 2022 22:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiIHCAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2022 22:00:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3097C198;
        Wed,  7 Sep 2022 19:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD157B81110;
        Thu,  8 Sep 2022 02:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A9AC433C1;
        Thu,  8 Sep 2022 02:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662602446;
        bh=ykIyX1r6EPVTXkRsMWuX4hF98iRFGnijnz7r06qwuS8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tDFZ5HJHLk/8gBiMczbHy21cqZpnE/ZuQj1aOm0JKkutHIX20imKw18NVAj2C24Bm
         WzN5CvHvmM8Q+njnoImwIgSm/qM3eHN4hOIpnBx6I25nYu11kM5XAlzAwqgHJbZI8U
         SR2wSLtwr2NOFQDEcUhMsr2zTV+kL+blOuBsBoRzm6GGteval3a2Kj5U3jQ2kcWoI7
         ZxHxewD+EmJj1v7QBTLkCHCHuL4ynULWfos/ZezP8O9sz+VgmwZEjbaYew+uLvZl3l
         d9+LbggXJjORb2dSV+yzh7s7wHXk+5+VeD6GxAaT9LiFt+zXLQXnLX/dymIxvLxLVA
         YEw06QZBg5f/A==
Message-ID: <b99b6fb5-c289-dec5-fa15-779e069af3cb@kernel.org>
Date:   Thu, 8 Sep 2022 10:00:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [f2fs-dev] [PATCH v2] Documentation: filesystems: correct
 possessive "its"
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Cc:     Christian Brauner <brauner@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        Seth Forshee <sforshee@kernel.org>,
        linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20220901002828.25102-1-rdunlap@infradead.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20220901002828.25102-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/9/1 8:28, Randy Dunlap wrote:
> Change occurrences of "it's" that are possessive to "its"
> so that they don't read as "it is".
> 
> For f2fs.rst, reword one description for better clarity.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-f2fs-devel@lists.sourceforge.net
> Cc: linux-xfs@vger.kernel.org
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Seth Forshee <sforshee@kernel.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: "Christian Brauner (Microsoft)" <brauner@kernel.org>
> ---
> v2: Reword the compress_log_size description.
>      Rebase (the xfs file changed).
>      Add Reviewed-by: tags.
> 
> Thanks for Al and Ted for suggesting rewording the f2fs.rst description.
> 
>   Documentation/filesystems/f2fs.rst                       |    5 ++---
>   Documentation/filesystems/idmappings.rst                 |    2 +-
>   Documentation/filesystems/qnx6.rst                       |    2 +-
>   Documentation/filesystems/xfs-delayed-logging-design.rst |    6 +++---
>   4 files changed, 7 insertions(+), 8 deletions(-)
> 
> --- a/Documentation/filesystems/f2fs.rst
> +++ b/Documentation/filesystems/f2fs.rst
> @@ -286,9 +286,8 @@ compress_algorithm=%s:%d Control compres
>   			 algorithm	level range
>   			 lz4		3 - 16
>   			 zstd		1 - 22
> -compress_log_size=%u	 Support configuring compress cluster size, the size will
> -			 be 4KB * (1 << %u), 16KB is minimum size, also it's
> -			 default size.
> +compress_log_size=%u	 Support configuring compress cluster size. The size will
> +			 be 4KB * (1 << %u). The default and minimum sizes are 16KB.

For f2fs part,

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
