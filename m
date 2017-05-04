Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49671 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753419AbdEDN2j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 May 2017 09:28:39 -0400
Date: Thu, 4 May 2017 15:28:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 4/8] xfs: namespace the helper uuid_getnodeuniq()
Message-ID: <20170504132837.GA17222@lst.de>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com> <1493904383-2187-5-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493904383-2187-5-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, May 04, 2017 at 04:26:19PM +0300, Amir Goldstein wrote:
> uuid_getnodeuniq(), as the comment says, 'is not in any way
> a standard or condoned UUID function'.
> 
> Therefore, prefix the helper name with xfs_ to differentiate it
> from the rest of the common uuid_ helpers.

I'd just kill it off and open code it in the only caller.
