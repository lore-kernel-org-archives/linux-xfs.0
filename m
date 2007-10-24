Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Oct 2007 02:03:38 -0700 (PDT)
Received: from zeus.office.navi.pl (ip-83-238-212-180.netia.com.pl [83.238.212.180])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9O93R83007035
	for <xfs@oss.sgi.com>; Wed, 24 Oct 2007 02:03:29 -0700
Subject: Re: [RFC 0/2] Case-insensitive filename lookup for XFS
From: Olaf =?iso-8859-2?Q?Fr=B1czyk?= <olaf@cbk.poznan.pl>
In-Reply-To: <op.t0oejdbf3jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <op.t0m36sn43jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <200710231422.21637.ms@teamix.de>
	 <op.t0oejdbf3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 24 Oct 2007 10:41:30 +0200
Message-Id: <1193215290.12133.16.camel@venus.local.navi.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Martin Steigerwald <ms@teamix.de>, xfs@oss.sgi.com

On Wed, 2007-10-24 at 10:34 +1000, Barry Naujok wrote:
> On Tue, 23 Oct 2007 22:22:21 +1000, Martin Steigerwald <ms@teamix.de> wrote:
> 
> > Am Dienstag, 23. Oktober 2007 schrieb Barry Naujok:
> >
> > Hi Barry,
> >
> >> To allow case-insensitivity to be a mount option rather than
> >> a mkfs option, the hashes stored on disk are always case-folded.
> >> This is indicated by the new "unicode" bit in the superblock.
> >> This bit also associated with the presence of the case-folding
> >> table on disk.
> >
> > What would happen in the following scenario?
> >
> > mount -t xfs /dev/somedevice /mnt/tmp
> > touch /mnt/tmp/testfile
> > touch /mnt/tmp/Testfile
> > touch /mnt/tmp/TESTFILE
> >
> > mount -t xfs -o remount,ci /dev/somedevice /mnt/tmp
> > rm /mnt/tmp/testfile
> 
> testfile would be deleted, Testfile and TESTFILE will remain.
> Subsequent rm's should remove the rest.

Or maybe testfile and Testfile will remain? If it is mounted as ci you
have no idea which one will be deleted.

IMO having this as mount option is broken by design. If you do it as
mkfs option then you avoid most of ugly problems.
1. What if you have the following code in your program

if (exists lala){
	error=remove lala
	if(error) die
	if(!error) error=create lala
	if(error) die
}

the create will fail, and it is clearly not expected behaviour.

2. What will ls show:
Test.txt
test.txt
TeSt.txt
when mount as ci?

3. Which one will be removed if you do rm on ci mounted filesystem?

4. If it were mkfs option you could avoid expensive filename lookups.
Just store all files in lowercase and on lookup convert the argument to
lowercase. If you want to preserve case you could use eg. file attribute
to store filename with case preserved.

Regards,

Olaf Frączyk



-- 
Olaf Frączyk <olaf@cbk.poznan.pl>
