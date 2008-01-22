Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jan 2008 18:27:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0M2RZuc023689
	for <xfs@oss.sgi.com>; Mon, 21 Jan 2008 18:27:40 -0800
Message-ID: <479554B3.70003@sgi.com>
Date: Tue, 22 Jan 2008 13:28:03 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: small problem w/ new xfs defaults patch
References: <4794159F.9070505@sandeen.net> <20080121051341.GA31708862@melbourne.sgi.com>
In-Reply-To: <20080121051341.GA31708862@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Niv Sardi wrote:
> * Eric Sandeen <sandeen@sandeen.net> [2008-01-20 21:46:39 -0600]:
> 
>> Index: xfsprogs-2.9.4/growfs/xfs_growfs.c
>> ===================================================================
> [...]
>> couple things... you lost a "\n" off the end of the data section there...
> 
> That has been fixed, I guess it needs to be sent to oss  (barry?)
> 
>> Also, do you really want to drop reporting of unwritten extents?  Even
>> if you're disallowing the selection on new mkfs's there may still be
>> different flavors of filesystems in existence, should it still be reported?
> 
> I don't really care, whatever the oss/xfs-master people like best.
> 
> Cheers

My preference would be to report the unwritten extent flag as Eric suggested.

--Tim
