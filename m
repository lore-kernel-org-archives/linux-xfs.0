Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37333 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751729AbeFFL5z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Jun 2018 07:57:55 -0400
Date: Wed, 6 Jun 2018 14:05:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] iomap: move bdev and dax_dev in a union
Message-ID: <20180606120510.GA13047@lst.de>
References: <20180606104033.4947-1-hch@lst.de> <20180606104033.4947-3-hch@lst.de> <CAHc6FU5xFMmN1EPGrZOhx9S5Focwq0Ky9HZeQ9VRGFC-o-cZZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU5xFMmN1EPGrZOhx9S5Focwq0Ky9HZeQ9VRGFC-o-cZZw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

On Wed, Jun 06, 2018 at 01:37:02PM +0200, Andreas Gruenbacher wrote:
> This seems backwards.

It is.  So much for last minute polarity fixups..
