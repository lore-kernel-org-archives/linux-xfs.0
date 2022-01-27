Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7688CC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 20:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiA0UoA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 15:44:00 -0500
Received: from sandeen.net ([63.231.237.45]:47522 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236736AbiA0Un7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jan 2022 15:43:59 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 01E334CE9D8;
        Thu, 27 Jan 2022 14:43:46 -0600 (CST)
Message-ID: <d5757b48-3d5b-5a61-6de8-1b6ca5af1171@sandeen.net>
Date:   Thu, 27 Jan 2022 14:43:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263805261.860211.1342663364051871462.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 38/45] libxfs: use opstate flags and functions for libxfs
 mount options
In-Reply-To: <164263805261.860211.1342663364051871462.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:20 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Port the three LIBXFS_MOUNT flags that actually do anything to set
> opstate flags in preparation for removing m_flags in a later patch.
> Retain the LIBXFS_MOUNT #defines so that libxfs clients can pass them
> into libxfs_mount.

Looks like the "flags" arg to rtmount_init() can be dropped now too,
I'll just fix that up locally.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   include/xfs_mount.h  |    7 ++++++-
>   libxfs/init.c        |   21 ++++++++++++---------
>   libxfs/libxfs_priv.h |    2 +-
>   repair/xfs_repair.c  |    2 +-
>   4 files changed, 20 insertions(+), 12 deletions(-)
> 
