Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12GQURl062154 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 10:26:30 -0600
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id KyAc4hWChOIBasmr
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Feb 2012 08:26:29 -0800 (PST)
Received: by qafk1 with SMTP id k1so1966543qaf.5
	for <xfs@oss.sgi.com>; Thu, 02 Feb 2012 08:26:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120202091330.GA31203@infradead.org>
References: <CAC=U0a1huHVULfMObyH_XNcQi5aTZtrbpcciNhw=92PE96f4cg@mail.gmail.com>
	<20120202091330.GA31203@infradead.org>
Date: Thu, 2 Feb 2012 11:26:28 -0500
Message-ID: <CAC=U0a11udmsGAKg5Sp+X2uxRTKS8gq37CK9OAZKhLOPKbWHKQ@mail.gmail.com>
Subject: Re: Inode lockdep problem observed on 2.6.37.6 xfs with RT subvolume
From: Kamal Dasu <kdasu.kdev@gmail.com>
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
Cc: cernekee@gmail.com, xfs@oss.sgi.com

On Thu, Feb 2, 2012 at 4:13 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Feb 01, 2012 at 07:44:13PM -0500, Kamal Dasu wrote:
>> Need some help understanding the state of xfs with rt subvolume
>> support on 2.6.37.
>>
>> When using xfs rt subvolume on a harddisk partition with kernel
>> 2.6.37.6,and normal r/w/delete file operations? causes deadlock
>> like hangs .? Failure? symptoms are lockups and mount failure on reboot.
>>
>> On further investigation it was found that one of the changes could be
>> the cause.
>> The same tests seem to pass with xfs in 2.6.31 kernel.
>>
>> xfs: simplify xfs_trans_iget? : aa72a5cf00001d0b952c7c755be404b9118ceb2e
>> http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
commitdiff;h=3Daa72a5cf00001d0b952c7c755be404b9118ceb2e
>>
>> Reverting the change and forward porting to the xfs_trans_inode() seems =
to
>> get rid of the deadlock and mount issues .
>>
>> Below is the change
>
> Please just upgrade to Linux 2.6.39 or better Linux 3.0 which is the
> long term support release. RT subvolume support has been fixed in 2.6.39
> by the following changes:
>
> =A0xfs: only lock the rt bitmap inode once per allocation
> =A0xfs: fix xfs_get_extsz_hint for a zero extent size hint
> =A0xfs: add lockdep annotations for the rt inodes
>
> But in general the RT subvolume code is not regularly tested and only
> fixed when issues arise.


Thanks for quick reply and clarifying this, if upgrading the kernel is
not an option, should I be
considering backporting  changes to 2.6.37,  should I  use the entire
2.6.39 or 3.0
xfs implementation as is of cherry pick the above three changes ?.

Regards
Kamal

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
