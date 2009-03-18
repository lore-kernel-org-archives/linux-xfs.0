Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2I8Yvd2221175 for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 03:35:17 -0500
Received: from relay.ihostexchange.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CD3A1C4F3C4
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 01:34:36 -0700 (PDT)
Received: from relay.ihostexchange.net (relay.ihostexchange.net
	[66.46.182.51]) by cuda.sgi.com with ESMTP id nGH2vqoB5PNjhO6L
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 01:34:36 -0700 (PDT)
From: Sebastian Brings <sbrings@silexmedia.com>
Date: Wed, 18 Mar 2009 04:33:47 -0400
Subject: RE: Lost files + indentical Foldernames on XFS Partition
Message-ID: <5948362D99F6F145B37A7D45B5DDA4481042DDA609@VMBX103.ihostexchange.net>
References: <49BFDC6E.6050607@liga01.de> <49BFDDC5.9060500@sandeen.net>
	<49C029AF.5070205@liga01.de>
In-Reply-To: <49C029AF.5070205@liga01.de>
Content-Language: en-US
MIME-Version: 1.0
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
To: "Steffen.Knauf@liga01.de" <Steffen.Knauf@liga01.de>, Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


> -----Original Message-----
> From: xfs-bounces@oss.sgi.com =

> [mailto:xfs-bounces@oss.sgi.com] On Behalf Of Steffen Knauf
> Sent: Dienstag, 17. M=E4rz 2009 23:53
> To: Eric Sandeen
> Cc: xfs@oss.sgi.com
> Subject: Re: Lost files + indentical Foldernames on XFS Partition
> =

> =

> > Steffen Knauf wrote:
> >   =

> >> Hello,
> >>
> >> today i have a strange behavior. I have a a directory =

> which contains =

> >> lots of indentical Folders with the same Name and Inode.
> >>     =



Does this happen on the filesystem you mounted in parallel on two machines?
I remember your question from early this week, so I ask =


Sebastian

> >
> > What kernel?
> >
> >   =

> =

> Linux version 2.6.16.60-0.21-smp (geeko@buildhost) (gcc version 4.1.2 =

> 20070115 (SUSE Linux))
> > Can you cut and paste what you see?
> >
> >   =

> =

> =

> Really strange is that if execute only a 'ls' command the files are =

> shown twice:
> =

> combine_sbn.0051.tga
> combine_sbn.0051.tga
> =

> But if i execute 'ls -il' the output looks like this:
> =

> combine_sbn.0051.tga: Datei oder Verzeichnis nicht gefunden
> combine_sbn.0057.tga: Datei oder Verzeichnis nicht gefunden
> combine_sbn.0058.tga: Datei oder Verzeichnis nicht gefunden
> =

> Here a directory example:
> =

> 2147642598 drwxrwxrwx 2 500 500 4096 2009-03-17 12:33 =

> S14-01_Fische_beauty_Main
> 2147642598 drwxrwxrwx 2 500 500 4096 2009-03-17 12:33 =

> S14-01_Fische_beauty_Main
> =

> >> I don't create Hardlinks or something else. On the other =

> side some files =

> >> are suddenly vanished. A "ls -al" result in the following error: =

> >> "Access  to bla not possible: File or Directory not found."
> >> I don't find some Errormessages in the logfile. I don't =

> know whether a =

> >> xfs_check make sense.
> >>     =

> >
> > xfs_repair -n will check the filesystem without actually =

> modifying anything.
> >
> >   =

> I'll try it....
> > -Eric
> >
> >   =

> Steffen
> =

> *
> *
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
