Return-Path: <SRS0=Pnyc=XE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F68C00307
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 06:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F392067D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 06:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfIIGLk convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Sep 2019 02:11:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbfIIGLk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Sep 2019 02:11:40 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 619DA6696F;
        Mon,  9 Sep 2019 06:11:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 55C6560BE0;
        Mon,  9 Sep 2019 06:11:39 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4A50A2551C;
        Mon,  9 Sep 2019 06:11:39 +0000 (UTC)
Date:   Mon, 9 Sep 2019 02:11:38 -0400 (EDT)
From:   Jianhong Yin <jiyin@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Jianhong.Yin" <yin-jianhong@163.com>, linux-xfs@vger.kernel.org,
        darrick wong <darrick.wong@oracle.com>
Message-ID: <1078045244.13455647.1568009498688.JavaMail.zimbra@redhat.com>
In-Reply-To: <43208913-ff91-25b6-bc29-8fac01683fa6@sandeen.net>
References: <20190906170243.13230-1-yin-jianhong@163.com> <43208913-ff91-25b6-bc29-8fac01683fa6@sandeen.net>
Subject: Re: [PATCH v2] xfs_io: copy_range don't truncate dst_file, and add
 smart length
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.66.12.115, 10.4.195.4]
Thread-Topic: xfs_io: copy_range don't truncate dst_file, and add smart length
Thread-Index: BtUae4cbHneeVH0mId6dXCZGaUFwBw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 09 Sep 2019 06:11:39 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


----- 原始邮件 -----
> 发件人: "Eric Sandeen" <sandeen@sandeen.net>
> 收件人: "Jianhong.Yin" <yin-jianhong@163.com>, linux-xfs@vger.kernel.org
> 抄送: jiyin@redhat.com, "darrick wong" <darrick.wong@oracle.com>
> 发送时间: 星期六, 2019年 9 月 07日 上午 5:04:13
> 主题: Re: [PATCH v2] xfs_io: copy_range don't truncate dst_file, and add smart length
> 
> On 9/6/19 12:02 PM, Jianhong.Yin wrote:
> > 1. copy_range should be a simple wrapper for copy_file_range(2)
> > and nothing else. and there's already -t option for truncate.
> > so here we remove the truncate action in copy_range.
> > see: https://patchwork.kernel.org/comment/22863587/#1
> > 
> > 2. improve the default length value generation:
> > if -l option is omitted use the length that from src_offset to end
> > (src_file's size - src_offset) instead.
> > if src_offset is greater than file size, length is 0.
> > 
> > 3. update manpage
> > 
> > and have confirmed that this change will not affect xfstests.
> > 
> > Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
> > ---
> >  io/copy_file_range.c | 22 +++++-----------------
> >  man/man8/xfs_io.8    | 12 ++++++------
> >  2 files changed, 11 insertions(+), 23 deletions(-)
> > 
> > diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> > index b7b9fd88..2bc8494e 100644
> > --- a/io/copy_file_range.c
> > +++ b/io/copy_file_range.c
> > @@ -66,21 +66,13 @@ copy_src_filesize(int fd)
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
> >  	long long src = 0;
> >  	long long dst = 0;
> 
> I'd like to change these to src_off & dst_off, just to help keep track
> of things.

that's better, suggest apply same change to copy_file_range_cmd():
-copy_file_range_cmd(int fd, long long *src, long long *dst, size_t len)
+copy_file_range_cmd(int fd, long long *src_off, long long *dst_off, size_t len)
 {
        loff_t ret;
 
        do {
-               ret = syscall(__NR_copy_file_range, fd, src, file->fd, dst,
+               ret = syscall(__NR_copy_file_range, fd, src_off, file->fd, dst_off,
                                len, 0);
                if (ret == -1) {
                        perror("copy_range");
@@ -66,21 +66,13 @@ copy_src_filesize(int fd)
        return st.st_size;
 }


> 
> >  	size_t len = 0;
> > +	bool len_specified = false;
> >  	int opt;
> >  	int ret;
> >  	int fd;
> > @@ -112,6 +104,7 @@ copy_range_f(int argc, char **argv)
> >  				printf(_("invalid length -- %s\n"), optarg);
> >  				return 0;
> >  			}
> > +			len_specified = true;
> >  			break;
> >  		case 'f':
> >  			src_file_nr = atoi(argv[1]);
> > @@ -137,7 +130,7 @@ copy_range_f(int argc, char **argv)
> >  		fd = filetable[src_file_nr].fd;
> >  	}
> >  
> > -	if (src == 0 && dst == 0 && len == 0) {
> > +	if (! len_specified) {
> 
> normal xfsprogs style is no space after the !

Good to know.

> 
> >  		off64_t	sz;
> >  
> >  		sz = copy_src_filesize(fd);
> > @@ -145,13 +138,8 @@ copy_range_f(int argc, char **argv)
> >  			ret = 1;
> >  			goto out;
> >  		}
> > -		len = sz;
> > -
> > -		ret = copy_dst_truncate();
> > -		if (ret < 0) {
> > -			ret = 1;
> > -			goto out;
> > -		}
> > +		if (sz > src)
> > +			len = sz - src;
> 
> Ok, so if source offset is past EOF, we keep len = 0.
> 
> Looks like the kernel does that internally too, so no problem there.
> 
> I'll make the cosmetic changes I mentioned above when I commit it, unless
> you have any concerns about that.

looks good to me. thanks Eric Darrick and Zorro.

> 
>         /* Shorten the copy to EOF */
>         size_in = i_size_read(inode_in);
>         if (pos_in >= size_in)
>                 count = 0;
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> >  	}
> >  
> >  	ret = copy_file_range_cmd(fd, &src, &dst, len);
> > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > index 6e064bdd..61c35c8e 100644
> > --- a/man/man8/xfs_io.8
> > +++ b/man/man8/xfs_io.8
> > @@ -669,13 +669,13 @@ The source must be specified either by path
> >  or as another open file
> >  .RB ( \-f ).
> >  If
> > -.I src_file
> > -.IR src_offset ,
> > -.IR dst_offset ,
> > -and
> >  .I length
> > -are omitted the contents of src_file will be copied to the beginning of
> > the
> > -open file, overwriting any data already there.
> > +is not specified, this command copies data from
> > +.I src_offset
> > +to the end of
> > +.BI src_file
> > +into the dst_file at
> > +.IR dst_offset .
> >  .RS 1.0i
> >  .PD 0
> >  .TP 0.4i
> > 
> 
