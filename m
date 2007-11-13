Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Nov 2007 10:21:07 -0800 (PST)
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lADIKxKK015204
	for <xfs@oss.sgi.com>; Tue, 13 Nov 2007 10:21:02 -0800
Received: from localhost (localhost.intra.frontsite.de [127.0.0.1])
	by mail.pawisda.de (Postfix) with ESMTP id D779DF52B
	for <xfs@oss.sgi.com>; Tue, 13 Nov 2007 19:21:05 +0100 (CET)
Received: from mail.pawisda.de ([127.0.0.1])
 by localhost (ndb [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 32306-09 for <xfs@oss.sgi.com>; Tue, 13 Nov 2007 19:21:00 +0100 (CET)
Received: from [192.168.51.2] (lw-pc002.intra.frontsite.de [192.168.51.2])
	by mail.pawisda.de (Postfix) with ESMTP id 878AFF50C
	for <xfs@oss.sgi.com>; Tue, 13 Nov 2007 19:21:00 +0100 (CET)
Message-ID: <4739EB0B.6030407@linworks.de>
Date: Tue, 13 Nov 2007 19:20:59 +0100
From: Ruben Porras <ruben.porras@linworks.de>
MIME-Version: 1.0
Subject: porting xfs_reno to linux
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Let's go back to the shrink xfs theme.

> 2. Move inodes out of offline AGs
> 		- On Irix, we have a program called 'xfs_reno' which
> 		  converts 64 bit inode filesystems to 32 bit inode
> 		  filesystems. This needs to be:
> 		  	- released under the GPL (should not be a problem).

done

> 			- ported to linux

Do you mean, rewrite the program to work on kernel space, or just port it to glibc?

Doing most of it on user land is easier, xfs_reno is already there, but it requires the AGs of the file system which are going to disappear to be traversed several times. It is needed to traverse each 'marked' AG one time to find its list of inodes. Then these inodes are going to be looked up during xfs_reno operation again several times (e.g. while copying attributes, linking and unlinking files...) 
is these information cached?

On the other side on kernel space it can be done without going through the ioctls. 

> 			- modified to understand inodes sit in certain
> 			  AGs and to move them out of those AGs as needed.
> 			- requires filesystem traversal to find all the
> 			  inodes to be moved.

To accomplish this I would write a function that traverses all the 'marked' AGs and return the list of ids to reallocate. These list could be exported through an ioctl to user space if needed. I don't find any function that traverses an AG, I've only seen functions to look up the records of an inode. Is there any function that do something similar or do I need to write if from scratch? Where can I find examples of it? is xfs_inobt_lookup the best one?

Thanks.

-- 
Rubén Porras
LinWorks GmbH
