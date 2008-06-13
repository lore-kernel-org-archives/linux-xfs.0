Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jun 2008 06:27:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5DDRaB9008956
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 06:27:36 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0ADD12C4D0E
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 06:28:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 9IlivrV2v4mJm3KP for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 06:28:32 -0700 (PDT)
Message-ID: <485275FF.2050909@sandeen.net>
Date: Fri, 13 Jun 2008 08:28:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com> <484F452A.8090909@sandeen.net> <48512A34.1020604@sandeen.net> <4851CD32.7080106@melbourne.sgi.com> <4851E774.2070401@sgi.com> <4851EC2D.6010504@melbourne.sgi.com> <48520704.8050903@melbourne.sgi.com>
In-Reply-To: <48520704.8050903@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg Banks <gnb@melbourne.sgi.com>
Cc: markgw@sgi.com, Timothy Shimmin <tes@sgi.com>, Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

Greg Banks wrote:

>> I'll need to improve
>> the scanning tool :-)
> Attached.
> 

I had done something similar, except:

--- summarise-stat64-2.pl.orig	2008-06-13 08:26:07.000000000 -0500
+++ summarise-stat64-2.pl	2008-06-13 08:26:24.000000000 -0500
@@ -93,11 +93,11 @@
 		{
 			$res{used64}++;
 		}
-		elsif (m/^\s+U readdir$/)
+		elsif (m/^\s+U readdir(|_r)$/)
 		{
 			$res{used32}++;
 		}
-		elsif (m/^\s+U readdir64$/)
+		elsif (m/^\s+U readdir64(|_r)$/)
 		{
 			$res{used64}++;
 		}

(lazily whitespace-mangled, sorry)

A new scan with my slightly different version of the tool yielded:

  447 readdir32
  908 stat32
   38 statfs32

where the nr. is the nr. of packages with that particular 32-bit call.

-Eric
