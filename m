Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB7507F3F
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 04:04:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 788A2AC004
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 02:04:55 -0800 (PST)
Received: from mail-ob0-f171.google.com (mail-ob0-f171.google.com
	[209.85.214.171]) by cuda.sgi.com with ESMTP id
	JL0DdXE1R0MWEq4g (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Dec 2013 02:04:54 -0800 (PST)
Received: by mail-ob0-f171.google.com with SMTP id wp18so10238327obc.30
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 02:04:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131226085134.GA32660@infradead.org>
References: <1387326161-24530-1-git-send-email-zwu.kernel@gmail.com>
	<20131226085134.GA32660@infradead.org>
Date: Sat, 28 Dec 2013 18:04:53 +0800
Message-ID: <CAEH94LhHC9t-9KGkUr5ppF1dcebRmtkXaHLn7BFR5dZGgwSAuQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] xfs: add O_TMPFILE support
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-api@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

On Thu, Dec 26, 2013 at 4:51 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Both patches looks good to me,
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Indeed thanks for your review. ok, i will place them to my TODO list.

>
> But now we need to make sure we can exercise it, which will need
> support for tmpfile and flink commands in xfs_io.
>
> And tests that use those commands in xfstests.  At a minimum I'd
> suggest:
>
>  - test creating read-only/read-write/executable files
>  - check how permission bits actually work for O_TMPFILE and
>    enforce that (unfortunately I can't find any documentation for that)
>  - check that creating non-regular files is properly rejected
>  - check that flink works on O_TMPFILE files, but doesn't work on
>    on other files
>
> For an additional XFS-specific test I'd recommend:
>
>  - creating a tmpfile, use src/godown to force the filesystem down and
>    check that repair recoveres the unlinked inode list
>  - creating a tmpfile, flinking it, use src/godown to force the
>    filesystem down and check that repair does not have to recover
>    the unlink inode list.
>
> On Wed, Dec 18, 2013 at 08:22:38AM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> HI, folks
>>
>>   It's time to post the latest revision out, welcome to any constructive comment, thanks.
>>
>>   If anyone is interested in playing with it, you can get this patchset from my dev git on github:
>>   git://github.com/wuzhy/kernel.git xfs_tmpfile
>>
>>   The patchset was tested against the code snippet from Andy Lutomirski and other test cases:
>>   http://lwn.net/Articles/562296/
>>   If you have any other better test cases, please let me know, thanks.
>>
>> #include <stdio.h>
>> #include <err.h>
>> #include <fcntl.h>
>> #include <unistd.h>
>> #include <string.h>
>>
>> #define __O_TMPFILE 020000000
>> #define O_DIRECTORY 0200000
>> #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
>> #define AT_EMPTY_PATH 0x1000
>>
>> int main(int argc, char **argv)
>> {
>>    char buf[128];
>>
>>    if (argc != 3)
>>      errx(1, "Usage: flinktest PATH linkat|proc");
>>
>>    int fd = open(".", O_TMPFILE | O_RDWR, 0600);
>>    if (fd == -1)
>>      err(1, "O_TMPFILE");
>>    else
>>      printf("fd #: %d\n", fd);
>>
>>    write(fd, "test", 4);
>>
>>    if (!strcmp(argv[2], "linkat")) {
>>      if (linkat(fd, "", AT_FDCWD, argv[1], AT_EMPTY_PATH) != 0)
>>        err(1, "linkat");
>>    } else if (!strcmp(argv[2], "proc")) {
>>      sprintf(buf, "/proc/self/fd/%d", fd);
>>      if (linkat(AT_FDCWD, buf, AT_FDCWD, argv[1], AT_SYMLINK_FOLLOW) != 0)
>>        err(1, "linkat");
>>    } else {
>>      errx(1, "invalid mode");
>>    }
>>
>>    return 0;
>> }
>>
>> Changelog from v1:
>>  - Fixed one chunk of the comments from Christoph Hellwig and Jeff Liu.
>>
>> v1:
>>  - Addressed the comments from Dave Chinner and Christoph Hellwig.
>>
>> Zhi Yong Wu (3):
>>   xfs: factor prid related codes into xfs_get_initial_prid()
>>   xfs: add O_TMPFILE support
>>   xfs: allow linkat() on O_TMPFILE files
>>
>>  fs/xfs/xfs_inode.c      |  123 ++++++++++++++++++++++++++++++++++++++++++++--
>>  fs/xfs/xfs_inode.h      |   12 +++++
>>  fs/xfs/xfs_iops.c       |   16 ++++++
>>  fs/xfs/xfs_shared.h     |    4 +-
>>  fs/xfs/xfs_symlink.c    |    5 +--
>>  fs/xfs/xfs_trans_resv.c |   55 +++++++++++++++++++--
>>  fs/xfs/xfs_trans_resv.h |    2 +
>>  7 files changed, 202 insertions(+), 15 deletions(-)
>>
>> --
>> 1.7.6.5
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
