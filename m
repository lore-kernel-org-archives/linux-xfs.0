Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47901 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751721AbeADI1x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 03:27:53 -0500
Date: Thu, 4 Jan 2018 09:27:51 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 11/18] fs, dax: introduce DEFINE_FSDAX_AOPS
Message-ID: <20180104082751.GG2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com> <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com> <20171227052910.GE24828@bombadil.infradead.org> <CAPcyv4ibKYi_zE=V2W_aLghtr3LiC30A2ffFq-aPQCrikwgy2w@mail.gmail.com> <20180103160503.GM4911@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180103160503.GM4911@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Wed, Jan 03, 2018 at 05:05:03PM +0100, Jan Kara wrote:
> Just for record I agree with what Dave said about this patch. Generic
> address_space_operations are not how aops are commonly defined by
> filesystems. Just create one structure for each fs as Dave suggested.

Agreed.
