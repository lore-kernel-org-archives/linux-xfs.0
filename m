Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Dec 2007 10:00:18 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBVI08X6017087
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 10:00:11 -0800
Received: from AUSEXCH1.greshamstorage.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6187D4D0A5C
	for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 10:00:17 -0800 (PST)
Received: from AUSEXCH1.greshamstorage.com (license.greshamstorage.com [12.166.178.178]) by cuda.sgi.com with ESMTP id 1n6EvDSe9i2MSsDF for <xfs@oss.sgi.com>; Mon, 31 Dec 2007 10:00:17 -0800 (PST)
Message-ID: <47792E2F.1090906@greshamstorage.com>
Date: Mon, 31 Dec 2007 12:00:15 -0600
From: Kipp Aldrich <kippa@greshamstorage.com>
Reply-To: kippa@greshamstorage.com
MIME-Version: 1.0
Subject: O_DIRECT and bigphysarea
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Is it possible to read/write an xfs file opened with O_DIRECT to a 
buffer obtained via bigphysarea? I have tried this and get "Bad Address" 
errors. Buffers obtained via regular alloc methods work fine. The 
bigphysarea buffers are correctly mmap'ed into user space, and show in 
/proc/<pid>/maps. So, the question is can I do xfs O_DIRECT on 
reads/writes to bigphysarea buffers?

Thanks. I am running 2.6 (2.6.21-rc3, from sgi cvs).

Kipp
-- 
Kipp A. Aldrich
