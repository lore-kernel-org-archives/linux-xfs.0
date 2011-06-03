Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p534xRc6255063 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 23:59:27 -0500
Received: from mail-ww0-f41.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BE3E496A1B
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 21:59:26 -0700 (PDT)
Received: from mail-ww0-f41.google.com (mail-ww0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id AppcyPOZqVjGtTex
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 21:59:26 -0700 (PDT)
Received: by wwi18 with SMTP id 18so4686973wwi.2
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 21:59:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110603003610.GD16306@thunk.org>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
	<4DE7A557.9040608@redhat.com>
	<7D3F86FA-5AA9-49B0-9AFE-F597E83C07B4@dilger.ca>
	<20110603003610.GD16306@thunk.org>
Date: Fri, 3 Jun 2011 07:59:25 +0300
Message-ID: <BANLkTikiE1v6r7sYKSsR_pgqM-dJzQKrzQ@mail.gmail.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
From: "Amir G." <amir73il@users.sourceforge.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@redhat.com>, Amir Goldstein <amir73il@users.sf.net>, xfs@oss.sgi.com, sergey57@gmail.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri, Jun 3, 2011 at 3:36 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Jun 02, 2011 at 11:22:53AM -0600, Andreas Dilger wrote:
>> On 2011-06-02, at 8:59 AM, Eric Sandeen wrote:
>> > I don't really mind adding ext4dev to FSTYP case statements, it
>> > -is- something which blkid could, in theory, still return, and
>> > making xfstests cope with that and try to invoke fsck -t ext4dev
>> > doesn't bother me too much. =A0It is sadly an fs type embedded into
>> > a few tools.
>>
>> I'm perfectly OK with using ext4dev as a filesystem type that allows tes=
ting
>> changes to ext4 on a system that is already running ext4 as the root fs.
>
> My take on this is that way too much time has been spent this subject.

No doubt.

> Being able to use ext4dev is useful, and given that we have all of
> this support in our existing system tools, why not use it to make ext4
> development more efficient/easy? =A0As a bonus you can build the ext4dev
> as a module, and that means you the compile/edit/debug cycle can be
> much faster since you can avoid doing a reboot, for those
> circumstances where using KVM is not possible/convenient. =A0Personally,
> I normally use KVM these days, but I can imagine situations where
> using ext4dev would be a better way to go. =A0For example, I'd probably
> use KVM on my laptop, but for testing on production servers in a data
> center, I'd probably use ext4dev, for a variety of local deployment
> considerations that's not worth going into here.
>
> That being said, whether or not we modify xfstests seems to be a moot
> point. =A0In order for me to do my bigalloc development, I've been
> patching common.rc so that "/sbin/mkfs.$FSTYP" --> "mkfs.$FSTYP" and
> "/sbin/fsck -t $FSTYP" --> "fsck.$FSTYP". =A0It's a 3 line change. =A0Not
> a big deal. =A0I've been making this change using /bin/ed after
> installing xfstests. =A0So if the XFS folks want to veto this change ---
> who cares? =A0It's not hard to make the change locally in order to make
> xfstests.
>
> On the other hand, given that xfstests is using "mkfs.$FSTYP", I don't
> see why it's so important that it clings to "fsck -t $FSTYP" instead
> of using "fsck.$FSTYP". =A0There's no real benefit to calling the fsck
> driver; it's just an extra fork and exec, and xfstests is being
> inconsistent by insisting on the use of the fsck driver, but not using
> the mkfs driver.
>
> But that being said, hacking xfstests is not hard, and if Dave and/or
> Eric feels strongly about resisting this change, it's not worth a lot
> of time, one way or another....
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0- Ted
>

I blame only myself for not presenting the case correctly.
I made it sound like I am trying to push my own private hack upstream.
Actually, all 10 people involved in snapshot development clone my xfstests
tree from github, so we have no real need for the upstream change.
The reason I was pushing upstream is because I found this feature
so useful, I thought other developers may enjoy it as well.

Anyone on on this thread not having used ext4dev by next LSF
can come to me to claim his beer ;-)

Amir.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
