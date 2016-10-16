Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34701 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbcJPI5C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Oct 2016 04:57:02 -0400
MIME-Version: 1.0
In-Reply-To: <20161016071659.GB17675@infradead.org>
References: <1476477878-17588-1-git-send-email-amir73il@gmail.com> <20161016071659.GB17675@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 16 Oct 2016 11:56:59 +0300
Message-ID: <CAOQ4uxgNMb3yf9LxC7UQK0F_kG05J6DASUdjOvLoioRrG9e8qw@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: add command line option -M to run as multi
 threaded process
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Sun, Oct 16, 2016 at 10:16 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Oct 14, 2016 at 11:44:38PM +0300, Amir Goldstein wrote:
>> xfs_io -M will start by spawning an idle thread.
>> The purpose of this idle thread is to test io from a multi threaded
>> process. With single threaded process, the file table is not shared
>> and file structs are not reference counted.
>>
>> So in order to detect file struct reference leaks, spawning an idle
>> thread will do the trick.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  io/Makefile |  2 +-
>>  io/init.c   | 32 +++++++++++++++++++++++++++++++-
>>  2 files changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/io/Makefile b/io/Makefile
>> index 1997ca9..032a8c7 100644
>> --- a/io/Makefile
>> +++ b/io/Makefile
>> @@ -13,7 +13,7 @@ CFILES = init.c \
>>       mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
>>       sync.c truncate.c reflink.c
>>
>> -LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
>> +LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
>>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
>>  LLDFLAGS = -static-libtool-libs
>>
>> diff --git a/io/init.c b/io/init.c
>> index 6b88cc6..1d1b97f 100644
>> --- a/io/init.c
>> +++ b/io/init.c
>> @@ -16,6 +16,7 @@
>>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>   */
>>
>> +#include <pthread.h>
>>  #include "platform_defs.h"
>>  #include "command.h"
>>  #include "input.h"
>> @@ -25,6 +26,7 @@
>>  char *progname;
>>  int  exitcode;
>>  int  expert;
>> +int  multithreaded;
>>  size_t       pagesize;
>>  struct timeval stopwatch;
>>
>> @@ -141,7 +143,7 @@ init(
>>       pagesize = getpagesize();
>>       gettimeofday(&stopwatch, NULL);
>>
>> -     while ((c = getopt(argc, argv, "ac:dFfmp:nrRstTVx")) != EOF) {
>> +     while ((c = getopt(argc, argv, "ac:dFfmMp:nrRstTVx")) != EOF) {
>>               switch (c) {
>>               case 'a':
>>                       flags |= IO_APPEND;
>> @@ -166,6 +168,9 @@ init(
>>                               exit(1);
>>                       }
>>                       break;
>> +             case 'M':
>> +                     multithreaded = 1;
>> +                     break;
>>               case 'n':
>>                       flags |= IO_NONBLOCK;
>>                       break;
>> @@ -213,12 +218,37 @@ init(
>>       add_check_command(init_check_command);
>>  }
>>
>> +/*
>> + * The purpose of this idle thread is to test io from a multi threaded process.
>> + * With single threaded process, the file table is not shared and file structs
>> + * are not reference counted. So in order to detect file struct reference
>> + * leaks, spawning an idle thread will do the trick.
>> + */
>> +void *
>> +idle_loop(void *arg)
>> +{
>> +     for (;;) pause();
>
> Indentation issue: the pause should on a line of its own.

Fixed for v2.
Thanks.

>
> Otherwise this looks fine to me:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
