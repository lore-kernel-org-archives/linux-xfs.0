Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Dec 2006 07:36:17 -0800 (PST)
Received: from deflector.emaze.net (deflector.emaze.net [213.178.220.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBNFaCqw010754
	for <linux-xfs@oss.sgi.com>; Sat, 23 Dec 2006 07:36:13 -0800
Received: from localhost (localhost [127.0.0.1])
	by deflector.emaze.net (Postfix) with ESMTP id 8F6E7F2816D
	for <linux-xfs@oss.sgi.com>; Sat, 23 Dec 2006 16:15:12 +0100 (CET)
Received: from deflector.emaze.net ([127.0.0.1])
	by localhost (deflector [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 06830-03 for <linux-xfs@oss.sgi.com>;
	Sat, 23 Dec 2006 16:15:12 +0100 (CET)
Received: from [192.168.10.55] (host68-236-dynamic.5-87-r.retail.telecomitalia.it [87.5.236.68])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by deflector.emaze.net (Postfix) with ESMTP id 459C2F28080
	for <linux-xfs@oss.sgi.com>; Sat, 23 Dec 2006 16:15:12 +0100 (CET)
Message-ID: <458D4845.2010803@emaze.net>
Date: Sat, 23 Dec 2006 16:16:21 +0100
From: fdegrassi <francesco.degrassi@emaze.net>
MIME-Version: 1.0
Subject: Possible performance problem introduced between kernel 2.6.15 and
 2.6.17 on xfs code
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi all,
i noticed that changing from kernel 2.6.15 to 2.6.17, gnomevfs-copy 
operations suffered an heavy performance hit (20 times slower).
I checked quickly (i am not a kernel hacker) and i think it could be 
related to libgnomevfs calling fadvice POSIX_FADV_DONTNEED  (in 
gnome_vfs_forget_cache, disabling this behaviour gets back normal 
performance).
I am not able to dig deeper than this, anyway it could be a starting point.
The relevant gnome bugzilla reference is the following: 
http://bugzilla.gnome.org/show_bug.cgi?id=363400

Francesco Degrassi
