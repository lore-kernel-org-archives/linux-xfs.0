Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:47102 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbdKQKxo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 05:53:44 -0500
Received: by mail-wm0-f68.google.com with SMTP id z3so5569989wme.5
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 02:53:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171117085731.GA28421@kroah.com>
References: <20171112191821.240484206@linutronix.de> <20171112192142.525567667@linutronix.de>
 <20171116080723.279591c8@lwn.net> <20171116151540.GA18500@silk.coyote.org>
 <CAOFm3uFANvJa0yxiKPcR7KER22951+uO8-qez+hKRY9PzzNskw@mail.gmail.com> <20171117085731.GA28421@kroah.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 17 Nov 2017 11:53:01 +0100
Message-ID: <CAOFm3uGptVog2ZRx+Wh_330=g=sM02Lgi_f2t3R1CSKy1Gp2ug@mail.gmail.com>
Subject: Re: [patch 1/7] Documentation: Add license-rules.rst to describe how
 to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonas Oberg <jonas@fsfe.org>, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Joe Perches <joe@perches.com>, xfs <linux-xfs@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>

On Fri, Nov 17, 2017 at 9:57 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Nov 17, 2017 at 08:37:28AM +0100, Philippe Ombredanne wrote:
>> Or fix the non-standard redefinition of the MODULE_LICENSE macro as
>> DRIVER_LICENSE as in [2]  and found elsewhere with
>> grep -r . -e "DRIVER_LICENSE"
>>
>> These break the otherwise nicely grepable MODULE_LICENSE macros
>> with this kind of warty redirection I stumbled upon while reviewing kernel
>> license scans:
>>
>> #define DRIVER_LICENSE "GPL"
>> [...]
>> MODULE_LICENSE(DRIVER_LICENSE);
>
> Yes, those should be cleaned up, there's only 11 instances of them,
> should be simple enough to do.  I can knock up a patch series for
> them...

That would be awesome and you are probably a million times faster than
me at that.

There are actually more like 29 locations with such an oddity around AFAIK.

Here is a better, more comprehensive grep:

egrep  "MODULE_LICENSE\([^\"]|DRIVER_LICENSE|DRV_LICENSE|MOD_LICENSE"
-r . | egrep -v
"module\.h|nand_ecc\.c|Documentation|scripts|az6007\.c|mt2063.c"

yielding these:

./drivers/ntb/test/ntb_perf.c:#define DRIVER_LICENSE "Dual BSD/GPL"
./drivers/ntb/test/ntb_perf.c:MODULE_LICENSE(DRIVER_LICENSE);
./drivers/ntb/test/ntb_tool.c:#define DRIVER_LICENSE "Dual BSD/GPL"
./drivers/ntb/test/ntb_tool.c:MODULE_LICENSE(DRIVER_LICENSE);
./drivers/ntb/test/ntb_pingpong.c:#define DRIVER_LICENSE "Dual BSD/GPL"
./drivers/ntb/test/ntb_pingpong.c:MODULE_LICENSE(DRIVER_LICENSE);
./drivers/ntb/ntb.c:#define DRIVER_LICENSE "Dual BSD/GPL"
./drivers/ntb/ntb.c:MODULE_LICENSE(DRIVER_LICENSE);
./drivers/input/tablet/hanwang.c:#define DRIVER_LICENSE  "GPL"
./drivers/input/tablet/hanwang.c:MODULE_LICENSE(DRIVER_LICENSE);
./drivers/input/tablet/kbtab.c:#define DRIVER_LICENSE "GPL"
./drivers/input/tablet/kbtab.c:MODULE_LICENSE(DRIVER_LICENSE);
./drivers/input/tablet/acecad.c:#define DRIVER_LICENSE "GPL"
./drivers/input/tablet/acecad.c:MODULE_LICENSE(DRIVER_LICENSE);
./drivers/input/misc/keyspan_remote.c:#define DRIVER_LICENSE "GPL"
./drivers/input/misc/keyspan_remote.c:MODULE_LICENSE(DRIVER_LICENSE);
./drivers/gpu/drm/gma500/psb_drv.h:#define DRIVER_LICENSE "GPL"
./drivers/gpu/drm/gma500/psb_drv.c:MODULE_LICENSE(DRIVER_LICENSE);
./drivers/net/usb/hso.c:#define MOD_LICENSE "GPL"
./drivers/net/usb/hso.c:MODULE_LICENSE(MOD_LICENSE);
./drivers/scsi/csiostor/csio_init.c:MODULE_LICENSE(CSIO_DRV_LICENSE);
./drivers/scsi/csiostor/csio_init.h:#define CSIO_DRV_LICENSE "Dual BSD/GPL"
./drivers/media/usb/usbvision/usbvision-video.c:#define DRIVER_LICENSE "GPL"
./drivers/media/usb/usbvision/usbvision-video.c:MODULE_LICENSE(DRIVER_LICENSE);
./drivers/watchdog/pcwd_usb.c:#define DRIVER_LICENSE "GPL"
./drivers/watchdog/pcwd_usb.c:MODULE_LICENSE(DRIVER_LICENSE);
./include/linux/raid/pq.h:#define MODULE_LICENSE(licence)

-- 
Cordially
Philippe Ombredanne
