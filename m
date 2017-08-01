Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37706 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751997AbdHATCW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 15:02:22 -0400
Subject: Re: Metadata corruption at xfs_attr3_leaf_write_verify()
References: <d161b07cad6536b0baf285328cf99500@mail.gmail.com>
 <A3EABCF079964F4FA6058F30EBF80FD8@alyakaslap>
 <b1f0c224-11b6-ba24-23e4-187f13d5cf17@sandeen.net>
 <8EDAE4D35FF54E00BE6005F72FD7193F@alyakaslap>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c3494cd8-6c73-8d2b-55e5-719cec621219@sandeen.net>
Date: Tue, 1 Aug 2017 14:02:20 -0500
MIME-Version: 1.0
In-Reply-To: <8EDAE4D35FF54E00BE6005F72FD7193F@alyakaslap>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>, linux-xfs@vger.kernel.org
Cc: Shyam Kaushik <shyam@zadarastorage.com>, bfoster@redhat.com, dchinner@redhat.com, david@fromorbit.com

On 8/1/17 1:57 PM, Alex Lyakas wrote:
> Hi Eric,
> 
> Thanks for your response.
> 
> I confirm that during log replay we also see this issue from time to
> time. However, our main problem is that during normal operation we
> trip on this assert, and this causes XFS to shutdown, causing outage.
> Please see the stack trace that I posted in the previous email; it
> does not happen during log replay.
Yep I understand that, I'm just noting that this transitional state
has (recently?) caused trouble in other areas as well.

-Eric
