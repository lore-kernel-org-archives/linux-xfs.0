Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 14:23:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QLNirc020757
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 14:23:44 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BACCD609FC
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 14:24:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id d3Kh55xFl4IVyepp for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 14:24:45 -0700 (PDT)
Message-ID: <4864091A.9010206@sandeen.net>
Date: Thu, 26 Jun 2008 16:24:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: is the flush-on-close-after-truncate still needed?
References: <4859415B.3000009@sandeen.net> <200806181049.07812.dchinner@agami.com> <20080626210904.GA15920@bob.dscon.sk> <486407EB.70703@sandeen.net>
In-Reply-To: <486407EB.70703@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: DS <xfs@bob.dscon.sk>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> DS wrote:
>> Hmm, but file overwrite in perl/php is slow, very slow.
> 
> If you have control over your perl/php, perhaps you can change it to do
> unlink/create/write instead of truncate/write?

Or even:

--- test.perl.orig        2008-06-26 16:22:48.163869293 -0500
+++ test.perl   2008-06-26 16:23:25.426869060 -0500
@@ -3,7 +3,7 @@
 $time=time();
 for ($i=1;$i<100;$i++)
 {
-open (SUBOR,">$i.txt");
+open (SUBOR,"+<$i.txt");
 print SUBOR "aaaaaaaaaaaaaaaaaaa\n";
 close (SUBOR);
 print "WRITE $i. FILE\n";

which gives you RW access, but does not do the truncate.

Or use sysopen.  Or ...

-Eric
