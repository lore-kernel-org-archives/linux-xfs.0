Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C4AE27F4C
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 11:47:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0C438F804C
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 09:47:00 -0800 (PST)
Received: from mho-02-ewr.mailhop.org (mho-04-ewr.mailhop.org [204.13.248.74])
	by cuda.sgi.com with ESMTP id ioodTXDVXD6tZRaP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Feb 2013 09:46:58 -0800 (PST)
Date: Mon, 4 Feb 2013 18:46:52 +0100
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Subject: Re: Volume fine on x86_64, corruption on ARM
Message-ID: <20130204174652.GM2421@vicerveza.homeunix.net>
References: <20130127225258.GA2287@vicerveza.homeunix.net>
	<510EE8B2.6040301@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <510EE8B2.6040301@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Feb 03, 2013 at 05:46:10PM -0500, Brian Foster wrote:
> On 01/27/2013 05:52 PM, Llu=EDs Batlle i Rossell wrote:
> > Hello,
> > =

> > I'm using linux 3.7.3 in both machines (x86_64 and armv5tel), and I cre=
ated
> > a volume in x86_64 to be the rootfs for the ARM. All fine, until I plug=
ged it
> > into the ARM (Log below).
> > =

> > Given the corruption, I used xfs_repair in the x86_64, moved a lot of f=
iles into lost+found, plugged it back to the ARM, booted, and corruption ag=
ain.
> > =

> > In the same USB HD, in the same ARM, and this same way, I've used succe=
sfully
> > ext4 and btrfs for a long time. Is there any known issue with ARM?
> > =

> =

> FYI, I played around with my old sheevaplug a bit and so far, only
> reproduced what I think are some USB (possibly hardware) issues. I
> started with a 3.8.0-rc6 kernel and an sdcard and was reproducing
> consistent USB resets leading to all sorts of errors.
> =

> I went back to 3.7.3 and replaced the sdcard with a thumb drive and
> reproduced corruption errors several times on a reboot (not on initial
> boot iirc). This required an fsck or reformat from my host system. I was
> also occasionally reproducing USB debounce errors that required me to
> power cycle and remove/attach the USB drive, which led me to try several
> boot attempts with a clean power cycle and attaching the USB drive after
> the bootloader (u-boot) has initialized, and with that sequence I
> couldn't reproduce the error.
> =

> Unfortunately, I then tried several soft reboot cycles with the drive
> attached and the error hasn't fired, so I can't make any serious
> conclusion from that other than the possibility of flaky drivers or
> hardware. Does your XFS rootfs _always_ fail, or can you get it to boot
> occasionally or with a power cycle? This, of course, could be completely
> unrelated to the issue you observe. I haven't tried a non-XFS filesystem
> yet on this drive either. I'll play with it more when I have some more ti=
me.

Sorry, I'm on a trip, and I can't test this soon.

I used the same USB HD with the same kernel very well, with reiserfs and bt=
rfs,
for many months (running fine with previous kernels too).
I tried three times to boot with XFS, and the corruption came up before sys=
temd
could start properly every time.

I switched to Ext4, and I've had no problem since then either. That's why I
concluded it was only XFS having the problem.

Thank you for your time!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
