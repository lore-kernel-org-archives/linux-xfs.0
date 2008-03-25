Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 20:05:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P35c31015223
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 20:05:40 -0700
Message-ID: <47E86C15.3080009@sgi.com>
Date: Tue, 25 Mar 2008 14:05:57 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Update of XFSPROG XFSDUMP on linux kernel 2.4.22
References: <1205842046.47dfb07ede86d@hermesadm.chb.fr>
In-Reply-To: <1205842046.47dfb07ede86d@hermesadm.chb.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Xavier Poirier <xpoirier@ch-bourg01.fr>
Cc: xfs@oss.sgi.com

Xavier Poirier wrote:
> Hi all XFS ML Users !
> 
> I'm Xavier from France.
> 
> I had installed two years ago a linux server with 2 XFS Partitions.
> 
> All is working like a charm !
> 
> * Except, 
> 
> xfsrestore command, that is often crashing (one time on two) with a dump file of 35Go
> 
> 
> Here is my versions descriptions:
> 
> - Linux Mandrake 9.2 kernel 2.4.22
> - XFSDUMP 2.2.13
> - XFSDUMP 2.5.4  (installed by RPM) 
> 
> 
> My question is :
> 
> Is it better to update the XFS programs to newer versions, or update my linux kernel,
 > to avoid problems ?
> 
As Hannes Dorbath said, probably both.
The dump format hasn't changed so you can try a new xfsrestore
if that is less painful for you.

If the new xfsrestore crashes then you can report the bug with
details on how it crashes.

> I've tryed to find some older distribs of xfsdump, but without succes (like 2.2.33)
> the most recent distribs fails with the configure at manual install ...
> 
I wouldn't go for older versions of dump/restore.

--Tim
