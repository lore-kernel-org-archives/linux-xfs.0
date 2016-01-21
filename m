Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B6AC7F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 16:53:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 081C4AC002
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 14:53:09 -0800 (PST)
Received: from mail-yk0-f174.google.com (mail-yk0-f174.google.com
	[209.85.160.174]) by cuda.sgi.com with ESMTP id
	pH6j0iwEB6cpyjnB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jan 2016 14:53:08 -0800 (PST)
Received: by mail-yk0-f174.google.com with SMTP id s126so41702451ykf.2
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 14:53:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160121215820.GA6033@dastard>
References: <1451886892-15548-1-git-send-email-david@fromorbit.com>
	<1451886892-15548-4-git-send-email-david@fromorbit.com>
	<CAA9_cmdAYzf3DpjPRZWikNgmJT_sdDACXa_znz6j0oqmmRdLOA@mail.gmail.com>
	<20160121215820.GA6033@dastard>
Date: Thu, 21 Jan 2016 14:53:06 -0800
Message-ID: <CAPcyv4iXg6pD4p2MTFA3hwUc6eTK=Lpw1nDuchAs1ZQWS05MtA@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: introduce per-inode DAX enablement
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, ext4@vger.kernel.org, XFS Developers <xfs@oss.sgi.com>

On Thu, Jan 21, 2016 at 1:58 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jan 21, 2016 at 08:37:11AM -0800, Dan Williams wrote:
>> On Sun, Jan 3, 2016 at 9:54 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > From: Dave Chinner <dchinner@redhat.com>
>> >
>> > Rather than just being able to turn DAX on and off via a mount
>> > option, some applications may only want to enable DAX for certain
>> > performance critical files in a filesystem.
>> >
>> > This patch introduces a new inode flag to enable DAX in the v3 inode
>> > di_flags2 field. It adds support for setting and clearing flags in
>> > the di_flags2 field via the XFS_IOC_FSSETXATTR ioctl, and sets the
>> > S_DAX inode flag appropriately when it is seen.
>> >
>> > When this flag is set on a directory, it acts as an "inherit flag".
>> > That is, inodes created in the directory will automatically inherit
>> > the on-disk inode DAX flag, enabling administrators to set up
>> > directory heirarchies that automatically use DAX. Setting this flag
>> > on an empty root directory will make the entire filesystem use DAX
>> > by default.
>>
>> When switching from page-cache to DAX, don't we need to flush existing
>> page cache mappings and remap directly?  Or, is the thought that
>> userspace needs to comprehend the presence of mixed mappings after
>> changing S_DAX?
>
> The change should be transparent to userspace. In general, I don't
> expect users to change the behaviour of files that are in active use
> (why would you do that?).

If by accident someone tries to dynamically change S_DAX while
existing mappings are established I think the kernel should just
return EBUSY.  I was not proposing we support it as a first-class
operation.

> This patch is really just introducing the
> flag, the userspace API and making it propagate correctly via the
> on-disk format. We'll fix up whatever problems with switching it
> on/off dynamically as we go, like we do with most experimental
> features once the on-disk behaviour is sorted out.

Ok.

> i.e. I've already got a couple of fixes we need to add to this - the
> DAX flag is only valid on CRC enabled filesystems,

I assume for torn-write protection?  The CRC limitation makes sense,
but we theoretically could get the same effect by using a separate
logdev that does not tear writes, right?

> so we need to
> check that in the ioctl (general problem with using di_flags2 field,
> not DAX flag specific issue). Adding a code to sync and unmap when
> changing the flag is probably also necessary in the ioctl - I don't
> have code to do that yet, but I have been thinking about it...

Matthew and I have also talked about a modification of mincore(2) to
interrogate the effective mapping mode.  It seems we'll need that or
something like it given the growing list of caveats with setting up a
DAX mapping.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
