Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 03:36:36 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBBBaVG3028616
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 03:36:32 -0800
Received: from puma.mxtelecom.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB3AE459796
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 03:36:39 -0800 (PST)
Received: from puma.mxtelecom.com (mx1.mxtelecom.com [87.86.212.101]) by cuda.sgi.com with ESMTP id Hg8e1QwsQM5EqJEn for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 03:36:39 -0800 (PST)
Message-ID: <475E76AB.705@mxtelecom.com>
Date: Tue, 11 Dec 2007 11:38:19 +0000
From: Matthew Hodgson <matthew@mxtelecom.com>
MIME-Version: 1.0
Subject: Zero-copy Block IO with XFS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

I'm experimenting with using XFS with a network block device (DST), and 
have come up against the problem that when writing data to the network, 
it uses kernel_sendpage to hand the page presented at the BIO layer to 
the network stack.  It then completes the block IO request.

The problem arises when XFS proceeds to then reuse that page before the 
NIC actually sends it.  Particularly if TX checksumming or TCP 
segmentation is being offloaded to the NIC, it seems that the NIC will 
try to access to page after the BIO request has returned, and so operate 
on stale data.  I assume the same problem might happen in the case of 
TCP retransmits or similar.  The motivation for using sendpage rather 
than sendmsg (or using sendpage on a copy of the original page) is to 
try to ensure speed by a zero-copy path through the subsystem.

Is there any way at all in which XFS would be able to (theoretically) 
expose an API to allow an underlying block device to retain ownership of 
pages until it's done with them, so as to avoid a potentially needless 
copy?  Or is there another way of achieving this?

thanks in advance,

Matthew.


-- 
Matthew Hodgson <matthew@mxtelecom.com>
Media & Systems Project Manager
Tel: +44 (0) 845 666 7778
http://www.mxtelecom.com
