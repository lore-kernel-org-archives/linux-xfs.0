Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55026 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfANRqS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:46:18 -0500
Subject: Re: [PATCH 2/5] xfs_metadump: Zap multi fsb blocks
References: <20190107201355.18996-1-stefanrin@gmail.com>
 <20190107201355.18996-3-stefanrin@gmail.com>
 <2b4718eb-bf55-600e-2a42-1b3128bf21bf@sandeen.net>
 <CAAxjCEz5puFW3a7D7exu9wQT5_uHAzt7Tcu2yVuG9PpOEKqbfQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ebcb60db-0f42-f19e-e3e8-e1b3f839d0a0@sandeen.net>
Date: Mon, 14 Jan 2019 11:46:16 -0600
MIME-Version: 1.0
In-Reply-To: <CAAxjCEz5puFW3a7D7exu9wQT5_uHAzt7Tcu2yVuG9PpOEKqbfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org



On 1/14/19 11:42 AM, Stefan Ring wrote:
> On Fri, Jan 11, 2019 at 6:31 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> On 1/7/19 2:13 PM, Stefan Ring wrote:
>>> Using basically the same code as in process_single_fsb_objects.
>>>
>>> Signed-off-by: Stefan Ring <stefanrin@gmail.com>
>>
>> thanks, the change here to goto write: looks good to me.
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Thanks, this makes my series fully reviewed. Is there anything left
> for me to do now? FWIW, I added the Reviewed-by tag and pushed it to
> <https://github.com/Ringdingcoder/xfsprogs-dev/commits/metadump-fully-reviewed>.
> 

I don't think so.  Pretty sure the failures I ran into with my extended
xfstests harness are actually pre-existing, and Carlos is looking at the
root cause.  I'll give it another once-over but I hope/plan to include this
in xfsprogs-4.20 now.

Apologies for the long wait, I can't tell you how much I appreciate
your effort on this.  Thank you!

-Eric
