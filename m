Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36087 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754346AbdC3VLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Mar 2017 17:11:16 -0400
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
References: <20170320214327.GA5098@fieldses.org>
 <20170321134500.GA1318@infradead.org> <20170321163011.GA16666@fieldses.org>
 <1490117004.2542.1.camel@redhat.com> <20170321183006.GD17872@fieldses.org>
 <1490122013.2593.1.camel@redhat.com> <20170329111507.GA18467@quack2.suse.cz>
 <1490810071.2678.6.camel@redhat.com> <20170330064724.GA21542@quack2.suse.cz>
 <1490872308.2694.1.camel@redhat.com> <20170330161231.GA9824@fieldses.org>
 <1490898932.2667.1.camel@redhat.com>
From: Boaz Harrosh <openosd@gmail.com>
Message-ID: <42bec37f-670c-3ea1-f2aa-7cecd619ad7e@gmail.com>
Date: Fri, 31 Mar 2017 00:11:11 +0300
MIME-Version: 1.0
In-Reply-To: <1490898932.2667.1.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On 03/30/2017 09:35 PM, Jeff Layton wrote:
<>
> Yeah, I imagine we'd need a on-disk change for this unless there's
> something already present that we could use in place of a crash counter.
> 

Perhaps we can use s_mtime and/or s_wtime in some way, I'm not sure
what is a parallel for that in xfs.
	s_mtime - time-of-last mount 
	s_wtime - time-of-last mount, umount, freez, unfreez, remount, ...
Of course you'll need a per FS vector to access that.

But this will need some math foo to get the bits compacted correctly
just a thought.

Thanks
Boaz

