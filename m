Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45106 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbeJBVVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 17:21:00 -0400
Date: Tue, 2 Oct 2018 07:37:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181002143713.GA19845@infradead.org>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142959.GD9127@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002142959.GD9127@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org

On Tue, Oct 02, 2018 at 04:29:59PM +0200, Jan Kara wrote:
> > OK naive question from me, how do we want an application to be able to
> > check if it is running on a DAX mapping?
> 
> The question from me is: Should application really care?

No, it should not.  DAX is an implementation detail thay may change
or go away at any time.
