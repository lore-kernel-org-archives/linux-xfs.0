Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 22:55:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l925tIxJ028639
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 22:55:20 -0700
Message-ID: <4701DD3F.1000104@sgi.com>
Date: Tue, 02 Oct 2007 15:55:11 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Creation time in XFS
References: <200709302124.38164.Martin@lichtvoll.de>	<470042DC.2040009@sgi.com> <p73ve9r6v3a.fsf@bingen.suse.de>
In-Reply-To: <p73ve9r6v3a.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, xfs@oss.sgi.com

Andi Kleen wrote:
> Timothy Shimmin <tes@sgi.com> writes:
> 
>> No XFS does not support creation time. It just has the regular
>> atime,mtime and ctime.
>> There are no plans that I've heard to support it.
>> Not much involved to support it AFAICT but it would either involve
>> changing the ondisk format of the inode or storing it in an EA.
> 
> If you ever change the on disk format adding a file type similar to ext3
> to directories could also greatly speed up find in many cases.
> 
Sounds a good idea.
In that case a new ondisk directory format (at v2 at the moment).
I think Dave (dgc) might have been mentioning something about that
recently.

--Tim
