Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:61141 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfGYKGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 06:06:36 -0400
Received: from fsav303.sakura.ne.jp (fsav303.sakura.ne.jp [153.120.85.134])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x6PA6YdF088925
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 19:06:34 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126012062002.bbtec.net [126.12.62.2])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x6PA6S9e088890
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 19:06:33 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: xfs: garbage file data inclusion bug under memory pressure
Message-ID: <f7c3d69e-bbd4-244c-41d7-b03c923c5344@i-love.sakura.ne.jp>
Date: Thu, 25 Jul 2019 19:06:24 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello.

I noticed that a file includes data from deleted files when

  XFS (sda1): writeback error on sector XXXXX

messages are printed (due to close to OOM).

So far I confirmed that this bug exists at least from 4.18 till 5.3-rc1.
I haven't tried 4.17 and earlier kernels. I haven't tried other filesystems.



Steps to test:

(1) Run the disk space filler (source code is shown below).

  # ./fillspace > file &
  # unlink file
  # fg

(2) Wait until the disk space filler completes.

(3) Start the reproducer (source code is shown below).

  # ./oom-torture

(4) Stop the reproducer using Ctrl-C after "writeback error on sector"
    message was printed.

  [ 1410.792467] XFS (sda1): writeback error on sector 159883016
  [ 1410.822127] XFS (sda1): writeback error on sector 187138128
  [ 1410.951357] XFS (sda1): writeback error on sector 162195392
  [ 1410.952527] XFS (sda1): writeback error on sector 95210384
  [ 1410.953870] XFS (sda1): writeback error on sector 95539264

(5) Examine files written by the reproducer for file data
    written by the disk space filler.

  # grep -F XXXXX /tmp/file.*
  Binary file /tmp/file.10111 matches
  Binary file /tmp/file.10122 matches
  Binary file /tmp/file.10143 matches
  Binary file /tmp/file.10162 matches
  Binary file /tmp/file.10179 matches

oom-torture.c
----------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <poll.h>

static char use_delay = 0;

static void sigcld_handler(int unused)
{
	use_delay = 1;
}

int main(int argc, char *argv[])
{
	static char buffer[4096] = { };
	char *buf = NULL;
	unsigned long size;
	int i;
	signal(SIGCLD, sigcld_handler);
	for (i = 0; i < 1024; i++) {
		if (fork() == 0) {
			int fd = open("/proc/self/oom_score_adj", O_WRONLY);
			write(fd, "1000", 4);
			close(fd);
			sleep(1);
			if (!i)
				pause();
			snprintf(buffer, sizeof(buffer), "/tmp/file.%u", getpid());
			fd = open(buffer, O_WRONLY | O_CREAT | O_APPEND, 0600);
			while (write(fd, buffer, sizeof(buffer)) == sizeof(buffer)) {
				poll(NULL, 0, 10);
				fsync(fd);
			}
			_exit(0);
		}
	}
	for (size = 1048576; size < 512UL * (1 << 30); size <<= 1) {
		char *cp = realloc(buf, size);
		if (!cp) {
			size >>= 1;
			break;
		}
		buf = cp;
	}
	sleep(2);
	/* Will cause OOM due to overcommit */
	for (i = 0; i < size; i += 4096) {
		buf[i] = 0;
		if (use_delay) /* Give children a chance to write(). */
			poll(NULL, 0, 10);
	}
	pause();
	return 0;
}
----------------------------------------

fillspace.c
----------------------------------------
#include <unistd.h>

int main(int argc, char *argv[])
{
	static char buffer[1048576];
	int i;
	for (i = 0; i < sizeof(buffer); i++)
		buffer[i] = 'X';
	for (i = 0; i < sizeof(buffer); i+= 40)
		buffer[i] = '\n';
	while (write(1, buffer, sizeof(buffer)) > 0);
	return 0;
}
----------------------------------------



Environment:

This is a plain system with no special configuration.

  # cat /proc/partitions
  major minor  #blocks  name

     8        0  104857600 sda
     8        1  104856576 sda1
