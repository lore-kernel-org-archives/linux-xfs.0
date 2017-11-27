Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33444 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751771AbdK0Wtx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 17:49:53 -0500
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id F38753258
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 16:49:26 -0600 (CST)
Subject: Re: [PATCH] xfs: fix leaks on corruption errors in xfs_bmap.c
From: Eric Sandeen <sandeen@sandeen.net>
References: <4b6bc004-3a7f-40f7-7d97-d1f358439b88@sandeen.net>
Message-ID: <140491d7-1703-b9c4-7bb0-e354f61216ee@sandeen.net>
Date: Mon, 27 Nov 2017 16:49:51 -0600
MIME-Version: 1.0
In-Reply-To: <4b6bc004-3a7f-40f7-7d97-d1f358439b88@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>



On 11/27/17 4:48 PM, Eric Sandeen wrote:
> Use _GOTO instead of _RETURN so we can free the allocated
> cursor on error.
> 
> Fixes: bf80628 ("xfs: remove xfs_bmse_shift_one")
> Fixes-coverity-id: 1423813

also 1423676

-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Compile-tested only 
> 

