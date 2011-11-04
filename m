Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA467FNx074756 for <xfs@oss.sgi.com>; Fri, 4 Nov 2011 01:07:15 -0500
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7924518C2424
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 23:07:13 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id mMveGGpgpyA73u8k
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 23:07:13 -0700 (PDT)
Received: by wwf27 with SMTP id 27so2250191wwf.32
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 23:07:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111104053908.GB16720@infradead.org>
References: <1320374284-1534-1-git-send-email-guaneryu@gmail.com>
	<1320374284-1534-2-git-send-email-guaneryu@gmail.com>
	<20111104053908.GB16720@infradead.org>
From: Eryu Guan <guaneryu@gmail.com>
Date: Fri, 4 Nov 2011 14:06:51 +0800
Message-ID: <CA+dCu89OZxLx9wCS8511mkRi-uMUDnHFcJQ7yVfR+EL99avcBw@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfstests: meet btrfs fs size requirement in
	_scratch_mkfs_sized()
Reply-To: guaneryu@gmail.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Nov 4, 2011 at 1:39 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Nov 04, 2011 at 10:38:04AM +0800, Eryu Guan wrote:
>> btrfs requires at least 256M file system size, so check 'fssize' in
>> _scratch_mkfs_sized first and give it a proper value. Otherwise
>> mkfs.btrfs will complain something like
>>
>> "File system size 267386880 bytes is too small, 256M is required at leas=
t"
>>
>> This makes 015 077 and 083 run on btrfs.
>
> But it's not really going to test the ENOSPC conditions it was designed
> to exercise. =A0It would be better to either find a way to make btrfs run=
 on
> smaller filesystem, or call _notrun for too small filesystems on btrfs
> from _scratch_mkfs_sized.

Yes, you're right. I checked 015 (it would dd zero to btrfs to full) but fo=
rgot
to check 077 and 083.

I'll try to find a better way. Thanks for reviewing!

Eryu Guan
>
>>
>> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
>> ---
>> =A0common.rc | =A0 =A05 +++++
>> =A01 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/common.rc b/common.rc
>> index e948169..ab61786 100644
>> --- a/common.rc
>> +++ b/common.rc
>> @@ -356,6 +356,11 @@ _scratch_mkfs_sized()
>> =A0 =A0 =A0 /sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $=
blocks
>> =A0 =A0 =A0 ;;
>> =A0 =A0 =A0btrfs)
>> + =A0 =A0# btrfs needs at least 256M file system size
>> + =A0 =A0 if [ $fssize -lt $((256*1024*1024)) ]
>> + =A0 =A0 then
>> + =A0 =A0 =A0 =A0 =A0 =A0 fssize=3D$((256*1024*1024))
>> + =A0 =A0 fi
>> =A0 =A0 =A0 $MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
>> =A0 =A0 =A0 ;;
>> =A0 =A0 =A0*)
>> --
>> 1.7.7.1
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
