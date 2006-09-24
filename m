Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Sep 2006 06:42:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8ODgKaG004349
	for <xfs@oss.sgi.com>; Sun, 24 Sep 2006 06:42:21 -0700
Received: from moutng.kundenserver.de (unknown [212.227.126.190])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A5D8D111616
	for <xfs@oss.sgi.com>; Sun, 24 Sep 2006 06:41:39 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: largeio mount and performance impact
Date: Sun, 24 Sep 2006 15:41:34 +0200
Message-ID: <55EF1E5D5804A542A6CA37E446DDC2066558B4@mapibe17.exchange.xchg>
In-Reply-To: <4515620F.5010607@sandeen.net>
From: "Sebastian Brings" <sebas@silexmedia.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> -----Original Message-----
> From: Eric Sandeen [mailto:sandeen@sandeen.net]
> Sent: Samstag, 23. September 2006 18:34
> To: Sebastian Brings
> Cc: xfs@oss.sgi.com
> Subject: Re: largeio mount and performance impact
> 
> Sebastian Brings wrote:
> > In a different thread I read about the largeio mount option for XFS.
Now
> > I wonder if the problems I recently ran in have been caused by this.
> >
> > After a system uprgade from sles9 sp2 to sp3 one app started
> > misbehaving. Before the upgrade it used 15% CPU, after the upgrade
it
> > was 90+% and the performance dropped by about 50%. The app is
writing a
> > wave audio file, and for every 3840 bytes of audio samples it
appends,
> > it updates the RIFF header of the file. All of this was done using
the
> > buffered fopen/fwrite/... C library functions.
> > An strace showed that seeking to the beginning of the file also
> > triggered a 12MiB read(2) call, and seeking to the end, for example
to
> > 13MiB, translated to a seek(2) to offset 1mib and a read(2) of 12
MiB.
> >
> > Initiall I assumed something very strange had happened to the C lib
> > defaults. Otoh 12MiB is the swidth of the filesystem, so I assume
that
> > the C lib got the 12 MiB optimal IO size from XFS and therefore
behaved
> > as described above. Could that be?
> 
> Unless you specify the largeio mount option, I don't -think- any of
this
> is exposed.
> 
> What does stat -c %o <file> say?
> 
> Did this strace behavior change from sp2 to sp3?
> 
> -Eric


Stat seems to report 12MB:

# stat -c %o sebastian.tgz
12582912

Mount does not have largeio set explicitly. But this is a CXFS, so this
may change tings:

/dev/cxvm/fs1 on /shares/fs1 type xfs
(rw,noatime,client_timeout=1s,retry=0,server_list=(meta01,
meta02),filestreams,quota,mtpt=/shares/fs1)


I don't have strace data from the app running under sp2. But changing
the default library buffer size to a more reasonable size after the
fopen(), the app behaved normal again.


Sebastian
