Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1S7oi6G123052 for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 01:50:45 -0600
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E13391314F7F
	for <xfs@oss.sgi.com>; Sun, 27 Feb 2011 23:53:31 -0800 (PST)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	PRzi8JWesxyvhphZ for <xfs@oss.sgi.com>;
	Sun, 27 Feb 2011 23:53:31 -0800 (PST)
Received: by qyk7 with SMTP id 7so2078237qyk.5
	for <xfs@oss.sgi.com>; Sun, 27 Feb 2011 23:53:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110227224940.GL2924@thunk.org>
References: <4D6221B8.9040303@gmail.com> <20110221124635.GA5525@infradead.org>
	<AANLkTi=bJBeR0m3xuGX_9YZPqRFuMY=bKoxZEWJt37=M@mail.gmail.com>
	<20110227224940.GL2924@thunk.org>
Date: Mon, 28 Feb 2011 08:53:31 +0100
Message-ID: <AANLkTinKCUeHLmz3CFh_k3oxEW-p8ta0djGFK3q8vQ+0@mail.gmail.com>
Subject: Re: [PATCH] Check for immutable flag in fallocate path
From: Marco Stornelli <marco.stornelli@gmail.com>
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
To: Ted Ts'o <tytso@mit.edu>, Marco Stornelli <marco.stornelli@gmail.com>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

2011/2/27 Ted Ts'o <tytso@mit.edu>:
> On Mon, Feb 21, 2011 at 05:50:21PM +0100, Marco Stornelli wrote:
>> 2011/2/21 Christoph Hellwig <hch@infradead.org>:
>> > On Mon, Feb 21, 2011 at 09:26:32AM +0100, Marco Stornelli wrote:
>> >> From: Marco Stornelli <marco.stornelli@gmail.com>
>> >>
>> >> All fs must check for the immutable flag in their fallocate callback.
>> >> It's possible to have a race condition in this scenario: an applicati=
on
>> >> open a file in read/write and it does something, meanwhile root set t=
he
>> >> immutable flag on the file, the application at that point can call
>> >> fallocate with success. Only Ocfs2 check for the immutable flag at the
>> >> moment.
>> >
>> > Please add the check in fs/open.c:do_fallocate() so that it covers all
>> > filesystems.
>> >
>> >
>>
>> The check should be done after the fs got the inode mutex lock.
>
> Why? =A0None of the other places which check the IMMUTABLE flag do so
> under the inode mutex lock. =A0Yes, it's true that we're not properly
> doing proper locking when updating i_flags from the ioctl (this is
> true for all file systems), but this has been true for quite some
> time, and using a mutex to protect bit set/clear/test operations would
> be like using a sledgehammer to kill a fly.
>
> A proper fix if we want to be completely correct about updates to
> i_flags would involve using test_bit, set_bit, and clear_bit, which is
> guaranteed to be atomic. =A0This is how we update the
> ext4_inode_info->i_flags (which is different from inode->i_flags) (see
> the definition and use of EXT4_INODE_BIT_FNS in fs/ext4/ext4.h).
>
> At some point, it would be good to fix how we set/get i_flags values,
> but that's independent of the change that's being discussed here.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>

I was thinking to the possible race with setattr callback.

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
