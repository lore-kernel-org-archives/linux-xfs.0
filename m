Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50007 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755201AbdEDOSE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 May 2017 10:18:04 -0400
Date: Thu, 4 May 2017 16:18:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/8] xfs: re-define uuid_t as common struct uuid_v1
Message-ID: <20170504141802.GA18428@lst.de>
References: <20170504133417.GD17222@lst.de> <1493904383-2187-1-git-send-email-amir73il@gmail.com> <1493904383-2187-3-git-send-email-amir73il@gmail.com> <23808.1493907370@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23808.1493907370@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, May 04, 2017 at 03:16:10PM +0100, David Howells wrote:
> Leave struct uuid_v1 as is please.  The AFS protocol XDR encodes the fields as
> delineated in the struct:

No.  Use direct decoding of the fields (maybe using helpers) for the
two places in the whole kernel (afs and xfs) that care about they layout,
instead of needing a secondary structure and the related infrastructure.

The uuid_be (really should be uuid_t) and uuid_le (really should be guid_t)
is bad enough.
