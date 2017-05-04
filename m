Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49890 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755164AbdEDOBT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 May 2017 10:01:19 -0400
Date: Thu, 4 May 2017 16:01:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/8] xfs: re-define uuid_t as common struct uuid_v1
Message-ID: <20170504140117.GA17991@lst.de>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com> <1493904383-2187-3-git-send-email-amir73il@gmail.com> <20170504133417.GD17222@lst.de> <CAOQ4uxjxyEGZOAm2rCR+PcdFqfmJxgBBO7_SexPkPRy+0eePOA@mail.gmail.com> <20170504135913.GA17831@lst.de> <CAOQ4uxh0_68r7Ycf877RGHhA9rfUJtyN=q4V2_FohvD1gmBAig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh0_68r7Ycf877RGHhA9rfUJtyN=q4V2_FohvD1gmBAig@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, May 04, 2017 at 05:00:34PM +0300, Amir Goldstein wrote:
> On Thu, May 4, 2017 at 4:59 PM, Christoph Hellwig <hch@lst.de> wrote:
> > On Thu, May 04, 2017 at 04:57:51PM +0300, Amir Goldstein wrote:
> >> I did consider defining uuid_t as uuid_be.
> >> most of the patch set would have remained the same and
> >> xfs_uuid_getnodeuniq() would use struct uuid_v1 explicitly
> >> instead of implicitly.
> >
> > At least don't add new users of uuid_v1.  Moving that stuff into
> > uuid.[ch] was a major mistake, and I wish review would have caught
> > it back then.
> 
> Fine. I can keep xfs_uu_t for now.

Please kill it, but instead of using uuid_v1 just use get_unaligned_be*
access to uuid_be.
