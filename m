Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 325CD7F3F
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 00:22:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E2C38F8054
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 22:22:48 -0700 (PDT)
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id uYeNzS5hls3d1jLZ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Mar 2013 22:22:14 -0700 (PDT)
Received: by mail-pb0-f53.google.com with SMTP id un1so1039828pbc.12
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 22:22:14 -0700 (PDT)
Date: Wed, 20 Mar 2013 13:37:44 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] xfstests 299-305: remove fio config files after finished
	test
Message-ID: <20130320053744.GA4017@gmail.com>
References: <1363685450-27452-1-git-send-email-wenqing.lz@taobao.com>
	<51489024.20301@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51489024.20301@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Tue, Mar 19, 2013 at 11:19:48AM -0500, Eric Sandeen wrote:
> On 3/19/13 4:30 AM, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > After finished test, temporarily fio config file should be removed.
> 
> Looks fine, except that in test 300 you don't do rm -f; in every
> other test -f is used.  Was that intentional?

Thanks for pointing it out.  It's a typo.  I will submit a newer patch
to fix it.

> 
> Also, while looking at this, in 305 cleanup uses "poweron_scratch_dev"
> - is that defined anywhere?  I can't find it.

Yeah, I also cannot find it.  I am not sure why it is called here.  I
will take a look at it and make sure that we can remove it.

Regards,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
