Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 08:03:56 -0700 (PDT)
Message-ID: <4662D852.4000005@dgreaves.com>
Date: Sun, 03 Jun 2007 16:03:46 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression
References: <46608E3F.4060201@dgreaves.com> <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, netdev@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

Linus Torvalds wrote:
> It would be interesting to see what triggered it, since it apparently 
> worked before. So yes, a bisection would be great.

Tejun, all the problematic patches are yours - so adding you.
Neil, since the problem only occurs whilst an xfs filesystem is mounted on a
raid6 array, I've cc'ed you too...

OK
Got as far as I could...
I've run 9 or 10 kernels/bisects and got to a point with 8 of Tejun's changesets
where it wouldn't compile:

  CC      drivers/ata/sata_via.o
drivers/ata/sata_via.c:120: error: `ata_scsi_device_suspend' undeclared here
(not in a function)
drivers/ata/sata_via.c:120: error: initializer element is not constant
drivers/ata/sata_via.c:120: error: (near initialization for `svia_sht.suspend')
drivers/ata/sata_via.c:121: error: `ata_scsi_device_resume' undeclared here (not
in a function)
drivers/ata/sata_via.c:121: error: initializer element is not constant
drivers/ata/sata_via.c:121: error: (near initialization for `svia_sht.resume')
make[2]: *** [drivers/ata/sata_via.o] Error 1

git bisect visualise gave:

bad: 48aaae7a2fa46e1ed0d0b7677fde79ccfcb8c963
bisect: 54936f8b099325992f0f212a5e366fd5257c6c9c
good: 0a3fd051c7036ef71b58863f8e5da7c3dabd9d3f

I used:
git reset --hard 8575b814097af648dad284bd3087875a11b13d18
git reset --hard e92351bb53c0849fabfa80be53cbf3b0aa166e54
git reset --hard 3a32a8e96694a243ec7e7feb6d76dfc4b1fe90c1
git reset --hard 9666f4009c22f6520ac3fb8a19c9e32ab973e828
to step through - non compiled
git reset --hard 1d30c33d8d07868199560b24f10ed6280e78a89c
compiled and hung on resume.

given the first patch identified is
9666f4009c22f6520ac3fb8a19c9e32ab973e828: "libata: reimplement suspend/resume
support using sdev->manage_start_stop"
That seems a good candidate...

Incidentally, when I compile 1d30c33d8d07868199560b24f10ed6280e78a89c (far side
of the implicated changesets) if I umount my xfs over raid6 filesystem (no lvm
as I said in the OP) the resume succeeds.


David
PS I hope I've interpreted bisect correctly - first use and all that...
