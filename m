Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58842 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751579AbdG0OJJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 10:09:09 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
References: <20170727131245.28279-1-jack@suse.cz>
Date: Thu, 27 Jul 2017 10:09:07 -0400
In-Reply-To: <20170727131245.28279-1-jack@suse.cz> (Jan Kara's message of
        "Thu, 27 Jul 2017 15:12:38 +0200")
Message-ID: <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

Hi, Jan,

Thanks for looking into this!

> There are couple of open questions with this implementation:
>
> 1) Is it worth the hassle?
> 2) Is S_SYNC good flag to use or should we use a new inode flag?
> 3) VM_FAULT_RO and especially passing of resulting 'pfn' from
>    dax_iomap_fault() through filesystem fault handler to dax_pfn_mkwrite() in
>    vmf->orig_pte is a bit of a hack. So far I'm not sure how to refactor
>    things to make this cleaner.

4) How does an application discover that it is safe to flush from
   userspace?

-Jeff
