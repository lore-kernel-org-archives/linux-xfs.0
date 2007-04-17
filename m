Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Apr 2007 13:57:43 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3HKvdfB029040
	for <xfs@oss.sgi.com>; Tue, 17 Apr 2007 13:57:40 -0700
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx2.redhat.com (8.13.1/8.13.1) with ESMTP id l3HKUfeT009781
	for <xfs@oss.sgi.com>; Tue, 17 Apr 2007 16:30:42 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l3HKUesm004074
	for <xfs@oss.sgi.com>; Tue, 17 Apr 2007 16:30:40 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l3HKUcAx017901
	for <xfs@oss.sgi.com>; Tue, 17 Apr 2007 16:30:40 -0400
Message-ID: <46252D94.2050106@sandeen.net>
Date: Tue, 17 Apr 2007 15:27:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: when is a dmapi tarball not a dmapi tarball?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

when you find it on oss, it seems :)

[esandeen@neon tmp]$ wget
ftp://oss.sgi.com/projects/xfs/cmd_tars/dmapi_2.2.8-1.tar.gz
--15:11:31--  ftp://oss.sgi.com/projects/xfs/cmd_tars/dmapi_2.2.8-1.tar.gz
           => `dmapi_2.2.8-1.tar.gz'
Resolving oss.sgi.com... 192.48.170.157
Connecting to oss.sgi.com|192.48.170.157|:21... connected.
Logging in as anonymous ... Logged in!
==> SYST ... done.    ==> PWD ... done.
==> TYPE I ... done.  ==> CWD /projects/xfs/cmd_tars ... done.
==> SIZE dmapi_2.2.8-1.tar.gz ... 84649
==> PASV ... done.    ==> RETR dmapi_2.2.8-1.tar.gz ... done.
Length: 84649 (83K)

100%[=======================================>] 84,649       133K/s   in
0.6s

15:11:33 (133 KB/s) - `dmapi_2.2.8-1.tar.gz' saved [84649]

[esandeen@neon tmp]$ tar xvzf dmapi_2.2.8-1.tar.gz

gzip: stdin: not in gzip format
tar: Child returned status 1
tar: Error exit delayed from previous errors

[esandeen@neon tmp]$ file dmapi_2.2.8-1.tar.gz
dmapi_2.2.8-1.tar.gz: RPM v3 src IA64 dmapi-2.2.8-1

[esandeen@neon tmp]$ rpm -qpl dmapi_2.2.8-1.tar.gz
dmapi-2.2.8.src.tar.gz
dmapi.spec

Might want to fix that...

-Eric
