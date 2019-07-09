Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47714 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfGISp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 14:45:59 -0400
Date: Tue, 9 Jul 2019 11:45:59 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [linux-kernel-mentees] [PATCH v6] Doc : fs : convert xfs.txt to
 ReST
Message-ID: <20190709184559.GL32320@bombadil.infradead.org>
References: <20190709124859.GA21503@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709124859.GA21503@localhost>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sheriff Esseson <sheriffesseson@gmail.com>
Cc: skhan@linuxfoundation.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linuxfoundation.org

On Tue, Jul 09, 2019 at 01:48:59PM +0100, Sheriff Esseson wrote:
> Convert xfs.txt to ReST, rename and fix broken references, consequently.
> 
> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
> ---
> 
> Changes in v6:
> 	- undo text reflow from v5.
> 	- fix a typo.
> 	- change indication of defaults , as suggested by Darrick J. Wong, to
> 	  keep the read simple.
> 	- change delimiter of boolean option from a newline to an "or" (clue
> 	  from something like "<option> and <another option>" in the text)
> 	  because the former does not render well in html.
> 
>  Documentation/filesystems/dax.txt             |   2 +-
>  Documentation/filesystems/index.rst           |   1 +
>  .../filesystems/{xfs.txt => xfs.rst}          | 123 +++++++++---------
>  MAINTAINERS                                   |   2 +-
>  4 files changed, 61 insertions(+), 67 deletions(-)
>  rename Documentation/filesystems/{xfs.txt => xfs.rst} (81%)

Documentation/{filesystem/xfs.txt => admin-guide/xfs.rst}.

> -	If "largeio" specified, a filesystem that was created with a
> -	"swidth" specified will return the "swidth" value (in bytes)
> -	in st_blksize. If the filesystem does not have a "swidth"
> -	specified but does specify an "allocsize" then "allocsize"
> +	If ``largeio`` specified, a filesystem that was created with a

surely 'If ``largeio`` is specified' here?

> +	``swidth`` specified will return the ``swidth`` value (in bytes)
> +	in ``st_blksize``. If the filesystem does not have a ``swidth``
> +	specified but does specify an ``allocsize`` then ``allocsize``
>  	(in bytes) will be returned instead. Otherwise the behaviour
