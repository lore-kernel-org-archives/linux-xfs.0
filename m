Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 13:53:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7OKroDW014630
	for <linux-xfs@oss.sgi.com>; Thu, 24 Aug 2006 13:53:51 -0700
Message-ID: <44EE11B0.7010208@sandeen.net>
Date: Thu, 24 Aug 2006 15:53:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: how to understand allocsp
References: <1156450310.2700.85.camel@localhost.localdomain>
In-Reply-To: <1156450310.2700.85.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: mingz@ele.uri.edu
Cc: linux-xfs@oss.sgi.com

Ming Zhang wrote:
> Hi All
> 
> Play with xfs_io and feel confused about this allocsp.
> 
> Starting with a empty file.
> 

I honestly never keep this all straight without going back to the code, 
but I'd start by looking at the comments for, and code in, 
xfs_change_file_space and xfs_alloc_file_space.

         /*
          * XFS_IOC_RESVSP and XFS_IOC_UNRESVSP will reserve or unreserve
          * file space.
          * These calls do NOT zero the data space allocated to the file,
          * nor do they change the file size.
          *
          * XFS_IOC_ALLOCSP and XFS_IOC_FREESP will allocate and free file
          * space.
          * These calls cause the new file data to be zeroed and the file
          * size to be changed.
          */

The semantics of all this could be clearer, IMHO.

-Eric
