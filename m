Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51598 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbeGZDCm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 23:02:42 -0400
Subject: Re: [PATCH 12/10] xfs_repair: use libxfs extsize/cowextsize
 validation helpers
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
 <20180628173008.GJ5711@magnolia>
 <6c0bc803-dd19-2b1f-a843-b5c555fab25a@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <761c1590-1a34-f62c-5a9b-64a54ba22de5@sandeen.net>
Date: Wed, 25 Jul 2018 18:48:14 -0700
MIME-Version: 1.0
In-Reply-To: <6c0bc803-dd19-2b1f-a843-b5c555fab25a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 7/25/18 6:44 PM, Eric Sandeen wrote:
> On 6/28/18 10:30 AM, Darrick J. Wong wrote:
...

> So maybe just:
> 
> +_("Bad extent size %u for inode %" PRIu64 ", "),
> +_("Bad CoW extent size %u on inode %" PRIu64 ", "),

Uh, may as well fix for-vs-on, too :)

