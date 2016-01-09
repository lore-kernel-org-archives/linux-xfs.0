Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 43FAB7F37
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 08:17:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24D1930405F
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 06:17:49 -0800 (PST)
Received: from mail-yk0-f171.google.com (mail-yk0-f171.google.com
	[209.85.160.171]) by cuda.sgi.com with ESMTP id
	t8m1X6oeye02RiYE (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 09 Jan 2016 06:17:25 -0800 (PST)
Received: by mail-yk0-f171.google.com with SMTP id v14so297456046ykd.3
	for <xfs@oss.sgi.com>; Sat, 09 Jan 2016 06:17:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160109075414.GA5008@ZenIV.linux.org.uk>
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160104182005.24118.50361.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160109075414.GA5008@ZenIV.linux.org.uk>
Date: Sat, 9 Jan 2016 06:17:24 -0800
Message-ID: <CAPcyv4gyNKHPbhwNrK3N3qtrpO5j=B6Os3ZHZFUrGA-DU6kHNQ@mail.gmail.com>
Subject: Re: [resend PATCH 1/3] block,
	fs: reliably communicate bdev end-of-life
From: Dan Williams <dan.j.williams@intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@fb.com>, linux-nvdimm <linux-nvdimm@ml01.01.org>, XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Fri, Jan 8, 2016 at 11:54 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Jan 04, 2016 at 10:20:05AM -0800, Dan Williams wrote:
[..]
>         Would you mind explaining what the hell is _the_ backing device
> of a filesystem?  What does that translate into in case of e.g. btrfs
> spanning several disks?  Or ext4 with journal on a different device, for
> that matter?
>
>         If anything, I would argue that filesystem is out of place here -
> general situation is "IO on X may require IO on device Y and X needs to do
> something when Y goes away".  Consider e.g. /dev/loop backed by a device
> that went away.  Or by a file on fs that has run down the curtain and joined
> the bleedin choir invisible.  With another fs partially hosted by that
> loopback device.  Or by RAID0 containing said device.
>
>         You are given Y and attempt to locate the affected X.  _Then_
> you assume that X is a filesystem and has "something to be done" independent
> from the role Y played for it, so you can pick that action from superblock
> method.
>
>         IMO you are placing the burden in the wrong place.  _Recepient_
> knows what it depends upon and what should be done for each source of
> trouble.  So make it recepient's responsibility to request notifications.
> At which point the superblock method goes away, along with the requirement
> to handle all sources of trouble the same way, etc.
>
>         What's more, things like RAID5 (also interested in knowing when
> a component has been ripped out) might or might not decide to propagate
> the event further - after all, that's exactly the point of redundancy.
>
>         I'd look into something along the lines of notifier chain per
> gendisk, with potential victims registering a callback when they decide
> that from now on such and such device might screw them over...

Makes sense.  I'll drop this series for now and come back after
re-working it use notifiers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
