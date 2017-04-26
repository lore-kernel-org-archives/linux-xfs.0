Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50220 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1037590AbdDZNNU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 09:13:20 -0400
Subject: Re: [PATCH 03/12] mkfs: remove intermediate getstr followed by getnum
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-4-jtulak@redhat.com>
 <4d7d62da-6402-0fee-29f3-9c8755c35fba@sandeen.net>
 <CACj3i736V2XdRfE_wNLD7sHZOC7++1LMhoZWB7GXCkTP-=tsjg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <33a3adb7-c33b-9a62-50ce-87ef52db86c3@sandeen.net>
Date: Wed, 26 Apr 2017 08:13:19 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i736V2XdRfE_wNLD7sHZOC7++1LMhoZWB7GXCkTP-=tsjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 4/26/17 2:40 AM, Jan Tulak wrote:
> On Tue, Apr 25, 2017 at 7:37 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 4/23/17 1:54 PM, Jan Tulak wrote:

...

>>> +     set_conf_raw(opts, index, str);
>> So this is really an unrelated functional change here; ideally, this
>> patch would come before the "raw option" patch.  Once every option goes
>> through getnum, /then/ you can add the raw storage to getnum().
>>
>> Not a huge deal, but if you resend the series, you might consider that
>> ordering.  Otherwise I think this one looks ok :)
> Well, we are saving the raw here ... and then reading it in printfs.
> So if we want to avoid the situation from the previous set, where
> input error prints changed the values (printing "1024" instead of
> user-given "1k"), we have to use raw before we remove the getstr(),
> not later. But then we might try to print something that didn't go
> through getnum yet, so we don't have the string saved... which is why
> I made it as one patch.

Oh, I see.  Ok, thanks - sorry for missing that.

-Eric

> Jan
> 
