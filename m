Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A565F29DF5
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 09:33:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80855304032
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 07:33:03 -0800 (PST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id hLg0XEYEgZx5C56w
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Nov 2015 07:33:02 -0800 (PST)
Received: by wmec201 with SMTP id c201so122982968wme.1
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 07:33:01 -0800 (PST)
Subject: Re: AIO read returns negative number for bytes read
References: <564883BD.8070607@scylladb.com>
	<x497flhsq1c.fsf@segfault.boston.devel.redhat.com>
	<564B2303.7000902@scylladb.com> <20151119153004.GB25804@quack.suse.cz>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <564DEBAA.1080700@scylladb.com>
Date: Thu, 19 Nov 2015 17:32:58 +0200
MIME-Version: 1.0
In-Reply-To: <20151119153004.GB25804@quack.suse.cz>
Content-Type: multipart/mixed; boundary="------------020709070705040807030305"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------020709070705040807030305
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/2015 05:30 PM, Jan Kara wrote:
> On Tue 17-11-15 14:52:19, Avi Kivity wrote:
>>
>> On 11/16/2015 09:27 PM, Jeff Moyer wrote:
>>> Hi Avi,
>>>
>>> Avi Kivity <avi@scylladb.com> writes:
>>>
>>>> Due to a bug in my program, I initiated a read beyond
>>>> eof. Specifically, the file size is 13002 bytes and the read offset is
>>>> 13312 (0x3400).
>>>>
>>>> I would expect such a read to return 0 bytes read, but io_getevents
>>>> returns -310, which is suspiciously equal to (13002 - 13312).
>>>>
>>>> I attach a reproducer.
>>>>
>>>> 4.2.5-201.fc22.x86_64
>>>>
>>>> Are my expectations incorrect, or is this a bug in aio or xfs?
>>> Your expectations are correct.  The bug was introduced by commit
>>> 9fe55eea7e4b4 (Fix race when checking i_size on direct i/o read).  I've
>>> CC'd the patch author and linux-fsdevel.  I'm not sure what the right
>>> fix is, given that the size checks were removed from the vfs to fix some
>>> race condition.  Unfortunately, the commit message doesn't really do a
>>> good job of explaining the race.  In order to save others time, here is
>>> a good explanation of the problem that commit is meant to fix, along
>>> with a reproducer:
>>>    http://marc.info/?l=linux-fsdevel&m=138641356614458&w=2
>>>
>>> Thanks for the great bug report, and sorry I have no solution to
>>> proffer.
>>>
>> Thanks.  I will await a fix with interest.
> Can you please post the reproduce here as well? I couldn't easily find it
> with google.
>
>

Attached.

I am told that a simple synchronous O_DIRECT read beyond unaligned eof 
suffices as well.


--------------020709070705040807030305
Content-Type: text/plain; charset=UTF-8;
 name="aio_read_fails.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="aio_read_fails.c"

#define _GNU_SOURCE

#include <libaio.h>
#include <assert.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int ac, char** av) {
  int fd;
  char* buf;
  io_context_t ioc = NULL;
  int r;
  struct iocb iocb;
  struct iocb *iocbp[1];
  struct io_event ioev;

  buf = aligned_alloc(4096, 4096*4);
  assert(buf);
  r = io_setup(1, &ioc);
  assert(r == 0);
  fd = open("tmp.tmp", O_RDWR | O_CREAT | O_DIRECT, 0600);
  assert(fd >= 0);
  io_prep_pwrite(&iocb, fd, buf, 4096*4, 0);
  iocbp[0] = &iocb;
  r = io_submit(ioc, 1, iocbp);
  assert(r == 1);
  r = io_getevents(ioc, 1, 1, &ioev, NULL);
  assert(r == 1);
  assert(ioev.res == 4*4096);
  ftruncate(fd, 13002);
  io_prep_pread(&iocb, fd, buf, 8192, 13312);
  r = io_submit(ioc, 1, iocbp);
  assert(r == 1);
  r = io_getevents(ioc, 1, 1, &ioev, NULL);
  assert(r == 1);
  printf("read result: %d\n", (int)ioev.res);
  return 0;
}

--------------020709070705040807030305
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------020709070705040807030305--
