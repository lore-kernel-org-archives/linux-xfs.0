Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9923629DFE
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 09:33:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7997D8F8059
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 07:33:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ca9YxWQRUoXANngj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 19 Nov 2015 07:33:05 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: AIO read returns negative number for bytes read
References: <564883BD.8070607@scylladb.com>
	<x497flhsq1c.fsf@segfault.boston.devel.redhat.com>
	<564B2303.7000902@scylladb.com> <20151119153004.GB25804@quack.suse.cz>
Date: Thu, 19 Nov 2015 10:33:03 -0500
In-Reply-To: <20151119153004.GB25804@quack.suse.cz> (Jan Kara's message of
	"Thu, 19 Nov 2015 16:30:04 +0100")
Message-ID: <x49k2perols.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: linux-aio@kvack.org, Avi Kivity <avi@scylladb.com>, linux-fsdevel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, xfs@oss.sgi.com

Jan Kara <jack@suse.cz> writes:

> Can you please post the reproduce here as well? I couldn't easily find it
> with google.

Here it is, Jan.

-Jeff

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
