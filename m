Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p533QJ5t248761 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 22:26:19 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3022499B9F
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 20:26:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HSKyTbVzGoRxwTtC for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2011 20:26:17 -0700 (PDT)
Message-ID: <4DE8544D.30800@redhat.com>
Date: Thu, 02 Jun 2011 22:26:05 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
	<4DE7A557.9040608@redhat.com>
	<7D3F86FA-5AA9-49B0-9AFE-F597E83C07B4@dilger.ca>
	<20110603003610.GD16306@thunk.org>
In-Reply-To: <20110603003610.GD16306@thunk.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, Amir Goldstein <amir73il@users.sf.net>, xfs@oss.sgi.com, sergey57@gmail.com, "Amir G." <amir73il@users.sourceforge.net>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On 6/2/11 7:36 PM, Ted Ts'o wrote:
> On Thu, Jun 02, 2011 at 11:22:53AM -0600, Andreas Dilger wrote:
>> On 2011-06-02, at 8:59 AM, Eric Sandeen wrote:
>>> I don't really mind adding ext4dev to FSTYP case statements, it
>>> -is- something which blkid could, in theory, still return, and
>>> making xfstests cope with that and try to invoke fsck -t ext4dev
>>> doesn't bother me too much.  It is sadly an fs type embedded into
>>> a few tools.
>>
>> I'm perfectly OK with using ext4dev as a filesystem type that allows testing
>> changes to ext4 on a system that is already running ext4 as the root fs.
> 
> My take on this is that way too much time has been spent this subject.
> Being able to use ext4dev is useful, and given that we have all of
> this support in our existing system tools, why not use it to make ext4
> development more efficient/easy?  As a bonus you can build the ext4dev
> as a module, and that means you the compile/edit/debug cycle can be
> much faster since you can avoid doing a reboot, for those
> circumstances where using KVM is not possible/convenient.  Personally,
> I normally use KVM these days, but I can imagine situations where
> using ext4dev would be a better way to go.  For example, I'd probably
> use KVM on my laptop, but for testing on production servers in a data
> center, I'd probably use ext4dev, for a variety of local deployment
> considerations that's not worth going into here.
> 
> That being said, whether or not we modify xfstests seems to be a moot
> point.  In order for me to do my bigalloc development, I've been
> patching common.rc so that "/sbin/mkfs.$FSTYP" --> "mkfs.$FSTYP" and
> "/sbin/fsck -t $FSTYP" --> "fsck.$FSTYP".  It's a 3 line change.  Not
> a big deal.  I've been making this change using /bin/ed after
> installing xfstests.  So if the XFS folks want to veto this change ---
> who cares?  It's not hard to make the change locally in order to make
> xfstests.
> 
> On the other hand, given that xfstests is using "mkfs.$FSTYP", I don't
> see why it's so important that it clings to "fsck -t $FSTYP" instead
> of using "fsck.$FSTYP".  There's no real benefit to calling the fsck
> driver; it's just an extra fork and exec, and xfstests is being
> inconsistent by insisting on the use of the fsck driver, but not using
> the mkfs driver.
> 
> But that being said, hacking xfstests is not hard, and if Dave and/or
> Eric feels strongly about resisting this change, it's not worth a lot
> of time, one way or another....

I think we just want to make sure we understand the reasons for a change.

Every change has risks, and xfstests is used on a lot of different systems.

If I don't fully understand the motivation for a change, I ask questions.
All part of a careful review.

And I apologize for the mkfs vs. fsck inconsistency, that was probably
my fault, originally ;)

-Eric
 
> 						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
