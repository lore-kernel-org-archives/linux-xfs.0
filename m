Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36438 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfDVKzw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Apr 2019 06:55:52 -0400
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
References: <20190404165737.30889-1-amir73il@gmail.com>
 <20190404211730.GD26298@dastard>
 <CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com>
 <20190407232728.GF26298@dastard> <20190408110322.GA18662@quack2.suse.cz>
From: Boaz Harrosh <openosd@gmail.com>
Message-ID: <3e7529e5-cd31-5085-ca20-5ca23115c044@gmail.com>
Date: Mon, 22 Apr 2019 13:55:42 +0300
MIME-Version: 1.0
In-Reply-To: <20190408110322.GA18662@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On 08/04/19 14:03, Jan Kara wrote:
<>
> Hum, you are right. Ext4 is buggy in this regard. I've fixed the race for
> page fault in ea3d7209ca01 "ext4: fix races between page faults and hole
> punching" but didn't realize the problem is there for buffered reads as
> well. I'll think how we can fix this. Thanks for noticing this!
> 

This is very interesting. Please CC me if you have devised a test for this?

For a long time I want to enhance fsstress --verify that each writer always
writes the long address it writes to as data (ie. file looks like an increasing
long counter) And readers want to see only this pattern or zero.

> 								Honza
> 

Thanks
Boaz
