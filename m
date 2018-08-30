Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52028 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbeH3Uiq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Aug 2018 16:38:46 -0400
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
 <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
 <20180830163614.GA27069@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
Date: Thu, 30 Aug 2018 11:35:46 -0500
MIME-Version: 1.0
In-Reply-To: <20180830163614.GA27069@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 8/30/18 11:36 AM, Christoph Hellwig wrote:
> On Thu, Aug 30, 2018 at 11:31:40AM -0500, Eric Sandeen wrote:
>> That's no reason to uniquely disallow it for reflinked files, though;
>> the problem is universal.  It's true for fiemap as well.  So I'm not sure
>> that's an argument against the patch?
> 
> fiemap at least tells you an extent is shared, bmap does not.

yes, so bmap is clearly the wrong interface to use if you want to
write directly to a file's blocks.  But if you know enough to check
the fiemap shared flag, you know enough to not use fibmap for that purpose...

-Eric
