Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33780 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752348AbeDGWAO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 7 Apr 2018 18:00:14 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6339017267
        for <linux-xfs@vger.kernel.org>; Sat,  7 Apr 2018 16:59:34 -0500 (CDT)
Subject: Re: [PATCH 0/6] xfs: quota fixes and enhancements
From: Eric Sandeen <sandeen@sandeen.net>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Message-ID: <6479893d-7f01-f262-6ec5-84a33237d2d8@sandeen.net>
Date: Sat, 7 Apr 2018 17:00:13 -0500
MIME-Version: 1.0
In-Reply-To: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

On 4/4/18 1:47 PM, Eric Sandeen wrote:
> A semi-random smattering of quota stuff.  First three seem quite
> good to go, the rest are more along the lines of a suggestion
> or conversation-starter.  ;)
> 
> (the first patch is just removing an unused arg).
> 
> xfs_repair doesn't look at quota blocks.  At all.  It relies
> on quotacheck in the kernel to fix them up as needed.

I'm starting to rethink a lot of this hackery.  Why doesn't xfs_repair
just fix things up?  (leave quotacheck to the next mount, but the
"repair" stuff in the kernel seems like a really strange wart.)

I think I'll look at teaching repair to sanity check the quota
inodes, but if anyone knows why that's a bad idea please let me
know.  ;)

Thanks,
-Eric
