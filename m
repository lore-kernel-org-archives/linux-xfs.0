Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 80F1A7F47
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 17:46:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 600448F8033
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 15:46:53 -0700 (PDT)
Received: from mail-lb0-f180.google.com (mail-lb0-f180.google.com
	[209.85.217.180]) by cuda.sgi.com with ESMTP id
	4Dt8p9Nf3htvuItX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 18 Oct 2015 15:46:51 -0700 (PDT)
Received: by lbbes7 with SMTP id es7so40060659lbb.2
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 15:46:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151018214456.GM2678@thunk.org>
References: <CAHc6FU5s7-t3+jtKDusVFqc542Ag7pEOTUqp1LSxg8_uCPyF=A@mail.gmail.com>
	<20151016231615.GF15011@thunk.org>
	<CAHc6FU5B35D30Cc0-iSAfKDrCfc29paYe-tg-GGP7KEH08+2rA@mail.gmail.com>
	<20151017143951.GA2678@thunk.org> <20151017225910.GT27164@dastard>
	<20151018003532.GD2678@thunk.org>
	<CAHc6FU6U-r4YjxdvhW_OAmdekzK-tBT62Hs_JBYFB0V65qDw4w@mail.gmail.com>
	<20151018214456.GM2678@thunk.org>
Date: Mon, 19 Oct 2015 00:46:49 +0200
Message-ID: <CAHc6FU7J9OESpAJzOKOmu-UP-bC_kzKT-oVg-MVKAaVzswOacA@mail.gmail.com>
Subject: Re: e2fsprogs: Richacl support
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Sun, Oct 18, 2015 at 11:44 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Oct 18, 2015 at 10:46:23PM +0200, Andreas Gruenbacher wrote:
>> > The only question is whether we pay attention to the richacl acl's at
>> > all.  One thing that's not clear to me is what VFS is supposed to do
>> > if an inode has both an Posix ACL xattr and a Richacl xattr at the
>> > same time.
>>
>> The VFS will either look for POSIX ACLs or for a richacl; it won't
>> even notice if both are present.
>
> How does this work in practice?  Does it look for richacl's first, and
> if it doesn't find it, it will then look for a Posix ACL, or vice
> versa?

The filesystem sets the MS_POSIXACL super-block flag for POSIX ACLs or
the MS_RICHACL super-block flag for richacls. These flags are checked
with the IS_POSIXACL(inode) and IS_RICHACL(inode) macros.

>> Right now, filesystems that e2fsck is perfectly happy with can still
>> cause errors when used. It would be nice to fix that.
>>
>> With POSIX ACLs, this problem is slightly less severe because the ACL
>> isn't looked at for the owner; it would even be possible to replace a
>> corrupted POSIX ACL. Richacls unfortunately don't allow this
>> optimization.
>
> Is there code we can use to verify a richacl, and if it's corrupted,
> what are the options about how we can fix it?  Or do we just remove
> it, and just use the inode's i_uid field for the owner instead of
> whatever might be in the richacl?

The on-disk format is relatively simple, it's the same on ext4 and on
xfs and hopefully will be the same on other filesystems as well. That
code could be shared.

If a richacl is found to be corrupt, a safe way of recovering would be
to remove the richacl and clear the S_IRWXUGO mode bits. I don't think
trying to fix ACLs would make sense. The i_uid field is unrelated.

> Ideally, if you can send the patch to add support to validate / fix
> Richacl's in e2fsck, that would be great.

I can send the validation code; not sure how removing corrupt xattrs
would fit into e2fsck though. Can e2fsck remove individual xattrs?

>> This really should be a feature flag and not a mount option, it just
>> doesn't make sense to switch at mount time.
>>
>> From this discussion, I'm even more convinced that we should use an
>> incompat feature rather than a ro-incompat feature.
>
> OK, let's go with that.

Okay, good.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
