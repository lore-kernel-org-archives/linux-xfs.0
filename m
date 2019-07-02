Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49716 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfGBPQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 11:16:00 -0400
Date: Tue, 2 Jul 2019 08:15:59 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [linux-kernel-mentees] [PATCH v5] Doc : fs : convert xfs.txt to
 ReST
Message-ID: <20190702151559.GE1729@bombadil.infradead.org>
References: <20190702123040.GA30111@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702123040.GA30111@localhost>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sheriff Esseson <sheriffesseson@gmail.com>
Cc: skhan@linuxfoundation.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linuxfoundation.org

On Tue, Jul 02, 2019 at 01:30:40PM +0100, Sheriff Esseson wrote:
> +++ b/Documentation/filesystems/index.rst
> @@ -40,4 +40,5 @@ Documentation for individual filesystem types can be found here.
>  .. toctree::
>     :maxdepth: 2
>  
> -   binderfs.rst
> +   binderfs
> +   xfs

I don't think this makes sense.  Look:

Kernel API documentation
------------------------
...
   filesystems/index

but the contents of xfs.rst are not kernel API documentation.  We have
precedent in Documentation/index.rst for:

Filesystem Documentation
------------------------

The documentation in this section are provided by specific filesystem
subprojects.

.. toctree::
   :maxdepth: 2

   filesystems/ext4/index

but that looks more like the xfs-delayed-logging-design.txt and
xfs-self-describing-metadata.txt files.

I think Documentation/filesystems/xfs.rst should be part of the
admin guide.  Furtnately, ext4 has again led the way here, and
Documentation/admin-guide/ext4.rst already exists.
