Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230DCC001B0
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Aug 2023 18:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjHFSyi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Aug 2023 14:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjHFSyh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Aug 2023 14:54:37 -0400
X-Greylist: delayed 1975 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Aug 2023 11:54:35 PDT
Received: from juniper.fatooh.org (juniper.fatooh.org [IPv6:2600:3c01:e000:3fa::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C99171E
        for <linux-xfs@vger.kernel.org>; Sun,  6 Aug 2023 11:54:34 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPS id D7E87403E5;
        Sun,  6 Aug 2023 11:54:34 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        by juniper.fatooh.org (Postfix) with ESMTP id B31AA403F3;
        Sun,  6 Aug 2023 11:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:from:to:cc:references:in-reply-to
        :content-type:content-transfer-encoding; s=dkim; bh=O+GuNYC2NmJ1
        67wKFT3dXq+IMHg=; b=WY9s0HFvKEi02xFoD9xWS7GLJwbTFiEDojzNR7Ud+7+K
        X4bYSUwQVuC/Xi4Jp7m85uLxW8mdul+RM5aAW3YGBYt/AIN+Pn6FvoQ1AV2SP7WJ
        I1Bcb8ExLx4eZ/vbFuLLMEvM0ZytxFcIgcGntG5L1k3Km/XrJVe0tA+RNszPK+M=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:from:to:cc:references:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=dkim; b=ViC6Ux
        ieRDv7mIAZtQNut/VeZ5e28nI9qkjwbWf9WDJxWP9/7NQlPyUrSxmuvBz7Kn9LuP
        /nlmoIRW4MP4kmfNLXIgolSJwkZPqfpNqK8a0c5AC+OAM8uRaNgqRepI1+6R8FQH
        QWuwkbbUX4qhk3t6xcWn8Hq9TqYx7mqgZ3W9M=
Received: from [198.18.0.3] (unknown [104.184.153.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPSA id AC43C403E5;
        Sun,  6 Aug 2023 11:54:34 -0700 (PDT)
Message-ID: <159bf7ff-fe2e-4aad-9866-e7d82e037986@fatooh.org>
Date:   Sun, 6 Aug 2023 11:54:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: read-modify-write occurring for direct I/O on RAID-5
Content-Language: en-US
From:   Corey Hickey <bugfood-ml@fatooh.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <55225218-b866-d3db-d62b-7c075dd712de@fatooh.org>
 <ZMyxp/Udved6l9F/@dread.disaster.area>
 <db157228-3687-57bf-d090-10517847404d@fatooh.org>
 <ZM1zOFWVm9lD8pNc@dread.disaster.area>
 <0f21f5eb-803f-c8d1-503a-bb0addeef01f@fatooh.org>
In-Reply-To: <0f21f5eb-803f-c8d1-503a-bb0addeef01f@fatooh.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-08-04 18:44, Corey Hickey wrote:
>> Buffered writes won't guarantee you alignment, either, In fact, it's
>> much more likely to do weird stuff than direct IO. If your
>> filesystem is empty, then buffered writes can look *really good*,
>> but once the filesystem starts being used and has lots of
>> discontiguous free space or the system is busy enough that writeback
>> can't lock contiguous ranges of pages, writeback IO will look a
>> whole lot less pretty and you have little control over what
>> it does....
> 
> I'll keep that in mind. This filesystem doesn't get extensive writes
> except when restoring from backup. That is why I started looking at
> alignment, though--restoring from backup onto a new array with new
> disks was incurring lots of RMW, reads were very delayed, and the
> kernel was warning about hung tasks.

I tested and learned further. The root cause does not seem to be
excessive RMW--the root cause seems to be that the drives in my new
array do not handle the RMW nearly as well as the drives I had used
before.

Under different usage, I had previously noticed reduced performance on
"parallel" reads of the new drives as compared to my older drives,
though I didn't investigate further at the time.

I don't know a great way to test this--there's probably a better way
with fio or something. I wrote a small program to _roughly_ simulate the
non-sequential activity of a RAID-5 RMW. Mostly I just wanted to induce
lots of seeks over small intervals.

I see consistent results across different drives attached via different
cables to different SATA controllers. It's not just that I have one
malfunctioning component.

Differences in performance between runs are negligible, so I'm only
reporting one run of each test.

For 512 KB chunks, the Toshiba performs 11.5% worse.
----------------------------------------------------------------------
$ sudo ./rmw /dev/disk/by-id/ata-WDC_WD60EFRX-68L0BN1_WD-WX11DA71YR1L "$((512 * 1024))" "$((2 * 1024))"
testing path: /dev/disk/by-id/ata-WDC_WD60EFRX-68L0BN1_WD-WX11DA71YR1L  buffer_size: 524288  count: 2048
1073741824 bytes in 34.633402 seconds: 29.6 MiB/sec

$ sudo ./rmw /dev/disk/by-id/ata-TOSHIBA_HDWG21C_2290A04EFPBG "$((512 * 1024))" "$((2 * 1024))"
testing path: /dev/disk/by-id/ata-TOSHIBA_HDWG21C_2290A04EFPBG  buffer_size: 524288  count: 2048
1073741824 bytes in 39.147649 seconds: 26.2 MiB/sec
----------------------------------------------------------------------

For 128 KB chunks, the Toshiba performs 29.4% worse.
----------------------------------------------------------------------
$ sudo ./rmw /dev/disk/by-id/ata-WDC_WD60EFRX-68L0BN1_WD-WX11DA71YR1L "$((128 * 1024))" "$((8 * 1024))"
testing path: /dev/disk/by-id/ata-WDC_WD60EFRX-68L0BN1_WD-WX11DA71YR1L  buffer_size: 131072  count: 8192
1073741824 bytes in 100.036280 seconds: 10.2 MiB/sec

$ sudo ./rmw /dev/disk/by-id/ata-TOSHIBA_HDWG21C_2290A04EFPBG "$((128 * 1024))" "$((8 * 1024))"
testing path: /dev/disk/by-id/ata-TOSHIBA_HDWG21C_2290A04EFPBG  buffer_size: 131072  count: 8192
1073741824 bytes in 142.250680 seconds: 7.2 MiB/sec
----------------------------------------------------------------------

I don't know if the MD behavior tends toward better or worse as
compared to my synthetic testing, but there's definitely a difference
in performance between drives--apparently higher latency on the
Toshiba.

The RAID-5 write-back journal feature seems interesting, but I
hit a reproducible bug early on:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1043078

Making RAID-5 work well under these circumstances doesn't seem
worth it. I'm probably going to use RAID-10 instead.

The test program follows.

-Corey

----------------------------------------------------------------------
#define _GNU_SOURCE

#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

long parse_positive_long(char *);
int rmw(char *, long, long);
size_t rmw_once(int, char *, long);

int main(int argc, char **argv) {
     char *path;
     long buffer_size, count;

     if (argc != 4) {
         printf("usage: %s path buffer_size count\n", argv[0]);
         printf("WARNING: this overwrites the target file/device\n");
     }

     path = argv[1];
     if (! (buffer_size = parse_positive_long(argv[2]))) {
         exit(1);
     }
     if (buffer_size % 512) {
         printf("buffer size must be a multiple of 512\n");
         exit(1);
     }

     if (! (count = parse_positive_long(argv[3]))) {
         exit(1);
     }

     printf("testing path: %s  buffer_size: %ld  count: %ld\n", path, buffer_size, count);
     if (! rmw(path, buffer_size, count)) {
         exit(1);
     }
     exit(0);
}

/* returns 0 on failure */
long parse_positive_long(char *str) {
     long ret;
     char *endptr;
     ret = strtol(str, &endptr, 0);
     if (str[0] != 0 && endptr[0] == 0) {
         if (ret <= 0) {
             printf("expected positive number instead of: %ld\n", ret);
             return 0;
         }
         return ret;
     } else {
         printf("error parsing number: %s\n", str);
         return 0;
     }
}

int rmw(char *path, long buffer_size, long count) {
     int fd, i;
     size_t bytes_handled, bytes_total;
     char *buffer;
     struct timespec start_time, end_time;
     double elapsed;

     buffer = aligned_alloc(512, buffer_size);
     if (! buffer) {
         printf("error allocating buffer: %s\n", strerror(errno));
     }

     fd = open(path, O_RDWR|O_DIRECT|O_SYNC);
     if (fd == -1) {
         printf("error opening %s: %s\n", path, strerror(errno));
         return 0;
     }

     bytes_total = 0;
     clock_gettime(CLOCK_MONOTONIC, &start_time);
     for (i = 0; i < count; ++i) {
         bytes_handled = rmw_once(fd, buffer, buffer_size);
         if (! bytes_handled) {
             return 0;
         }
         bytes_total += bytes_handled;
         if (bytes_handled != buffer_size) {
             printf("warning: encountered EOF\n");
             break;
         }
     }
     clock_gettime(CLOCK_MONOTONIC, &end_time);

     if (close(fd)) {
         printf("error closing %s: %s\n", path, strerror(errno));
     }

     free(buffer);

     if (! bytes_total) {
         return 0;
     }

     elapsed = (double)(end_time.tv_sec - start_time.tv_sec) +
               (double)(end_time.tv_nsec - start_time.tv_nsec) / 1.0e9;
     if (elapsed == 0.0) {
         printf("no time elapsed???\n");
         return 0;
     }

     printf("%ld bytes in %lf seconds: %.1lf MiB/sec\n", bytes_total, elapsed, (double)bytes_total/elapsed/1024/1024);
     return 1;
}


size_t rmw_once(int fd, char *buffer, long buffer_size) {
     size_t bytes_read, bytes_written;
     ssize_t last_size;
     long i;
     int attempts;

     /* ----- READ ----- */
     bytes_read = 0;
     attempts = 0;
     do {
         ++attempts;
         last_size = read(fd, buffer + bytes_read, buffer_size - bytes_read);
         bytes_read += last_size;
     } while (bytes_read < buffer_size && last_size > 0);

     if (attempts > 1) {
         printf("warning: took %d attempts to read into buffer\n", attempts);
     }

     if (last_size < 0) {
         printf("error reading: %s\n", strerror(errno));
         return 0;
     }

     /* ----- MODIFY ----- */
     for (i = 0; i < bytes_read; ++i) {
         /* do something... doesn't matter what */
         buffer[i] = ~buffer[i];
     }

     /* ----- WRITE ----- */
     if (lseek(fd, -bytes_read, SEEK_CUR) == -1) {
         printf("error seeking: %s\n", strerror(errno));
         return 0;
     }

     bytes_written = 0;
     attempts = 0;
     do {
         attempts += 1;
         last_size = write(fd, buffer, bytes_read - bytes_written);
         bytes_written += last_size;
     } while (bytes_written < bytes_read && last_size > 0);

     if (attempts > 1) {
         printf("warning: took %d attempts to write from buffer\n");
     }

     if (last_size < 0) {
         printf("error writing: %s\n", strerror(errno));
         return 0;
     }

     assert(bytes_read == bytes_written);

     return bytes_read;
}
----------------------------------------------------------------------
