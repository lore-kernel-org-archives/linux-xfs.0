Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 21:58:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m414wZL2030089
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 21:58:37 -0700
Message-ID: <48194E23.5050009@sgi.com>
Date: Thu, 01 May 2008 14:59:15 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: request to checkin updated xfstess/dmapi/src/suite1/cmd/Makefile.in
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

I would like to check in an updated
xfstests/dmapi/src/suite1/cmd/Makefile.in
like we do with the other Makefile.in's in xfstests/dmapi.
This has been the current model that we've been following
where we checkin the Makefile.in even though it can be generated
by running automake on the Makefile.am file.

The xfstests/dmapi/src/suite1/cmd/Makefile.am was updated for a new
binary target but not the Makefile.in
which means that one needs to run automake.
So I've run automake and would like to check in the new Makefile.in
so that one just needs to run configure and make for the build in
dmapi. The xfstests makefile currently runs configure and make
in dmapi.

--Tim
