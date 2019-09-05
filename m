Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B83C3A59E
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 01:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA38220820
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 01:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfIEBIq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 21:08:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727544AbfIEBIq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Sep 2019 21:08:46 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF408A76C;
        Thu,  5 Sep 2019 01:08:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D5465D70D;
        Thu,  5 Sep 2019 01:08:45 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 92E854A460;
        Thu,  5 Sep 2019 01:08:45 +0000 (UTC)
Date:   Wed, 4 Sep 2019 21:08:45 -0400 (EDT)
From:   Jianhong Yin <jiyin@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Jianhong.Yin" <yin-jianhong@163.com>, linux-xfs@vger.kernel.org
Message-ID: <1860997644.12718148.1567645725346.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190905001457.GF5354@magnolia>
References: <20190904233634.12261-1-yin-jianhong@163.com> <20190905001457.GF5354@magnolia>
Subject: Re: [PATCH v2] xfsprogs: copy_range don't truncate dstfile
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.68.5.41, 10.4.195.17]
Thread-Topic: xfsprogs: copy_range don't truncate dstfile
Thread-Index: syP+ZF0HOt+dGi7unskT8tU0wby2Bg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 05 Sep 2019 01:08:45 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



----- 原始邮件 -----
> 发件人: "Darrick J. Wong" <darrick.wong@oracle.com>
> 收件人: "Jianhong.Yin" <yin-jianhong@163.com>
> 抄送: linux-xfs@vger.kernel.org, jiyin@redhat.com
> 发送时间: 星期四, 2019年 9 月 05日 上午 8:14:57
> 主题: Re: [PATCH v2] xfsprogs: copy_range don't truncate dstfile
> 
> On Thu, Sep 05, 2019 at 07:36:34AM +0800, Jianhong.Yin wrote:
> > now if we do copy_range from srcfile to dstfile without any option
> > will truncate the dstfile, and not any document indicate this default
> > action. that's unexpected and confuse people.
> 
> Needs manpage update.
> 
> Also, did you check that xfstests doesn't somehow use this?  There are
> several cfr tests now...
> 
> generic/430 generic/431 generic/432 generic/433 generic/434 generic/553
> generic/554 generic/564 generic/565 generic/716
I've checked all of them, there are 5 line might use the feature(truncate dstfile)

'''
./430:$XFS_IO_PROG -f -c "copy_range $testdir/file" "$testdir/copy"
./430:$XFS_IO_PROG -f -c "copy_range $testdir/file" "$testdir/copy"
./433:$XFS_IO_PROG -f -c "copy_range $testdir/file" "$testdir/copy"
./432:$XFS_IO_PROG -f -c "copy_range $testdir/file" "$testdir/copy"
./431:$XFS_IO_PROG -f -c "copy_range $testdir/file" "$testdir/copy"
'''

if there's already a $testdir/copy and it's size > $testdir/file, will break the test

should add -t option to fix them:
  $XFS_IO_PROG -t -f -c "copy_range $testdir/file" "$testdir/copy

I will send patch to xfstests-dev, later


> 
> --D
> 
> > '''
> > $ ./xfs_io -f -c 'copy_range copy_file_range.c'  testfile
> > $ ll testfile
> > -rw-rw-r--. 1 yjh yjh 3534 Sep  5 07:15 testfile
> > $ ./xfs_io -c 'copy_range testfile'  testfile
> > $ ll testfile
> > -rw-rw-r--. 1 yjh yjh 3534 Sep  5 07:16 testfile
> > $ ./xfs_io -c 'copy_range testfile -l 3534 -d 3534' testfile
> > $ ll testfile
> > -rw-rw-r--. 1 yjh yjh 7068 Sep  5 07:17 testfile
> > $ ./xfs_io -c 'copy_range copy_file_range.c'  testfile
> > $ ll testfile
> > -rw-rw-r--. 1 yjh yjh 7068 Sep  5 07:18 testfile
> > $ cmp -n 3534 copy_file_range.c testfile
> > $ cmp -i 0:3534 copy_file_range.c testfile
> > '''
> > 
> > Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
> > ---
> >  io/copy_file_range.c | 15 ---------------
> >  1 file changed, 15 deletions(-)
> > 
> > diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> > index b7b9fd88..283f5094 100644
> > --- a/io/copy_file_range.c
> > +++ b/io/copy_file_range.c
> > @@ -66,15 +66,6 @@ copy_src_filesize(int fd)
> >  	return st.st_size;
> >  }
> >  
> > -static int
> > -copy_dst_truncate(void)
> > -{
> > -	int ret = ftruncate(file->fd, 0);
> > -	if (ret < 0)
> > -		perror("ftruncate");
> > -	return ret;
> > -}
> > -
> >  static int
> >  copy_range_f(int argc, char **argv)
> >  {
> > @@ -146,12 +137,6 @@ copy_range_f(int argc, char **argv)
> >  			goto out;
> >  		}
> >  		len = sz;
> > -
> > -		ret = copy_dst_truncate();
> > -		if (ret < 0) {
> > -			ret = 1;
> > -			goto out;
> > -		}
> >  	}
> >  
> >  	ret = copy_file_range_cmd(fd, &src, &dst, len);
> > --
> > 2.21.0
> > 
> 
