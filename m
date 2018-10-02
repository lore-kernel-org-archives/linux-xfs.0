Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36722 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729254AbeJBVvB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Oct 2018 17:51:01 -0400
Date: Tue, 2 Oct 2018 17:07:08 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181002150708.GF9127@quack2.suse.cz>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142959.GD9127@quack2.suse.cz>
 <20181002143713.GA19845@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002143713.GA19845@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org

On Tue 02-10-18 07:37:13, Christoph Hellwig wrote:
> On Tue, Oct 02, 2018 at 04:29:59PM +0200, Jan Kara wrote:
> > > OK naive question from me, how do we want an application to be able to
> > > check if it is running on a DAX mapping?
> > 
> > The question from me is: Should application really care?
> 
> No, it should not.  DAX is an implementation detail thay may change
> or go away at any time.

I agree that whether / how pagecache is used for filesystem access is an
implementation detail of the kernel.  OTOH for some workloads it is about
whether kernel needs gigabytes of RAM to cache files or not, which is not a
detail anymore if you want to fully utilize the machine. So people will be
asking for this and will be finding odd ways to determine whether DAX is
used or not (such as poking in smaps). And once there is some widely enough
used application doing this, it is not "stupid application" problem anymore
but the kernel's problem of not maintaining backward compatibility.

So I think we would be better off providing *some* API which applications
can use to determine whether pagecache is used or not and make sure this
API will convey the right information even if we change DAX
implementation or remove it altogether.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
