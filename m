Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3OMcDxF190668 for <xfs@oss.sgi.com>; Sat, 24 Apr 2010 17:38:13 -0500
Received: from mail-px0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DD261041A52
	for <xfs@oss.sgi.com>; Sat, 24 Apr 2010 15:40:14 -0700 (PDT)
Received: from mail-px0-f181.google.com (mail-px0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	4s6ov2My1EPYwelk for <xfs@oss.sgi.com>;
	Sat, 24 Apr 2010 15:40:14 -0700 (PDT)
Received: by pxi19 with SMTP id 19so1348427pxi.26
	for <xfs@oss.sgi.com>; Sat, 24 Apr 2010 15:40:14 -0700 (PDT)
Message-ID: <4BD37360.10804@gmail.com>
Date: Sat, 24 Apr 2010 15:40:32 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
Subject: Re: [opensuse-kernel] Re: 2.6.34-rc3: simple du (on a big xfs tree)
	triggers oom killer [bisected:
	57817c68229984818fea9e614d6f95249c3fb098]
References: <201004050049.17952.hpj@urpla.net>
	<201004241844.23482.hpj@urpla.net>
	<20100424232320.71f764eb@galadriel.home>
	<201004250030.40867.hpj@urpla.net>
In-Reply-To: <201004250030.40867.hpj@urpla.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Nick Piggin <npiggin@suse.de>, opensuse-kernel@opensuse.org, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 04/24/2010 03:30 PM, Hans-Peter Jansen wrote:
> On Saturday 24 April 2010, 23:23:20 Emmanuel Florac wrote:
>> Le Sat, 24 Apr 2010 18:44:22 +0200 vous =E9criviez:
>>> Greg, you might search for a server using xfs filesystems and and a
>>> i586 kernel>=3D 2.6.33, (2.6.32.11 of SLE11-SP1 will serve as well),
>>> log in as an ordinary user, do a "du" on /usr, and wait for the other
>>> users screaming...
>>
>> I did precisely that, and didn't notice anything special (du on kernel
>> source tree) kernel 2.6.32.11, deadline scheduler, 7 drives RAID-6
>> array, 8GB RAM.
>
> I guess, you're not on this specific openSUSE git version of 2.6.32.11 (e=
.g.
> the preparation for SP1 of SLE11), which, as usual, carries a lot of stuff
> from later kernels. The offending patch was included in linux-2.6.33
> between -rc4 and -rc5:
>
> Committer
> Alex Elder<aelder@sgi.com>
> Author
> Dave Chinner<david@fromorbit.com>
> Author date
> 11.01.10 00:51
> Parent
> xfs: Avoid inodes in reclaim when flushing from inode cache
> Child
> xfs: Remove inode iolock held check during allocation
> Branch
> master origin (Merge branch 'for-linus' of git://git.kernel.org/pub/scm/.=
..)
> Branch
> 2.6.33.1 (Linux 2.6.33)
> Follows
> v2.6.33-rc4 (Linux 2.6.33-rc4)
> Precedes
> v2.6.33-rc5 (Linux 2.6.33-rc5)
>
> Cheers,
> Pete


is this bisectable?
from what I remember with 2.6.33
looking at the bugreports I don't recall
any issue in regards with firmware related stuff
for radeon(but could be wrong).

Keep in mind, I don't have your card, but I do have the X1600
which had no issues so far(running the latest HEAD).
does changing the .config work for you?
(in regards to what the thread I posted
had mentioned)

as for the open suse SP1 of SLE11..glad there is
an option to load the latest kernel.

Justin P. Mattock

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
