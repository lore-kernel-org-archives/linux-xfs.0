Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC103C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 22:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiA1W7n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:59:43 -0500
Received: from sandeen.net ([63.231.237.45]:43486 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231497AbiA1W7l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jan 2022 17:59:41 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B32A078FD;
        Fri, 28 Jan 2022 16:59:27 -0600 (CST)
Message-ID: <cc28e646-62d3-ac0d-528d-19619a626777@sandeen.net>
Date:   Fri, 28 Jan 2022 16:59:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v1.1 39/45] libxfs: remove pointless *XFS_MOUNT* flags
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263805814.860211.18062742237091017727.stgit@magnolia>
 <20220128224300.GK13540@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20220128224300.GK13540@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/28/22 4:43 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Get rid of these flags and the m_flags field, since none of them do
> anything anymore.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good, thanks!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> v1.1: add some clarifying comments, maintain same inode64 behavior

