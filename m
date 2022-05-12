Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D922C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 20:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358290AbiELUgK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 May 2022 16:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358396AbiELUgJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 16:36:09 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E90FBC83
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 13:36:03 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0B8CA335038;
        Thu, 12 May 2022 15:36:00 -0500 (CDT)
Message-ID: <69d87685-4174-0157-e233-0e72a4e6dbed@sandeen.net>
Date:   Thu, 12 May 2022 15:36:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 3/3] xfs_repair: check the ftype of dot and dotdot
 directory entries
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176674590.248791.17672675617466150793.stgit@magnolia>
 <165176676265.248791.9813054389307375890.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <165176676265.248791.9813054389307375890.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:06 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The long-format directory block checking code skips the filetype check
> for the '.' and '..' entries, even though they're part of the ondisk
> format.  This leads to repair failing to catch subtle corruption at the
> start of a directory.
> 
> Found by fuzzing bu[0].filetype = zeroes in xfs/386.

Ok, mostly a refactoring into a check_longform_ftype, then adding that check
to .. and .

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
