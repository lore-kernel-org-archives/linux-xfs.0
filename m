Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47804 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfGBPEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 11:04:54 -0400
Date: Tue, 2 Jul 2019 08:04:52 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [linux-kernel-mentees] [PATCH v5] Doc : fs : convert xfs.txt to
 ReST
Message-ID: <20190702150452.GD1729@bombadil.infradead.org>
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
> +When mounting an XFS filesystem, the following options are accepted.  For
> +boolean mount options, the names with the "(*)" prefix is the default behaviour.
> +For example, take a behaviour enabled by default to be a one (1) or, a zero (0)
> +otherwise, ``(*)[no]default`` would be 0 while ``[no](*)default`` , a 1.
> -When mounting an XFS filesystem, the following options are accepted.
> -For boolean mount options, the names with the (*) suffix is the
> -default behaviour.

You seem to have reflowed all the text.  That means git no longer notices
it's a rename, and quite frankly the shorter lines that were in use were
better.  This is not an improvement; please undo it in the next version
(which you should not post for several days to accumulate more feedback).
