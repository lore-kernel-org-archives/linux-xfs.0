Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43102 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752104AbdKJJHA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Nov 2017 04:07:00 -0500
Date: Fri, 10 Nov 2017 10:06:58 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/15] mm, devmap: introduce CONFIG_DEVMAP_MANAGED_PAGES
Message-ID: <20171110090658.GD4895@lst.de>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com> <150949216597.24061.3943310722702629588.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150949216597.24061.3943310722702629588.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de

On Tue, Oct 31, 2017 at 04:22:46PM -0700, Dan Williams wrote:
> Combine the now three use cases of page-idle callbacks for ZONE_DEVICE
> memory into a common selectable symbol.

Very sparse changelog.  I understand the Kconfig bit, but it also seems to
introduce new static key functionality that isn't explained at all.
