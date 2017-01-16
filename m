Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44176 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750855AbdAPOmr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 09:42:47 -0500
Subject: Re: [RFC] libxfs: cross-compile fixes
References: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
 <1473493051-12838-1-git-send-email-ralph.sennhauser@gmail.com>
 <704667b9-d8d4-974b-6be7-aef2ef275b12@sandeen.net>
 <20170116144528.47389cb3@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e788cd17-a40e-b847-0a54-c7f0d549b923@sandeen.net>
Date: Mon, 16 Jan 2017 08:42:46 -0600
MIME-Version: 1.0
In-Reply-To: <20170116144528.47389cb3@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Cc: linux-xfs@vger.kernel.org

On 1/16/17 7:45 AM, Ralph Sennhauser wrote:
> On Sun, 15 Jan 2017 14:32:00 -0600
> Eric Sandeen <sandeen@sandeen.net> wrote:
> 
>> On 9/10/16 2:37 AM, Ralph Sennhauser wrote:
>>> ---
>>>
>>> Based on the earlier discussion this seems to be the preferred way
>>> of handling things.
>>>
>>> Should I split it into 3 patches?
>>> Do you want something different to happen when cross-compiling?  
>>
>> Hi Ralph -
>>
>> I just merged a patch to for-next to address cross-compiling;
>> it was on the list prior to this one.
>>
>> Can you confirm that it resolves your issues?
> 
> Hi Eric,
> 
> I compile tested 4.9.0 with 0a71e38396304b4d1215ba0b51cd6ce8e33eb40d on
> top. Cross-compiling is fixed for me with this leaving only the d_namlen
> issue with musl for which you already reviewed a patch from me. If that
> gets addressed I can use vanilla xfsprogs.

Hi Ralph, that should have been merged as well.  Check out the for-next
branch of the git tree.

Thanks,
-Eric
