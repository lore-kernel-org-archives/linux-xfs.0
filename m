Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 21:37:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA24bcr0004066
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 21:37:39 -0700
Message-ID: <472AA999.6090900@sgi.com>
Date: Fri, 02 Nov 2007 15:37:45 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
References: <06CCEA2EB1B80A4A937ED59005FA855101AED1BE@svits26.main.ad.rit.edu> <472A87FA.7000804@sandeen.net>
In-Reply-To: <472A87FA.7000804@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jay Sullivan <jpspgd@rit.edu>, xfs@oss.sgi.com

Eric Sandeen wrote:
> Jay Sullivan wrote:
> 
>> I ran xfs_repair -L on the FS and it could be mounted again, 
> 
> Was it not even mountable before this, or why did you use the -L flag? 
> If the log is corrupted that points to more problems... perhaps you've 
> had some power loss & your write caches evaporated, and lvm doesn't do 
> barriers?
> 
> -eric
> 

BTW, I occasionally wonder about the reason for log corruptions.
If we have an "evaporated" write cache that would stop a write from
going but it wouldn't do a partial sector (< 512 byte) write, would it?
I have presumed that sector writes complete or not and that is what
the log code is based on.

OOI, Jay, how did it fail to mount - what was the log msg?
I presume you couldn't mount such that even the log couldn't be
replayed? Did it fail during replay?

--Tim
