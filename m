Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7164C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 02:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiGNCHG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 22:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiGNCHF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 22:07:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A552CFD0D
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 19:07:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BC6961D9E
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 02:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8622BC341C8;
        Thu, 14 Jul 2022 02:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657764421;
        bh=p6GCHw7AlKTvuq/g7RB/B1fQTz0mia0f89z/pDr3byY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m6CUwgNNk+JmjoaMil1ZKxDaDSRFzLwUFgoouXvkS1XFpRGUlTkFYBh+IpREp5FrD
         5kuIyOoOQjjD4z/HkYo4kcuNPPi4TrsaZwPa90sN0ie4mJcF3nowG/gnGY4hmx2B/W
         t+cH3yKgxF+X4zpVf0sgiHUMqsX2OTcLUnNM2jAfhtpuFsYrz4l2ZRRqO9Ze1UZtix
         ZvD6hjSuFG/DvGgkOH1aa3P01Aojk+HgR2fyG+Zf3jX7V9RV26ETkfs8voeEksewkK
         lIsiRhXpLCruhdEJ4wJNS8eNnHNyvn+31CQ6RbIU5asnL/6R2ThBNLXg9Sd8B+e66l
         8OBG2XMNEVtGw==
Date:   Wed, 13 Jul 2022 19:07:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     hexiaole <hexiaole1994@126.com>, linux-xfs@vger.kernel.org,
        hexiaole <hexiaole@kylinos.cn>
Subject: Re: [PATCH v1] xfs: correct nlink printf specifier from hd to PRIu32
Message-ID: <Ys96RYai0JMlOlnp@magnolia>
References: <20220628144542.33704-1-hexiaole1994@126.com>
 <bec46274-1ef5-c8de-2861-b8dadf3b188b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bec46274-1ef5-c8de-2861-b8dadf3b188b@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 13, 2022 at 08:57:52PM -0500, Eric Sandeen wrote:
> On 6/28/22 9:45 AM, hexiaole wrote:
> > From: hexiaole <hexiaole@kylinos.cn>
> > 
> > 1. Description
> > libxfs/xfs_log_format.h declare 'di_nlink' as unsigned 32-bit integer:
> > 
> > typedef struct xfs_icdinode {
> >         ...
> >         __uint32_t      di_nlink;       /* number of links to file */
> >         ...
> > } xfs_icdinode_t;
> > 
> > But logprint/log_misc.c use '%hd' to print 'di_nlink':
> > 
> > void
> > xlog_print_trans_inode_core(xfs_icdinode_t *ip)
> > {
> >     ...
> >     printf(_("nlink %hd uid %d gid %d\n"),
> >            ip->di_nlink, ip->di_uid, ip->di_gid);
> >     ...
> > }
> > 
> > '%hd' can be 16-bit on many architectures, on these architectures, the 'printf' only print the low 16-bit of 'di_nlink'.
> > 
> > 2. Reproducer
> > 2.1. Commands
> > [root@localhost ~]# cd
> > [root@localhost ~]# xfs_mkfile 128m 128m.xfs
> > [root@localhost ~]# mkfs.xfs 128m.xfs
> > [root@localhost ~]# mount 128m.xfs /mnt/
> > [root@localhost ~]# cd /mnt/
> > [root@localhost mnt]# seq 1 65534|xargs mkdir -p
> > [root@localhost mnt]# cd
> > [root@localhost ~]# umount /mnt/
> > [root@localhost ~]# xfs_logprint 128m.xfs|grep nlink|tail -1
> > 
> > 2.2. Expect result
> > nlink 65536
> > 
> > 2.3. Actual result
> > nlink 0
> 
> I'm being pedantic for such a small change, but technically this needs to be sent
> with a Signed-off-by: from you please?

It's not pedantry, it's a assertion that the author has the right to
submit the change under the GPL2, which is mandatory.

--D

> It's probably enough for you to just reply to this thread with "yes, please
> add my Signed-off-by"
> 
> Thanks,
> -Eric
> 
> > ---
> >  logprint/log_misc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> > index 35e926a3..6add28ed 100644
> > --- a/logprint/log_misc.c
> > +++ b/logprint/log_misc.c
> > @@ -444,7 +444,7 @@ xlog_print_trans_inode_core(
> >      printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
> >  	   ip->di_magic, ip->di_mode, (int)ip->di_version,
> >  	   (int)ip->di_format);
> > -    printf(_("nlink %hd uid %d gid %d\n"),
> > +    printf(_("nlink %" PRIu32 " uid %d gid %d\n"),
> >  	   ip->di_nlink, ip->di_uid, ip->di_gid);
> >      printf(_("atime 0x%llx mtime 0x%llx ctime 0x%llx\n"),
> >  		xlog_extract_dinode_ts(ip->di_atime),
