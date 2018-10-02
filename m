Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60490 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbeJBV2C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Oct 2018 17:28:02 -0400
Date: Tue, 2 Oct 2018 16:44:13 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181002144412.GC4963@linux-x5ow.site>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142959.GD9127@quack2.suse.cz>
 <20181002143713.GA19845@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181002143713.GA19845@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org

On Tue, Oct 02, 2018 at 07:37:13AM -0700, Christoph Hellwig wrote:
> No, it should not.  DAX is an implementation detail thay may change
> or go away at any time.

Well we had an issue with an application checking for dax, this is how
we landed here in the first place.

It's not that I want them to do it, it's more that they're actually
doing it in all kinds of interesting ways and then complaining when it
doesn't work anymore.

So it's less of an "API beauty price problem" but more of a "provide a
documented way which we won't break" way.

Byte,
	   Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
