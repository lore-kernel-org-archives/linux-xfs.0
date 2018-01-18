Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57243 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932807AbeARQ6Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jan 2018 11:58:24 -0500
Date: Thu, 18 Jan 2018 17:56:12 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v6 00/99] XArray version 6
Message-ID: <20180118165612.GS13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180117202203.19756-1-willy@infradead.org>
 <20180118160749.GP13726@twin.jikos.cz>
 <20180118164843.GA23800@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180118164843.GA23800@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: dsterba@suse.cz, linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

On Thu, Jan 18, 2018 at 08:48:43AM -0800, Matthew Wilcox wrote:
> Thank you!  I shall attempt to debug.  Was this with a btrfs root
> filesystem?  I'm most suspicious of those patches right now, since they've
> received next to no testing.  I'm going to put together a smaller patchset
> which just does the page cache conversion and nothing else in the hope
> that we can get that merged this year.

No, the root is ext3 and there was no btrfs filesytem mounted at the
time.
