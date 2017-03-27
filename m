Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752452AbdC0UUc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 16:20:32 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net>
References: <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
Subject: Re: [PATCH 2/2 V2] xfs_io: hook up statx
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5791.1490646019.1@warthog.procyon.org.uk>
Date: Mon, 27 Mar 2017 21:20:19 +0100
Message-ID: <5792.1490646019@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

Eric Sandeen <sandeen@sandeen.net> wrote:

> +			m_mask = atoi(optarg);

strtoul() would probably be more useful as you can then specify a hex number.

David
