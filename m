Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Apr 2007 18:03:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3I138fB018969
	for <xfs@oss.sgi.com>; Tue, 17 Apr 2007 18:03:10 -0700
Message-Id: <200704180103.LAA09246@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: when is a dmapi tarball not a dmapi tarball?
Date: Wed, 18 Apr 2007 11:08:45 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <46252D94.2050106@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Eric Sandeen' <sandeen@sandeen.net>, 'xfs mailing list' <xfs@oss.sgi.com>

Fixed! 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Eric Sandeen
> Sent: Wednesday, 18 April 2007 6:27 AM
> To: xfs mailing list
> Subject: when is a dmapi tarball not a dmapi tarball?
> 
> when you find it on oss, it seems :)
> 
> [esandeen@neon tmp]$ wget
> ftp://oss.sgi.com/projects/xfs/cmd_tars/dmapi_2.2.8-1.tar.gz
> --15:11:31--  
> ftp://oss.sgi.com/projects/xfs/cmd_tars/dmapi_2.2.8-1.tar.gz
>            => `dmapi_2.2.8-1.tar.gz'
> Resolving oss.sgi.com... 192.48.170.157
> Connecting to oss.sgi.com|192.48.170.157|:21... connected.
> Logging in as anonymous ... Logged in!
> ==> SYST ... done.    ==> PWD ... done.
> ==> TYPE I ... done.  ==> CWD /projects/xfs/cmd_tars ... done.
> ==> SIZE dmapi_2.2.8-1.tar.gz ... 84649
> ==> PASV ... done.    ==> RETR dmapi_2.2.8-1.tar.gz ... done.
> Length: 84649 (83K)
> 
> 100%[=======================================>] 84,649       
> 133K/s   in
> 0.6s
> 
> 15:11:33 (133 KB/s) - `dmapi_2.2.8-1.tar.gz' saved [84649]
> 
> [esandeen@neon tmp]$ tar xvzf dmapi_2.2.8-1.tar.gz
> 
> gzip: stdin: not in gzip format
> tar: Child returned status 1
> tar: Error exit delayed from previous errors
> 
> [esandeen@neon tmp]$ file dmapi_2.2.8-1.tar.gz
> dmapi_2.2.8-1.tar.gz: RPM v3 src IA64 dmapi-2.2.8-1
> 
> [esandeen@neon tmp]$ rpm -qpl dmapi_2.2.8-1.tar.gz
> dmapi-2.2.8.src.tar.gz
> dmapi.spec
> 
> Might want to fix that...
> 
> -Eric
> 
> 
