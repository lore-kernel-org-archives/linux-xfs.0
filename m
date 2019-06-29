Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42214 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfF2Blj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 21:41:39 -0400
Date: Fri, 28 Jun 2019 18:41:36 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1] Doc : fs : convert xfs.txt to ReST
Message-ID: <20190629014136.GF4286@bombadil.infradead.org>
References: <20190628214302.GA12096@localhost>
 <20190629010733.GA31770@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190629010733.GA31770@localhost>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sheriff Esseson <sheriffesseson@gmail.com>
Cc: skhan@linuxfoundation.org, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel-mentees@lists.linuxfoundation.org

On Sat, Jun 29, 2019 at 02:25:08AM +0100, Sheriff Esseson wrote:
> On Fri, Jun 28, 2019 at 10:43:24PM +0100, Sheriff Esseson wrote:
> > 	Convert xfs.txt to ReST, markup and rename accordingly. Update
> > 	Documentation/index.rst.

Don't quote the entire previous patch when submitting a new one.

> Rid Documentation/filesystems/index.rst of ".rst" in toc-tree references.
> 
> CC xfs-list.
> 
> Correct email indentation.

This text should be below the --- line, and it should be marked as "v2:"

And you didn't update the MAINTAINERS file.

> +For boolean mount options, the names with the "(*)" prefix is the
> +default behaviour. For example, take an behaviour enabled by default to be a one (1) or,

This line is too long.  Doesn't checkpatch.pl complain?

> +   rtdev=<device>
> +        An XFS filesystem has up to three parts: a data section, a log
> +	section, and a real-time section.  The real-time section is optional.
> +        If enabled, ``rtdev`` sets ``device`` to be used as an
> +        external real-time section, similar to ``logdev`` above.

Darrick mentioned the indentation was weird here, and you haven't fixed that.

> +   sunit=<value>
> +	Used to specify the stripe unit for a RAID device
> +	or (in conjunction with ``swidth`` below) a stripe volume.  ``value`` must be specified in 512-byte
> +	block units. This option is only relevant to filesystems

line length
