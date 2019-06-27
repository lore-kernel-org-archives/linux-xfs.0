Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59919 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbfF0Df7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 23:35:59 -0400
Message-ID: <224f3629edfceb8e36a91b9451366b80aaef15cd.camel@themaw.net>
Subject: Re: [PATCH 03/10] xfs: mount-api - add xfs_parse_param()
From: Ian Kent <raven@themaw.net>
Date: Thu, 27 Jun 2019 11:35:53 +0800
In-Reply-To: <6dc984b1eb55d201c95314d146fbeafb45d71c03.camel@themaw.net>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
         <156134511636.2519.2203014992522713286.stgit@fedora-28>
         <20190624172632.GU5387@magnolia>
         <6dc984b1eb55d201c95314d146fbeafb45d71c03.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

On Tue, 2019-06-25 at 07:47 +0800, Ian Kent wrote:
> +	default:
> > > +		return invalf(fc, "XFS: unknown mount option [%s].", param-
> > > > key);
> > 
> > What do these messages end up looking like in dmesg?
> > 
> > The reason I ask is that today when mount option processing fails we log
> > the device name in the error message:
> > 
> > # mount /dev/sda1 /mnt -o gribblegronk
> > [64010.878477] XFS (sda1): unknown mount option [gribblegronk].
> > 
> > AFAICT using invalf (instead of xfs_warn) means that now we don't report
> > the device name, and all you'd get is:
> > 
> > "[64010.878477] XFS: unknown mount option [gribblegronk]."
> > 
> > which is not as helpful...
> 
> Yes, I thought that might be seen as a problem.
> 
> The device name was obtained from the super block in the the
> original code and the super block isn't available at this
> point.
> 
> Not sure what to do about it but I'll have a look.
> 

It turns out that I also made a mistake with the error string.

The above would actually print (something like):
[64010.878477] xfs: XFS: unknown mount option [gribblegronk]."

I can change the case of the struct fs_parameter_description
.name and leave out the "XFS" in the error string to fix that.

But, because the parameter parsing is done before super block
creation, there's no bdev to get a device name from.

There should be a source (block device path) filed set in
the fs context and I could dup the last component of that
or walk the path to resolve symlinks and dup the path
dentry d_name which should give (something like) the
device name.

But the printk %pg format is a bit different in the way
it constructs the name from the bdev so it could well be
different.

That could lead to confusion too.

Also, if an error is occurs in the VFS the message won't
have the device name either.

So I'm not sure what to do about this one, suggestions?

Ian
