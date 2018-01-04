Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47828 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750770AbeADIR4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 03:17:56 -0500
Date: Thu, 4 Jan 2018 09:17:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 00/18] dax: fix dma vs truncate/hole-punch
Message-ID: <20180104081755.GD2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Michal Hocko <mhocko@suse.com>, jack@suse.cz, Peter Zijlstra <peterz@infradead.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Andreas Dilger <adilger.kernel@dilger.ca>, hch@lst.de, Matthew Wilcox <mawilcox@microsoft.com>, Michael Ellerman <mpe@ellerman.id.au>, Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@redhat.com>, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-fsdevel@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, linux-nvdimm@lists.01.org, Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Paul Mackerras <paulus@samba.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

> So far this solution only targets xfs since it already implements
> xfs_break_layouts in all the locations that would need this
> synchronization. It applies on top of the vmem_altmap / dev_pagemap
> reworks from Christoph.

Those got a rebase since your posting of this series, btw.
