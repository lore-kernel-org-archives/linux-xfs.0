Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35758 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751665AbdHPKfZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 06:35:25 -0400
Received: by mail-wr0-f194.google.com with SMTP id w63so2284496wrc.2
        for <linux-xfs@vger.kernel.org>; Wed, 16 Aug 2017 03:35:25 -0700 (PDT)
Date: Wed, 16 Aug 2017 13:25:26 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 3/3] fs, xfs: introduce MAP_DIRECT for creating
 block-map-sealed file ranges
Message-ID: <20170816102526.kksbsvcr5cqcf35k@node.shutemov.name>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277754211.23945.458876600578531019.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170815091836.c3xpsfgfwz7w35od@node.shutemov.name>
 <CAPcyv4gmyFugKwMJCVwC9wFmQ8TL4TbHsa0p2Pqg2a6LziRHVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gmyFugKwMJCVwC9wFmQ8TL4TbHsa0p2Pqg2a6LziRHVw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Tue, Aug 15, 2017 at 10:11:27AM -0700, Dan Williams wrote:
> > We had issues before with user-imposed ETXTBSY. See MAP_DENYWRITE.
> >
> > Are we sure it won't a source of denial-of-service attacks?
> 
> I believe MAP_DENYWRITE allowed any application with read access to be
> able to deny writes which is obviously problematic. MAP_DIRECT is
> different. You need write access to the file so you can already
> destroy data that another application might depend on, and this only
> blocks allocation and reflink.
> 
> However, I'm not opposed to adding more safety around this. I think we
> can address this concern with an fcntl seal as Dave suggests, but the
> seal only applies to the 'struct file' instance and only gates whether
> MAP_DIRECT is allowed on that file. The act of setting
> F_MAY_SEAL_IOMAP requires CAP_IMMUTABLE, but MAP_DIRECT does not. This
> allows the 'permission to mmap(MAP_DIRECT)' to be passed around with
> an open file descriptor.

Sounds like a good approach to me.

-- 
 Kirill A. Shutemov
