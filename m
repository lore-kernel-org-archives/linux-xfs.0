Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A49EC35242
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 20:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5125220659
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 20:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgBKUEh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 15:04:37 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48978 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727762AbgBKUEg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 15:04:36 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5D4493A1E0C;
        Wed, 12 Feb 2020 07:04:32 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j1blm-0002kh-GY; Wed, 12 Feb 2020 07:04:30 +1100
Date:   Wed, 12 Feb 2020 07:04:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Vincent Fazio <vfazio@xes-inc.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Aaron Sierra <asierra@xes-inc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fallback to readonly during recovery
Message-ID: <20200211200430.GJ10776@dread.disaster.area>
References: <20200210211037.1930-1-vfazio@xes-inc.com>
 <99259ceb-2d0d-1054-4335-017f1854ba14@sandeen.net>
 <829353330.403167.1581373892759.JavaMail.zimbra@xes-inc.com>
 <400031d2-dbcb-a0de-338d-9a11f97c795c@sandeen.net>
 <20200211125504.GA2951@bfoster>
 <e8169b53-252b-b133-7bc5-ee5dc206c402@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e8169b53-252b-b133-7bc5-ee5dc206c402@xes-inc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=l697ptgUJYAA:10
        a=5xOlfOR4AAAA:8 a=7-415B0cAAAA:8 a=I9lKwJ2Ql21KwK4mQOcA:9
        a=QEXdDO2ut3YA:10 a=SGlsW6VomvECssOqsvzv:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 11, 2020 at 08:04:01AM -0600, Vincent Fazio wrote:
> All,
> 
> On 2/11/20 6:55 AM, Brian Foster wrote:
> > On Mon, Feb 10, 2020 at 05:40:03PM -0600, Eric Sandeen wrote:
> > > On 2/10/20 4:31 PM, Aaron Sierra wrote:
> > > > > From: "Eric Sandeen" <sandeen@sandeen.net>
> > > > > Sent: Monday, February 10, 2020 3:43:50 PM
> > > > > On 2/10/20 3:10 PM, Vincent Fazio wrote:
> > > > > > Previously, XFS would fail to mount if there was an error during log
> > > > > > recovery. This can occur as a result of inevitable I/O errors when
> > > > > > trying to apply the log on read-only ATA devices since the ATA layer
> > > > > > does not support reporting a device as read-only.
> > > > > > 
> > > > > > Now, if there's an error during log recovery, fall back to norecovery
> > > > > > mode and mark the filesystem as read-only in the XFS and VFS layers.
> > > > > > 
> > > > > > This roughly approximates the 'errors=remount-ro' mount option in ext4
> > > > > > but is implicit and the scope only covers errors during log recovery.
> > > > > > Since XFS is the default filesystem for some distributions, this change
> > > > > > allows users to continue to use XFS on these read-only ATA devices.
> > > > > What is the workload or scenario where you need this behavior?
> > > > > 
> > > > > I'm not a big fan of ~silently mounting a filesystem with latent errors,
> > > > > tbh, but maybe you can explain a bit more about the problem you're solving
> > > > > here?
> > > > Hi Eric,
> > > > 
> > > > We use SSDs from multiple vendors that can be configured at power-on (via
> > > > GPIO) to be read-write or write-protected. When write-protected we get I/O
> > > > errors for any writes that reach the device. We believe that behavior is
> > > > correct.
> > > > 
> > > > We have found that XFS fails during log recovery even when the log is clean
> > > > (apparently due to metadata writes immediately before actual recovery).
> > > There should be no log recovery if it's clean ...
> > > 
> > > And I don't see that here - a clean log on a readonly device simply mounts
> > > RO for me by default, with no muss, no fuss.
> > > 
> > > # mkfs.xfs -f fsfile
> > > ...
> > > # losetup /dev/loop0 fsfile
> > > # mount /dev/loop0 mnt
> > > # touch mnt/blah
> > > # umount mnt
> > > # blockdev --setro /dev/loop0
> > > # dd if=/dev/zero of=/dev/loop0 bs=4k count=1
> > > dd: error writing ‘/dev/loop0’: Operation not permitted
> > > # mount /dev/loop0 mnt
> > > mount: /dev/loop0 is write-protected, mounting read-only
> > > # dmesg
> > > [  419.941649] /dev/loop0: Can't open blockdev
> > > [  419.947106] XFS (loop0): Mounting V5 Filesystem
> > > [  419.952895] XFS (loop0): Ending clean mount
> > > # uname -r
> > > 5.5.0
> > > 
> I think it's important to note that you're calling `blockdev --setro` here,
> which sets the device RO at the block layer...
> 
> As mentioned in the commit message, the SSDs we work with are ATA devices
> and there is no such mechanism in the ATA spec to report to the block layer
> that the device is RO. What we run into is this:

This sounds like you are trying to solve the wrong problem - this
isn't actually a filesystem issue. The fundamental problem is you
have a read-only device that isn't being marked by the kernel as
read-only, and everything goes wrong after that.

Write a udev rule to catch these SSDs at instantation time and mark
them read only via software. That way everything understands the
device is read only and behaves correctly, rather than need to make
every layer above the block device understand that a read-write
device is actually read-only...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
