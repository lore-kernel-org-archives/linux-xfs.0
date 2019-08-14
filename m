Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37169 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfHNLOj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Aug 2019 07:14:39 -0400
Date: Wed, 14 Aug 2019 13:14:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/9] fs: Enable bmap() function to properly return
 errors
Message-ID: <20190814111435.GB1885@lst.de>
References: <20190808082744.31405-1-cmaiolino@redhat.com> <20190808082744.31405-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808082744.31405-2-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

Just curious from looking this again - shoudn't the 0 block be turned
into an error by the bmap() function?  At least for the legacy ->bmap
case so that we don't have to carry this cruft around.
