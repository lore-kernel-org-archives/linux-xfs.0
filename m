Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9DCC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 23:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 559FF21881
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 23:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfIDXeo convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 19:34:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728008AbfIDXeo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Sep 2019 19:34:44 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2997300DA3A;
        Wed,  4 Sep 2019 23:34:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA1855C1D6;
        Wed,  4 Sep 2019 23:34:43 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id CE4A91800B74;
        Wed,  4 Sep 2019 23:34:43 +0000 (UTC)
Date:   Wed, 4 Sep 2019 19:34:43 -0400 (EDT)
From:   Jianhong Yin <jiyin@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Jianhong.Yin" <yin-jianhong@163.com>, linux-xfs@vger.kernel.org
Message-ID: <1308604014.12711742.1567640083503.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190904172736.GD5354@magnolia>
References: <20190904063222.21253-1-yin-jianhong@163.com> <20190904172736.GD5354@magnolia>
Subject: Re: [PATCH] xfsprogs: copy_range don't truncate dstfile if same
 with srcfile
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.68.5.41, 10.4.195.12]
Thread-Topic: xfsprogs: copy_range don't truncate dstfile if same with srcfile
Thread-Index: UUI6jKkxwnvglQAqiZM6gT9QNKhUjQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 04 Sep 2019 23:34:43 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



----- 原始邮件 -----
> 发件人: "Darrick J. Wong" <darrick.wong@oracle.com>
> 收件人: "Jianhong.Yin" <yin-jianhong@163.com>
> 抄送: linux-xfs@vger.kernel.org, jiyin@redhat.com
> 发送时间: 星期四, 2019年 9 月 05日 上午 1:27:36
> 主题: Re: [PATCH] xfsprogs: copy_range don't truncate dstfile if same with srcfile
> 
> On Wed, Sep 04, 2019 at 02:32:22PM +0800, Jianhong.Yin wrote:
> > now if we do copy_range in same file without any extra option
> > will truncate the file, and not any document indicate this default
> > action. that's risky to users.
> > 
> > '''
> > $ LANG=C ll testfile
> > -rw-rw-r--. 1 yjh yjh 4054 Sep  4 14:22 testfile
> > $ ./xfs_io -c 'copy_range testfile' testfile
> > $ LANG=C ll testfile
> > -rw-rw-r--. 1 yjh yjh 4054 Sep  4 14:23 testfile
> > '''
> > 
> > Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
> > ---
> >  io/copy_file_range.c | 23 +++++++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
> > 
> > diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> > index b7b9fd88..487041c0 100644
> > --- a/io/copy_file_range.c
> > +++ b/io/copy_file_range.c
> > @@ -75,6 +75,19 @@ copy_dst_truncate(void)
> >  	return ret;
> >  }
> >  
> > +int is_same_file(int fd1, int fd2) {
> > +	struct stat stat1, stat2;
> > +	if (fstat(fd1, &stat1) < 0) {
> > +		perror("fstat");
> > +		return -1;
> > +	}
> > +	if (fstat(fd2, &stat2) < 0) {
> > +		perror("fstat");
> > +		return -1;
> > +	}
> > +	return (stat1.st_dev == stat2.st_dev) && (stat1.st_ino == stat2.st_ino);
> > +}
> > +
> >  static int
> >  copy_range_f(int argc, char **argv)
> >  {
> > @@ -147,10 +160,12 @@ copy_range_f(int argc, char **argv)
> >  		}
> >  		len = sz;
> >  
> > -		ret = copy_dst_truncate();
> > -		if (ret < 0) {
> > -			ret = 1;
> > -			goto out;
> > +		if (!is_same_file(fd, file->fd)) {
> 
> Uggggh, why does xfs_io copy_range have this weird behavior?  It should
> be a simple wrapper for copy_file_range (the syscall) and nothing else.
> 
> The code patch looks fine for solving this edge case, but we really
> shouldn't have this "extra" functionality in a debugging tool that
> should be athin wrapper around the syscall for xfstests purposes.

right, agree.

> 
> --D
> 
> > +			ret = copy_dst_truncate();
> > +			if (ret < 0) {
> > +				ret = 1;
> > +				goto out;
> > +			}
> >  		}
> >  	}
> >  
> > --
> > 2.17.2
> > 
> 
