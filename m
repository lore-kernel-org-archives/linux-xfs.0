Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30950C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Feb 2022 23:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343646AbiBDXXy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Feb 2022 18:23:54 -0500
Received: from sandeen.net ([63.231.237.45]:54532 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378099AbiBDXXx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Feb 2022 18:23:53 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DAE7E7BCB;
        Fri,  4 Feb 2022 17:23:29 -0600 (CST)
Message-ID: <27b0c656-b7f1-8690-9c9a-2d43df1c4e6a@sandeen.net>
Date:   Fri, 4 Feb 2022 17:23:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH 05/17] misc: add a crc32c self test to mkfs and repair
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263812233.863810.8941848920301589525.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <164263812233.863810.8941848920301589525.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enhance mkfs and xfs_repair to run the crc32c self test when they start
> up, and refuse to continue if the self test fails.   We don't want to
> format a filesystem if the checksum algorithm produces incorrect
> results, and we especially don't want repair to tear a filesystem apart
> because it thinks the checksum is wrong.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>


Good idea.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

