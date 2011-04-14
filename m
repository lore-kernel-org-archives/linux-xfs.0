Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3EEvnKh000455 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 09:57:49 -0500
Received: from mail1.slb.deg.dub.stisp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 2003C3E11ED
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 08:01:10 -0700 (PDT)
Received: from mail1.slb.deg.dub.stisp.net (mail1.slb.deg.dub.stisp.net
	[84.203.253.98]) by cuda.sgi.com with SMTP id U71Janw2UfDY7Vh4
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 08:01:10 -0700 (PDT)
Message-ID: <4DA70BD3.1070409@draigBrady.com>
Date: Thu, 14 Apr 2011 15:59:31 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
References: <20110414102608.GA1678@x4.trippels.de>	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
In-Reply-To: <20110414140222.GB1679@x4.trippels.de>
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
To: xfs-oss <xfs@oss.sgi.com>, linux-ext4@vger.kernel.org
Cc: coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>

On 14/04/11 15:02, Markus Trippelsdorf wrote:
>>> Hi P=E1draig,
>>>
>>> here you go:
>>> + filefrag -v unwritten.withdata                                       =
                                                                           =
   =

>>> Filesystem type is: ef53                                               =
                                                                           =
   =

>>> File size of unwritten.withdata is 5120 (2 blocks, blocksize 4096)     =
                                                                           =
   =

>>>  ext logical physical expected length flags                            =
                                                                           =
   =

>>>    0       0   274432            2560 unwritten,eof                    =
                                                                           =
   =

>>> unwritten.withdata: 1 extent found
>>>
>>> Please notice that this also happens with ext4 on the same kernel. =

>>> Btrfs is fine.
>>
> `filefrag -vs` fixes the issue on both xfs and ext4.

So in summary, currently on (2.6.39-rc3), the following
will (usually?) report a single unwritten extent,
on both ext4 and xfs

  fallocate -l 10MiB -n k
  dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock of=3Dk
  filefrag -v k # grep for an extent without unwritten || fail

This particular issue has been discussed so far at:
http://debbugs.gnu.org/cgi/bugreport.cgi?bug=3D8411
Note there it was stated there that ext4 had this
fixed as of 2.6.39-rc1, so maybe there is something lurking?

cheers,
P=E1draig.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
