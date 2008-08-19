Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 01:09:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7J89fww000883
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 01:09:41 -0700
Message-ID: <48AA81B0.9000403@sgi.com>
Date: Tue, 19 Aug 2008 18:17:52 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: endianess macros
References: <20080814180856.GB3087@infradead.org> <48AA6844.7000203@sgi.com>
In-Reply-To: <48AA6844.7000203@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

I just pushed it in.

Timothy Shimmin wrote:
> Christoph Hellwig wrote:
>> This commit:
>>
>> commit 413d57c9907c72ed608df2be72ef8ed13a3eeb46
>> Author: Marcin Slusarz <marcin.slusarz@gmail.com>
>> Date:   Wed Feb 13 15:03:29 2008 -0800
>>
>>     xfs: convert beX_add to beX_add_cpu (new common API)
>>         
>>     remove beX_add functions and replace all uses with beX_add_cpu
>>
>> which is in Linus tree never made it to the oss cvs tree.  It's doing
>> this little change all over the place, so having it in both trees would
>> be really useful..
>>
> 
> Yes, thanks I'll add this one into dev.
> I'd really like to start changing stuff to minimise our
> cvs/mainline differences.
> It's time I did the diff like you and Lachlan have done :)
> 
> --Tim
> 
> 
> 
