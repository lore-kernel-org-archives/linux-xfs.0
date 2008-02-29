Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Feb 2008 13:21:55 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1TLLZ1L025127
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 13:21:36 -0800
Message-ID: <47C87775.2010007@thebarn.com>
Date: Fri, 29 Feb 2008 15:21:57 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com> <1204166101.13569.102.camel@edge.scott.net.au>
In-Reply-To: <1204166101.13569.102.camel@edge.scott.net.au>
Content-Type: multipart/mixed;
 boundary="------------060201010306050906020701"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------060201010306050906020701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Nathan Scott wrote:
> On Thu, 2008-02-28 at 12:09 +1100, Barry Naujok wrote:
>   
>> Lazy superblock counters was released into mainline in 2.6.23-rc1.
>> Some  
>> distros are still running an older kernel (2.6.22 for example) and
>> with  
>>     
>
> (many distros?  RHEL5 and SLES10 wont have such recent kernels yet,
> right?)
>
>   
>> the latest xfsprogs, cannot mount a freshly made filesystem with
>> default  
>> options.
>>
>> This patch make lazy counters default back to off now.
>>     
>
> Looks good, thanks.
>
>   
>> Users who have a more recent kernel can easily enable them with mkfs
>> or  
>> xfs_admin -c1 (in a patch posted out a few days ago which will be in
>> the  
>> same xfsprogs release as this patch).
>>
>> Lazy counters will default to on again in xfsprogs 2.10.0 (when CI
>> support  
>> is released). This should give enough time for distro kernels to catch
>> up.
>>     
>
> Hmm, that still seems pretty soon to me.  I'd have thought you'd at
> least want to wait until most of the distributions (esp. SUSE for you
> guys) have released versions that have kernels sufficiently recent
> that the default mkfs will work.  Otherwise this will be a recurring
> problem.
>   
I don't suppose there is an easy way to query xfs and find out if it can 
support
the lazy SB option?

> cheers.
>
>   


--------------060201010306050906020701
Content-Type: text/x-vcard; charset=utf-8;
 name="cattelan.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cattelan.vcf"

begin:vcard
fn:Russell Cattelan
n:Cattelan;Russell
email;internet:cattelan@thebarn.com
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------060201010306050906020701--
