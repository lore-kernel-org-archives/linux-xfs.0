Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E33BC3A5A5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 05:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AC16206A3
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 05:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfIEFXR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 01:23:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725209AbfIEFXR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Sep 2019 01:23:17 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F22EB18005FF;
        Thu,  5 Sep 2019 05:23:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E8516100194E;
        Thu,  5 Sep 2019 05:23:16 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id DC1832551B;
        Thu,  5 Sep 2019 05:23:16 +0000 (UTC)
Date:   Thu, 5 Sep 2019 01:23:16 -0400 (EDT)
From:   Jianhong Yin <jiyin@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     "Jianhong.Yin" <yin-jianhong@163.com>, linux-xfs@vger.kernel.org
Message-ID: <383538918.12739000.1567660996645.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190905050235.GA7239@dhcp-12-102.nay.redhat.com>
References: <20190904063222.21253-1-yin-jianhong@163.com> <20190905050235.GA7239@dhcp-12-102.nay.redhat.com>
Subject: Re: [PATCH] xfsprogs: copy_range don't truncate dstfile if same
 with srcfile
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.66.12.115, 10.4.195.13]
Thread-Topic: xfsprogs: copy_range don't truncate dstfile if same with srcfile
Thread-Index: Gadlyws9XEnz1+APg07pDfACj2bN2Q==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Thu, 05 Sep 2019 05:23:17 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I've send new patch do same work

----- 原始邮件 -----
> 发件人: "Zorro Lang" <zlang@redhat.com>
> 收件人: "Jianhong.Yin" <yin-jianhong@163.com>
> 抄送: linux-xfs@vger.kernel.org, jiyin@redhat.com
> 发送时间: 星期四, 2019年 9 月 05日 下午 1:02:35
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
> > +			ret = copy_dst_truncate();
> > +			if (ret < 0) {
> > +				ret = 1;
> > +				goto out;
> > +			}
> 
> Finally we turn to talk about this part now:) The patch itself looks fine to
> me.
> 
> I just have one question to other xfsprogs developers, why the copy_range
> would
> like to truncate(0) the target file by default (len=0 by default)? I think
> this's
> not a same or not same files problem, this's why we truncate the target file?
> 
> Why not set the 'len' to the size of srcfile(copy_src_filesize) by default if
> there's not a '-l N' specified? And never truncate the target file (if
> someone need
> to truncate target file, do it by -c 'truncate N' or '-t').
> 
> Anyway, talk is cheap, show my demo code to explain what I mean:
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index b7b9fd88..51c3dc55 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -66,15 +66,6 @@ copy_src_filesize(int fd)
>         return st.st_size;
>  }
>  
> -static int
> -copy_dst_truncate(void)
> -{
> -       int ret = ftruncate(file->fd, 0);
> -       if (ret < 0)
> -               perror("ftruncate");
> -       return ret;
> -}
> -
>  static int
>  copy_range_f(int argc, char **argv)
>  {
> @@ -87,6 +78,7 @@ copy_range_f(int argc, char **argv)
>         int src_path_arg = 1;
>         int src_file_nr = 0;
>         size_t fsblocksize, fssectsize;
> +       int lflag=0;
>  
>         init_cvtnum(&fsblocksize, &fssectsize);
>  
> @@ -112,6 +104,7 @@ copy_range_f(int argc, char **argv)
>                                 printf(_("invalid length -- %s\n"), optarg);
>                                 return 0;
>                         }
> +                       lflag = 1;
>                         break;
>                 case 'f':
>                         src_file_nr = atoi(argv[1]);
> @@ -137,23 +130,15 @@ copy_range_f(int argc, char **argv)
>                 fd = filetable[src_file_nr].fd;
>         }
>  
> -       if (src == 0 && dst == 0 && len == 0) {
> +       if (!lflag) {
>                 off64_t sz;
> -
>                 sz = copy_src_filesize(fd);
> -               if (sz < 0 || (unsigned long long)sz > SIZE_MAX) {
> -                       ret = 1;
> -                       goto out;
> -               }
> -               len = sz;
> -
> -               ret = copy_dst_truncate();
> -               if (ret < 0) {
> +               if (sz < 0 || (unsigned long long)sz > SIZE_MAX || sz < src)
> {
>                         ret = 1;
>                         goto out;
>                 }
> +               len = sz - src;
>         }
> -
>         ret = copy_file_range_cmd(fd, &src, &dst, len);
>  out:
>         close(fd);
> 
> Thanks,
> Zorro
> 
> >  		}
> >  	}
> >  
> > --
> > 2.17.2
> > 
> 
