Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51448 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbeCLHvT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Mar 2018 03:51:19 -0400
Date: Mon, 12 Mar 2018 08:51:17 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 02/11] xfs, dax: introduce xfs_dax_aops
Message-ID: <20180312075117.GA5232@lst.de>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com> <152066489984.40260.2215636951958334858.stgit@dwillia2-desk3.amr.corp.intel.com> <20180310094633.GA31604@lst.de> <CAPcyv4iZFW9Lk=KdEy=0iYzM9GmQ4ccoN2imYNDq6XwXDgXsDw@mail.gmail.com> <CAPcyv4ijGP_77VgLUekE53=i7JxMPjvUqpebKPnV2vXMqzpWcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ijGP_77VgLUekE53=i7JxMPjvUqpebKPnV2vXMqzpWcw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jeff Moyer <jmoyer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Sun, Mar 11, 2018 at 12:16:25PM -0700, Dan Williams wrote:
> I did the rename, and am housing these in fs/dax.c, I assume that's
> what you wanted.

libfs.c would seem ok to, but we're into micro-management land now :)
