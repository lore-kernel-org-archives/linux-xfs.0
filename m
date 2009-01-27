Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0RF5FFj054418 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 09:05:15 -0600
Received: from pastinake.doctronic.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82140BDD4E
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 07:04:31 -0800 (PST)
Received: from pastinake.doctronic.de (pastinake.doctronic.de [217.6.226.210])
	by cuda.sgi.com with ESMTP id GgsSJJF6jAgqEDd8 for
	<xfs@oss.sgi.com>; Tue, 27 Jan 2009 07:04:31 -0800 (PST)
Received: from ZWERG.DOCTRONIC.LOCAL (zwerg.doctronic.de [192.168.4.131])
	by pastinake.doctronic.de (8.13.1/8.13.1) with ESMTP id n0REbOfi020791
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 15:37:24 +0100
Received: from co by ZWERG.DOCTRONIC.LOCAL with local (Exim 4.63)
	(envelope-from <oberscheid@doctronic.de>) id 1LRp48-0005bD-8m
	for xfs@oss.sgi.com; Tue, 27 Jan 2009 15:37:24 +0100
Date: Tue, 27 Jan 2009 15:37:24 +0100
From: Carsten Oberscheid <oberscheid@doctronic.de>
Subject: Re: Strange fragmentation in nearly empty filesystem
Message-ID: <20090127143724.GP16931@doctronic.de>
References: <20090123102130.GB8012@doctronic.de>
	<20090124003329.GE32390@disturbed>
	<20090126075724.GA1753@doctronic.de> <497E02CD.2020000@sandeen.net>
	<20090127071023.GA16511@doctronic.de>
	<20090127084034.GA16931@doctronic.de>
	<497F0C78.7060501@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <497F0C78.7060501@sandeen.net>
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
To: xfs@oss.sgi.com

On Tue, Jan 27, 2009 at 07:30:32AM -0600, Eric Sandeen wrote:
> It'd be best to run vmware under some other kernel, and observe its
> behavior, not just mount some existing filesystem and look at existing
> files and do other non-vmware-related tests.

If this really is just a vmware and/or kernel problem that has nothing
to do with the filesystem, then I agree.

> You went from a file with 34 holes to one with 27k holes by copying it?

Yep.

>  Perhaps this is cp's sparse file detection in action, seeking over
> swaths of zeros.
...
> Perhaps, if by "worse" you mean "leaves holes for regions with zeros".
> Try cp --sparse=3Dnever and see how that goes.

Didn't know this one.


[co@tangchai]~/vmware/foo cp --sparse=3Dnever foo.vmem test_nosparse

[co@tangchai]~/vmware/foo xfs_bmap -vvp test_ | grep hole | wc -l
test_livecd    test_nosparse  =


[co@tangchai]~/vmware/foo xfs_bmap -vvp test_nosparse | grep hole | wc -l
0

[co@tangchai]~/vmware/foo xfs_bmap -vvp test_nosparse | grep -v hole | wc -l
9


You win.

> My best guess is that your cp test is making the file even more sparse
> by detecting blocks full of zeros and seeking over them, leaving more
> holes.  Not really related to vmware behavior, though.

All right. So next I'll try and downgrade vmplayer.

Just out of couriosity (and stubbornness): Are there any XFS
parameters that might influence fragmentation for the better, in case
I have to put up with a stupid application?

Thanks for your time & thoughts & best regards


Carsten Oberscheid

-- =

carsten oberscheid                  d  o  c  t  r  o  n  i  c
email oberscheid@doctronic.de       information publishing + retrieval
phone +49 228 92 682 00             http://www.doctronic.de

doctronic GmbH & Co. KG, Bonn
Handelsregister: HRA 4685 (AG Bonn); USt-ID: DE 210 898 186
Komplement=E4rin:  doctronic Verwaltungsges. mbH, Bonn, HRB 8926 (AG Bonn)
Gesch=E4ftsf=FChrer: Holger Fl=F6rke, Ingo K=FCper, Carsten Oberscheid

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
