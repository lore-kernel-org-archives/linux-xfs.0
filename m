Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 07:35:52 -0800 (PST)
Received: from evaldomino.Falconstor.com (mail1.falconstor.com [216.223.47.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NFZiqw021667
	for <linux-xfs@oss.sgi.com>; Tue, 23 Jan 2007 07:35:45 -0800
Message-ID: <45B6277F.20506@falconstor.com>
Date: Tue, 23 Jan 2007 10:19:27 -0500
From: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Reply-To: geir.myrestrand@falconstor.com
MIME-Version: 1.0
Subject: Will xfs_growfs succeed on a full file system?
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Does xfs_growfs depend on some space left on the file system in order to 
be able to grow it?

I have a colleague who ran into an issue where a file system resize 
failed. The file system is 100% full.

Aside from analyzing what happened in his case, should XFS be able to 
grow a file system that is 100% full?

The device has already been expanded, it is the XFS file system that 
fails to resize. I just wonder if that is by design, or whether it is an 
issue.

-- 

Geir A. Myrestrand
