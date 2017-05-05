Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35416 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752077AbdEENSh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 May 2017 09:18:37 -0400
Subject: Re: [PATCH] xfs: make fatal assert failures conditional in debug mode
References: <1493922564-14273-1-git-send-email-bfoster@redhat.com>
 <7b09b8c0-53dc-37e4-a6c0-88835515345b@sandeen.net>
 <20170505122030.GA17318@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <32905dd8-dba1-b33f-ad72-2bc4ecb56147@sandeen.net>
Date: Fri, 5 May 2017 08:18:36 -0500
MIME-Version: 1.0
In-Reply-To: <20170505122030.GA17318@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 5/5/17 7:20 AM, Brian Foster wrote:

>> I'd just like to see "N" behavior /explicitly/ stated (with the text "N") :)
>>
> 
> That sounds reasonable. After catching up on some of the chat on irc,
> how about the following to avoid using "convert?"
> 
> "Say Y here to cause DEBUG mode assert failures to result in fatal
> errors that BUG() the kernel. If you say N, assert failures result in
> warnings."

sounds good to me.  sorry for the bikeshed.

-Eric
