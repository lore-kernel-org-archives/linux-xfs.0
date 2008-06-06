Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Jun 2008 06:34:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m56DYM72001056
	for <xfs@oss.sgi.com>; Fri, 6 Jun 2008 06:34:23 -0700
Received: from noire.bucharest.roedu.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1FE7795692
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2008 06:35:15 -0700 (PDT)
Received: from noire.bucharest.roedu.net (noire.Bucharest.roedu.net [141.85.128.18]) by cuda.sgi.com with ESMTP id 53rrYf3nH5R9medZ for <xfs@oss.sgi.com>; Fri, 06 Jun 2008 06:35:15 -0700 (PDT)
Received: from ahriman.bucharest.roedu.net (noire.bucharest.roedu.net [141.85.128.18])
	(authenticated bits=0)
	by noire.bucharest.roedu.net (8.12.10/8.12.10) with ESMTP id m56CZSke018730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 6 Jun 2008 15:35:28 +0300
From: dizzy <dizzy@roedu.net>
Subject: readdir() ordering guarantees on XFS
Date: Fri, 6 Jun 2008 16:34:13 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061634.13990.dizzy@roedu.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello

POSIX leaves unspecified the order of getting the entries with readdir(). This 
is normal since different filesystems may implement their own techniques to 
organize entries in a directory (linear, hash, various search trees, etc).

But if I can makes sure that several Linux machines will have the same FS (ie 
XFS), mount options and same kernels can assume that traversing the same file 
hierarchy structure (that is a file structure with the exact same directories 
and files as names, structure, attributes, except maybe "ctime" which we 
can't really control in Linux) can I expect that traversing using readdir() 
will give me the entries in the exact same order? Or are there any other 
conditions that I have to check for that would guarantee it? (such as, for a 
linear directory aproach one has to have created the directory entries in the 
same order on all the machines to expect same order on readdir()).

Currently, we workaround this issue by reading all the directory entries, 
sorting them and traversing the entries in the sorted order. This however has 
been proven to slow the traversal (depth first traversal) operation about 30% 
than doing it in the order received from readdir() (I even had the test code 
read the whole directory contents, sort them in memory but still have it 
traverse in the order readdir() reported and it is 30% faster than traversing 
in the sorted order).

Any idea?

Thanks!

PS: please Cc: me as I'm not subscribed to the list, thank you

-- 
Mihai RUSU					Email: dizzy@roedu.net
			"Linux is obsolete" -- AST
