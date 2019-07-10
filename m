Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bonobo.elm.relay.mailchannels.net ([23.83.212.22]:4646 "EHLO
        bonobo.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728107AbfGJQIB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 12:08:01 -0400
Date: Wed, 10 Jul 2019 19:07:46 +0300
From: Andrey Zhunev <a-j@a-j.ru>
Message-ID: <1015034894.20190710190746@a-j.ru>
Subject: Re: Need help to recover root filesystem after a power supply issue
In-Reply-To: <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
References: <958316946.20190710124710@a-j.ru>
  <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
  <1373677058.20190710182851@a-j.ru>
  <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>


Wednesday, July 10, 2019, 6:45:28 PM, you wrote:

> On Wed, Jul 10, 2019 at 9:29 AM Andrey Zhunev <a-j@a-j.ru> wrote:
>>
>> Well, this machine is always online (24/7, with a UPS backup power).
>> Yesterday we found it switched OFF, without any signs of life. Trying
>> to switch it on, the PSU made a humming noise and the machine didn't
>> even try to start. So we replaced the PSU. After that, the machine
>> powered on - but refused to boot... Something tells me these two
>> failures are likely related...

> Most likely the drive is dying and the spin down from power failure
> and subsequent spin up has increased the rate of degradation, and
> that's why they seem related.

> What do you get for:

> # smarctl -x /dev/sda


The '-x' option gives a lot of output.
It's pasted here: https://pastebin.com/raw/yW3yDuSF


Well, if there are evidnces the drive is really dying - so be it...
I just need to recover the data, if possible.
On the other hand, if the drive will work further - I will find some
unimportant files to store...


---
Best regards,
 Andrey
