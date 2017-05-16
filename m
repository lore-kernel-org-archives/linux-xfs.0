Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33644 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdEPLQS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2017 07:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <20170515155012.GM4519@birch.djwong.org>
References: <20170515134508.2713243-1-arnd@arndb.de> <CAPcyv4jxondHhtMZbr01XE+w1Q0mxy+mR=4ypwsHpA0AtJuj2g@mail.gmail.com>
 <CAK8P3a1XU32oVTeV5=TeV8C+66rKKoRJnebQTAzqUr1BcSH69w@mail.gmail.com> <20170515155012.GM4519@birch.djwong.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 16 May 2017 13:16:16 +0200
Message-ID: <CAK8P3a1Vb9orUWcEzDb3mkSXXUFq3cQBrBmUMWo7Z6KsJFiqLQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dax: hide block device code in #ifdef
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-xfs@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, May 15, 2017 at 5:50 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, May 15, 2017 at 04:20:09PM +0200, Arnd Bergmann wrote:
>> On Mon, May 15, 2017 at 4:11 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > On Mon, May 15, 2017 at 6:44 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> We allow configurations with CONFIG_BLOCK=n and CONFIG_DAX=y, which now
>> >> results in a link error:
>> >>
>> >> drivers/dax/super.c: In function 'bdev_dax_pgoff':
>> >> drivers/dax/super.c:50:26: error: implicit declaration of function 'get_start_sect'; did you mean 'get_task_cred'? [-Werror=implicit-function-declaration]
>> >>
>> >> The two obvious ways to avoid the link error are to either add an #ifdef
>> >> around the code that was moved from fs/block_dev.c, or to disallow the
>> >> configuration. I could not see if there is or is not a reason to support
>> >> this combination of options, but in case there is, the #ifdef is the
>> >> safer choice.
>> >>
>> >> Fixes: ef51042472f5 ("block, dax: move "select DAX" from BLOCK to FS_DAX")
>> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> >
>> > Yup, the same one I came up with:
>> >
>> > https://patchwork.kernel.org/patch/9725513/
>> >
>> > If you have a a pull request coming up soon you can add my Acked-by to
>> > both of these patches, otherwise I'll send what I have along at the
>> > end of the week.
>>
>> I didn't plan to send a pull request, please use whatever you have.
>
> I don't mind pulling the (second) patch in via the xfs tree.
>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>

I think Dan's "dax, xfs, ext4: compile out iomap-dax paths in the
FS_DAX=n case" handles this in a nicer way, so my patch 2/2 is not
needed any more.

      Arnd
